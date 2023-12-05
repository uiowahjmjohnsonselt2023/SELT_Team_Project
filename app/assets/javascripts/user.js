// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function updateUserRating(rating) {
    var stars = "";
    for (var i = 0; i < 5; i++) {
        if (i < rating) {
            stars += "<span class='star filled'>★</span>"; // filled star
        } else {
            stars += "<span class='star'>☆</span>"; // empty star
        }
    }
    return stars;
}

// New function for toggling dropdowns
function toggleDropdown(dropdownId) {
    var dropdown = document.getElementById(dropdownId);
    dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
}
