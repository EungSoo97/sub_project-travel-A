
// ── CSS 변수 fallback ──
(function injectFallbackVars() {
    const style = document.createElement('style');
    style.textContent = `
        :root {
            --primary: #2563eb;
        }
    `;
    document.head.prepend(style);
})();


// ── 드래그 앤 드롭 ──
document.querySelectorAll('.activity-list').forEach(list => {
    let dragged = null;
    let placeholder = null;
    let offsetY = 0;
    let clone = null;

    function getItems() {
        return [...list.querySelectorAll('.activity-item:not(.drag-clone)')];
    }

    function createPlaceholder(item) {
        const ph = document.createElement('div');
        ph.className = 'drag-placeholder';
        ph.style.height = item.offsetHeight + 'px';
        return ph;
    }

    function getItemAtY(y) {
        return getItems().find(item => {
            if (item === dragged) return false;
            const rect = item.getBoundingClientRect();
            return y >= rect.top && y <= rect.bottom;
        });
    }

    function onMoveStart(clientY, item) {
        dragged = item;
        offsetY = clientY - item.getBoundingClientRect().top;

        clone = item.cloneNode(true);
        clone.classList.add('drag-clone');
        clone.classList.add('is-floating');
        clone.style.cssText = `
            position: fixed;
            left: ${item.getBoundingClientRect().left}px;
            top: ${item.getBoundingClientRect().top}px;
            width: ${item.offsetWidth}px;
            z-index: 9999;
            pointer-events: none;
        `;
        const dragRoot = item.closest('.schedule-edit-page') || document.body;
        dragRoot.appendChild(clone);

        placeholder = createPlaceholder(item);
        item.parentNode.insertBefore(placeholder, item);
        item.classList.add('dragging');
        item.style.display = 'none';
    }

    function onMove(clientY) {
        if (!dragged || !clone) return;
        clone.style.top = (clientY - offsetY) + 'px';

        const target = getItemAtY(clientY);
        if (target) {
            const rect = target.getBoundingClientRect();
            const mid = rect.top + rect.height / 2;
            list.insertBefore(placeholder, clientY < mid ? target : target.nextSibling);
        }
    }

    function onMoveEnd() {
        if (!dragged) return;
        dragged.style.display = '';
        dragged.classList.remove('dragging');
        list.insertBefore(dragged, placeholder);
        placeholder && placeholder.remove();
        clone && clone.remove();
        dragged = null;
        placeholder = null;
        clone = null;
    }

    // ── 터치 (모바일 핵심 수정) ──
    list.addEventListener('touchstart', e => {
        const item = e.target.closest('.activity-item');
        if (!item) return;
        // 삭제 버튼, 시간 편집 클릭은 드래그 제외
        if (e.target.closest('.activity-item__delete')) return;
        if (e.target.closest('.activity-item__time')) return;


        onMoveStart(e.touches[0].clientY, item);
    }, { passive: false });

    document.addEventListener('touchmove', e => {
        if (!dragged) return;

        e.preventDefault(); // ⭐ 중요
        onMove(e.touches[0].clientY);
    }, { passive: false });

    document.addEventListener('touchend', () => {
        if (dragged) onMoveEnd();
    });

    // ── 마우스 (PC) ──
    list.addEventListener('mousedown', e => {
        const item = e.target.closest('.activity-item');
        if (!item) return;

        if (e.target.closest('.activity-item__delete')) return;
        if (e.target.closest('.activity-item__time')) return;



        onMoveStart(e.clientY, item);

        const onMouseMove = e => onMove(e.clientY);
        const onMouseUp = () => {
            onMoveEnd();
            document.removeEventListener('mousemove', onMouseMove);
            document.removeEventListener('mouseup', onMouseUp);
        };

        document.addEventListener('mousemove', onMouseMove);
        document.addEventListener('mouseup', onMouseUp);
    });
});


// ── 삭제 ──
document.addEventListener('click', e => {
    const btn = e.target.closest('.activity-item__delete');
    if (!btn) return;

    const item = btn.closest('.activity-item');
    const dayBlock = item.closest('.day-block');
    const itemCost = getActivityCost(item);
    if (confirm('이 일정을 삭제할까요?')) {
        item.remove();
        adjustDayEstimatedCost(dayBlock, -itemCost);
    }
});


// ── 시간 인라인 편집 ──
document.addEventListener('click', e => {
    const timeEl = e.target.closest('.activity-item__time');
    if (!timeEl || timeEl.querySelector('input')) return;

    const original = timeEl.textContent.trim();

    function formatTime(val) {
        if (!val.includes(':')) return '09:00';
        const [h, m] = val.split(':');
        return `${h.padStart(2, '0')}:${m}`;
    }

    const input = document.createElement('input');
    input.type = 'time';
    input.value = formatTime(original);

    input.style.cssText = `
        font-size: 12px;
        font-weight: 600;
        color: var(--primary);
        border: 1px solid var(--primary);
        border-radius: 4px;
        padding: 2px 4px;
        width: 90px;
        background: #fff;
        outline: none;
    `;

    timeEl.innerHTML = '';
    timeEl.appendChild(input);
    input.focus();

    function commit() {
        const val = input.value || original;
        timeEl.textContent = val;
    }

    input.addEventListener('blur', commit);

    input.addEventListener('keydown', e => {
        if (e.key === 'Enter') input.blur();
        if (e.key === 'Escape') {
            timeEl.textContent = original;
        }
    });
});
// ── 모달 열기 ──
document.addEventListener('click', e => {
    const btn = e.target.closest('.btn-add-activity');
    if (!btn) return;

    // data-list-id 속성으로 타겟 리스트 직접 지정
    const modal = document.getElementById('activityModal');
    modal.dataset.targetListId = btn.dataset.listId;
    modal.classList.add('show');
    modal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
});


// ── 모달 닫기 ──
document.getElementById('closeModalBtn').addEventListener('click', () => {
    closeActivityModal();
});

document.getElementById('activityModal').addEventListener('click', e => {
    if (e.target.id === 'activityModal') {
        closeActivityModal();
    }
});

document.addEventListener('keydown', e => {
    const modal = document.getElementById('activityModal');
    if (e.key === 'Escape' && modal.classList.contains('show')) {
        closeActivityModal();
    }
});

function closeActivityModal() {
    const modal = document.getElementById('activityModal');
    modal.classList.remove('show');
    modal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
}


// ── 활동 추가 ──
function normalizeActivityCategory(value) {
    const normalized = String(value || '').trim().toUpperCase();
    if (normalized === 'TRANSPORT' || normalized === 'MOVE') return 'transport';
    if (normalized === 'DINING' || normalized === 'FOOD' || normalized === 'RESTAURANT') return 'dining';
    if (normalized === 'ACCOMMODATION' || normalized === 'HOTEL') return 'accommodation';
    return 'spot';
}

function toActivityCategoryCode(type) {
    const normalized = normalizeActivityCategory(type);
    if (normalized === 'transport') return 'TRANSPORT';
    if (normalized === 'dining') return 'DINING';
    if (normalized === 'accommodation') return 'ACCOMMODATION';
    return 'ATTRACTION';
}

function getActivityCost(item) {
    return parseInt(item && item.dataset.cost, 10) || 0;
}

function getDayEstimatedCost(dayBlock) {
    if (!dayBlock) return 0;
    const costEl = dayBlock.querySelector('.day-block__cost');
    return parseInt((costEl && costEl.dataset.cost) || dayBlock.dataset.estimatedCost, 10) || 0;
}

function setDayEstimatedCost(dayBlock, cost, currency) {
    if (!dayBlock) return;
    const costEl = dayBlock.querySelector('.day-block__cost');
    const nextCost = Math.max(0, parseInt(cost, 10) || 0);
    const nextCurrency = currency || dayBlock.dataset.currency || (costEl && costEl.dataset.currency) || 'KRW';

    dayBlock.dataset.estimatedCost = String(nextCost);
    dayBlock.dataset.currency = nextCurrency;

    if (costEl) {
        costEl.dataset.cost = String(nextCost);
        costEl.dataset.currency = nextCurrency;
        costEl.textContent = `예상 비용: ${nextCost.toLocaleString('ko-KR')} ${nextCurrency}`;
    }
}

function adjustDayEstimatedCost(dayBlock, deltaCost) {
    if (!dayBlock) return;
    setDayEstimatedCost(dayBlock, getDayEstimatedCost(dayBlock) + (parseInt(deltaCost, 10) || 0));
}

document.getElementById('addActivityBtn').addEventListener('click', () => {
    const time = document.getElementById('newTime').value;
    const title = document.getElementById('newTitle').value;
    const desc = document.getElementById('newDesc').value;
    const type = normalizeActivityCategory(document.getElementById('newType').value || 'SPOT');
    const durationMinutes = parseInt(document.getElementById('newDuration').value) || 0;
    const cost = parseInt(document.getElementById('newCost').value) || 0;
    const currency = document.getElementById('newCurrency').value || 'KRW';

    if (!time || !title) {
        alert('시간과 제목은 필수!');
        return;
    }

    const modal = document.getElementById('activityModal');
    const listId = modal.dataset.targetListId;
    const list = document.getElementById(listId);


    // 타입에 따른 아이콘 결정
    const iconMap = {
        'transport': '<i class="fa-solid fa-train"></i>',
        'dining': '<i class="fa-solid fa-utensils"></i>',
        'accommodation': ' <i class="fa-solid fa-hotel"></i>',
        'spot': '<i class="fa-solid fa-location-dot"></i>'
    };
    const icon = iconMap[type] || '<i class="fa-solid fa-location-dot"></i>';

    // 타입에 따른 CSS 클래스 결정
    const classMap = {
        'transport': 'activity-item--move',
        'dining': 'activity-item--food',
        'accommodation': 'activity-item--hotel',
        'spot': 'activity-item--spot'
    };
    const itemClass = classMap[type] || 'activity-item--spot';

    // 메타 태그 HTML (비용 태그는 항상 표시)
    let metaTagsHTML = '';
    if (durationMinutes > 0) {
        metaTagsHTML += `<span class="meta-tag meta-tag--time">⏱ ${durationMinutes}분</span>`;
    }
    if (cost === 0) {
        metaTagsHTML += `<span class="meta-tag meta-tag--cost">무료</span>`;
    } else {
        metaTagsHTML += `<span class="meta-tag meta-tag--cost">${cost} ${currency}</span>`;
    }

    // 새 아이템 생성
    const item = document.createElement('div');
    item.className = `activity-item ${itemClass}`;
    item.draggable = true;
    item.dataset.type = toActivityCategoryCode(type);
    item.dataset.category = type;
    item.dataset.categoryCode = toActivityCategoryCode(type);
    item.dataset.isNew = "true"; // ── 새로 추가된 활동 표시 ──
    item.innerHTML = `
        <div class="activity-item__drag">⋮⋮</div>
        <div class="activity-item__icon">${icon}</div>
        <div class="activity-item__body">
            <div class="activity-item__top">
                <span class="activity-item__time">${time}</span>
                <span class="activity-item__title">${title}</span>
            </div>
            <div class="activity-item__desc">${desc}</div>
            <div class="activity-item__meta">
                ${metaTagsHTML}
            </div>
        </div>
        <button class="activity-item__delete" type="button" title="삭제">🗑</button>
    `;

    // 데이터 속성 저장
    item.dataset.durationMinutes = durationMinutes;
    item.dataset.cost = cost;
    item.dataset.currency = currency;

    list.appendChild(item);
    adjustDayEstimatedCost(list.closest('.day-block'), cost);

    // 입력값 초기화
    document.getElementById('newTime').value = '';
    document.getElementById('newTitle').value = '';
    document.getElementById('newDesc').value = '';
    document.getElementById('newDuration').value = '';
    document.getElementById('newCost').value = '';
    document.getElementById('newCurrency').value = 'KRW';
    document.getElementById('newType').value = 'spot';

    closeActivityModal();
});
