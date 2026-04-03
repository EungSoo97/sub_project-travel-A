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

const customAddBtn  = document.getElementById('customAddBtn');
const customGroup   = document.getElementById('customChipGroup');
const backdrop      = document.getElementById('backdrop');
const inputSheet    = document.getElementById('inputSheet');
const sheetInput    = document.getElementById('sheetInput');
const sheetConfirm  = document.getElementById('sheetConfirm');
const sheetCancel   = document.getElementById('sheetCancel');

function openSheet() {
  backdrop.classList.add('is-open');
  inputSheet.classList.add('is-open');
  setTimeout(() => sheetInput.focus(), 300);
}

function closeSheet() {
  backdrop.classList.remove('is-open');
  inputSheet.classList.remove('is-open');
  sheetInput.value = '';
}

function addCustomChip() {
  const val = sheetInput.value.trim();
  if (!val) { closeSheet(); return; }

  const label = document.createElement('label');
  label.className = 'chip chip--custom';

  const cb = document.createElement('input');
  cb.type = 'checkbox';
  cb.name = 'customTag';
  cb.value = val;
  cb.checked = true;

  const span = document.createElement('span');
  span.textContent = val;

  const xBtn = document.createElement('button');
  xBtn.type = 'button';
  xBtn.className = 'chip-remove';
  xBtn.textContent = '✕';
  xBtn.addEventListener('click', (e) => {
    e.preventDefault();
    label.remove();
  });

  span.appendChild(xBtn);
  label.appendChild(cb);
  label.appendChild(span);
  customGroup.insertBefore(label, customAddBtn);
  closeSheet();
}

if (customAddBtn) {
  customAddBtn.addEventListener('click', openSheet);
  backdrop.addEventListener('click', closeSheet);
  sheetConfirm.addEventListener('click', addCustomChip);
  sheetCancel.addEventListener('click', closeSheet);
  sheetInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') addCustomChip();
  });
}


// ── Date Range Picker (Bottom Sheet) ──
(function () {
  const DAYS_KO   = ['일','월','화','수','목','금','토'];
  const MONTHS_KO = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
  const toYMD     = d => `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`;
  const parseYMD  = s => { const [y,m,d] = s.split('-'); return new Date(+y, +m-1, +d); };
  const diffDays  = (a, b) => Math.round((b - a) / 86400000);
  const fmtMid    = d => `${d.getMonth()+1}월 ${d.getDate()}일`;
  const fmtShort  = d => `${d.getMonth()+1}.${d.getDate()}`;
  const today     = new Date(); today.setHours(0, 0, 0, 0);

  let startDate = null, endDate = null, phase = 0;

  const dateTrigger   = document.getElementById('dateTrigger');
  const triggerVal    = document.getElementById('triggerVal');
  const triggerNights = document.getElementById('triggerNights');
  const backdrop      = document.getElementById('dateBackdrop');
  const sheet         = document.getElementById('dateSheet');
  const sheetClose    = document.getElementById('dateSheetClose');
  const calScroll     = document.getElementById('calScroll');
  const sumStart      = document.getElementById('sumStart');
  const sumEnd        = document.getElementById('sumEnd');
  const sumNights     = document.getElementById('sumNights');
  const footerInfo    = document.getElementById('footerInfo');
  const applyBtn      = document.getElementById('calApplyBtn');
  const hidStart      = document.getElementById('startDate');
  const hidEnd        = document.getElementById('endDate');

  if (!dateTrigger) return;

  function openSheet() {
    backdrop.classList.add('open');
    sheet.classList.add('open');
    if (!calScroll.innerHTML) buildCalendars();
  }
  function closeSheet() {
    backdrop.classList.remove('open');
    sheet.classList.remove('open');
  }

  dateTrigger.addEventListener('click', openSheet);
  backdrop.addEventListener('click', closeSheet);
  sheetClose.addEventListener('click', closeSheet);

  function buildCalendars() {
    const now = new Date();
    let html = '';
    for (let i = 0; i < 6; i++) {
      const yr = now.getFullYear() + Math.floor((now.getMonth() + i) / 12);
      const mo = (now.getMonth() + i) % 12;
      html += buildMonth(yr, mo);
    }
    calScroll.innerHTML = html;
    calScroll.querySelectorAll('.cal-day[data-ymd]').forEach(el => {
      el.addEventListener('click', onDayClick);
    });
  }

  function buildMonth(yr, mo) {
    const first = new Date(yr, mo, 1);
    const last  = new Date(yr, mo + 1, 0);
    const dow   = first.getDay();
    let days = '';
    for (let i = 0; i < dow; i++) days += `<div class="cal-day empty"></div>`;
    for (let d = 1; d <= last.getDate(); d++) {
      const dt  = new Date(yr, mo, d);
      const ymd = toYMD(dt);
      let cls   = 'cal-day';
      if (dt < today)                    cls += ' past';
      else if (dt.getTime() === today.getTime()) cls += ' today';
      days += `<div class="${cls}" data-ymd="${ymd}">${d}</div>`;
    }
    return `<div class="cal-month">
      <div class="cal-month-label">${yr}년 ${MONTHS_KO[mo]}</div>
      <div class="cal-dow"><span>일</span><span>월</span><span>화</span><span>수</span><span>목</span><span>금</span><span>토</span></div>
      <div class="cal-days">${days}</div>
    </div>`;
  }

  function onDayClick(e) {
    const d = parseYMD(e.currentTarget.dataset.ymd);

    if (phase === 0) {
      startDate = d; endDate = null; phase = 1;

    } else if (phase === 1) {
      if (d.getTime() === startDate.getTime()) {
        // 출발일 재클릭 → 선택 전체 취소
        startDate = null; endDate = null; phase = 0;
      } else if (d < startDate) {
        endDate = startDate; startDate = d; phase = 2;
      } else {
        endDate = d; phase = 2;
      }

    } else if (phase === 2) {
      if (d.getTime() === startDate.getTime()) {
        // 출발일 재클릭 → 출발일만 취소, 도착일을 새 출발일로
        startDate = endDate; endDate = null; phase = 1;
      } else if (d.getTime() === endDate.getTime()) {
        // 도착일 재클릭 → 도착일만 취소
        endDate = null; phase = 1;
      } else {
        // 다른 날짜 → 출발일부터 새로 선택
        startDate = d; endDate = null; phase = 1;
      }
    }

    applyBtn.disabled = !(startDate && endDate);
    refreshHighlight();
  }

  function refreshHighlight() {
    calScroll.querySelectorAll('.cal-day[data-ymd]').forEach(el => {
      el.classList.remove('sel-start', 'sel-end', 'in-range', 'range-start-cap', 'range-end-cap');
      const d = parseYMD(el.dataset.ymd);
      if (startDate && d.getTime() === startDate.getTime()) el.classList.add('sel-start');
      if (endDate   && d.getTime() === endDate.getTime())   el.classList.add('sel-end');
      if (startDate && endDate && d > startDate && d < endDate) {
        el.classList.add('in-range');
        const prev = new Date(d); prev.setDate(prev.getDate() - 1);
        const next = new Date(d); next.setDate(next.getDate() + 1);
        if (prev.getTime() === startDate.getTime()) el.classList.add('range-start-cap');
        if (next.getTime() === endDate.getTime())   el.classList.add('range-end-cap');
      }
    });
    updateSummary();
  }

  function updateSummary() {
    if (startDate) {
      sumStart.textContent = `${fmtMid(startDate)} (${DAYS_KO[startDate.getDay()]})`;
      sumStart.classList.remove('empty');
    } else {
      sumStart.textContent = '선택 전';
      sumStart.classList.add('empty');
    }
    if (endDate) {
      sumEnd.textContent = `${fmtMid(endDate)} (${DAYS_KO[endDate.getDay()]})`;
      sumEnd.classList.remove('empty');
    } else {
      sumEnd.textContent = '선택 전';
      sumEnd.classList.add('empty');
    }
    if (startDate && endDate) {
      const n = diffDays(startDate, endDate);
      sumNights.textContent = `${n}박 ${n+1}일`;
      sumNights.classList.add('visible');
      footerInfo.innerHTML = `<strong>${fmtShort(startDate)} ~ ${fmtShort(endDate)}</strong>${n}박 ${n+1}일`;
    } else if (startDate) {
      sumNights.classList.remove('visible');
      footerInfo.textContent = '도착일을 선택하세요';
    } else {
      sumNights.classList.remove('visible');
      footerInfo.textContent = '출발일을 먼저 선택하세요';
    }
  }

  applyBtn.addEventListener('click', () => {
    if (!startDate || !endDate) return;
    const n = diffDays(startDate, endDate);
    triggerVal.textContent      = `${fmtMid(startDate)} ~ ${fmtMid(endDate)}`;
    triggerNights.textContent   = `${n}박 ${n+1}일`;
    triggerNights.style.display = 'inline-flex';
    dateTrigger.classList.add('has-value', 'active');
    hidStart.value = toYMD(startDate);
    hidEnd.value   = toYMD(endDate);
    closeSheet();
  });
})();