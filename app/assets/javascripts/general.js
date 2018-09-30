function animateRefresh(selector, finalColor) {
  $(selector).animate({backgroundColor: '#28a745'}, 200);
  $(selector).animate({backgroundColor: finalColor}, 1000);
}

function incrementScoreTimeInfo() {
  $('.score-time-info').each(function() {
    minutes = parseInt($(this).text(), 10);
    if (minutes < 60) {
      minutes++;
      var timeInfo = minutes.toString();
      if (minutes == 60) {
        timeInfo = '>' + timeInfo;
      }
      $(this).text(timeInfo);
    }
  });
}

setInterval(incrementScoreTimeInfo, 60000);


$(document).on('turbolinks:load', function() {
  // Event handlers

  // Select all content of .replace-input-field when it is clicked or gets focus
  $('.replace-input-field').on ('focus click', function() {
    $(this).select();
  });
});
