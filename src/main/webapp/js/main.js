document.addEventListener("DOMContentLoaded", function () {
  const menuBtn = document.getElementById("mobileMenuBtn");
  const nav = document.getElementById("siteNav");
  const travelerInput = document.getElementById("travelers");
  const plusBtn = document.querySelector("[data-counter-plus]");
  const minusBtn = document.querySelector("[data-counter-minus]");
  const uploadTrigger = document.getElementById("uploadTrigger");
  const imageFile = document.getElementById("imageFile");
  const uploadPreview = document.getElementById("uploadPreview");

  document.querySelector(".mobile-menu-btn").addEventListener("click", () => {
    document.querySelector(".site-nav").classList.toggle("is-open");
  });
  if (menuBtn && nav) {
    menuBtn.addEventListener("click", function () {
      nav.classList.toggle("is-open");
    });
  }

  if (travelerInput && plusBtn && minusBtn) {
    plusBtn.addEventListener("click", function () {
      const current = Number(travelerInput.value || 1);
      travelerInput.value = String(Math.min(current + 1, 20));
    });

    minusBtn.addEventListener("click", function () {
      const current = Number(travelerInput.value || 1);
      travelerInput.value = String(Math.max(current - 1, 1));
    });
  }

  if (uploadTrigger && imageFile) {
    uploadTrigger.addEventListener("click", function () {
      imageFile.click();
    });

    imageFile.addEventListener("change", function (e) {
      const file = e.target.files && e.target.files[0];
      if (!file || !uploadPreview) return;

      const reader = new FileReader();
      reader.onload = function (event) {
        uploadPreview.innerHTML = "";

        const img = document.createElement("img");
        img.src = event.target.result;
        img.alt = "업로드 이미지 미리보기";

        const text = document.createElement("p");
        text.textContent =
          "이미지 업로드 완료 - 실제 AI 분석 API 연결 전 단계입니다.";

        uploadPreview.appendChild(img);
        uploadPreview.appendChild(text);
      };
      reader.readAsDataURL(file);
    });
  }
});

const minInput = document.getElementById("minPrice");
const maxInput = document.getElementById("maxPrice");

minInput.addEventListener("input", () => {
  maxInput.min = minInput.value;
});

lucide.createIcons();

const form = document.getElementById("planForm");
const searchContainer = document.getElementById("searchContainer");
const loadingOverlay = document.getElementById("loadingOverlay");
const progressBar = document.getElementById("progressBar");
const progressText = document.getElementById("progressText");
const destinationInput = document.querySelector('input[name="destination"]');
const travelersInput = document.querySelector('input[name="travelers"]');
const aiMessage = document.getElementById("aiMessage");

let progress = 0;
let currentStep = 0;

const messages = [
  "1,247개의 관광지 데이터를 분석하고 있습니다...",
  "37개의 가능한 경로를 비교하고 있습니다...",
  "실시간 영업시간과 혼잡도를 확인하고 있습니다...",
  "맞춤형 여행 일정을 생성 중입니다..."
];

function updateAIMessage() {
  if (aiMessage) {
    aiMessage.innerText = messages[currentStep];
  }
}

function markStepDone(stepEl) {
  if (!stepEl) return;

  stepEl.classList.remove("active");
  stepEl.classList.add("done");

  const iconEl = stepEl.querySelector(".icon");
  if (iconEl) {
    iconEl.innerHTML = '<i data-lucide="check"></i>';
  }
}

function markStepActive(stepEl) {
  if (!stepEl) return;

  stepEl.classList.add("active");
}

function resetLoadingState() {
  progress = 0;
  currentStep = 0;

  if (progressBar) progressBar.style.width = "0%";
  if (progressText) progressText.innerText = "0%";

  for (let i = 0; i < 4; i++) {
    const stepEl = document.getElementById("step" + i);
    if (!stepEl) continue;

    stepEl.classList.remove("active", "done");

    const iconEl = stepEl.querySelector(".icon");
    if (!iconEl) continue;

    if (i === 0) {
      stepEl.classList.add("active");
      iconEl.innerHTML = '<i data-lucide="map"></i>';
    } else if (i === 1) {
      iconEl.innerHTML = '<i data-lucide="trending-up"></i>';
    } else if (i === 2) {
      iconEl.innerHTML = '<i data-lucide="calendar"></i>';
    } else if (i === 3) {
      iconEl.innerHTML = '<i data-lucide="sparkles"></i>';
    }
  }

  updateAIMessage();
  lucide.createIcons();
}

if (form) {
  form.addEventListener("submit", function (e) {
    e.preventDefault();

    resetLoadingState();

    searchContainer.style.display = "none";
    loadingOverlay.style.display = "flex";

    const destination = destinationInput ? destinationInput.value : "";
    const travelers = travelersInput ? travelersInput.value : "";

    const metaContext = document.getElementById("loadingMetaContext");
    if (metaContext) {
      metaContext.innerText = destination + " · " + travelers + "명";
    }

    // 진행률: 6초 동안 100%
    const progressInterval = setInterval(() => {
      if (progress < 100) {
        progress++;
        if (progressBar) progressBar.style.width = progress + "%";
        if (progressText) progressText.innerText = progress + "%";
      } else {
        clearInterval(progressInterval);
      }
    }, 60);

    // 단계 전환: 1.5초마다
    const stepInterval = setInterval(() => {
      if (currentStep < 3) {
        const prevStep = document.getElementById("step" + currentStep);
        markStepDone(prevStep);

        currentStep++;

        const currentStepEl = document.getElementById("step" + currentStep);
        markStepActive(currentStepEl);

        updateAIMessage();
        lucide.createIcons();
      } else {
        clearInterval(stepInterval);
      }
    }, 1500);

    const formData = new FormData(form);
    const queryString = new URLSearchParams(formData).toString();

    fetch("planner/result?" + queryString, {
      method: "GET",
    })
        .then((response) => response.text())
        .then((html) => {
          clearInterval(progressInterval);
          clearInterval(stepInterval);

          if (progressBar) progressBar.style.width = "100%";
          if (progressText) progressText.innerText = "100%";

          setTimeout(() => {
            document.open();
            document.write(html);
            document.close();
          }, 800);
        })
        .catch((err) => {
          clearInterval(progressInterval);
          clearInterval(stepInterval);
          alert("서버 연결에 실패했습니다: " + err);
          window.location.reload();
        });
  });
}