
    (function () {
    /* ── 상수 ── */
    // 플랜 상세 URL 패턴: /planner/detail?planId={id}
    // 서버에서 plan_id를 실제로 매핑해야 하면 이 패턴을 수정하세요.
    const DETAIL_URL = '/planner/detail';

    // DB에서 가져오는 API 엔드포인트.
    // TravelDao.getSavedTravelPlanJson()을 호출하는 서블릿을 만들어서 연결하세요.
    // 현재는 destination(카테고리) 기준으로 조회합니다.
    //   GET /planner/plans?destination=교토  → JSON array 응답
    const PLANS_API = '/planner/plans';

    /* ── 상태 ── */
    let currentCategory = null;
    let touchStartY = 0;

    /* ── 모달 열기 ── */
    window.openPlanSheet = function (articleEl) {
    currentCategory = articleEl.dataset.category;
    const label     = articleEl.dataset.label;

    document.getElementById('planSheetTitle').textContent = label + ' 플랜';
    document.getElementById('planSheetSub').textContent   = '인기 플랜 중 마음에 드는 것을 선택하세요';
    renderLoading();

    const backdrop = document.getElementById('planBackdrop');
    const sheet    = document.getElementById('planSheet');
    backdrop.style.display = 'block';
    requestAnimationFrame(() => {
    backdrop.classList.add('open');
    sheet.classList.add('open');
});

    document.body.style.overflow = 'hidden';

    // URL에 현재 카테고리 반영 (뒤로가기로 닫힘 지원)
    history.pushState({ planSheet: true, category: currentCategory }, '', '?modal=' + encodeURIComponent(currentCategory));

    fetchPlans(currentCategory);
};

    /* ── 모달 닫기 ── */
    window.closePlanSheet = function () {
    const backdrop = document.getElementById('planBackdrop');
    const sheet    = document.getElementById('planSheet');
    sheet.classList.remove('open');
    backdrop.classList.remove('open');
    document.body.style.overflow = '';

    // URL을 모달 열기 전 상태로 되돌림
    if (history.state && history.state.planSheet) {
    history.back();
}

    setTimeout(() => { backdrop.style.display = 'none'; }, 300);
};

    /* ── 뒤로가기로 닫힘 ── */
    window.addEventListener('popstate', function (e) {
    const sheet = document.getElementById('planSheet');
    if (sheet.classList.contains('open')) {
    sheet.classList.remove('open');
    const backdrop = document.getElementById('planBackdrop');
    backdrop.classList.remove('open');
    document.body.style.overflow = '';
    setTimeout(() => { backdrop.style.display = 'none'; }, 300);
}
});

    /* ── 페이지 진입 시 URL에 modal= 파라미터 있으면 자동 열기 ── */
    (function checkUrlOnLoad() {
    const params   = new URLSearchParams(location.search);
    const category = params.get('modal');
    if (!category) return;
    // DOM 준비 후 해당 카드 찾아서 열기
    const card = document.querySelector('[data-category="' + category + '"]');
    if (card) setTimeout(() => openPlanSheet(card), 300);
})();

    /* ── 데이터 로드 ── */
    function fetchPlans(category) {
    // ① 실제 서블릿이 준비됐을 때 아래 fetch 사용
    // fetch(PLANS_API + '?destination=' + encodeURIComponent(category))
    //   .then(r => r.json())
    //   .then(data => renderPlans(data))
    //   .catch(() => renderError());

    // ② 서블릿 준비 전 — 목 데이터로 동작 확인
    setTimeout(() => {
    const mock = getMockPlans(category);
    renderPlans(mock);
}, 600);
}

    /* ── 렌더링 ── */
    function renderLoading() {
    document.getElementById('planSheetBody').innerHTML = `
      <div class="plan-sheet__state">
        <div class="plan-sheet__spinner"></div>
        <span>플랜을 불러오는 중…</span>
      </div>`;
}

    function renderError() {
    document.getElementById('planSheetBody').innerHTML = `
      <div class="plan-sheet__state">
        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" stroke-width="1.8">
          <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <span>플랜을 불러오지 못했습니다</span>
      </div>`;
}

    function renderPlans(plans) {
    if (!plans || plans.length === 0) {
    document.getElementById('planSheetBody').innerHTML = `
        <div class="plan-sheet__state">
          <span>등록된 플랜이 없습니다</span>
        </div>`;
    return;
}

    const html = plans.slice(0, 3).map(p => `
      <button class="plan-card" onclick="goToDetail(${p.planId})">
        <div class="plan-card__top">
          <span class="plan-card__badge">
            <svg width="10" height="10" viewBox="0 0 10 10" fill="currentColor">
              <circle cx="5" cy="5" r="5"/>
            </svg>
            ${escHtml(p.travelStyle || '추천')}
          </span>
          <span class="plan-card__arrow">
            <svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="1.8">
              <path d="M2.5 6h7M6.5 2.5L10 6l-3.5 3.5"/>
            </svg>
          </span>
        </div>
        <p class="plan-card__title">${escHtml(p.title || '여행 플랜')}</p>
        <p class="plan-card__overview">${escHtml(p.overview || '')}</p>
        <div class="plan-card__meta">
          ${p.days ? `<span class="meta-chip">📅 ${p.days}일</span>` : ''}
          ${p.travelers ? `<span class="meta-chip">👥 ${p.travelers}명</span>` : ''}
          ${p.destination ? `<span class="meta-chip">📍 ${escHtml(p.destination)}</span>` : ''}
        </div>
        <div class="plan-card__footer">
          <div>
            <span class="plan-card__cost-label">예상 비용</span>
            <span class="plan-card__cost">${formatCost(p.totalEstimatedCost, p.currency)}</span>
          </div>
          <span class="plan-card__cta">상세 보기 →</span>
        </div>
      </button>
    `).join('');

    document.getElementById('planSheetBody').innerHTML = html;
}

    /* ── 상세 페이지 이동 ── */
    // plan_id를 쿼리스트링으로 넘겨서 TravelPlanServlet(또는 별도 DetailServlet)에서 처리
    // URL 예시: /planner/detail?planId=42
    window.goToDetail = function (planId) {
    location.href = DETAIL_URL + '?planId=' + planId;
};

    /* ── 유틸 ── */
    function escHtml(str) {
    return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

    function formatCost(cost, currency) {
    if (!cost) return '정보 없음';
    const c = currency || 'KRW';
    if (c === 'KRW') return Number(cost).toLocaleString('ko-KR') + '원';
    return Number(cost).toLocaleString() + ' ' + c;
}

    /* ── 목 데이터 (서블릿 연동 전 테스트용) ── */
    function getMockPlans(category) {
    const base = {
    교토: [
{ planId: 1, title: '교토 3박 4일 봄 여행', overview: '아라시야마 대나무 숲부터 기온 거리까지, 벚꽃 시즌에 즐기는 교토의 모든 것.', days: 4, travelers: 2, travelStyle: '문화·감성', destination: '교토', totalEstimatedCost: 950000, currency: 'KRW' },
{ planId: 2, title: '교토 2박 3일 단풍 코스', overview: '도후쿠지와 에이칸도의 단풍을 중심으로, 조용한 사찰 투어.', days: 3, travelers: 1, travelStyle: '힐링', destination: '교토', totalEstimatedCost: 680000, currency: 'KRW' },
{ planId: 3, title: '교토·나라 4박 5일', overview: '교토와 나라를 함께 즐기는 알찬 일정. 사슴공원과 호류지 포함.', days: 5, travelers: 2, travelStyle: '역사·자연', destination: '교토/나라', totalEstimatedCost: 1200000, currency: 'KRW' },
    ],
    도쿄: [
{ planId: 10, title: '도쿄 4박 5일 도심 탐방', overview: '시부야·하라주쿠·아키하바라를 아우르는 도쿄 핵심 코스.', days: 5, travelers: 2, travelStyle: '쇼핑·관광', destination: '도쿄', totalEstimatedCost: 1100000, currency: 'KRW' },
{ planId: 11, title: '도쿄 3박 4일 미식 투어', overview: '쓰키지·츠루통탄·오모테산도 카페 투어까지 먹방 중심 일정.', days: 4, travelers: 2, travelStyle: '미식', destination: '도쿄', totalEstimatedCost: 900000, currency: 'KRW' },
{ planId: 12, title: '도쿄 2박 3일 빠른 코스', overview: '짧은 일정에 핵심만 담은 초압축 도쿄 여행.', days: 3, travelers: 1, travelStyle: '관광', destination: '도쿄', totalEstimatedCost: 620000, currency: 'KRW' },
    ],
    오사카: [
{ planId: 20, title: '오사카 3박 4일 먹방 투어', overview: '도톤보리·구로몬 시장·타코야키 골목 완전 정복.', days: 4, travelers: 2, travelStyle: '미식', destination: '오사카', totalEstimatedCost: 820000, currency: 'KRW' },
{ planId: 21, title: '오사카·교토 5박 6일', overview: '오사카를 베이스로 교토 당일치기를 포함한 간사이 완전 정복.', days: 6, travelers: 2, travelStyle: '관광·문화', destination: '간사이', totalEstimatedCost: 1350000, currency: 'KRW' },
{ planId: 22, title: '오사카 2박 3일 테마파크', overview: '유니버설 스튜디오 재팬 중심의 가족 여행 코스.', days: 3, travelers: 4, travelStyle: '가족·레저', destination: '오사카', totalEstimatedCost: 1800000, currency: 'KRW' },
    ],
};

    // 매핑 안 된 카테고리는 기본 플랜 반환
    return base[category] || [
{ planId: 99, title: category + ' 추천 플랜 A', overview: '현지 인기 스팟을 중심으로 구성한 여행 코스입니다.', days: 3, travelers: 2, travelStyle: '관광', destination: category, totalEstimatedCost: 750000, currency: 'KRW' },
{ planId: 100, title: category + ' 추천 플랜 B', overview: '힐링에 초점을 맞춘 여유로운 일정입니다.', days: 4, travelers: 1, travelStyle: '힐링', destination: category, totalEstimatedCost: 600000, currency: 'KRW' },
{ planId: 101, title: category + ' 추천 플랜 C', overview: '알찬 관광과 맛집 탐방을 동시에 즐기는 코스.', days: 5, travelers: 2, travelStyle: '미식·관광', destination: category, totalEstimatedCost: 1000000, currency: 'KRW' },
    ];
}

    /* ── 스와이프 다운으로 닫기 ── */
    const sheet = document.getElementById('planSheet');
    sheet.addEventListener('touchstart', function(e) {
    touchStartY = e.touches[0].clientY;
}, { passive: true });
    sheet.addEventListener('touchend', function(e) {
    const dy = e.changedTouches[0].clientY - touchStartY;
    if (dy > 80) closePlanSheet();
}, { passive: true });
})();
