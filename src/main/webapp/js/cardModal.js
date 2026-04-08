
    (function () {
    /* ── 상수 ── */
    // 플랜 상세 URL 패턴: /planner/detail?planId={id}
    // 서버에서 plan_id를 실제로 매핑해야 하면 이 패턴을 수정하세요.
    const DETAIL_URL = 'detail-page';

    // DB에서 가져오는 API 엔드포인트.
    // TravelDao.getSavedTravelPlanJson()을 호출하는 서블릿을 만들어서 연결하세요.
    // 현재는 destination(카테고리) 기준으로 조회합니다.
    //   GET /planner/plans?destination=교토  → JSON array 응답
    const PLANS_API = 'planner/plans';

    /* ── 상태 ── */
    let currentCategory = null;
    let touchStartY = 0;

    /* ── 모달 열기 ── */
        window.openPlanSheet = function (articleEl) {
            currentCategory = articleEl.dataset.category;
            const label = articleEl.dataset.label;
            const type = articleEl.dataset.type || 'destination'; // 기본값은 destination

            document.getElementById('planSheetTitle').textContent = label + ' 플랜';
            document.getElementById('planSheetSub').textContent = '인기 플랜 중 마음에 드는 것을 선택하세요';
            renderLoading();

            const backdrop = document.getElementById('planBackdrop');
            const sheet = document.getElementById('planSheet');
            backdrop.style.display = 'block';
            requestAnimationFrame(() => {
                backdrop.classList.add('open');
                sheet.classList.add('open');
            });

            document.body.style.overflow = 'hidden';
            history.pushState({ planSheet: true, category: currentCategory, type: type }, '', '?modal=' + encodeURIComponent(currentCategory));

            fetchPlans(currentCategory, type);
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
    // function fetchPlans(category) {
    // // ① 실제 서블릿이 준비됐을 때 아래 fetch 사용
    // // fetch(PLANS_API + '?destination=' + encodeURIComponent(category))
    // //   .then(r => r.json())
    // //   .then(data => renderPlans(data))
    // //   .catch(() => renderError());

        function fetchPlans(category, type) {
            renderLoading();

            // type에 따라 다른 파라미터로 요청
            const params = type === 'theme'
                ? 'category=' + encodeURIComponent(category)  // 테마는 category 파라미터
                : 'destination=' + encodeURIComponent(category);  // 지역은 destination 파라미터

            fetch('/planner/plans?' + params)
                .then(function (r) {
                    if (!r.ok) throw new Error('서버 오류');
                    return r.json();
                })
                .then(function (data) {
                    renderPlans(data);
                })
                .catch(function (err) {
                    console.error(err);
                    renderError();
                });
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
    location.href = DETAIL_URL + '?id=' + planId;
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
    function formatCost(cost, currency) {
        if (!cost) return '정보 없음';
        const symbol = currency === 'KRW' ? '₩' : (currency || '');
        return symbol + Number(cost).toLocaleString();
    }

    function escHtml(str) {
        if (!str) return '';
        return str.replace(/[&<>"']/g, function(m) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[m];
        });
    }
