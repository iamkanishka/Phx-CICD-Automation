Hooks.UploadFile = {
    mounted() {
      this.el.addEventListener("change", async (e) => {
        let file = e.target.files[0];
        let formData = new FormData();
        formData.append("file", file);
  
        let response = await fetch("/upload", {
          method: "POST",
          body: formData
        });
  
        let data = await response.json();
        if (data.url) {
          alert("Uploaded to: " + data.url);
        } else {
          alert("Upload failed");
        }
      });
    }
  };
  