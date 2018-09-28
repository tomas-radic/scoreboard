/*
Hooks all possible user activity events and causes page to be reloaded if user
becomes active after 5 or more minutes of inactivity
*/
function hookIdleTracking() {
  var idleState = false;
  var idleTimer = null;

  $('*').bind('focus mousemove click mouseup mousedown keydown keypress keyup submit change mouseenter scroll resize dblclick', function () {
    clearTimeout(idleTimer);
    if (idleState == true) {
      location.reload();
    }
    idleState = false;
    idleTimer = setTimeout(function () {
      idleState = true;
    }, 300000);
  });
}

$(document).on('turbolinks:load', function() {
  hookIdleTracking();
});
