document.addEventListener('DOMContentLoaded', function () {
    const menuBtn = document.getElementById('mobileMenuBtn');
    const nav = document.getElementById('siteNav');
    const travelerInput = document.getElementById('travelers');
    const plusBtn = document.querySelector('[data-counter-plus]');
    const minusBtn = document.querySelector('[data-counter-minus]');
    const uploadTrigger = document.getElementById('uploadTrigger');
    const imageFile = document.getElementById('imageFile');
    const uploadPreview = document.getElementById('uploadPreview');

    document.querySelector('.mobile-menu-btn')
        .addEventListener('click', () => {
            document.querySelector('.site-nav')
                .classList.toggle('is-open');
        });
    if (menuBtn && nav) {
        menuBtn.addEventListener('click', function () {
            nav.classList.toggle('is-open');
        });
    }

    if (travelerInput && plusBtn && minusBtn) {
        plusBtn.addEventListener('click', function () {
            const current = Number(travelerInput.value || 1);
            travelerInput.value = String(Math.min(current + 1, 20));
        });

        minusBtn.addEventListener('click', function () {
            const current = Number(travelerInput.value || 1);
            travelerInput.value = String(Math.max(current - 1, 1));
        });
    }

    if (uploadTrigger && imageFile) {
        uploadTrigger.addEventListener('click', function () {
            imageFile.click();
        });

        imageFile.addEventListener('change', function (e) {
            const file = e.target.files && e.target.files[0];
            if (!file || !uploadPreview) return;

            const reader = new FileReader();
            reader.onload = function (event) {
                uploadPreview.innerHTML = '';

                const img = document.createElement('img');
                img.src = event.target.result;
                img.alt = '업로드 이미지 미리보기';

                const text = document.createElement('p');
                text.textContent = '이미지 업로드 완료 - 실제 AI 분석 API 연결 전 단계입니다.';

                uploadPreview.appendChild(img);
                uploadPreview.appendChild(text);
            };
            reader.readAsDataURL(file);
        });
    }
});

const minInput = document.getElementById('minPrice');
const maxInput = document.getElementById('maxPrice');

minInput.addEventListener('input', () => {
    maxInput.min = minInput.value;
});

