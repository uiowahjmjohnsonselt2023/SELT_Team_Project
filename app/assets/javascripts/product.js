document.addEventListener('DOMContentLoaded', function() {
    const productImages = document.getElementById('image_field');
    const imageError = document.getElementById('image_error');
    const imagePreview = document.getElementById('image_preview');
    const checkbox = document.getElementById("flexSwitchCheckDefault");
    const switchLabel = document.getElementById("switchLabel");

    if (productImages) {
        productImages.addEventListener('change', function(e) {
            if (e.target.files.length > 5) {
                alert('You can only upload a maximum of 5 files');
                e.target.value = '';
                imageError.style.display = 'block';
            } else {
                imageError.style.display = 'none';
            }

            imagePreview.innerHTML = '';

            for (let i = 0; i < e.target.files.length; i++) {
                const img = document.createElement('img');
                img.src = URL.createObjectURL(e.target.files[i]);
                img.style.width = '100px';
                img.style.height = '100px';
                img.style.marginRight = '10px';
                img.className = 'preview-image';
                img.role = 'presentation';
                imagePreview.appendChild(img);
            }
        });
    }

    if (checkbox) {
        checkbox.addEventListener("change", function() {
            switchLabel.innerHTML = checkbox.checked ? "List View" : "Card View";
        });
    }
});
