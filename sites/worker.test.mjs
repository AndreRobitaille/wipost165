import { test, after } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, writeFileSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { execFileSync } from 'node:child_process';
import { createWorker } from './worker.mjs';

const root = mkdtempSync(join(tmpdir(), 'post165-templates-'));
after(() => rmSync(root, { recursive: true, force: true }));
mkdirSync(join(root, '.openai'));
writeFileSync(join(root, '.openai/hosting.json'), '{}');
execFileSync('bin/rails', ['runner', 'script/export_site_preview.rb', root], {
  env: { ...process.env, RAILS_ENV: 'development', PUBLIC_SITE_PREVIEW: '0', PUBLIC_SITE_EDITION: 'v1', PUBLIC_SITE_COMING_SOON: '0' }, stdio: 'pipe'
});
const templates = JSON.parse(readFileSync(join(root, 'worker/templates.json')));
const NOW = Date.parse('2026-10-07T17:00:00Z');
const TOKEN = 'synthetic-test-website-token';
const baseEvent = {
  id: 'public-1', title: 'Public gathering', description: 'Hello\nNext line\n\nAnother paragraph.',
  location: 'Two Rivers', all_day: false, starts_at: '2026-10-24T08:30:00-05:00',
  ends_at: null, starts_on: null, ends_on_exclusive: null, cancelled: false,
  category: 'public_event', updated_at: '2026-10-01T12:00:00Z'
};
const feed = events => ({ schema_version: 1, timezone: 'America/Chicago', complete: true, from: '2026-10-07', to: '2027-01-05', events });
const detail = event => ({ schema_version: 1, timezone: 'America/Chicago', event });
const upstream = (body, headers = {}) => new Response(JSON.stringify(body), { headers: {
  'Content-Type': 'application/json', 'Cache-Control': 'private, max-age=300, must-revalidate', Date: new Date(NOW).toUTCString(), ...headers
} });
async function request(path, fetcher, options = {}) {
  const worker = createWorker(templates, { fetcher, clock: options.clock || (() => NOW) });
  const response = await worker.fetch(new Request(`https://preview.example${path}`, options.request), { PUBLISHER_TOKEN: options.token ?? TOKEN });
  return { response, html: await response.text() };
}

test('live collection uses the fixed public API and keeps its credential out of HTML', async () => {
  let calls = 0;
  const { response, html } = await request('/events?from=private&origin=https://evil.example', async (url, init) => {
    calls++;
    assert.equal(url, 'https://members.wipost165.org/public/v1/events?from=2026-10-07&to=2027-01-05');
    assert.equal(init.headers.Authorization, `Bearer ${TOKEN}`);
    assert.equal(init.redirect, 'manual');
    assert.equal(init.cache, 'no-store');
    return upstream(feed([{ ...baseEvent, private_notes: 'PRIVATE-SENTINEL' }]));
  });
  assert.equal(calls, 1);
  assert.equal(response.status, 200);
  assert.equal(response.headers.get('cache-control'), 'no-store');
  assert.match(response.headers.get('x-robots-tag'), /noindex/);
  assert.match(html, /Saturday, October 24, 2026 · 8:30 AM CDT/);
  assert.match(html, /href="\/events\/public-1"/);
  assert.doesNotMatch(html, /synthetic-test-website-token|PRIVATE-SENTINEL|EXAMPLE OCCASION|__SITES_|preview-note/);
});

test('static pages and blocked routes never fetch publisher content', async () => {
  const never = () => { throw new Error('Unexpected publisher request'); };
  for (const path of ['/visit', '/contact', '/about', '/membership', '/veteran-help']) {
    const { response, html } = await request(path, never, { token: '' });
    assert.equal(response.status, 200);
    assert.match(html, /<h1/);
  }
  for (const path of ['/people', '/people/story/portrait/revision/small.webp', '/public/v1/events', '/api', '/worker/templates.json']) {
    assert.equal((await request(path, never)).response.status, 404);
  }
  assert.equal((await request('/events', never, { request: { method: 'POST' } })).response.status, 405);
});

test('details support a modal and direct URL with escaped text', async () => {
  const event = { ...baseEvent, title: '<script>evil()</script> __SITES_title__', description: '<img src=x onerror=evil()>\nSafe', location: '"quoted" & local', ends_at: '2026-10-24T14:00:00-05:00' };
  for (const modal of [false, true]) {
    const { response, html } = await request('/events/public-1', async () => upstream(detail(event)), { request: { headers: modal ? { 'Turbo-Frame': 'event-details' } : {} } });
    assert.equal(response.status, 200);
    assert.match(html, /&lt;script&gt;evil\(\)&lt;\/script&gt; __SITES_title__/);
    assert.doesNotMatch(html, /<script>evil|<img src=x/);
    assert.match(html, /Until Oct 24, 2:00 PM CDT/);
    assert.match(html, modal ? /<turbo-frame id="event-details">/ : /<html/);
    assert.match(html, modal ? /<h2.*data-event-dialog-target="heading"/ : /<h1 id="event-title"/);
    if (modal) assert.doesNotMatch(html, /<html/);
  }
});

test('cancelled events remain visible but are not promoted on home', async () => {
  const events = [{ ...baseEvent, cancelled: true }, { ...baseEvent, id: 'public-2', title: 'Next active gathering', starts_at: '2026-10-27T08:30:00-05:00' }];
  assert.match((await request('/events', async () => upstream(feed(events)))).html, /CANCELLED/);
  const home = await request('/', async () => upstream(feed(events)));
  assert.match(home.html, /Next active gathering/);
  assert.doesNotMatch(home.html, /Public gathering/);
  const cancelled = await request('/events/public-1', async () => upstream(detail(events[0])));
  assert.match(cancelled.html, /This event has been cancelled/);
  assert.doesNotMatch(cancelled.html, /Plan your first visit →/);
});

test('all-day exclusive ends, DST times, past state and unknown locations match Rails semantics', async () => {
  const allDay = { ...baseEvent, all_day: true, starts_at: null, starts_on: '2026-11-01', ends_on_exclusive: '2026-11-03', location: null };
  let result = await request('/events/public-1', async () => upstream(detail(allDay)));
  assert.match(result.html, /Sunday, November 1, 2026 – November 2, 2026 · All day/);
  assert.match(result.html, /To be confirmed/);
  result = await request('/events/public-1', async () => upstream(detail({ ...baseEvent, starts_at: '2026-11-11T11:00:00-06:00' })));
  assert.match(result.html, /Wednesday, November 11, 2026 · 11:00 AM CST/);
  result = await request('/events/public-1', async () => upstream(detail({ ...baseEvent, starts_at: '2026-10-06T11:00:00-05:00' })));
  assert.match(result.html, /already taken place/);
});

test('empty calendar differs from unavailable and unavailable has no sample fallback', async () => {
  assert.match((await request('/events', async () => upstream(feed([])))).html, /No upcoming public dates/);
  for (const status of [401, 429, 500, 503, 302]) {
    const result = await request('/events', async () => new Response('private upstream details', { status }));
    assert.match(result.html, /calendar is temporarily unavailable/);
    assert.doesNotMatch(result.html, /private upstream details|No upcoming public dates|EXAMPLE/);
  }
  assert.match((await request('/', async () => { throw new Error(TOKEN); })).html, /public calendar is temporarily unavailable/);
  assert.equal((await request('/events/public-1', async () => upstream(detail(baseEvent)), { token: '' })).response.status, 503);
});

test('404 and 503 details retain their status, modal frame, and retry behavior', async () => {
  for (const status of [404, 401, 503]) {
    const result = await request('/events/public-1', async () => new Response('secret', { status }), { request: { headers: { 'Turbo-Frame': 'event-details' } } });
    assert.equal(result.response.status, status === 404 ? 404 : 503);
    assert.match(result.html, /<turbo-frame id="event-details">/);
    assert.doesNotMatch(result.html, /secret/);
    if (status !== 404) assert.match(result.html, /event-dialog#retry/);
  }
});

test('invalid, partial, stale, oversized and mismatched responses fail closed', async () => {
  const cases = [
    () => upstream({ ...feed([baseEvent]), complete: false }),
    () => upstream({ ...feed([baseEvent]), from: '2026-10-06' }),
    () => upstream({ ...feed([baseEvent]), timezone: 'not/a-zone' }),
    () => upstream(feed([baseEvent, baseEvent])),
    () => upstream(feed([{ ...baseEvent, starts_at: '2026-02-30T10:00:00Z' }])),
    () => upstream(feed([{ ...baseEvent, category: 'internal' }])),
    () => upstream(feed([{ ...baseEvent, starts_at: '2027-05-01T10:00:00Z' }])),
    () => upstream(feed([baseEvent]), { Age: '300' }),
    () => upstream(feed([baseEvent]), { Date: new Date(NOW - 301000).toUTCString() }),
    () => upstream(feed([baseEvent]), { 'Cache-Control': 'public, max-age=300' }),
    () => upstream(feed([baseEvent]), { 'Content-Length': '3000000' }),
    () => new Response('{bad json', { headers: { 'Content-Type': 'application/json' } })
  ];
  for (const fetcher of cases) assert.match((await request('/events', fetcher)).html, /calendar is temporarily unavailable/);
  assert.equal((await request('/events/another-id', async () => upstream(detail(baseEvent)))).response.status, 503);
});

test('freshness expiry while reading hides data; later requests revalidate withdrawal', async () => {
  let now = NOW;
  const expired = await request('/events/public-1', async () => {
    const response = upstream(detail(baseEvent), { Age: '299' });
    const originalGetReader = response.body.getReader.bind(response.body);
    response.body.getReader = () => { now += 2000; return originalGetReader(); };
    return response;
  }, { clock: () => now });
  assert.equal(expired.response.status, 503);
  let calls = 0;
  const worker = createWorker(templates, { clock: () => NOW, fetcher: async () => ++calls === 1 ? upstream(detail(baseEvent)) : new Response('', { status: 404 }) });
  const req = new Request('https://preview.example/events/public-1');
  assert.equal((await worker.fetch(req, { PUBLISHER_TOKEN: TOKEN })).status, 200);
  assert.equal((await worker.fetch(req, { PUBLISHER_TOKEN: TOKEN })).status, 404);
  assert.equal(calls, 2);
});
