(function () {
  'use strict';

  var root = document.documentElement;
  var btn = document.querySelector('.theme-toggle');
  if (!btn) return;

  function resolved() {
    var explicit = root.getAttribute('data-theme');
    if (explicit === 'light' || explicit === 'dark') return explicit;
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches
      ? 'dark'
      : 'light';
  }

  function syncAria() {
    btn.setAttribute('aria-pressed', resolved() === 'dark' ? 'true' : 'false');
  }

  btn.addEventListener('click', function () {
    var next = resolved() === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', next);
    try { localStorage.setItem('theme', next); } catch (e) {}
    syncAria();
  });

  // Keep aria-pressed in sync if OS theme changes while no explicit override is set.
  if (window.matchMedia) {
    var mq = window.matchMedia('(prefers-color-scheme: dark)');
    var listener = function () { syncAria(); };
    if (mq.addEventListener) mq.addEventListener('change', listener);
    else if (mq.addListener) mq.addListener(listener);
  }

  syncAria();
})();
