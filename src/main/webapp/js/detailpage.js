function copyUrl() {
  const url = window.location.href;

  navigator.clipboard
    .writeText(url)
    .then(() => {
      alert("URL이 복사되었습니다!");
    })
    .catch((err) => {
      console.error("복사 실패:", err);
    });
}
function toggleHeart(btn) {
  if (btn.innerText === "♡") {
    btn.innerText = "❤";
  } else {
    btn.innerText = "♡";
  }
}

const modal = document.getElementById("Modal");
const openBtn = document.getElementById("openModalBtn");
const closeBtn = document.getElementById("closeModalBtn");
const reviewText = document.getElementById("reviewText");
const submitReview = document.getElementById("submitReview");

if (openBtn) {
  openBtn.onclick = function () {
    modal.style.display = "block";
  };
}

if (closeBtn) {
  closeBtn.onclick = function () {
    modal.style.display = "none";
  };
}

window.onclick = function (event) {
  if (event.target === modal) {
    modal.style.display = "none";
  }
};

if (submitReview) {
  submitReview.onclick = function () {
    const content = reviewText ? reviewText.value.trim() : "";
    if (content === "") {
      alert("후기를 입력해주세요.");
      return;
    }
    console.log("작성된 후기", content);
    // Find the form and submit it
    const form = submitReview.closest('form');
    if (form) {
      form.submit();
    }
  };
}
