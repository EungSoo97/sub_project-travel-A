function openPlanSheet(title, subTitle) {
    const backdrop = document.getElementById('planBackdrop');
    const sheet = document.getElementById('planSheet');

    // 제목 및 설명 세팅
    document.getElementById('planSheetTitle').textContent = title;
    document.getElementById('planSheetSub').textContent = subTitle;

    backdrop.style.display = 'block';

    // 브라우저 렌더링 후 애니메이션 적용
    requestAnimationFrame(() => {
        backdrop.classList.add('open');
        sheet.classList.add('open');
    });

    document.body.style.overflow = 'hidden'; // 배경 스크롤 방지
}

/* 모달 닫기 함수 /
function closePlanSheet() {
    const backdrop = document.getElementById('planBackdrop');
    const sheet = document.getElementById('planSheet');

    sheet.classList.remove('open');
    backdrop.classList.remove('open');
    document.body.style.overflow = '';

    setTimeout(() => {
        backdrop.style.display = 'none';
    }, 300); // 애니메이션 시간(0.3s) 후 제거
}

/ (선택사항) 뒤로가기 클릭 시 모달 닫기 대응 */
window.addEventListener('popstate', function () {
    const sheet = document.getElementById('planSheet');
    if (sheet.classList.contains('open')) {
        closePlanSheet();
    }
});
// ✅ openPlanSheet — "show" 클래스로 통일 (CSS 기준)
function openPlanSheet() {
    const backdrop = document.getElementById('dpPlanBackdrop');
    const sheet = document.getElementById('dpPlanSheet');

    backdrop.classList.add('show');
    sheet.classList.add('show');
    document.body.style.overflow = 'hidden';
}

// ✅ closePlanSheet
function closePlanSheet() {
    const backdrop = document.getElementById('dpPlanBackdrop');
    const sheet = document.getElementById('dpPlanSheet');

    sheet.classList.remove('show');
    backdrop.classList.remove('show');
    document.body.style.overflow = '';
}

// ✅ 후기 전체보기
function openReviewList() {
    document.getElementById("dpPlanBackdrop").classList.add("show");
    document.getElementById("dpPlanSheet").classList.add("show");
    document.getElementById("reviewListSection").style.display = "block";
    document.getElementById("reviewWriteSection").style.display = "none";
    document.getElementById("dpPlanSheetTitle").innerText = "여행 후기";
    document.getElementById("dpPlanSheetSub").innerText = "후기 전체보기";
    document.body.style.overflow = "hidden";
}

// ✅ 후기 작성
function openReviewWrite() {
    document.getElementById("dpPlanBackdrop").classList.add("show");
    document.getElementById("dpPlanSheet").classList.add("show");
    document.getElementById("reviewListSection").style.display = "none";
    document.getElementById("reviewWriteSection").style.display = "block";
    document.getElementById("dpPlanSheetTitle").innerText = "후기 작성";
    document.getElementById("dpPlanSheetSub").innerText = "";
    document.body.style.overflow = "hidden";
}
window.addEventListener('popstate', function () {
    const sheet = document.getElementById('dpPlanSheet');
    if (sheet && sheet.classList.contains('show')) {
        closePlanSheet();
    }
});