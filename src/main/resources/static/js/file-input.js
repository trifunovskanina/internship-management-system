document.querySelectorAll(".custom-file-input input[type='file']").forEach(function (input) {
    input.addEventListener("change", function () {
        const fileName = this.parentElement.querySelector(".file-name");
        fileName.textContent = this.files.length > 0
            ? this.files[0].name
            : "No file chosen";
    });
});
