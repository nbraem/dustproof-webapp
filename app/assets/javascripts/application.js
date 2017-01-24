// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

var ready_application;
ready_application = function() {
  $('#refresh-link').on('click', function(e) {
    window.location.reload();
    e.preventDefault();
  });

  $("#q_device_eui_eq").on("change", function(){
    $(this).closest('form')[0].submit();
  });

};

$(document).ready(ready_application);
$(document).on('page:load', ready_application);
