(function () {
    function activateTab(targetId) {
        const tabBtns = document.querySelectorAll('.tabs .tab');
        const tabContents = document.querySelectorAll('.tab-content');

        tabBtns.forEach(btn => btn.classList.remove('active'));
        tabContents.forEach(content => content.classList.remove('active'));

        const targetBtn = document.querySelector(`.tab[data-target="${targetId}"]`);
        const targetContent = document.getElementById(targetId);

        if (targetBtn) targetBtn.classList.add('active');
        if (targetContent) targetContent.classList.add('active');
    }

    function extractPlanId(card) {
        const detailBtn = card.querySelector('.btn-detail');
        if (!detailBtn) return '';
        const onclickAttr = detailBtn.getAttribute('onclick') || '';
        const match = onclickAttr.match(/id=(\d+)/);
        return match ? match[1] : '';
    }

    function extractDestination(card) {
        const title = card.querySelector('h3');
        return title ? title.textContent.trim() : '';
    }

    function addLiveButtons() {
        // Check for stopTracking parameter and reset state if needed
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('stopTracking') === 'true') {
            console.log('Stop tracking parameter detected, resetting all tracking states');
            
            // Clear localStorage
            localStorage.removeItem('liveTrackingPlanId');
            
            // Reset all tracking buttons to initial state
            const allCards = document.querySelectorAll('#content-saved .trip-card');
            allCards.forEach(card => {
                const liveBtn = card.querySelector('.live-track-btn');
                if (liveBtn) {
                    liveBtn.innerHTML = 'ð\x9f\x9a\x80 \uc2e4\uc2dc\uac04 \ud2b8\ub798\ud0b9 \ud558\uae30';
                    liveBtn.disabled = false;
                    card.classList.remove('active-card');
                }
            });
            
            // Remove the stopTracking parameter from URL
            const newUrl = window.location.pathname;
            window.history.replaceState({}, '', newUrl);
        }
        
        const savedCards = document.querySelectorAll('#content-saved .trip-card');
        const trackingPlanId = localStorage.getItem('liveTrackingPlanId');
        
        // 트래킹 중인 카드를 상단으로 이동
        if (trackingPlanId) {
            const trackingCard = Array.from(savedCards).find(card => {
                const planId = extractPlanId(card);
                return planId === trackingPlanId;
            });
            
            if (trackingCard) {
                const container = trackingCard.parentNode;
                container.insertBefore(trackingCard, container.firstChild);
            }
        }
        
        savedCards.forEach(card => {
            if (card.querySelector('.live-track-btn')) return;

            const planId = extractPlanId(card);
            if (!planId) return;

            // 1. 예정됨 상태 표시 제거
            const statusBadge = card.querySelector('.status-badge');
            if (statusBadge) {
                statusBadge.style.display = 'none';
            }

            // 2. 실시간 트래킹 버튼 생성 및 위치 설정
            const liveBtn = document.createElement('button');
            liveBtn.type = 'button';
            liveBtn.className = 'live-track-btn';
            liveBtn.dataset.planId = planId;
            liveBtn.dataset.destination = extractDestination(card);
            liveBtn.innerHTML = '🚀 실시간 트래킹 하기';
            liveBtn.style.position = 'absolute';
            liveBtn.style.top = '10px';
            liveBtn.style.right = '10px';
            liveBtn.style.zIndex = '10';
            liveBtn.style.padding = '8px 12px';
            liveBtn.style.border = 'none';
            liveBtn.style.borderRadius = '6px';
            liveBtn.style.fontSize = '12px';
            liveBtn.style.cursor = 'pointer';
            liveBtn.style.transition = 'all 0.2s ease';
            liveBtn.style.backgroundColor = '#1d4ed8ab';
            liveBtn.style.color = 'white';
            
            // 카드 전체에 relative 위치 설정 후 상단에 버튼 추가
            card.style.position = 'relative';
            card.appendChild(liveBtn);

            // localStorage에 저장된 트래킹 상태 복원
            if (trackingPlanId && trackingPlanId === planId) {
                liveBtn.innerHTML = '🔴실시간 트래킹중';
                liveBtn.disabled = true;
                card.classList.add('active-card');
            }

            // 3. 클릭 이벤트 처리
            liveBtn.addEventListener('click', function () {
                // 🔴실시간 트래킹중으로 변경
                this.innerHTML = '🔴실시간 트래킹중';
                this.disabled = true;
                
                // 카드 강조 표시
                card.classList.add('active-card');
                
                // 다른 카드의 트래킹 상태 초기화
                savedCards.forEach(otherCard => {
                    if (otherCard !== card) {
                        const otherBtn = otherCard.querySelector('.live-track-btn');
                        if (otherBtn) {
                            otherBtn.innerHTML = '🚀 실시간 트래킹 하기';
                            otherBtn.disabled = false;
                        }
                        otherCard.classList.remove('active-card');
                    }
                });
                
                // localStorage에 현재 트래킹 상태 저장
                localStorage.setItem('liveTrackingPlanId', planId);
                
                // 페이지 이동 (기능 유지) - destination 인코딩 문제 해결
                const ctx = window.MYPAGE_CTX || '';
                const destination = this.dataset.destination || '';
                const encodedDestination = encodeURIComponent(destination);
                const url = `${ctx}/my-live?planId=${encodeURIComponent(this.dataset.planId)}&destination=${encodedDestination}`;
                console.log('이동 URL:', url);
                window.location.href = url;
            });
        });
    }

    window.triggerTab = function (targetId) {
        activateTab(targetId);
        const tabsElement = document.querySelector('.tabs');
        if (tabsElement) {
            tabsElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    };

    document.addEventListener('DOMContentLoaded', function () {
        const body = document.body;
        window.MYPAGE_CTX = body ? (body.dataset.contextPath || '') : '';

        document.querySelectorAll('.tabs .tab').forEach(btn => {
            btn.addEventListener('click', function () {
                activateTab(this.getAttribute('data-target'));
            });
        });

        addLiveButtons();
    });
})();