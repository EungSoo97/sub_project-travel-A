(function () {
    const LIVE_IDLE_LABEL = '\ud83d\ude80 \uc2e4\uc2dc\uac04 \ud2b8\ub798\ud0b9 \ud558\uae30';
    const LIVE_ACTIVE_LABEL = '\ud83d\udd34\uc2e4\uc2dc\uac04 \ud2b8\ub798\ud0b9\uc911';
    const LIVE_IDLE_COLOR = '#1d4ed8ab';
    const LIVE_ACTIVE_COLOR = '#ef444480';

    function toNumber(value) {
        const number = Number(value);
        return Number.isFinite(number) ? number : 0;
    }

    function compareSavedCards(a, b) {
        const liveDiff = toNumber(b.dataset.liveTracking) - toNumber(a.dataset.liveTracking);
        if (liveDiff !== 0) return liveDiff;

        const starredDiff = (b.dataset.starred === 'true' ? 1 : 0) - (a.dataset.starred === 'true' ? 1 : 0);
        if (starredDiff !== 0) return starredDiff;

        const createdDiff = toNumber(b.dataset.createdTime) - toNumber(a.dataset.createdTime);
        if (createdDiff !== 0) return createdDiff;

        return toNumber(b.dataset.planId) - toNumber(a.dataset.planId);
    }

    function sortSavedCards() {
        const container = document.getElementById('content-saved');
        if (!container) return;

        Array.from(container.querySelectorAll('.trip-card'))
            .sort(compareSavedCards)
            .forEach(function (card) {
                container.appendChild(card);
            });
    }

    function activateTab(targetId) {
        const tabBtns = document.querySelectorAll('.tabs .tab');
        const tabContents = document.querySelectorAll('.tab-content');

        tabBtns.forEach(function (btn) { btn.classList.remove('active'); });
        tabContents.forEach(function (content) { content.classList.remove('active'); });

        const targetBtn = document.querySelector('.tab[data-target="' + targetId + '"]');
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

    function setButtonLiveState(button, isLive) {
        if (!button) return;
        button.textContent = isLive ? LIVE_ACTIVE_LABEL : LIVE_IDLE_LABEL;
        button.innerHTML = button.textContent;
        button.style.backgroundColor = isLive ? LIVE_ACTIVE_COLOR : LIVE_IDLE_COLOR;
    }

    function ensureLivePulseStyle() {
        if (document.getElementById('livePulseStyle')) return;

        const style = document.createElement('style');
        style.id = 'livePulseStyle';
        style.textContent = '@keyframes livePulse{0%,100%{opacity:1;transform:translateY(-50%) scale(1)}50%{opacity:.4;transform:translateY(-50%) scale(1.4)}}';
        document.head.appendChild(style);
    }

    function updateGlobalLiveNav(planId, ctx) {
        const liveNavLink = document.getElementById('liveNavLink');
        if (!liveNavLink) return;

        const dot = liveNavLink.querySelector('.live-nav-dot');
        if (planId) {
            ensureLivePulseStyle();
            liveNavLink.href = ctx + '/my-live?planId=' + encodeURIComponent(planId);
            liveNavLink.style.position = 'relative';

            if (!dot) {
                const nextDot = document.createElement('span');
                nextDot.className = 'live-nav-dot';
                nextDot.style.cssText = [
                    'position:absolute',
                    'left:-4px',
                    'top:50%',
                    'transform:translateY(-50%)',
                    'width:9px',
                    'height:9px',
                    'border-radius:50%',
                    'background:#ef4444',
                    'animation:livePulse 1.4s ease-in-out infinite',
                    'pointer-events:none'
                ].join(';');
                liveNavLink.appendChild(nextDot);
            }
            return;
        }

        if (dot) dot.remove();
        liveNavLink.href = ctx + '/live-select';
    }

    function postTracking(action, planId, ctx) {
        return fetch(ctx + '/live-tracking', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ action: action, planId: planId })
        }).then(function (response) {
            return response.json().catch(function () {
                return {};
            }).then(function (data) {
                if (!response.ok || !data.success) {
                    throw new Error(data.message || 'tracking update failed');
                }
                return data;
            });
        });
    }

    function resetOtherCards(savedCards, activeCard) {
        savedCards.forEach(function (otherCard) {
            if (otherCard === activeCard) return;

            const otherBtn = otherCard.querySelector('.live-track-btn');
            setButtonLiveState(otherBtn, false);
            otherCard.dataset.liveTracking = '0';
            otherCard.classList.remove('active-card');
        });
    }

    function addLiveButtons() {
        const savedCards = document.querySelectorAll('#content-saved .trip-card');
        const trackingPlanId = localStorage.getItem('liveTrackingPlanId');

        if (trackingPlanId) {
            const trackingCard = Array.from(savedCards).find(function (card) {
                return extractPlanId(card) === trackingPlanId;
            });

            if (trackingCard && trackingCard.parentNode) {
                trackingCard.parentNode.insertBefore(trackingCard, trackingCard.parentNode.firstChild);
            }
        }

        savedCards.forEach(function (card) {
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
            liveBtn.style.color = 'white';
            setButtonLiveState(liveBtn, false);

            card.style.position = 'relative';
            card.appendChild(liveBtn);

            if ((trackingPlanId && trackingPlanId === planId) || card.dataset.liveTracking === '1') {
                card.dataset.liveTracking = '1';
                card.classList.add('active-card');
                setButtonLiveState(liveBtn, true);
            }

            liveBtn.addEventListener('click', function () {
                const ctx = window.MYPAGE_CTX || '';
                const isTracking = localStorage.getItem('liveTrackingPlanId') === planId || card.dataset.liveTracking === '1';
                liveBtn.disabled = true;

                if (isTracking) {
                    postTracking('stop', planId, ctx).then(function () {
                        localStorage.removeItem('liveTrackingPlanId');
                        setButtonLiveState(liveBtn, false);
                        card.dataset.liveTracking = '0';
                        card.classList.remove('active-card');
                        sortSavedCards();
                        updateGlobalLiveNav('', ctx);
                    }).catch(function (error) {
                        console.error(error);
                    }).finally(function () {
                        liveBtn.disabled = false;
                    });
                    return;
                }

                postTracking('start', planId, ctx).then(function () {
                    localStorage.setItem('liveTrackingPlanId', planId);
                    card.dataset.liveTracking = '1';
                    card.classList.add('active-card');
                    setButtonLiveState(liveBtn, true);
                    resetOtherCards(savedCards, card);
                    sortSavedCards();
                    updateGlobalLiveNav(planId, ctx);

                    const destination = encodeURIComponent(liveBtn.dataset.destination || '');
                    window.location.href = ctx + '/my-live?planId=' + encodeURIComponent(planId) + '&destination=' + destination;
                }).catch(function (error) {
                    console.error(error);
                    liveBtn.disabled = false;
                });
            });
        });

        sortSavedCards();
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

        document.querySelectorAll('.tabs .tab').forEach(function (btn) {
            btn.addEventListener('click', function () {
                activateTab(this.getAttribute('data-target'));
            });
        });

        addLiveButtons();
    });
})();
