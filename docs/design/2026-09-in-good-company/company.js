(() => {
  const root = document.getElementById('company');
  if (!root) return;
  const one = (selector) => root.querySelector(selector);
  const all = (selector) => [...root.querySelectorAll(selector)];
  const profiles = {
    frank: { name: 'Frank', intro: 'The sort of person who remembers your name the second time around.', prompt: '“How did you first get involved here?”', often: 'Post gatherings & community events' },
    ron: { name: 'Ron', intro: 'Always happy to hear where you’ve been. Usually has a story of his own.', prompt: '“What keeps you coming back?”', often: 'Post gatherings & remembrance events' },
    jo: { name: 'Jo', intro: 'Likes getting people together. Especially when someone new comes along.', prompt: '“What’s a good first event to come to?”', often: 'Post gatherings & community events' }
  };
  const views = new Set(all('[data-view]').map((view) => view.dataset.view));
  let rememberedPerson = null;
  let currentRoute = 'welcome';
  const requestedState = new URLSearchParams(location.search).get('state');
  const calendarState = ['quiet', 'unavailable'].includes(requestedState) ? requestedState : 'sample';
  ['sample', 'quiet', 'unavailable'].forEach((state) => {
    one(`#calendar-${state}`).hidden = state !== calendarState;
  });

  function updateRecognition() {
    for (const selector of ['#event-recognition', '#visit-recognition']) {
      const target = one(selector);
      target.replaceChildren();
      if (!rememberedPerson) {
        target.textContent = 'Coming on your own? Ask us who you can look for when you arrive.';
        continue;
      }
      const profile = profiles[rememberedPerson];
      const image = document.createElement('img');
      image.src = one(`[data-person="${rememberedPerson}"] img`).src;
      image.alt = '';
      const text = document.createElement('span');
      text.textContent = `You’ve met ${profile.name} here. In the finished site, you could ask whether they’ll be at the occasion you’re considering.`;
      target.append(image, text);
    }
  }

  function showRoute(route, moveFocus = false) {
    const person = route.startsWith('person-') ? route.slice(7) : null;
    let view = views.has(route) ? route : 'welcome';
    if (profiles[person]) view = 'person';
    if (view === 'person' && !profiles[person]) view = 'welcome';
    currentRoute = view === 'person' ? route : view;
    if (view === 'person') {
      rememberedPerson = person;
      const profile = profiles[person];
      one('#person-title').textContent = `Meet ${profile.name}.`;
      one('#person-intro').textContent = profile.intro;
      one('#conversation-prompt').textContent = profile.prompt;
      one('#person-often').textContent = profile.often;
    }
    all('[data-view]').forEach((section) => { section.hidden = section.dataset.view !== view; });
    all('[data-person]').forEach((link) => {
      if (view === 'person' && link.dataset.person === person) link.setAttribute('aria-current', 'page');
      else link.removeAttribute('aria-current');
    });
    const navigationGroups = { welcome: 'people', person: 'people', purpose: 'people', events: 'events', gathering: 'events', visit: 'visit', contact: 'visit' };
    const activeNav = navigationGroups[view];
    all('[data-nav]').forEach((link) => {
      if (link.dataset.nav === activeNav) link.setAttribute('aria-current', 'page');
      else link.removeAttribute('aria-current');
    });
    updateRecognition();
    one('#view-status').textContent = one(`[data-view="${view}"] h1`).textContent;
    if (moveFocus) {
      const content = one('#table-content');
      const start = content.getBoundingClientRect().top;
      content.focus({ preventScroll: true });
      if (start < 0 || start > innerHeight * .65) content.scrollIntoView({ block: 'start', behavior: 'instant' });
    }
  }

  root.addEventListener('click', (event) => {
    const link = event.target.closest('a[href^="#"]');
    if (!link || !root.contains(link) || link.classList.contains('skip') || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
    event.preventDefault();
    const route = link.getAttribute('href').slice(1);
    // Conversation previews use an opaque srcdoc frame without writable history.
    if (route !== currentRoute && location.protocol !== 'about:') {
      history.pushState(null, '', `#${route}`);
    }
    showRoute(route, true);
  });
  window.addEventListener('hashchange', () => showRoute(location.hash.slice(1), true));
  showRoute(location.hash.slice(1) || 'welcome');

  one('#contact-form').addEventListener('submit', (event) => {
    event.preventDefault();
    one('#message-text').textContent = `${one('#visitor-question').value.trim()}\n\n— ${one('#visitor-name').value.trim()}`;
    one('#contact-form').hidden = true;
    one('#message-preview').hidden = false;
    one('#view-status').textContent = 'Message preview. Nothing has been sent.';
    one('#edit-message').focus();
  });
  one('#edit-message').addEventListener('click', () => {
    one('#contact-form').hidden = false;
    one('#message-preview').hidden = true;
    one('#visitor-question').focus();
  });
})();
