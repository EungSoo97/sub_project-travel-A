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

function showLoginAlert() {
    alert('좋아요를 누르려면 로그인이 필요합니다.');
}

function toggleHeart(btn, postId) {
    fetch(`/like`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ planId: postId })  // ✅ 여기만 수정
    })
        .then(res => res.json())
        .then(data => {
            if (data.liked) {
                btn.innerText = "❤";
            } else {
                btn.innerText = "♡";
            }
        })
        .catch(err => {
            console.error(err);
        });
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
