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

// Function to set the address index and update form fields
function setAddressIndex(index, addresses) {
    // Update the hidden field with the selected index
    document.getElementById("selected-address-index").value = index;

    // Set the form fields with the address data
    if (addresses[index - 1]) {
        var address = addresses[index - 1];
        document.getElementById("street").value = address.street;
        document.getElementById("city").value = address.city;
        document.getElementById("state").value = address.state;
        document.getElementById("zip").value = address.zip;
        document.getElementById("country").value = address.country;
    }
}

// Function to attach event listeners to address buttons
function attachAddressButtonListeners(addresses) {
    document.querySelectorAll('.set-address-index').forEach(button => {
        button.addEventListener('click', (e) => {
            const index = e.target.getAttribute('data-index');
            setAddressIndex(index, addresses);
        });
    });
}


// Export the functions if using ES6 modules, otherwise omit this part
export { setAddressIndex, attachAddressButtonListeners };
