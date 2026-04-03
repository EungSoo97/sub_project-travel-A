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
        ph.style.cssText = `
            height: ${item.offsetHeight}px;
            background: #eff6ff;
            border: 2px dashed #2563eb;
            border-radius: 12px;
            margin: 4px 0;
        `;
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
        clone.style.cssText = `
            position: fixed;
            left: ${item.getBoundingClientRect().left}px;
            top: ${item.getBoundingClientRect().top}px;
            width: ${item.offsetWidth}px;
            z-index: 9999;
            pointer-events: none;
            opacity: 0.92;
            box-shadow: 0 8px 24px rgba(0,0,0,0.18);
            border-radius: 12px;
            background: white;
        `;
        document.body.appendChild(clone);

        placeholder = createPlaceholder(item);
        item.parentNode.insertBefore(placeholder, item);
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
        list.insertBefore(dragged, placeholder);
        placeholder.remove();
        clone.remove();
        dragged = null;
        placeholder = null;
        clone = null;
    }

    // ── 터치 (모바일 핵심 수정) ──
    list.addEventListener('touchstart', e => {
        const handle = e.target.closest('.activity-item__drag');
        if (!handle) return;

        e.preventDefault(); // ⭐ 중요

        const item = handle.closest('.activity-item');
        if (!item) return;

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
        const handle = e.target.closest('.activity-item__drag');
        if (!handle) return;

        e.stopPropagation(); // ⭐ 중요
        e.preventDefault();

        const item = handle.closest('.activity-item');
        if (!item) return;

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
    if (confirm('이 일정을 삭제할까요?')) {
        item.remove();
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

    const dayBlock = btn.closest('.day-block');
    const list = dayBlock.querySelector('.activity-list');

    const modal = document.getElementById('activityModal');
    modal.classList.add('show');

    // 현재 리스트 기억
    modal.dataset.targetListId = list.id;
});


// ── 모달 닫기 ──
document.getElementById('closeModalBtn').addEventListener('click', () => {
    document.getElementById('activityModal').classList.remove('show');
});


// ── 활동 추가 ──
document.getElementById('addActivityBtn').addEventListener('click', () => {
    const time = document.getElementById('newTime').value;
    const title = document.getElementById('newTitle').value;
    const desc = document.getElementById('newDesc').value;

    if (!time || !title) {
        alert('시간과 제목은 필수!');
        return;
    }

    const modal = document.getElementById('activityModal');
    const listId = modal.dataset.targetListId;
    const list = document.getElementById(listId);

    // 새 아이템 생성
    const item = document.createElement('div');
    item.className = 'activity-item activity-item--spot';
    item.innerHTML = `
        <div class="activity-item__drag">⋮⋮</div>
        <div class="activity-item__icon">📍</div>
        <div class="activity-item__body">
            <div class="activity-item__top">
                <span class="activity-item__time">${time}</span>
                <span class="activity-item__title">${title}</span>
            </div>
            <div class="activity-item__desc">${desc}</div>
        </div>
        <button class="activity-item__delete">🗑</button>
    `;

    list.appendChild(item);

    // 입력값 초기화
    document.getElementById('newTime').value = '';
    document.getElementById('newTitle').value = '';
    document.getElementById('newDesc').value = '';

    modal.classList.remove('show');
});