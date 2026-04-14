<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Travel-A(AI) | AI 여행 플래너</title>
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
<main>

    <section class="hero section">
        <div class="container hero__inner">
            <span class="hero__badge">AI Travel Planner</span>
            <h1 class="hero__title">AI가 만드는 완벽한 여행</h1>
            <p class="hero__desc">당신의 취향과 예산에 맞춘 맞춤형 여행 일정을 몇 초 만에 완성하세요.</p>
        </div>
    </section>
    <form id="planForm" action="planner/result" method="get" class="space-y-5">
    <section class="search section search-section" id="searchContainer">
        <div class="container">
                <div class="search-card__header">
                    <h2>여행 조건 입력</h2>    <!--       -->
                    <p>JSP에서는 form submit 기반으로 서버에 조건을 넘기고, 이후 결과 페이지에서 itinerary를 렌더링하면 됩니다.</p>
                </div>

                <div class="form-grid">
                    <div class="form-field form-field--wide">
                        <label for="departureAirportCode">출발 공항</label>
                        <button type="button" class="airport-trigger" id="airportTrigger">
                            <span class="airport-trigger__icon">✈</span>
                            <span class="airport-trigger__main">
                                <span class="airport-trigger__label">국내 출발 공항</span>
                                <span class="airport-trigger__value" id="airportTriggerValue">공항을 선택해 주세요</span>
                            </span>
                            <span class="airport-trigger__code" id="airportTriggerCode"></span>
                        </button>
                        <input type="hidden" id="departureAirportCode" name="departureAirportCode">
                        <input type="hidden" id="departureAirportName" name="departureAirportName">
                        <input type="hidden" id="departureAirportAddress" name="departureAirportAddress">
                        <input type="hidden" id="departureAirportRoutes" name="departureAirportRoutes">
                    </div>

                    <div class="form-field form-field--wide">
                        <label for="destination">여행지</label>
                        <input id="destination" name="destination" type="text" placeholder="예: 일본, 시코쿠, 규슈" required>
                    </div>

                    <div class="form-field form-field--wide">
                        <label>여행 기간</label>
                        <div class="date-trigger" id="dateTrigger">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color:var(--primary);flex-shrink:0"><rect x="3" y="4" width="18" height="18" rx="3"/><path d="M16 2v4M8 2v4M3 10h18"/></svg>
                            <div class="trigger-main">
                                <span class="trigger-label">출발일 · 도착일</span>
                                <span class="trigger-val" id="triggerVal">날짜를 선택해주세요</span>
                            </div>
                            <span class="trigger-nights" id="triggerNights"></span>
                        </div>
                        <input type="hidden" id="startDate" name="startDate">
                        <input type="hidden" id="endDate" name="endDate">
                    </div>
                </div>

            <div class="search-card__row">
                <label class="traveler-box__label">여행 인원</label>
                <div class="traveler-box">
                    <div class="traveler-box__head">
                        <span class="traveler-box__badge" id="travelerBadge">둘이</span>
                    </div>
                    <div class="traveler-box__body">
                        <div class="traveler-count-display">
                            <span class="count-num" id="countDisplay">2</span>
                            <span class="count-unit">명</span>
                        </div>
                        <div class="traveler-stepper">
                            <button class="stepper-btn" type="button" data-counter-minus>−</button>
                            <button class="stepper-btn" type="button" data-counter-plus>+</button>
                        </div>
                    </div>
                    <div class="traveler-presets">
                        <button class="preset-chip" type="button" data-val="1">혼자</button>
                        <button class="preset-chip is-active" type="button" data-val="2">2명</button>
                        <button class="preset-chip" type="button" data-val="3">3명</button>
                        <button class="preset-chip" type="button" data-val="4">4명+</button>
                    </div>
                    <input type="number" class="budget-summary" id="travelers" name="travelers" value="2" min="1" max="20">
                </div>
            </div>

            <div class="search-card__row">
                <label class="traveler-box__label">예상 여행 경비</label>
                <div class="price-box">
                    <div class="price-box__head">
                        <span class="price-box__badge">1인 기준</span>
                    </div>
                    <div class="budget-range-track">
                        <div class="budget-range-fill" id="rangeFill"></div>
                    </div>
                    <div class="budget-sliders">
                        <input type="range" id="rangeMin" name="min-budget" min="0" max="5000000" step="10000" value="0">
                        <input type="range" id="rangeMax" name="max-budget" min="0" max="5000000" step="10000" value="1000000">
                    </div>
                    <div class="budget-amounts">
                        <div class="budget-amount-box budget-amount-box--min">
                            <span class="budget-amount-box__label">최소</span>
                            <input type="number" id="minPrice" placeholder="0 원" step="10000" min="0">
                        </div>
                        <span class="budget-amounts-sep">—</span>
                        <div class="budget-amount-box budget-amount-box--max">
                            <span class="budget-amount-box__label">최대</span>
                            <input type="number" id="maxPrice" placeholder="제한 없음" step="10000" min="0">
                        </div>
                    </div>
                    <div class="budget-presets">
                        <button class="budget-preset-btn" type="button" data-range="0,500000">~50만</button>
                        <button class="budget-preset-btn is-active" type="button" data-range="0,1000000">~100만</button>
                        <button class="budget-preset-btn" type="button" data-range="500000,2000000">50~200만</button>
                        <button class="budget-preset-btn" type="button" data-range="1500000,4000000">150~400만</button>
                        <button class="budget-preset-btn" type="button" data-range="0,5000000">제한없음</button>
                    </div>
                    <div class="budget-summary">
                        <span class="budget-summary__text">설정된 예산 범위</span>
                        <span class="budget-summary__value" id="budgetSummaryVal">100만 원 이하</span>
                    </div>
                </div>
            </div>

                <div class="chip-group-wrap">
                    <h3>여행 스타일</h3>
                    <div class="chip-group">
                        <label class="chip"><input type="checkbox" name="travelStyle" value="식도락"><span>식도락</span></label>
                        <label class="chip"><input type="checkbox" name="travelStyle" value="액티브"><span>액티브</span></label>
                        <label class="chip"><input type="checkbox" name="travelStyle" value="문화"><span>문화</span></label>
                        <label class="chip"><input type="checkbox" name="travelStyle" value="쇼핑"><span>쇼핑</span></label>
                        <label class="chip"><input type="checkbox" name="travelStyle" value="자연"><span>자연</span></label>
                    </div>
                </div>

                <div class="chip-group-wrap">
                    <h3>분위기</h3>
                    <div class="chip-group">
                        <label class="chip"><input type="checkbox" name="mood" value="힐링"><span>힐링</span></label>
                        <label class="chip"><input type="checkbox" name="mood" value="도심"><span>도심</span></label>
                        <label class="chip"><input type="checkbox" name="mood" value="로맨틱"><span>로맨틱</span></label>
                        <label class="chip"><input type="checkbox" name="mood" value="가족"><span>가족</span></label>
                        <label class="chip"><input type="checkbox" name="mood" value="모험"><span>모험</span></label>
                    </div>
                </div>

            <div class="chip-group-wrap">
                <h3>커스텀 태그</h3>
                <div class="chip-group" id="customChipGroup">
                    <button type="button" class="chip-add-btn" id="customAddBtn">+ 추가</button>
                </div>
            </div>

                <button type="submit" class="btn btn--primary btn--block">AI 여행 일정 만들기</button>
            </div>
    </section>
    </form>

    <div id="loadingOverlay">
        <div class="loading-container">
            <!-- 상단 헤더: 애니메이션 서클 -->
            <div class="loading-header">
                <div class="loading-circle">
                    <div class="circle ping"></div>
                    <div class="circle pulse"></div>
                    <div class="circle core">
                        <i data-lucide="sparkles"></i>
                    </div>
                </div>
                <h2 class="loading-title">AI가 완벽한 일정을<br>설계하고 있어요</h2>
                <div id="loadingMetaContext" class="loading-meta"></div>
            </div>

            <!-- 진행률 섹션 -->
            <div class="progress-section">
                <div class="progress-info">
                    <span class="progress-label">심층 분석 중...</span>
                    <span id="progressText" class="progress-percentage">0%</span>
                </div>
                <div class="progress-bar-bg">
                    <div id="progressBar" class="progress-bar"></div>
                </div>
            </div>

            <!-- 단계별 상태 (Step) -->
            <div class="steps-wrapper">
                <div id="step0" class="step active">
                    <div class="step-icon"><i data-lucide="map"></i></div>
                    <div class="step-content">
                        <h3>여행지 정보 수집</h3>
                        <p>실시간 명소 정보와 리뷰 분석</p>
                    </div>
                </div>
                <div id="step1" class="step">
                    <div class="step-icon"><i data-lucide="trending-up"></i></div>
                    <div class="step-content">
                        <h3>최적 동선 계산</h3>
                        <p>거리와 이동 시간을 고려한 경로 최적화</p>
                    </div>
                </div>
                <div id="step2" class="step">
                    <div class="step-icon"><i data-lucide="calendar"></i></div>
                    <div class="step-content">
                        <h3>운영 시간 및 혼잡도 확인</h3>
                        <p>데이터 기반 혼잡도 예측 분석</p>
                    </div>
                </div>
                <div id="step3" class="step">
                    <div class="step-icon"><i data-lucide="sparkles"></i></div>
                    <div class="step-content">
                        <h3>개인화 일정 확정</h3>
                        <p>취향에 맞춘 최종 일정 브리핑 생성</p>
                    </div>
                </div>
            </div>

            <!-- AI 실시간 메시지 카드 -->
            <div class="ai-msg-card">
                <div class="ai-msg-icon"><i data-lucide="bot"></i></div>
                <p id="aiMessage" class="ai-msg-text">데이터 엔진 가동 중...</p>
            </div>
        </div>
    </div>


    <section class="section">
        <div class="container">
            <div class="image-search-card">
                <div class="section-head section-head--center">
                    <h2>이미지로 여행지 찾기</h2>
                    <p>이미지를 업로드하면 미리보기를 보여주고, 이후 AI 분석 결과를 연결할 수 있습니다.</p>
                </div>

                <div class="upload-box" id="uploadBox">
                    <input type="file" id="imageFile" accept="image/*" hidden>

                    <button type="button" class="upload-box__button" id="uploadTrigger">
                        이미지 업로드
                    </button>

                    <p class="upload-box__text">클릭하거나 파일을 드래그하여 업로드하세요</p>

                    <div class="upload-preview" id="uploadPreview"></div>

                    <button type="button" class="upload-analyze-btn" id="analyzeBtn" style="display:none;">
                        이 이미지로 여행지 추천받기
                    </button>
                </div>
            </div>
        </div>
    </section>

    <section class="features section section--soft">
        <div class="container">
            <div class="feature-grid">
                <article class="feature-card">
                    <div class="feature-card__icon">⚡</div>
                    <h3>초정밀 AI 분석</h3>
                    <p>취향과 예산을 고려한 일정 추천</p>
                </article>
                <article class="feature-card">
                    <div class="feature-card__icon">📈</div>
                    <h3>실시간 최저가</h3>
                    <p>항공편과 숙박을 한눈에 비교</p>
                </article>
                <article class="feature-card">
                    <div class="feature-card__icon">📷</div>
                    <h3>이미지 검색</h3>
                    <p>사진 기반 여행지 추천 확장 가능</p>
                </article>
                <article class="feature-card">
                    <div class="feature-card__icon">🛡️</div>
                    <h3>안전한 예약</h3>
                    <p>검증된 파트너 연동 구조에 적합</p>
                </article>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div class="section-head">
                <h2>인기 여행지</h2>
                <p>카드를 누르면 관련 여행 플랜을 확인할 수 있습니다.</p>
            </div>

            <div class="destination-grid">
                <article class="destination-card"
                         onclick="openPlanSheet(this)"
                         data-category="교토"
                         data-label="교토 · 일본">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80" alt="교토">
                        <div class="destination-card__overlay">
                            <strong>교토</strong>
                            <span>일본</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>벚꽃과 전통 문화의 도시</p></div>
                </article>

                <article class="destination-card"
                         onclick="openPlanSheet(this)"
                         data-category="도쿄"
                         data-label="도쿄 · 일본">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80" alt="도쿄">
                        <div class="destination-card__overlay">
                            <strong>도쿄</strong>
                            <span>일본</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>현대와 전통이 공존하는 도시</p></div>
                </article>

                <article class="destination-card"
                         onclick="openPlanSheet(this)"
                         data-category="오사카"
                         data-label="오사카 · 일본">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1590559899731-a382839e5549?auto=format&fit=crop&w=1200&q=80" alt="오사카">
                        <div class="destination-card__overlay">
                            <strong>오사카</strong>
                            <span>일본</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>맛과 활기가 살아있는 도시</p></div>
                </article>

                <article class="destination-card"
                         onclick="openPlanSheet(this)"
                         data-category="자연"
                         data-label="자연 여행 · 테마"
                         data-type="theme">  <!-- 테마 구분용 -->
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80" alt="자연 여행">
                        <div class="destination-card__overlay">
                            <strong>자연 여행</strong>
                            <span>테마</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>자연 속 휴식과 힐링 중심 코스</p></div>
                </article>

                <article class="destination-card"
                         onclick="openPlanSheet(this)"
                         data-category="식도락"
                         data-label="맛집 탐방 · 테마"
                         data-type="theme">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1468413253725-0d5181091126?auto=format&fit=crop&w=1200&q=80" alt="해안 드라이브">
                        <div class="destination-card__overlay">
                            <strong>맛집 탐방</strong>
                            <span>테마</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>입이 즐거운 미식 코스 여행</p></div>
                </article>

                <article class="destination-card"
                         onclick="openPlanSheet(this)"
                         data-category="문화"
                         data-label="문화 투어 · 테마"
                         data-type="theme">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=80" alt="역사 투어">
                        <div class="destination-card__overlay">
                            <strong>문화 투어</strong>
                            <span>테마</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>문화를 직접 느낄 수있는 여행</p></div>
                </article>
            </div>
        </div>
    </section>

    <section class="cta section">
        <div class="container cta__inner">
            <h2>지금 바로 떠날 준비되셨나요?</h2>
            <p>AI가 추천하는 최적 동선과 가격 비교를 한 번에 확인해보세요.</p>
            <a href="${pageContext.request.contextPath}/explore" class="btn btn--light">즉흥 여행 상품 보기</a>
        </div>
    </section>
</main>


<div class="input-sheet-backdrop" id="backdrop"></div>
<div class="input-sheet" id="inputSheet">
    <div class="sheet-handle"></div>
    <p class="sheet-title">태그 추가</p>
    <div class="sheet-input-row">
        <input type="text" id="sheetInput" placeholder="예: 온천, 야경, 현지 시장" maxlength="12">
        <button class="sheet-confirm" id="sheetConfirm">추가</button>
    </div>
    <button class="sheet-cancel" id="sheetCancel">취소</button>
</div>


<div class="sheet-backdrop" id="airportBackdrop"></div>
<div class="bottom-sheet airport-sheet" id="airportSheet" role="dialog" aria-modal="true" aria-labelledby="airportSheetTitle">
    <div class="sheet-handle-wrap"><div class="sheet-handle"></div></div>
    <div class="sheet-head">
        <span class="sheet-head-title" id="airportSheetTitle">출발 공항 선택</span>
        <button type="button" class="sheet-close-btn" id="airportSheetClose" aria-label="닫기">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 6L6 18M6 6l12 12"/></svg>
        </button>
    </div>
    <p class="airport-sheet__desc">공항을 누르면 주소와 일본 주요 노선을 확인하고 선택할 수 있어요.</p>
    <div class="airport-list" id="airportList"></div>
    <div class="airport-sheet__footer">
        <button type="button" class="airport-apply-btn" id="airportApplyBtn" disabled>선택 완료</button>
    </div>
</div>

<div class="sheet-backdrop" id="dateBackdrop"></div>
<div class="bottom-sheet" id="dateSheet">
    <div class="sheet-handle-wrap"><div class="sheet-handle"></div></div>
    <div class="sheet-head">
        <span class="sheet-head-title">여행 기간 선택</span>
        <button type="button" class="sheet-close-btn" id="dateSheetClose">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M18 6L6 18M6 6l12 12"/></svg>
        </button>
    </div>
    <div class="date-summary">
        <div class="summary-col">
            <span class="summary-lbl">출발일</span>
            <span class="summary-date empty" id="sumStart">선택 전</span>
        </div>
        <div class="summary-arrow">→</div>
        <div class="summary-col" style="text-align:right">
            <span class="summary-lbl">도착일</span>
            <span class="summary-date empty" id="sumEnd">선택 전</span>
        </div>
        <div class="summary-nights" id="sumNights"></div>
    </div>
    <div class="cal-scroll" id="calScroll"></div>
    <div class="sheet-footer">
        <div class="footer-info" id="footerInfo">출발일을 먼저 선택하세요</div>
        <button type="button" class="btn-cal-apply" id="calApplyBtn" disabled>적용하기</button>
    </div>
</div>
<!-- 백드롭 -->
<div id="planBackdrop" onclick="closePlanSheet()"></div>
<!-- Plan 선택 Bottom Sheet -->
<div id="planSheet" role="dialog" aria-modal="true" aria-labelledby="planSheetTitle">

    <div class="plan-sheet__handle-wrap">
        <div class="plan-sheet__handle"></div>
    </div>

    <div class="plan-sheet__head">
        <div>
            <p id="planSheetTitle" class="plan-sheet__title">추천 여행 플랜</p>
            <p class="plan-sheet__sub" id="planSheetSub">인기 플랜 중 마음에 드는 것을 선택하세요</p>
        </div>
        <button class="plan-sheet__close" onclick="closePlanSheet()" aria-label="닫기">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <path d="M1 1l12 12M13 1L1 13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
        </button>
    </div>

    <!-- 플랜 목록 (JS가 동적 렌더) -->
    <div class="plan-sheet__body" id="planSheetBody">
        <div class="plan-sheet__state">
            <div class="plan-sheet__spinner"></div>
            <span>플랜을 불러오는 중…</span>
        </div>
    </div>
</div>
<script src="/js/cardModal.js"></script>
<script>
    
    const uploadBox = document.getElementById("uploadBox");
    const imageFile = document.getElementById("imageFile");
    const uploadTrigger = document.getElementById("uploadTrigger");
    const uploadPreview = document.getElementById("uploadPreview");
    const analyzeBtn = document.getElementById("analyzeBtn");

    // 업로드 버튼 클릭 -> 파일 선택창 열기
    uploadTrigger.addEventListener("click", function () {
        imageFile.click();
    });

    // 파일 선택 시 미리보기 표시
    imageFile.addEventListener("change", function () {
        const file = this.files[0];
        if (!file) return;

        showPreview(file);
    });

    // 드래그 앤 드롭
    uploadBox.addEventListener("dragover", function (e) {
        e.preventDefault();
        uploadBox.classList.add("is-dragover");
    });

    uploadBox.addEventListener("dragleave", function () {
        uploadBox.classList.remove("is-dragover");
    });

    uploadBox.addEventListener("drop", function (e) {
        e.preventDefault();
        uploadBox.classList.remove("is-dragover");

        const file = e.dataTransfer.files[0];
        if (!file || !file.type.startsWith("image/")) return;

        imageFile.files = e.dataTransfer.files;
        showPreview(file);
    });

    function showPreview(file) {
        const reader = new FileReader();

        reader.onload = function (e) {
            uploadPreview.innerHTML = `
                <div class="upload-preview__card">
                    <img src="${e.target.result}" alt="업로드 이미지 미리보기" class="upload-preview__image">
                    <p class="upload-preview__name">${file.name}</p>
                </div>
            `;

            analyzeBtn.style.display = "inline-block";
        };

        reader.readAsDataURL(file);
    }

    // 나중에 AI 분석 연결
    analyzeBtn.addEventListener("click", function () {
        const file = imageFile.files[0];
        if (!file) {
            alert("먼저 이미지를 업로드해주세요.");
            return;
        }

        // 지금은 테스트용 페이지 이동 or alert
        // 나중에 fetch("/image-analyze")로 바꾸면 됨
        alert("다음 단계: 서버로 이미지 전송 후 여행지 추천 결과 표시");
    });
</script>
</body>
</html>
