(() => {
(function initTraveler() {
  const hiddenInput = document.getElementById("travelers");
  const countEl     = document.getElementById("countDisplay");
  const minusBtn    = document.querySelector("[data-counter-minus]");
  const plusBtn     = document.querySelector("[data-counter-plus]");
  const presets     = document.querySelectorAll(".preset-chip");
  const badge       = document.getElementById("travelerBadge");

  if (!hiddenInput || !countEl || !minusBtn || !plusBtn) return;


  const MIN = 1, MAX = 20;
  let count = 2;

  const LABELS = { 1: "혼자", 2: "둘이", 3: "셋이", 4: "넷이서" };

  function render() {
    countEl.textContent = count;
    hiddenInput.value   = count;
    countEl.style.transform = "scale(1.28)";
    setTimeout(() => (countEl.style.transform = "scale(1)"), 140);
    minusBtn.disabled = count <= MIN;
    plusBtn.disabled  = count >= MAX;
    if (badge) badge.textContent = LABELS[count] || count + "명";
    presets.forEach(c => c.classList.toggle("is-active", Number(c.dataset.val) === count));
  }

  minusBtn.addEventListener("click", () => { if (count > MIN) { count--; render(); } });
  plusBtn.addEventListener("click",  () => { if (count < MAX) { count++; render(); } });
  presets.forEach(c => c.addEventListener("click", () => {
    const v = Number(c.dataset.val);
    if (v >= MIN && v <= MAX) { count = v; render(); }
  }));

  hiddenInput.addEventListener("input", () => {
    let v = parseInt(hiddenInput.value, 10);
    if (isNaN(v)) return;
    count = Math.min(MAX, Math.max(MIN, v));
    hiddenInput.value = count;
    countEl.textContent = count;
    countEl.style.transform = "scale(1.28)";
    setTimeout(() => (countEl.style.transform = "scale(1)"), 140);
    minusBtn.disabled = count <= MIN;
    plusBtn.disabled  = count >= MAX;
    if (badge) badge.textContent = LABELS[count] || count + "명";
    presets.forEach(c => c.classList.toggle("is-active", Number(c.dataset.val) === count));
  });

  render();
})();

(function initBudget() {
  const STEP = 10000, ABS_MIN = 0, ABS_MAX = 5000000;

  const rangeMin  = document.getElementById("rangeMin");
  const rangeMax  = document.getElementById("rangeMax");
  const fill      = document.getElementById("rangeFill");
  const textMin   = document.getElementById("minPrice");
  const textMax   = document.getElementById("maxPrice");
  const summaryEl = document.getElementById("budgetSummaryVal");
  const boxMin    = document.querySelector(".budget-amount-box--min");
  const boxMax    = document.querySelector(".budget-amount-box--max");
  const presets   = document.querySelectorAll(".budget-preset-btn");

  if (!rangeMin || !rangeMax) return;

  let minVal = 0, maxVal = 5000000;

  function fmt(n) {
    if (n >= 5000000) return "500만+";
    if (n >= 1000000)  return Math.floor(n / 10000) + "만";
    return n.toLocaleString("ko-KR");
  }
  function fmtFull(n) {
    if (n >= 10000000) return "500만 원+";
    return n.toLocaleString("ko-KR") + " 원";
  }

  function syncAll() {
    minVal = Math.max(ABS_MIN, Math.min(minVal, ABS_MAX - STEP));
    maxVal = Math.max(ABS_MIN + STEP, Math.min(maxVal, ABS_MAX));
    if (minVal >= maxVal) minVal = maxVal - STEP;

    rangeMin.value = minVal;
    rangeMax.value = maxVal;

    if (document.activeElement !== textMin)
      textMin.value = minVal === 0 ? "" : minVal;
    if (document.activeElement !== textMax)
      textMax.value = maxVal === ABS_MAX ? "" : maxVal;

    const pMin = (minVal / ABS_MAX) * 100;
    const pMax = (maxVal / ABS_MAX) * 100;
    fill.style.left  = pMin + "%";
    fill.style.width = (pMax - pMin) + "%";

    if (minVal === 0 && maxVal === ABS_MAX) {
      summaryEl.textContent = "제한 없음";
    } else if (minVal === 0) {
      summaryEl.textContent = fmtFull(maxVal) + " 이하";
    } else if (maxVal === ABS_MAX) {
      summaryEl.textContent = fmtFull(minVal) + " 이상";
    } else {
      summaryEl.textContent = fmt(minVal) + " ~ " + fmtFull(maxVal);
    }

    presets.forEach(btn => {
      const [pMin, pMax] = btn.dataset.range.split(",").map(Number);
      btn.classList.toggle("is-active", pMin === minVal && pMax === maxVal);
    });
  }

  rangeMin.addEventListener("input", () => {
    minVal = Number(rangeMin.value);
    if (minVal >= maxVal) minVal = maxVal - STEP;
    syncAll();
  });
  rangeMax.addEventListener("input", () => {
    maxVal = Number(rangeMax.value);
    if (maxVal <= minVal) maxVal = minVal + STEP;
    syncAll();
  });

  [textMin, textMax].forEach((el, i) => {
    const box = i === 0 ? boxMin : boxMax;
    el.addEventListener("focus", () => box && box.classList.add("is-focused"));
    el.addEventListener("blur",  () => {
      box && box.classList.remove("is-focused");
      const v = parseInt(el.value, 10);
      if (!isNaN(v)) {
        if (i === 0) minVal = Math.round(v / STEP) * STEP;
        else         maxVal = Math.round(v / STEP) * STEP;
        syncAll();
      }
    });
  });

  presets.forEach(btn => btn.addEventListener("click", () => {
    const [pMin, pMax] = btn.dataset.range.split(",").map(Number);
    minVal = pMin; maxVal = pMax; syncAll();
  }));

  syncAll();
})();

(function initAirportSelector() {
  const airports = [
    {
      code: "ICN",
      name: "인천국제공항",
      address: "인천광역시 중구 공항로 272",
      summary: "가장 많은 일본 노선과 소도시 연결편",
      routes: ["도쿄", "오사카", "후쿠오카", "삿포로", "나고야", "오키나와", "히로시마", "센다이", "시즈오카"]
    },
    {
      code: "GMP",
      name: "김포국제공항",
      address: "서울특별시 강서구 하늘길 112",
      summary: "서울 도심 접근성이 좋은 비즈니스 중심 공항",
      routes: ["도쿄 하네다", "오사카 간사이"]
    },
    {
      code: "PUS",
      name: "김해국제공항",
      address: "부산광역시 강서구 공항진입로 108",
      summary: "부산과 영남권에서 일본 주요 도시로 이동",
      routes: ["도쿄", "오사카", "후쿠오카", "삿포로", "마쓰야마"]
    },
    {
      code: "CJU",
      name: "제주국제공항",
      address: "제주특별자치도 제주시 공항로 2",
      summary: "제주 출발 도쿄, 오사카 중심 노선",
      routes: ["도쿄", "오사카", "후쿠오카"]
    },
    {
      code: "TAE",
      name: "대구국제공항",
      address: "대구광역시 동구 공항로 221",
      summary: "대구 출발 일본 주요 대도시 직항",
      routes: ["도쿄", "오사카", "후쿠오카"]
    },
    {
      code: "CJJ",
      name: "청주국제공항",
      address: "충청북도 청주시 청원구 내수읍 오창대로 980",
      summary: "최근 일본 노선 선택지가 넓어진 중부권 공항",
      routes: ["도쿄", "오사카", "후쿠오카", "삿포로"]
    }
  ];

  const trigger = document.getElementById("airportTrigger");
  const triggerValue = document.getElementById("airportTriggerValue");
  const triggerCode = document.getElementById("airportTriggerCode");
  const backdrop = document.getElementById("airportBackdrop");
  const sheet = document.getElementById("airportSheet");
  const closeBtn = document.getElementById("airportSheetClose");
  const list = document.getElementById("airportList");
  const applyBtn = document.getElementById("airportApplyBtn");
  const codeInput = document.getElementById("departureAirportCode");
  const nameInput = document.getElementById("departureAirportName");
  const addressInput = document.getElementById("departureAirportAddress");
  const routesInput = document.getElementById("departureAirportRoutes");
  let previousBodyOverflow = "";

  if (!trigger || !backdrop || !sheet || !list) return;

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function renderAirports() {
    list.innerHTML = airports.map(function(airport) {
      const routeChips = airport.routes
        .map(function(route) {
          return `<span class="airport-route-chip">${escapeHtml(route)}</span>`;
        })
        .join("");

      return `
        <button type="button" class="airport-option" data-code="${airport.code}">
          <span class="airport-option__top">
            <span>
              <span class="airport-option__name">${escapeHtml(airport.name)}</span>
              <span class="airport-option__summary">${escapeHtml(airport.summary)}</span>
            </span>
            <span class="airport-option__code">${airport.code}</span>
          </span>
          <span class="airport-option__details">
            <span class="airport-option__detail-label">주소</span>
            <span class="airport-option__detail-text">${escapeHtml(airport.address)}</span>
            <span class="airport-option__detail-label">갈 수 있는 일본 노선</span>
            <span class="airport-route-chips">${routeChips}</span>
          </span>
        </button>
      `;
    }).join("");
  }

  function openSheet() {
    if (!list.innerHTML) renderAirports();
    previousBodyOverflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    backdrop.classList.add("open");
    sheet.classList.add("open");
  }

  function closeSheet() {
    backdrop.classList.remove("open");
    sheet.classList.remove("open");
    document.body.style.overflow = previousBodyOverflow;
  }

  function selectAirport(airport) {
    if (!airport) return;

    trigger.classList.add("is-selected");
    triggerValue.textContent = airport.name;
    triggerCode.textContent = airport.code;
    codeInput.value = airport.code;
    nameInput.value = airport.name;
    addressInput.value = airport.address;
    routesInput.value = airport.routes.join(", ");
    if (applyBtn) applyBtn.disabled = false;

    list.querySelectorAll(".airport-option").forEach(function(option) {
      option.classList.toggle("is-active", option.dataset.code === airport.code);
    });
  }

  trigger.addEventListener("click", openSheet);
  backdrop.addEventListener("click", closeSheet);
  closeBtn && closeBtn.addEventListener("click", closeSheet);
  applyBtn && applyBtn.addEventListener("click", function() {
    if (!applyBtn.disabled) closeSheet();
  });

  list.addEventListener("click", function(e) {
    const option = e.target.closest(".airport-option");
    if (!option) return;

    const airport = airports.find(function(item) {
      return item.code === option.dataset.code;
    });
    selectAirport(airport);
  });
})();

function renderLucideIcons() {
  if (window.lucide && typeof window.lucide.createIcons === "function") {
    window.lucide.createIcons();
  }
}

renderLucideIcons();

const form = document.getElementById("planForm");
const searchContainer = document.getElementById("searchContainer");
const loadingOverlay = document.getElementById("loadingOverlay");
const progressBar = document.getElementById("progressBar");
const progressText = document.getElementById("progressText");
const destinationInput = document.querySelector('input[name="destination"]');
const travelersInput = document.querySelector('input[name="travelers"]');
const departureAirportInput = document.getElementById("departureAirportCode");
const startDateInput = document.getElementById("startDate");
const endDateInput = document.getElementById("endDate");
const airportTrigger = document.getElementById("airportTrigger");
const dateTrigger = document.getElementById("dateTrigger");
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
  renderLucideIcons();
}

function getFieldWrapper(control) {
  return control ? control.closest(".form-field") : null;
}

function setFieldError(control, message) {
  const wrapper = getFieldWrapper(control);
  if (!wrapper) return;

  control.classList.add("is-invalid");
  control.setAttribute("aria-invalid", "true");

  let errorEl = wrapper.querySelector(".field-error");
  if (!errorEl) {
    errorEl = document.createElement("p");
    errorEl.className = "field-error";
    wrapper.appendChild(errorEl);
  }
  errorEl.textContent = message;
}

function clearFieldError(control) {
  const wrapper = getFieldWrapper(control);
  if (!wrapper) return;

  control.classList.remove("is-invalid");
  control.removeAttribute("aria-invalid");

  const errorEl = wrapper.querySelector(".field-error");
  if (errorEl) {
    errorEl.remove();
  }
}

function validateRequiredSearchFields() {
  const checks = [
    {
      control: airportTrigger,
      isValid: departureAirportInput && departureAirportInput.value.trim(),
      message: "출발 공항을 선택해 주세요."
    },
    {
      control: destinationInput,
      isValid: destinationInput && destinationInput.value.trim(),
      message: "여행지를 입력해 주세요."
    },
    {
      control: dateTrigger,
      isValid: startDateInput && startDateInput.value.trim() && endDateInput && endDateInput.value.trim(),
      message: "여행 기간을 선택해 주세요."
    }
  ];

  let firstInvalid = null;
  checks.forEach(function(check) {
    if (!check.control) return;

    if (check.isValid) {
      clearFieldError(check.control);
      return;
    }

    setFieldError(check.control, check.message);
    if (!firstInvalid) {
      firstInvalid = check.control;
    }
  });

  if (firstInvalid) {
    firstInvalid.focus();
    firstInvalid.scrollIntoView({ behavior: "smooth", block: "center" });
    return false;
  }

  return true;
}

if (airportTrigger) {
  airportTrigger.addEventListener("click", function() {
    clearFieldError(airportTrigger);
  });
}

if (destinationInput) {
  destinationInput.addEventListener("input", function() {
    if (destinationInput.value.trim()) {
      clearFieldError(destinationInput);
    }
  });
}

if (dateTrigger) {
  dateTrigger.addEventListener("click", function() {
    clearFieldError(dateTrigger);
  });
}

if (form) {
  form.addEventListener("submit", function (e) {
    e.preventDefault();

    if (!validateRequiredSearchFields()) {
      return;
    }

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
        renderLucideIcons();
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
})();
