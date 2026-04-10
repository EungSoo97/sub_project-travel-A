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