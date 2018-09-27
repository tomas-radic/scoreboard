function animateRefresh(selector, finalColor) {
  $(selector).animate({backgroundColor: '#28a745'}, 200);
  $(selector).animate({backgroundColor: finalColor}, 1000);
}
