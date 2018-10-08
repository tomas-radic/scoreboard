var lastActivityTime = $.now();

/*
Hooks all possible user activity events and causes page to be reloaded if user
becomes active after 5 or more minutes of inactivity
*/
function hookIdleTracking() {
  var idleState = false;
  var idleTimer = null;

  $('*').bind('focus mousemove click mouseup mousedown keydown keypress keyup submit change mouseenter scroll resize dblclick', function () {
    var thisActivityTime = $.now();

    if ((thisActivityTime - lastActivityTime) > 300000) {
      location.reload();
    }

    lastActivityTime = thisActivityTime;
  });
}

$(document).on('turbolinks:load', function() {
  hookIdleTracking();
});
