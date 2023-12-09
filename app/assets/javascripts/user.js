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

document.addEventListener('DOMContentLoaded', () => {
    let addresses = [];

    // Function to fetch addresses from the server
    function fetchAddresses(userId) {
        fetch(`/users/${userId}/addresses`) // Adjust the URL as necessary
            .then(response => response.json())
            .then(data => {
                addresses = data;
                attachAddressButtonListeners();
            })
            .catch(error => console.error('Error fetching addresses:', error));
    }

    function displayAddress(index) {
        if (addresses[index]) {
            const address = addresses[index];
            document.getElementById('street').value = address.street;
            document.getElementById('city').value = address.city;
            document.getElementById('state').value = address.state;
            document.getElementById('zip').value = address.zip;
            document.getElementById('country').value = address.country;
        } else {
            console.error('Address does not exist at index:', index);
        }
    }

    function updateAddress() {
        const userId = document.body.getAttribute('data-user-id');
        const addressData = new URLSearchParams({
            street: document.getElementById('street').value,
            city: document.getElementById('city').value,
            state: document.getElementById('state').value,
            zip: document.getElementById('zip').value,
            country: document.getElementById('country').value,
            // Include any other necessary fields
        }).toString();

        // Retrieve CSRF token from meta tag
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        fetch(`/users/${userId}`, {  // Using the update_address_path
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-CSRF-Token': csrfToken,
            },
            body: addressData
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                console.log('Address updated:', data);
                // Handle successful update, e.g., show a success message
            })
            .catch(error => {
                console.error('Error updating address:', error);
                // Handle errors, e.g., show an error message
            });
    }




    function attachAddressButtonListeners() {
        document.querySelectorAll('.address-button').forEach(button => {
            button.addEventListener('click', function() {
                const index = parseInt(this.getAttribute('data-index'), 10);
                displayAddress(index);
                document.getElementById('address_index').value = index - 1; // Adjusting the index for the server
            });
        });
    }


    // Assuming the user ID is available somehow, e.g., injected into the page by the server
    const userId = document.body.getAttribute('data-user-id');
    fetchAddresses(userId);

    // Attach event listener to the "Update" button
    const updateButton = document.getElementById('update-button');
    if (updateButton) {
        updateButton.addEventListener('click', updateAddress);
    }
});

