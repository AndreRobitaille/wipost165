// Sites runtime adapter. HTML templates and assets are generated from Rails.
const PUBLISHER = 'https://members.wipost165.org';
const POST_ZONE = 'America/Chicago';
const MAX_BODY = 2 * 1024 * 1024;
const NOINDEX = 'noindex, nofollow, nosnippet, noimageindex';
class Unavailable extends Error {}
class NotFound extends Error {}
const requireValid = value => { if (!value) throw new Unavailable(); };
const escapeHTML = value => String(value ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
// One replacement pass prevents event text from being interpreted as a template.
const fill = (template, values) => template.replace(/__SITES_(\w+)__/g, (_, key) => {
  if (!Object.hasOwn(values, key)) throw new Unavailable();
  return values[key];
});
const parts = (value, zone, options) => new Intl.DateTimeFormat('en-US', { timeZone: zone, ...options }).formatToParts(new Date(value));
const partMap = (value, zone, options) => Object.fromEntries(parts(value, zone, options).map(p => [p.type, p.value]));
function localDate(value, zone) {
  const p = partMap(value, zone, { year: 'numeric', month: '2-digit', day: '2-digit' });
  return `${p.year}-${p.month}-${p.day}`;
}
const addDays = (date, days) => new Date(Date.parse(`${date}T12:00:00Z`) + days * 86400000).toISOString().slice(0, 10);
function validDate(value) {
  return typeof value === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(value) && Number.isFinite(Date.parse(value)) && new Date(value).toISOString().slice(0, 10) === value;
}
function validTimestamp(value) {
  return typeof value === 'string' && /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|[+-]\d{2}:\d{2})$/.test(value) && validDate(value.slice(0, 10)) && Number.isFinite(Date.parse(value));
}
function localMidnight(date, zone) {
  const desired = Date.parse(`${date}T00:00:00Z`);
  let instant = desired;
  for (let attempt = 0; attempt < 3; attempt++) {
    const p = partMap(instant, zone, { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit', hourCycle: 'h23' });
    const represented = Date.parse(`${p.year}-${p.month}-${p.day}T${p.hour}:${p.minute}:${p.second}Z`);
    instant += desired - represented;
  }
  return instant;
}
function validateEvent(event) {
  requireValid(event && typeof event === 'object' && !Array.isArray(event));
  for (const key of ['id', 'title']) requireValid(typeof event[key] === 'string' && event[key].trim());
  for (const key of ['description', 'location']) requireValid(event[key] === null || typeof event[key] === 'string');
  requireValid(typeof event.all_day === 'boolean' && typeof event.cancelled === 'boolean');
  requireValid(event.category === 'public_event' && validTimestamp(event.updated_at));
  if (event.all_day) {
    requireValid(event.starts_at === null && event.ends_at === null && validDate(event.starts_on));
    requireValid(event.ends_on_exclusive === null || (validDate(event.ends_on_exclusive) && event.ends_on_exclusive > event.starts_on));
  } else {
    requireValid(event.starts_on === null && event.ends_on_exclusive === null && validTimestamp(event.starts_at));
    requireValid(event.ends_at === null || (validTimestamp(event.ends_at) && Date.parse(event.ends_at) >= Date.parse(event.starts_at)));
  }
}
function validateFeed(data, interval, id) {
  requireValid(data?.schema_version === 1 && typeof data.timezone === 'string');
  try { new Intl.DateTimeFormat('en-US', { timeZone: data.timezone }).format(); } catch { throw new Unavailable(); }
  if (id !== null) {
    validateEvent(data.event);
    requireValid(data.event.id === id);
    return;
  }
  requireValid(data.complete === true && data.from === interval.from && data.to === interval.to && Array.isArray(data.events));
  const ids = new Set();
  let previous = null;
  const lower = localMidnight(interval.from, data.timezone);
  const upper = localMidnight(interval.to, data.timezone);
  for (const event of data.events) {
    validateEvent(event);
    requireValid(!ids.has(event.id));
    ids.add(event.id);
    const start = event.all_day ? localMidnight(event.starts_on, data.timezone) : Date.parse(event.starts_at);
    let end = start;
    if (event.all_day) end = localMidnight(event.ends_on_exclusive || addDays(event.starts_on, 1), data.timezone);
    else if (event.ends_at) end = Date.parse(event.ends_at);
    requireValid(start < upper && (end > start ? end > lower : start >= lower));
    requireValid(!previous || start > previous.start || (start === previous.start && event.id >= previous.id));
    previous = { start, id: event.id };
  }
}
function freshnessDeadline(headers, sent, now) {
  const directives = (headers.get('cache-control') || '').toLowerCase().split(',').map(s => s.trim());
  const maxAges = directives.filter(d => /^max-age=/.test(d));
  requireValid(directives.includes('private') && !directives.some(d => ['public', 'no-store', 'no-cache'].includes(d)) && maxAges.length === 1);
  requireValid(/^max-age=\d+$/.test(maxAges[0]));
  const date = Date.parse(headers.get('date'));
  const ageHeader = headers.get('age') || '0';
  requireValid(Number.isFinite(date) && /^\d+$/.test(ageHeader));
  const lifetime = Math.min(300, Number(maxAges[0].split('=')[1])) * 1000;
  const correctedAge = Math.max(0, now - date, Number(ageHeader) * 1000 + now - sent);
  requireValid(correctedAge < lifetime);
  return now + lifetime - correctedAge;
}
async function readBounded(response) {
  requireValid(!response.headers.has('content-length') || Number(response.headers.get('content-length')) <= MAX_BODY);
  requireValid(response.body);
  const reader = response.body.getReader();
  const chunks = [];
  let length = 0;
  try {
    while (true) {
      const { value, done } = await reader.read();
      if (done) break;
      length += value.length;
      requireValid(length <= MAX_BODY);
      chunks.push(value);
    }
  } finally { await reader.cancel().catch(() => {}); }
  const bytes = new Uint8Array(length);
  let offset = 0;
  for (const chunk of chunks) { bytes.set(chunk, offset); offset += chunk.length; }
  return JSON.parse(new TextDecoder('utf-8', { fatal: true }).decode(bytes));
}
async function loadFeed(token, interval, id, fetcher, clock) {
  requireValid(typeof token === 'string' && token.length > 0);
  const url = new URL('/public/v1/events', PUBLISHER);
  if (id === null) url.search = new URLSearchParams(interval).toString();
  else {
    requireValid(id !== '.' && id !== '..');
    url.pathname += `/${encodeURIComponent(id)}`;
  }
  const sent = clock();
  const abort = new AbortController();
  const timeout = setTimeout(() => abort.abort(), 4000);
  try {
    const response = await fetcher(url.href, {
      method: 'GET', redirect: 'manual', signal: abort.signal,
      headers: { Accept: 'application/json', Authorization: `Bearer ${token}`, 'Cache-Control': 'no-cache' },
      cache: 'no-store'
    });
    if (response.status === 404 && id !== null) throw new NotFound();
    requireValid(response.status === 200 && /^application\/json(?:;|$)/i.test(response.headers.get('content-type') || ''));
    const deadline = freshnessDeadline(response.headers, sent, clock());
    const data = await readBounded(response);
    validateFeed(data, interval, id);
    requireValid(clock() < deadline);
    return { data, deadline };
  } finally { clearTimeout(timeout); }
}
const dateLabel = date => new Intl.DateTimeFormat('en-US', { timeZone: 'UTC', weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }).format(new Date(`${date}T12:00:00Z`));
function timedLabel(value, zone, until = false) {
  const p = partMap(value, zone, { weekday: 'long', year: 'numeric', month: until ? 'short' : 'long', day: 'numeric', hour: 'numeric', minute: '2-digit', hour12: true, timeZoneName: 'short' });
  const date = until ? `${p.month} ${p.day},` : `${p.weekday}, ${p.month} ${p.day}, ${p.year} ·`;
  return `${date} ${p.hour}:${p.minute} ${p.dayPeriod} ${p.timeZoneName}`;
}
function eventValues(event, zone) {
  const date = event.all_day ? event.starts_on : localDate(event.starts_at, zone);
  const p = partMap(`${date}T12:00:00Z`, 'UTC', { month: 'long', day: 'numeric', year: 'numeric', weekday: 'short' });
  let when;
  if (event.all_day) {
    when = dateLabel(date);
    if (event.ends_on_exclusive && event.ends_on_exclusive > addDays(date, 1)) {
      when += ' – ' + new Intl.DateTimeFormat('en-US', { timeZone: 'UTC', year: 'numeric', month: 'long', day: 'numeric' }).format(new Date(`${addDays(event.ends_on_exclusive, -1)}T12:00:00Z`));
    }
    when += ' · All day';
  } else when = timedLabel(event.starts_at, zone);
  const description = escapeHTML(event.description).replace(/\r\n?/g, '\n');
  return {
    id: escapeHTML(encodeURIComponent(event.id)), title: escapeHTML(event.title),
    location: escapeHTML(event.location?.trim() ? event.location : 'Location to be confirmed'),
    day: p.day, weekday: p.weekday, month: p.month, year: p.year,
    short_month: new Intl.DateTimeFormat('en-US', { timeZone: 'UTC', month: 'short' }).format(new Date(`${date}T12:00:00Z`)),
    when: escapeHTML(when), starts_at: escapeHTML(event.starts_at),
    until: event.ends_at ? escapeHTML(timedLabel(event.ends_at, zone, true)) : '',
    description_html: description ? description.split(/\n\n+/).map(paragraph => `<p>${paragraph.replace(/\n/g, '<br />\n')}</p>`).join('\n\n') : '<p></p>'
  };
}
function isPast(event, zone, now) {
  const today = localDate(now, zone);
  if (event.all_day) return (event.ends_on_exclusive || addDays(event.starts_on, 1)) <= today;
  return localDate(event.ends_at || event.starts_at, zone) < today;
}
function renderHome(templates, data, now) {
  const event = data.events.find(event => !event.cancelled && (event.all_day ? !isPast(event, data.timezone, now) : Date.parse(event.starts_at) > now));
  const invitation = event ? fill(templates.home.invitation, eventValues(event, data.timezone)) : templates.home.empty;
  return fill(templates.home.shell, { invitation });
}
function renderCalendar(templates, data) {
  const months = new Map();
  for (const event of data.events) {
    const values = eventValues(event, data.timezone);
    const key = `${values.year}-${values.month}`;
    if (!months.has(key)) months.set(key, { ...values, index: months.size, cards: '' });
    months.get(key).cards += fill(event.cancelled ? templates.calendar.cancelled_card : templates.calendar.card, values);
  }
  const calendar = months.size ? [...months.values()].map(values => fill(templates.calendar.month, values)).join('') + templates.calendar.note : templates.calendar.empty;
  return fill(templates.calendar.shell, { calendar });
}
function renderDetail(templates, data, modal, now) {
  const event = data.event;
  let state = 'active';
  if (event.cancelled) state = 'cancelled';
  else if (isPast(event, data.timezone, now)) state = 'past';
  let timing = 'timed';
  if (event.all_day) timing = 'all_day';
  else if (event.ends_at) timing = 'with_end';
  const kind = modal ? 'modal' : 'page';
  const values = eventValues(event, data.timezone);
  if (!event.location?.trim()) values.location = 'To be confirmed';
  const details = fill(templates.details[`${state}_${timing}_${kind}`], values);
  return fill(templates.details[`${kind}_shell`], { details });
}
export function createWorker(templates, { fetcher = (...args) => fetch(...args), clock = () => Date.now() } = {}) {
  return {
    async fetch(request, env) {
      const url = new URL(request.url);
      const path = url.pathname;
      const headers = {
        'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'no-store',
        'X-Robots-Tag': NOINDEX, 'X-Content-Type-Options': 'nosniff',
        'Referrer-Policy': 'strict-origin-when-cross-origin', 'X-Frame-Options': 'SAMEORIGIN',
        Vary: 'Turbo-Frame'
      };
      const respond = (html, status = 200) => new Response(request.method === 'HEAD' ? null : html, { status, headers });
      if (!['GET', 'HEAD'].includes(request.method)) { headers.Allow = 'GET, HEAD'; return respond('Method not allowed', 405); }
      if (path.startsWith('/assets/') || path === '/robots.txt') {
        if (env.ASSETS) return env.ASSETS.fetch(request);
        return respond('Not found', 404);
      }
      if (Object.hasOwn(templates.pages, path)) return respond(templates.pages[path]);
      // Preserve links shared from the earlier static deployment.
      if (path.endsWith('.html') && ['/events', ...Object.keys(templates.pages)].includes(path.slice(0, -5))) {
        headers.Location = path.slice(0, -5);
        return respond('', 302);
      }
      const match = path.match(/^\/events\/([^/]+)$/);
      const modal = !!match && request.headers.get('Turbo-Frame') === 'event-details';
      if (path !== '/' && path !== '/events' && !match) return respond(templates.errors['404_page'], 404);
      try {
        let id = null;
        if (match) {
          try { id = decodeURIComponent(match[1]); } catch { throw new NotFound(); }
        }
        const from = localDate(clock(), POST_ZONE);
        const { data, deadline } = await loadFeed(env.PUBLISHER_TOKEN, { from, to: addDays(from, 90) }, id, fetcher, clock);
        let html;
        if (path === '/') html = renderHome(templates, data, clock());
        else if (path === '/events') html = renderCalendar(templates, data);
        else html = renderDetail(templates, data, modal, clock());
        requireValid(clock() < deadline);
        return respond(html);
      } catch (error) {
        // Never log upstream bodies/headers or echo exception details to browsers.
        const status = error instanceof NotFound ? 404 : 503;
        if (status === 503) headers['Retry-After'] = '10';
        if (path === '/') return respond(fill(templates.home.shell, { invitation: templates.home.unavailable }));
        if (path === '/events') return respond(fill(templates.calendar.shell, { calendar: templates.calendar.unavailable }));
        return respond(templates.errors[`${status}_${modal ? 'modal' : 'page'}`], status);
      }
    }
  };
}
