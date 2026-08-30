(function () {
  var params = new URLSearchParams(window.location.search);
  var problema = params.get('problema');
  if (!problema) return;
  var alvo = document.querySelector('[data-problema="' + CSS.escape(problema) + '"]');
  if (!alvo) return;
  alvo.classList.add('problema--em-foco');
  window.requestAnimationFrame(function () {
    alvo.focus({ preventScroll: false });
  });
})();
