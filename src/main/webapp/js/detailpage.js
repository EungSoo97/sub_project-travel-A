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

// Form will submit normally without JavaScript interference
function openReviewSheet() {
  document.getElementById("planBackdrop").classList.add("show");
  document.getElementById("planSheet").classList.add("show");
  document.body.style.overflow = "hidden";
}

function closeReviewSheet() {
  document.getElementById("planBackdrop").classList.remove("show");
  document.getElementById("planSheet").classList.remove("show");
  document.body.style.overflow = "";
}