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

let progress = 0;
let currentStep = 0;
const totalEstimatedTimeMs = 1000000; // 예상 생성 시간: 45초 (Gemini 2.5 JSON 생성기반)

form.addEventListener("submit", function (e) {
  e.preventDefault(); // 기본 form submit 보류 (AJAX 처리)

  // 1. 화면 전환 애니메이션
  searchContainer.classList.add("opacity-0");
  setTimeout(() => {
    searchContainer.style.display = "none";
    loadingOverlay.style.display = "flex";
    document.getElementById("loadingMetaContext").innerText =
      destinationInput.value + " · " + travelersInput.value + "명";
  }, 300);

  // 2. 가짜 프로그래스 바 (45초 동안 95%까지 서서히 차오르게)
  const intervalTime = totalEstimatedTimeMs / 95;
  const progressInterval = setInterval(() => {
    if (progress < 95) {
      progress += 1;
      progressBar.style.width = progress + "%";
      progressText.innerText = progress + "%";
    }
  }, intervalTime);

  // 3. 4개의 스텝 애니메이션 렌더링
  const stepDuration = totalEstimatedTimeMs / 4;
  const stepInterval = setInterval(() => {
    if (currentStep < 3) {
      // 이전 스텝 완료 처리
      const prevDiv = document.getElementById("step" + currentStep);
      prevDiv.classList.remove(
        "bg-blue-50",
        "border-2",
        "border-blue-500",
        "scale-105",
      );
      prevDiv.classList.add("bg-gray-100");
      // 아이콘 체크 표시로 변경 (Lucide 아이콘 객체화)
      prevDiv
        .querySelector(".flex-shrink-0")
        .classList.replace("bg-blue-100", "bg-blue-600");
      prevDiv
        .querySelector(".flex-shrink-0")
        .classList.replace("text-blue-600", "text-white");
      prevDiv.querySelector(".flex-shrink-0").innerHTML =
        '<i data-lucide="check" class="w-6 h-6"></i>';
      prevDiv
        .querySelector("h3")
        .classList.replace("text-blue-700", "text-gray-800");

      currentStep += 1;

      // 다음 스텝 활성화
      const currDiv = document.getElementById("step" + currentStep);
      currDiv.classList.remove("bg-gray-50", "opacity-60");
      currDiv.classList.add(
        "bg-blue-50",
        "border-2",
        "border-blue-500",
        "scale-105",
      );

      const currIconBg = currDiv.querySelector(".flex-shrink-0");
      currIconBg.classList.replace("bg-white", "bg-blue-100");
      currIconBg.classList.replace("text-gray-400", "text-blue-600");
      // 현재 아이콘에 펄스 애니메이션 추가
      currIconBg.querySelector("i").classList.add("animate-pulse");
      currDiv
        .querySelector("h3")
        .classList.replace("text-gray-700", "text-blue-700");

      lucide.createIcons(); // 새로운 아이콘 렌더링
    }
  }, stepDuration);

  // 4. AJAX 전송
  const formData = new FormData(form);
  const queryString = new URLSearchParams(formData).toString();

  fetch("planner/result?" + queryString, {
    method: "GET",
  })
    .then((response) => response.text())
    .then((html) => {
      // 통신 완료! 강제로 100%
      clearInterval(progressInterval);
      clearInterval(stepInterval);
      progressBar.style.width = "100%";
      progressText.innerText = "100%";

      setTimeout(() => {
        // 받아온 JSP 결과 화면으로 페이지 완전 치환
        document.open();
        document.write(html);
        document.close();
      }, 800);
    })
    .catch((err) => {
      alert("서버 연결에 실패했습니다: " + err);
      window.location.reload();
    });
});
