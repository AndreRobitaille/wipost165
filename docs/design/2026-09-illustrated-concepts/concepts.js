const menu = document.querySelector('.menu-toggle');
const nav = document.querySelector('#nav');
menu.addEventListener('click', () => {
  const open = menu.getAttribute('aria-expanded') !== 'true';
  menu.setAttribute('aria-expanded', String(open));
  nav.classList.toggle('is-open', open);
});
nav.querySelectorAll('a').forEach(link => link.addEventListener('click', () => {
  menu.setAttribute('aria-expanded', 'false');
  nav.classList.remove('is-open');
}));
const dialog = document.querySelector('dialog');
const content = document.querySelector('#dialog-content');
dialog.querySelector('.close').addEventListener('click', () => dialog.close());
function openDialog(markup) {
  content.innerHTML = markup;
  dialog.showModal();
}
const sampleEvents = {
  show: {name: 'Car & bike show', date: 'Saturday, September 19, 2026'},
  fry: {name: 'Community brat fry', date: 'Saturday, October 3, 2026'}
};
document.querySelectorAll('[data-event]').forEach(button => button.addEventListener('click', () => {
  const event = sampleEvents[button.dataset.event];
  // Fixed preview content only. No network data or query values enter this markup.
  openDialog(`<div class="invitation-art"><img src="assets/saturday.png" width="1536" height="1024" alt="Illustrated classic car, coffee mugs, and grill."></div><div class="invitation-copy"><p class="kicker">Post 165 · Sample public event</p><h2 id="dialog-title">${event.name}</h2><p class="invitation-date">${event.date}</p><dl><dt>Time & place</dt><dd>To be confirmed</dd><dt>Guests & children</dt><dd>Attendance details to be confirmed</dd><dt>Cost / registration</dt><dd>To be confirmed</dd></dl><p class="sample-explanation">This is a fictional invitation for design review. The finished event page would include confirmed details, directions, sharing, and an add-to-calendar option.</p></div>`);
}));
document.querySelectorAll('[data-contact]').forEach(button => button.addEventListener('click', () => {
  openDialog('<div class="invitation-copy"><p class="kicker">Contact preview</p><h2 id="dialog-title">Start with a conversation.</h2><p>The finished site will put an approved public contact name, phone, and email here.</p><p class="sample-explanation">Contact information is awaiting confirmation. This mockup does not collect information or send messages.</p></div>');
}));
document.querySelectorAll('[data-support]').forEach(button => button.addEventListener('click', () => {
  openDialog('<div class="invitation-copy"><p class="kicker">Veteran support preview</p><h2 id="dialog-title">Find the right person to talk to.</h2><p>This route will lead to verified veteran assistance resources and approved contacts.</p><p class="sample-explanation">Specific services and referral details are awaiting confirmation. This preview does not imply that the Post provides a particular service.</p></div>');
}));
const state = new URLSearchParams(location.search).get('state');
if (state === 'quiet' || state === 'unavailable') {
  document.querySelector('.event-list').hidden = true;
  document.querySelector('.empty-state').hidden = false;
  document.querySelector('.sample-tag').textContent = 'Calendar preview';
  if (state === 'unavailable') {
    document.querySelector('#empty-heading').textContent = 'Please check with the Post before making plans.';
    document.querySelector('#empty-copy').textContent = 'We can’t confirm the calendar right now. Contact the Post for current event information.';
  }
}
