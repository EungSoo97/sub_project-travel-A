// edit-schedule.js  –  터치 + 마우스 드래그 앤 드롭

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

        // 클론 생성 (시각적 드래그 요소)
        clone = item.cloneNode(true);
        clone.classList.add('drag-clone');
        clone.style.cssText = `
            position: fixed;
            left: ${item.getBoundingClientRect().left}px;
            top: ${item.getBoundingClientRect().top}px;
            width: ${item.offsetWidth}px;
            z-index: 9999;
            pointer-events: none;
            opacity: 0.95;
            box-shadow: 0 8px 24px rgba(0,0,0,0.18);
            border-radius: 12px;
            background: white;
        `;
        document.body.appendChild(clone);

        // 플레이스홀더 (빈 자리 표시)
        placeholder = createPlaceholder(item);
        item.parentNode.insertBefore(placeholder, item);
        item.style.display = 'none';
    }

    function onMove(clientY) {
        if (!dragged || !clone) return;

        // 클론 따라오게
        clone.style.top = (clientY - offsetY) + 'px';

        // 플레이스홀더 위치 재계산
        const target = getItemAtY(clientY);
        if (target) {
            const rect = target.getBoundingClientRect();
            const mid = rect.top + rect.height / 2;
            if (clientY < mid) {
                list.insertBefore(placeholder, target);
            } else {
                list.insertBefore(placeholder, target.nextSibling);
            }
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

    // ── 터치 이벤트 (모바일) ──
    list.addEventListener('touchstart', e => {
        const handle = e.target.closest('.activity-item__drag');
        if (!handle) return;
        const item = handle.closest('.activity-item');
        if (!item) return;

        e.preventDefault();
        onMoveStart(e.touches[0].clientY, item);
    }, { passive: false });

    document.addEventListener('touchmove', e => {
        if (!dragged) return;
        e.preventDefault();
        onMove(e.touches[0].clientY);
    }, { passive: false });

    document.addEventListener('touchend', () => {
        if (!dragged) return;
        onMoveEnd();
    });

    // ── 마우스 이벤트 (PC) ──
    list.addEventListener('mousedown', e => {
        const handle = e.target.closest('.activity-item__drag');
        if (!handle) return;
        const item = handle.closest('.activity-item');
        if (!item) return;

        e.preventDefault();
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

// ── 삭제 버튼 ──
document.addEventListener('click', e => {
    const btn = e.target.closest('.activity-item__delete');
    if (!btn) return;
    const item = btn.closest('.activity-item');
    if (confirm('이 일정을 삭제할까요?')) item.remove();
});