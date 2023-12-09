// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap
//= require jquery.remotipart
window.addEventListener("beforeunload", function (e) {
    // Perform an AJAX request to log out the user
    // Example using jQuery:
    $.ajax({
      type: "POST",
      url: "/logout", // Adjust the URL to your logout endpoint
      async: false, // Use synchronous request to ensure it completes before page unload
    });
  });
  
  
  
  
  
  
  