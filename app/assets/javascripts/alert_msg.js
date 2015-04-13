var ready;

ready = function() {
  $('.alert_msg').slideToggle('slow');
};

$(document).ready(function() {
  setTimeout(ready, 4000);
});

