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
        if (card.dataset.planId) return card.dataset.planId;

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

    function postTracking(ctx, payload) {
        return fetch(`${ctx}/live-tracking`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(payload)
        }).then(response => {
            if (!response.ok) {
                throw new Error('tracking request failed');
            }
            return response.json();
        });
    }

    function addLiveButtons() {
        const ctx = window.MYPAGE_CTX || '';
        const urlParams = new URLSearchParams(window.location.search);

        if (urlParams.get('stopTracking') === 'true') {
            localStorage.removeItem('liveTrackingPlanId');
            postTracking(ctx, { action: 'stop' }).catch(() => {
                // The tracking page usually stops tracking before redirecting here.
            });
            window.history.replaceState({}, '', window.location.pathname);
        }

        const savedCards = Array.from(document.querySelectorAll('#content-saved .trip-card'));
        const activeCard = savedCards.find(card => card.dataset.liveTracking === '1');
        const activePlanId = activeCard ? extractPlanId(activeCard) : '';

        if (activeCard) {
            activeCard.parentNode.insertBefore(activeCard, activeCard.parentNode.firstChild);
            localStorage.setItem('liveTrackingPlanId', activePlanId);
        } else {
            localStorage.removeItem('liveTrackingPlanId');
        }

        savedCards.forEach(card => {
            if (card.querySelector('.live-track-btn')) return;

            const planId = extractPlanId(card);
            if (!planId) return;

            const statusBadge = card.querySelector('.status-badge');
            if (statusBadge) {
                statusBadge.style.display = 'none';
            }

            const liveBtn = document.createElement('button');
            liveBtn.type = 'button';
            liveBtn.className = 'live-track-btn';
            liveBtn.dataset.planId = planId;
            liveBtn.dataset.destination = extractDestination(card);
            liveBtn.innerHTML = activePlanId === planId ? '🔴실시간 트래킹중' : '🚀 실시간 트래킹 하기';
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

            card.style.position = 'relative';
            card.classList.toggle('active-card', activePlanId === planId);
            card.appendChild(liveBtn);

            liveBtn.addEventListener('click', function () {
                const isCurrentlyActive = card.dataset.liveTracking === '1';

                if (isCurrentlyActive) {
                    this.innerHTML = '해제 중...';
                    this.disabled = true;

                    postTracking(ctx, { action: 'stop', planId: Number(planId) })
                        .then(data => {
                            if (!data.success) {
                                throw new Error('tracking stop failed');
                            }

                            card.dataset.liveTracking = '0';
                            card.classList.remove('active-card');
                            localStorage.removeItem('liveTrackingPlanId');

                            this.innerHTML = '🚀 실시간 트래킹 하기';
                            this.disabled = false;
                        })
                        .catch(() => {
                            this.innerHTML = '🔴실시간 트래킹중';
                            this.disabled = false;
                            alert('실시간 트래킹 해제에 실패했습니다. 잠시 후 다시 시도해주세요.');
                        });
                    return;
                }

                this.innerHTML = '활성화 중...';
                this.disabled = true;

                postTracking(ctx, { action: 'start', planId: Number(planId) })
                    .then(data => {
                        if (!data.success) {
                            throw new Error('tracking update failed');
                        }

                        savedCards.forEach(otherCard => {
                            const otherPlanId = extractPlanId(otherCard);
                            const otherBtn = otherCard.querySelector('.live-track-btn');
                            const isActive = otherPlanId === planId;

                            otherCard.dataset.liveTracking = isActive ? '1' : '0';
                            otherCard.classList.toggle('active-card', isActive);

                            if (otherBtn) {
                                otherBtn.innerHTML = isActive ? '🔴실시간 트래킹중' : '🚀 실시간 트래킹 하기';
                                otherBtn.disabled = false;
                            }
                        });

                        localStorage.setItem('liveTrackingPlanId', planId);

                        const destination = this.dataset.destination || '';
                        const encodedDestination = encodeURIComponent(destination);
                        window.location.href = `${ctx}/my-live?planId=${encodeURIComponent(planId)}&destination=${encodedDestination}`;
                    })
                    .catch(() => {
                        this.innerHTML = '🚀 실시간 트래킹 하기';
                        this.disabled = false;
                        alert('실시간 트래킹 활성화에 실패했습니다. 잠시 후 다시 시도해주세요.');
                    });
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
