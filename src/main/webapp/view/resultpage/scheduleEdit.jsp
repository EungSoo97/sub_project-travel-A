<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>일정 편집하기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/edit-schedule.css">
</head>
<body>

<div class="container schedule-edit-page">

    <!-- ── 헤더 ── -->
    <div class="edit-header">
        <div class="edit-header__left">
            <h1>일정 편집하기</h1>
            <p>${result.summary.destination} · ${result.summary.days}일 여행</p>
        </div>
        <div class="edit-header__actions">
            <button class="btn-recalc" type="button">
                <span class="btn-icon"><i class="fa-solid fa-rotate"></i></span> 경로 재계산
            </button>
            <button type="button" class="btn-save" onclick="handleSave()">
                <span class="btn-icon"><i class="fa-solid fa-floppy-disk"></i></span> 저장
            </button>
        </div>
    </div>

    <!-- ── 활동 추가 모달 (전역 1개) ── -->
    <div class="modal" id="activityModal" aria-hidden="true">
        <div class="modal-content">
            <h2>활동 추가</h2>

            <label>카테고리</label>
            <select id="newType">
                <option value="spot">여행지</option>
                <option value="dining">식사</option>
                <option value="transport">이동</option>
                <option value="accommodation">숙박</option>
            </select>

            <label>시간</label>
            <input type="time" id="newTime">

            <label>제목</label>
            <input type="text" id="newTitle" placeholder="예: 점심 식사">

            <label>설명</label>
            <input type="text" id="newDesc" placeholder="간단 설명">

            <label>소요 시간 (분)</label>
            <input type="number" id="newDuration" placeholder="0" min="0">

            <label>비용</label>
            <div style="display: flex; gap: 8px;">
                <input type="number" id="newCost" placeholder="0" min="0" style="flex: 1;">
                <input type="text" id="newCurrency" value="KRW" style="width: 100px;">
            </div>

            <div class="modal-actions">
                <button id="closeModalBtn" type="button">취소</button>
                <button id="addActivityBtn" type="button">추가</button>
            </div>
        </div>
    </div>

    <!-- ── Day 블록 반복 ── -->
    <c:forEach var="item" items="${result.itinerary}" varStatus="dayStatus">

        <div class="day-block"
             data-estimated-cost="${item.estimatedCost}"
             data-currency="${item.currency}">

            <!-- Day 헤더 -->
            <div class="day-block__header">
                <span class="day-block__title">Day ${item.day} · ${item.date}</span>
                <button class="btn-add-activity" type="button"
                        data-list-id="day${item.day}-list">
                    <span><i class="fa-solid fa-plus"></i></span> 활동 추가
                </button>
            </div>

            <!-- 일정 아이템 목록 -->
            <div class="activity-list" id="day${item.day}-list">

                <c:forEach var="act" items="${item.activities}" varStatus="actStatus">

                    <%-- type별 CSS 클래스 분기 --%>
                    <c:set var="activityCategory" value="${fn:toUpperCase(not empty act.categoryCode ? act.categoryCode : (not empty act.category ? act.category : act.type))}"/>
                    <c:choose>
                        <c:when test="${activityCategory == 'TRANSPORT'}">
                            <c:set var="itemClass" value="activity-item--move"/>
                            <c:set var="iconEmoji" value="<i class='fa-solid fa-train'></i>"/>
                        </c:when>
                        <c:when test="${activityCategory == 'DINING' or activityCategory == 'FOOD' or activityCategory == 'RESTAURANT'}">
                            <c:set var="itemClass" value="activity-item--food"/>
                            <c:set var="iconEmoji" value="<i class='fa-solid fa-utensils'></i>"/>
                        </c:when>
                        <c:when test="${activityCategory == 'ACCOMMODATION' or activityCategory == 'HOTEL'}">
                            <c:set var="itemClass" value="activity-item--hotel"/>
                            <c:set var="iconEmoji" value="<i class='fa-solid fa-hotel'></i>"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="itemClass" value="activity-item--spot"/>
                            <c:set var="iconEmoji" value="<i class='fa-solid fa-location-dot'></i>"/>
                        </c:otherwise>
                    </c:choose>

                    <div class="activity-item ${itemClass}"
                         draggable="true"
                         data-day="${item.day}"
                         data-order="${actStatus.count}"
                         data-type="${empty activityCategory ? act.type : activityCategory}"
                         data-category="${act.category}"
                         data-category-code="${act.categoryCode}"
                         data-duration-minutes="${act.durationMinutes}"
                         data-cost="${act.cost}"
                         data-currency="${act.currency}"
                         data-location="${act.location}">

                        <div class="activity-item__drag"><i class="fa-solid fa-grip-vertical"></i></div>

                        <div class="activity-item__icon"><c:out value="${iconEmoji}" escapeXml="false"/></div>

                        <div class="activity-item__body">
                            <div class="activity-item__top">
                                <span class="activity-item__time">${act.time}</span>
                                <span class="activity-item__title">${fn:escapeXml(act.name)}</span>
                            </div>

                            <div class="activity-item__desc">
                                    ${fn:escapeXml(act.description)}
                            </div>

                            <div class="activity-item__meta">
                                <c:if test="${not empty act.location}">
                                    <span class="meta-tag meta-tag--location">
                                        <i class="fa-solid fa-location-dot"></i> ${fn:escapeXml(act.location)}
                                    </span>
                                </c:if>
                                <c:choose>
                                    <c:when test="${act.durationMinutes > 0}">
                                        <span class="meta-tag meta-tag--time">
                                            <i class="fa-regular fa-clock"></i> ${act.durationMinutes}분
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="meta-tag meta-tag--time">
                                            <i class="fa-regular fa-clock"></i> 미정
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${act.cost == 0}">
                                        <span class="meta-tag meta-tag--cost">무료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="meta-tag meta-tag--cost">
                                            ${act.cost} ${act.currency}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <button class="activity-item__delete" type="button" title="삭제"><i class="fa-solid fa-trash"></i></button>
                    </div>

                </c:forEach>

            </div>
            <!-- /activity-list -->

            <!-- Day 요약 푸터 -->
            <div class="day-block__footer">
                <span class="day-block__summary">${fn:escapeXml(item.summary)}</span>
                <span class="day-block__cost"
                      data-cost="${item.estimatedCost}"
                      data-currency="${item.currency}">예상 비용: ${item.estimatedCost} ${item.currency}</span>
            </div>

        </div>
        <!-- /day-block -->

    </c:forEach>

</div>
<!-- /container -->

<script src="${pageContext.request.contextPath}/js/scheduleEdit.js"></script>
<script>
    // ── planId 전역 변수 (중복 선언 방지) ──
    var PLAN_ID = parseInt('${savedPlan.planId}') || 0;

    // ── 저장 ──
    function handleSave() {
        console.log('handleSave 호출, planId:', PLAN_ID);

        if (!PLAN_ID) {
            alert('planId를 찾을 수 없습니다. 페이지를 새로고침 해주세요.');
            return;
        }

        var days = [];
        document.querySelectorAll('.day-block').forEach(function(block) {
            var addBtn = block.querySelector('.btn-add-activity');
            if (!addBtn) return;

            var dayNum = addBtn.dataset.listId
                .replace('day', '').replace('-list', '');

            var activities = [];
            block.querySelectorAll('.activity-item').forEach(function(item, idx) {
                activities.push({
                    order:           idx + 1,
                    time:            (item.querySelector('.activity-item__time')  || {}).textContent.trim(),
                    name:            (item.querySelector('.activity-item__title') || {}).textContent.trim(),
                    description:     (item.querySelector('.activity-item__desc')  || {}).textContent.trim(),
                    type:            item.dataset.type || 'SPOT',
                    category:        item.dataset.category || item.dataset.type || 'SPOT',
                    categoryCode:    item.dataset.categoryCode || item.dataset.type || 'SPOT',
                    durationMinutes: parseInt(item.dataset.durationMinutes) || 0,
                    cost:            parseInt(item.dataset.cost) || 0,
                    currency:        item.dataset.currency || 'KRW',
                    location:        item.dataset.location || ''
                });
            });

            var costEl = block.querySelector('.day-block__cost');
            var estimatedCost = parseInt((costEl && costEl.dataset.cost) || block.dataset.estimatedCost) || 0;
            var currency = (costEl && costEl.dataset.currency) || block.dataset.currency || 'KRW';

            days.push({
                day: Number(dayNum),
                estimatedCost: estimatedCost,
                currency: currency,
                activities: activities
            });
        });

        console.log('전송 데이터:', JSON.stringify({ planId: PLAN_ID, days: days }));

        fetch('${pageContext.request.contextPath}/edit-plan', {
            method:  'POST',
            headers: { 'Content-Type': 'application/json' },
            body:    JSON.stringify({ planId: PLAN_ID, days: days })
        })
            .then(function(res) { return res.json(); })
            .then(function(data) {
                console.log('서버 응답:', data);
                if (data.success) {
                    showToast('저장 완료! 이동합니다.');
                    setTimeout(function() {
                        window.location.href =
                            '${pageContext.request.contextPath}/myplan-page?id=' + PLAN_ID;
                    }, 1000);
                } else {
                    showToast('❌ ' + (data.message || '저장 실패'));
                }
            })
            .catch(function(err) {
                console.error('fetch 오류:', err);
                showToast('❌ 네트워크 오류');
            });
    }

    // ── 토스트 ──
    function showToast(msg) {
        var toast = document.getElementById('_globalToast');
        if (!toast) {
            toast = document.createElement('div');
            toast.id = '_globalToast';
            toast.style.cssText = 'position:fixed;bottom:24px;left:50%;' +
                'transform:translateX(-50%) translateY(20px);' +
                'background:#1f2937;color:#fff;padding:10px 20px;' +
                'border-radius:999px;font-size:13px;font-weight:600;' +
                'opacity:0;transition:.3s;z-index:9999;' +
                'pointer-events:none;white-space:nowrap;';
            document.body.appendChild(toast);
        }
        toast.textContent = msg;
        toast.style.opacity = '1';
        toast.style.transform = 'translateX(-50%) translateY(0)';
        setTimeout(function() {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(-50%) translateY(20px)';
        }, 2000);
    }
</script>
</body>
</html>
