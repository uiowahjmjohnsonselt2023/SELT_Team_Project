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
document.addEventListener('DOMContentLoaded', function() {
    var logoutButton = document.getElementById('logout-button');
  
    if (logoutButton) {
      logoutButton.addEventListener('click', function() {
        console.log('Logout button clicked');
  
        fetch('/closed', {
          method: 'DELETE',
          headers: {
            'X-CSRF-Token': '<%= form_authenticity_token %>',
            'Content-Type': 'application/json' // Adjust if needed based on your server's expectations
          },
        })
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          console.log('Logout request successful');
  
          // Redirect to the desired location
          window.location.href = '/';  // Change the URL as needed
        })
        .catch(error => {
          console.error('Logout request failed:', error);
        });
      });
    }
  });
  
  
  
  
  
  
  