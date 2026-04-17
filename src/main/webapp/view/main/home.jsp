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
                        <div class="date-trigger" id="dateTrigger" role="button" tabindex="0">
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

                    <p class="upload-box__text" id="uploadText">클릭하거나 파일을 드래그하여 업로드하세요</p>

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
                <h2>인기 여행지 플랜 TOP 3</h2>
                <p>많은 여행자들이 고른 도시에서 다음 여행의 힌트를 찾아보세요.</p>
            </div>

            <div class="destination-grid" id="destinationRankGrid">
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
            </div>

            <div class="section-head section-head--sub">
                <h2>인기 테마 여행 플랜 TOP 3</h2>
                <p>요즘 많이 찾는 여행 무드로 취향에 맞는 플랜을 골라보세요.</p>
            </div>

            <div class="destination-grid" id="themeRankGrid">
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
    (function loadTopHomeCards() {
        const destinationGrid = document.getElementById("destinationRankGrid");
        const themeGrid = document.getElementById("themeRankGrid");
        if (!destinationGrid && !themeGrid) return;

        const contextPath = "${pageContext.request.contextPath}";
        const destinationImageMap = [
            {
                keywords: ["교토", "kyoto"],
                description: "전통과 풍경이 어우러진 인기 지역",
                url: "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["도쿄", "tokyo"],
                description: "도시 명소와 핫플이 많은 인기 지역",
                url: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["오사카", "osaka"],
                description: "맛과 활기가 모이는 인기 지역",
                url: "https://images.unsplash.com/photo-1590559899731-a382839e5549?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["요코하마", "yokohama"],
                description: "항구의 야경과 산책 코스가 매력적인 인기 지역",
                url: "https://images.unsplash.com/photo-1516496636080-14fb876e029d?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["가마쿠라", "kamakura", "에노시마", "enoshima"],
                description: "바다와 오래된 골목을 함께 걷기 좋은 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["하코네", "hakone"],
                description: "온천과 후지산 풍경을 여유롭게 즐기는 인기 지역",
                url: "https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["가와구치코", "kawaguchiko", "후지 five lakes", "fuji five lakes"],
                description: "호수 너머 후지산을 담기 좋은 인기 지역",
                url: "https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["후지산", "후지", "mt fuji", "mount fuji", "fuji"],
                description: "일본의 상징적인 풍경을 만나는 인기 지역",
                url: "https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["닛코", "nikko"],
                description: "숲과 사찰, 계곡 풍경이 깊은 인기 지역",
                url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["가나자와", "kanazawa"],
                description: "정원과 전통 거리를 차분히 둘러보는 인기 지역",
                url: "https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["히로시마", "hiroshima", "미야지마", "miyajima", "이쓰쿠시마", "itsukushima"],
                description: "역사와 바다 위 풍경을 함께 만나는 인기 지역",
                url: "https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["오카야마", "okayama", "구라시키", "kurashiki"],
                description: "정원과 운하 마을의 여유가 있는 인기 지역",
                url: "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["돗토리", "tottori"],
                description: "사구와 해안 풍경이 선명한 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["마쓰모토", "matsumoto", "나가노", "nagano", "가루이자와", "karuizawa"],
                description: "산과 성, 고원 감성이 어우러진 인기 지역",
                url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["다카야마", "takayama", "시라카와고", "shirakawago"],
                description: "전통 마을과 산골 풍경을 만나는 인기 지역",
                url: "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["이세", "ise", "미에", "mie"],
                description: "신궁과 해안 마을을 따라 걷는 인기 지역",
                url: "https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["와카야마", "wakayama", "고야산", "koyasan", "구마노", "kumano"],
                description: "성지 순례길과 자연이 깊은 인기 지역",
                url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["마쓰야마", "matsuyama", "도고온천", "dogo"],
                description: "온천과 고즈넉한 성곽 산책이 좋은 인기 지역",
                url: "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["다카마쓰", "takamatsu", "나오시마", "naoshima", "시코쿠", "shikoku"],
                description: "섬과 예술, 정원을 함께 즐기는 인기 지역",
                url: "https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["후쿠오카", "fukuoka", "하카타", "hakata"],
                description: "맛집과 쇼핑, 근교 여행을 가볍게 잇는 인기 지역",
                url: "https://images.unsplash.com/photo-1481437156560-3205f6a55735?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["유후인", "yufuin", "벳푸", "beppu", "오이타", "oita"],
                description: "온천 마을과 산책 코스가 편안한 인기 지역",
                url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["구마모토", "kumamoto", "아소", "aso"],
                description: "성곽과 화산 풍경을 함께 만나는 인기 지역",
                url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["나가사키", "nagasaki"],
                description: "항구 도시의 이국적인 풍경이 있는 인기 지역",
                url: "https://images.unsplash.com/photo-1516496636080-14fb876e029d?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["가고시마", "kagoshima", "사쿠라지마", "sakurajima"],
                description: "화산과 남국의 분위기를 함께 느끼는 인기 지역",
                url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["센다이", "sendai", "마쓰시마", "matsushima"],
                description: "도시 산책과 섬 풍경을 함께 즐기는 인기 지역",
                url: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["아오모리", "aomori", "히로사키", "hirosaki"],
                description: "계절 축제와 자연 풍경이 뚜렷한 인기 지역",
                url: "https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["아키타", "akita"],
                description: "온천과 전통 마을의 차분함이 있는 인기 지역",
                url: "https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["니가타", "niigata", "사도", "sado"],
                description: "쌀과 사케, 바다 풍경이 어울리는 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["하코다테", "hakodate"],
                description: "야경과 항구 감성이 선명한 인기 지역",
                url: "https://images.unsplash.com/photo-1516496636080-14fb876e029d?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["오타루", "otaru"],
                description: "운하와 유리 공방 거리를 걷기 좋은 인기 지역",
                url: "https://images.unsplash.com/photo-1516496636080-14fb876e029d?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["비에이", "biei", "후라노", "furano"],
                description: "넓은 들판과 계절빛이 아름다운 인기 지역",
                url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["아사히카와", "asahikawa"],
                description: "홋카이도 북부 여행의 거점이 되는 인기 지역",
                url: "https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["삿포로", "sapporo", "홋카이도", "hokkaido"],
                description: "눈과 미식, 도심 여행을 함께 즐기는 인기 지역",
                url: "https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["오키나와", "okinawa", "나하", "naha", "이시가키", "ishigaki", "미야코지마", "miyakojima"],
                description: "맑은 바다와 섬의 여유를 즐기는 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["부산", "busan"],
                description: "바다와 도시 감성이 만나는 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["서울", "seoul"],
                description: "도시의 리듬과 명소가 모이는 인기 지역",
                url: "https://images.unsplash.com/photo-1538485399081-7191377e8241?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["제주", "jeju"],
                description: "바다와 오름을 따라 쉬어가기 좋은 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["강릉", "gangneung"],
                description: "해변과 카페 산책이 잘 어울리는 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["경주", "gyeongju"],
                description: "역사와 고즈넉한 풍경을 함께 걷는 인기 지역",
                url: "https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["전주", "jeonju"],
                description: "한옥과 먹거리를 천천히 즐기는 인기 지역",
                url: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["여수", "yeosu"],
                description: "밤바다와 해안 풍경이 매력적인 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["속초", "sokcho"],
                description: "바다와 산을 가까이 만나는 인기 지역",
                url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["후쿠오카", "fukuoka"],
                description: "가볍게 떠나 맛과 쇼핑을 즐기는 인기 지역",
                url: "https://images.unsplash.com/photo-1481437156560-3205f6a55735?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["삿포로", "sapporo", "홋카이도", "hokkaido"],
                description: "계절 풍경과 미식이 선명한 인기 지역",
                url: "https://images.unsplash.com/photo-1483921020237-2ff51e8e4b22?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["오키나와", "okinawa"],
                description: "맑은 바다와 여유로운 섬 분위기의 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["나고야", "nagoya"],
                description: "도시 여행과 근교 코스를 함께 잡기 좋은 인기 지역",
                url: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["나라", "nara"],
                description: "오래된 사찰과 산책길이 차분한 인기 지역",
                url: "https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["고베", "kobe"],
                description: "항구 도시의 야경과 미식이 있는 인기 지역",
                url: "https://images.unsplash.com/photo-1516496636080-14fb876e029d?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["방콕", "bangkok"],
                description: "거리 음식과 화려한 도시 에너지가 있는 인기 지역",
                url: "https://images.unsplash.com/photo-1508009603885-50cf7c579365?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["다낭", "danang", "da nang"],
                description: "해변과 휴양 코스를 편하게 즐기는 인기 지역",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["하노이", "hanoi"],
                description: "구시가지와 로컬 감성이 살아있는 인기 지역",
                url: "https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["타이베이", "taipei"],
                description: "야시장과 도시 산책을 즐기기 좋은 인기 지역",
                url: "https://images.unsplash.com/photo-1470004914212-05527e49370b?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["홍콩", "hong kong", "hongkong"],
                description: "스카이라인과 미식이 밀도 있게 모인 인기 지역",
                url: "https://images.unsplash.com/photo-1536599018102-9f803c140fc1?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["싱가포르", "singapore"],
                description: "깔끔한 도시 동선과 야경이 좋은 인기 지역",
                url: "https://images.unsplash.com/photo-1525625293386-3f8f99389edd?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["발리", "bali"],
                description: "휴양과 자연 감성을 함께 담는 인기 지역",
                url: "https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["파리", "paris"],
                description: "거리와 예술, 낭만을 따라 걷는 인기 지역",
                url: "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["런던", "london"],
                description: "클래식한 명소와 도시 산책이 좋은 인기 지역",
                url: "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["로마", "rome"],
                description: "역사적인 거리와 유적을 만나는 인기 지역",
                url: "https://images.unsplash.com/photo-1529260830199-42c24126f198?auto=format&fit=crop&w=1200&q=80"
            }
        ];
        const fallbackDestinationImages = [
            "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80",
            "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80",
            "https://images.unsplash.com/photo-1590559899731-a382839e5549?auto=format&fit=crop&w=1200&q=80"
        ];
        const themeImageMap = [
            {
                keywords: ["식도락", "맛집", "미식", "음식", "푸드", "카페", "야시장"],
                className: "theme-img--food",
                description: "맛집과 카페를 중심으로 즐기는 여행",
                url: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["바다", "해변", "해안", "오션", "비치", "섬"],
                className: "theme-img--sea",
                description: "탁 트인 바다와 해안 풍경을 만나는 여행",
                url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["힐링", "자연", "휴식", "온천", "숲", "산"],
                className: "theme-img--nature",
                description: "자연 속에서 쉬어가는 여유로운 여행",
                url: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["문화", "역사", "전통", "예술", "박물관", "투어"],
                className: "theme-img--culture",
                description: "도시의 이야기와 전통을 따라 걷는 여행",
                url: "https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["쇼핑", "시장", "편집샵", "기념품"],
                className: "theme-img--shopping",
                description: "거리와 상점을 둘러보며 취향을 찾는 여행",
                url: "https://images.unsplash.com/photo-1481437156560-3205f6a55735?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["액티브", "모험", "스포츠", "트레킹", "하이킹"],
                className: "theme-img--active",
                description: "몸을 움직이며 현지의 에너지를 느끼는 여행",
                url: "https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["로맨틱", "커플", "데이트", "야경"],
                className: "theme-img--romantic",
                description: "함께 걷기 좋은 풍경과 야경을 담은 여행",
                url: "https://images.unsplash.com/photo-1516496636080-14fb876e029d?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["가족", "아이", "키즈"],
                className: "theme-img--family",
                description: "함께 편하게 즐길 수 있는 가족 여행",
                url: "https://images.unsplash.com/photo-1504150558240-0b4fd8946624?auto=format&fit=crop&w=1200&q=80"
            },
            {
                keywords: ["도심", "시티", "도시", "핫플"],
                className: "theme-img--city",
                description: "도시의 명소와 핫플을 가볍게 즐기는 여행",
                url: "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80"
            }
        ];
        const fallbackThemeImages = [
            "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80",
            "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80",
            "https://images.unsplash.com/photo-1590559899731-a382839e5549?auto=format&fit=crop&w=1200&q=80"
        ];

        if (destinationGrid) destinationGrid.querySelectorAll(".destination-card").forEach(function (card) {
            card.remove();
        });
        if (themeGrid) themeGrid.querySelectorAll(".destination-card").forEach(function (card) {
            card.remove();
        });

        fetch(contextPath + "/planner/plans?topDestinations=true")
            .then(function (res) {
                if (!res.ok) throw new Error("Failed to load destination ranks");
                return res.json();
            })
            .then(function (destinations) {
                if (!Array.isArray(destinations) || destinations.length === 0) return;

                destinations.slice(0, 3).forEach(function (item, index) {
                    const destination = String(item.destination || "").trim();
                    if (!destination) return;

                    const card = document.createElement("article");
                    card.className = "destination-card region-rank-card";
                    card.tabIndex = 0;
                    card.setAttribute("role", "button");
                    card.setAttribute("aria-label", destination + " 플랜 목록 열기");
                    card.dataset.category = destination;
                    card.dataset.label = destination + " · 지역";
                    card.onclick = function () {
                        openPlanSheet(card);
                    };
                    card.onkeydown = function (event) {
                        if (event.key === "Enter" || event.key === " ") {
                            event.preventDefault();
                            openPlanSheet(card);
                        }
                    };

                    card.innerHTML =
                        '<div class="destination-card__image">' +
                        '<img src="' + escHomeHtml(getDestinationImage(destination, index, item.imageUrl)) + '" alt="' + escHomeHtml(destination) + '">' +
                        '<span class="destination-card__hint">플랜 목록 열기 <b>→</b></span>' +
                        '<div class="destination-card__overlay">' +
                        '<strong>' + escHomeHtml(destination) + '</strong>' +
                        '<span>지역 ' + Number(item.rank || index + 1) + '위 · ' + Number(item.count || 0) + '개 플랜</span>' +
                        '</div>' +
                        '</div>' +
                        '<div class="destination-card__body"><p>' + escHomeHtml(getDestinationDescription(destination)) + '</p></div>';

                    if (destinationGrid) destinationGrid.appendChild(card);
                });
            })
            .catch(function (err) {
                console.error("top destinations error:", err);
            })
            .finally(function () {
                if (!themeGrid) return;
                fetch(contextPath + "/planner/plans?topRequestStyles=true")
                    .then(function (res) {
                        if (!res.ok) throw new Error("Failed to load theme ranks");
                        return res.json();
                    })
                    .then(function (tags) {
                        if (!Array.isArray(tags) || tags.length === 0) return;

                        tags.slice(0, 3).forEach(function (item, index) {
                            const tag = String(item.tag || "").trim();
                            if (!tag) return;

                            const card = document.createElement("article");
                            card.className = "destination-card theme-rank-card";
                            card.tabIndex = 0;
                            card.setAttribute("role", "button");
                            card.setAttribute("aria-label", tag + " 테마 플랜 목록 열기");
                            card.dataset.type = "theme";
                            card.dataset.category = tag;
                            card.dataset.label = tag + " · 테마";
                            card.onclick = function () {
                                openPlanSheet(card);
                            };
                            card.onkeydown = function (event) {
                                if (event.key === "Enter" || event.key === " ") {
                                    event.preventDefault();
                                    openPlanSheet(card);
                                }
                            };

                            card.innerHTML =
                                '<div class="destination-card__image">' +
                                '<img class="' + getThemeImageClass(tag) + '" src="' + getThemeImage(tag, index) + '" alt="' + escHomeHtml(tag) + '">' +
                                '<span class="destination-card__hint">플랜 목록 열기 <b>→</b></span>' +
                                '<div class="destination-card__overlay">' +
                                '<strong>#' + escHomeHtml(tag) + '</strong>' +
                                '<span>테마 ' + Number(item.rank || index + 1) + '위 · ' + Number(item.count || 0) + '개 플랜</span>' +
                                '</div>' +
                                '</div>' +
                                '<div class="destination-card__body"><p>' + escHomeHtml(getThemeDescription(tag)) + '</p></div>';

                            themeGrid.appendChild(card);
                        });
                    })
                    .catch(function (err) {
                        console.error("top request styles error:", err);
                    });
            });

        function escHomeHtml(value) {
            return String(value)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        function getDestinationImage(destination, index, planImageUrl) {
            const representativeImage = String(planImageUrl || "").trim();
            if (isRemoteImageUrl(representativeImage)) {
                return representativeImage;
            }

            const matched = getMatchedDestination(destination);
            if (matched) {
                return matched.url;
            }

            return fallbackDestinationImages[index % fallbackDestinationImages.length];
        }

        function getDestinationDescription(destination) {
            const matched = getMatchedDestination(destination);
            return matched ? matched.description : "탐색에 올라온 플랜에서 자주 선택된 지역";
        }

        function getMatchedDestination(destination) {
            const normalizedDestination = normalizeThemeText(destination);
            return destinationImageMap.find(function (item) {
                return item.keywords.some(function (keyword) {
                    const normalizedKeyword = normalizeThemeText(keyword);
                    return normalizedDestination.includes(normalizedKeyword) || normalizedKeyword.includes(normalizedDestination);
                });
            });
        }

        function isRemoteImageUrl(value) {
            return /^https?:\/\//i.test(String(value || "").trim());
        }

        function getThemeImage(tag, index) {
            const matched = getMatchedThemeImage(tag);
            if (matched) {
                return matched.url;
            }

            return fallbackThemeImages[index % fallbackThemeImages.length];
        }

        function getThemeImageClass(tag) {
            const matched = getMatchedThemeImage(tag);
            return matched ? matched.className : "theme-img--fallback";
        }

        function getThemeDescription(tag) {
            const matched = getMatchedThemeImage(tag);
            return matched ? matched.description : "취향이 비슷한 여행자들이 많이 고른 테마";
        }

        function getMatchedThemeImage(tag) {
            const normalizedTag = normalizeThemeText(tag);
            return themeImageMap.find(function (item) {
                return item.keywords.some(function (keyword) {
                    const normalizedKeyword = normalizeThemeText(keyword);
                    return normalizedTag.includes(normalizedKeyword) || normalizedKeyword.includes(normalizedTag);
                });
            });
        }

        function normalizeThemeText(value) {
            return String(value || "")
                .replace(/#/g, "")
                .replace(/\s+/g, "")
                .toLowerCase();
        }
    })();
</script>
<script>
    const imageFile = document.getElementById("imageFile");
    const uploadTrigger = document.getElementById("uploadTrigger");
    const uploadPreview = document.getElementById("uploadPreview");
    const analyzeBtn = document.getElementById("analyzeBtn");

    let selectedFile = null;

    uploadTrigger.addEventListener("click", function () {
        imageFile.click();
    });

    imageFile.addEventListener("change", function () {
        const file = this.files[0];
        if (!file) return;

        if (!file.type.startsWith("image/")) {
            alert("이미지 파일만 업로드 가능합니다.");
            this.value = "";
            return;
        }

        selectedFile = file;

        const reader = new FileReader();
        reader.onload = function (e) {
            uploadPreview.innerHTML =
                '<div class="upload-preview__card">' +
                '<img src="' + e.target.result + '" alt="업로드 이미지 미리보기" class="upload-preview__image">' +
                '<p class="upload-preview__name">' + file.name + '</p>' +
                '</div>';

            uploadText.style.display = "none";
            analyzeBtn.style.display = "inline-block";
        };

        reader.onerror = function () {
            alert("이미지 미리보기를 불러오지 못했습니다.");
        };

        reader.readAsDataURL(file);
    });
    const uploadText = document.getElementById("uploadText");
</script>
</body>
</html>
