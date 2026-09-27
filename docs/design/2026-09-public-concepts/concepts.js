const menu = document.querySelector('.menu-toggle');
const navigation = document.querySelector('.nav');
menu.addEventListener('click', () => {
  const expanded = menu.getAttribute('aria-expanded') === 'true';
  menu.setAttribute('aria-expanded', String(!expanded));
  navigation.classList.toggle('is-open', !expanded);
});
navigation.querySelectorAll('a').forEach(link => link.addEventListener('click', () => {
  menu.setAttribute('aria-expanded', 'false');
  navigation.classList.remove('is-open');
}));
const audiences = {
  veteran: ['Meet your local Legion.', 'Ask about membership, meet other veterans, or find out how the Post serves Two Rivers. Start with a conversation.', 'Ask about getting involved →'],
  neighbor: ['You can be part of the good.', 'Come to a public event, learn about our community work, or ask where an extra pair of hands could help. Military service is not required to attend public events.', 'Ask how you can help →'],
  family: ['Family is part of the conversation.', 'Explore community events and ask about the Legion Family. We’ll help you find the right person to talk to about participating.', 'Ask about family participation →']
};
document.querySelectorAll('[data-audience]').forEach(button => button.addEventListener('click', () => {
  document.querySelectorAll('[data-audience]').forEach(peer => peer.setAttribute('aria-pressed', String(peer === button)));
  const [heading, copy, action] = audiences[button.dataset.audience];
  document.getElementById('audience-heading').textContent = heading;
  document.getElementById('audience-text').textContent = copy;
  document.getElementById('audience-action').textContent = action;
}));
const dialog = document.getElementById('detail-dialog');
const events = {show: ['Car & bike show', 'Saturday, September 19, 2026'], fry: ['Community brat fry', 'Saturday, October 3, 2026']};
document.querySelectorAll('[data-event]').forEach(button => button.addEventListener('click', () => {
  const [title, date] = events[button.dataset.event];
  document.getElementById('dialog-kind').textContent = 'Sample event · Design preview';
  document.getElementById('dialog-title').textContent = title;
  document.getElementById('dialog-body').innerHTML = `<p>A public community gathering. This preview demonstrates how an event’s essential details could appear.</p><dl><dt>Date</dt><dd>${date}</dd><dt>Time</dt><dd>To be confirmed</dd><dt>Location</dt><dd>Not supplied in this concept</dd></dl><p class="dialog-note">Illustrative content only. This is not a real event announcement. A production page would use approved information from the member site.</p>`;
  dialog.showModal();
}));
document.querySelector('[data-contact]').addEventListener('click', () => {
  document.getElementById('dialog-kind').textContent = 'Contact experience · Design preview';
  document.getElementById('dialog-title').textContent = 'Reach a real person.';
  document.getElementById('dialog-body').innerHTML = '<p>The finished site would show the Post’s verified public contact details here: a name or role, email, and phone where approved.</p><p>No message is sent by this prototype, and no unverified contact details are published.</p>';
  dialog.showModal();
});
dialog.querySelector('.close').addEventListener('click', () => dialog.close());
const state = new URLSearchParams(location.search).get('state');
if (state === 'quiet' || state === 'unavailable') {
  document.getElementById('event-list').hidden = true;
  document.getElementById('empty-state').hidden = false;
  if (state === 'unavailable') {
    document.getElementById('empty-heading').textContent = 'We can’t confirm the calendar right now.';
    document.getElementById('empty-copy').textContent = 'Please check with the Post before making plans. You can still explore our work and ways to get involved.';
  }
}
if (window.parent !== window) {
  const resize = () => window.parent.postMessage({type: 'post165-preview-height', height: Math.ceil(document.body.getBoundingClientRect().height)}, location.origin === 'null' ? '*' : location.origin);
  new ResizeObserver(resize).observe(document.body);
  window.addEventListener('load', resize);
}
