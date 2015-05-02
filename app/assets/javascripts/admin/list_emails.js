var ready;

ready = function() {
  $("#emails").on("click", function(){
        $("#testarea").show();
        $("#testarea").val(gon.emails);
  });
};

$(document).ready(ready);