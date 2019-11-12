$(document).ready(function(){
  $.get("https://api.ipify.org?format=json", function(response) {
    console.log(response);
    Shiny.onInputChange("getIP", response);
  }, "json");
});