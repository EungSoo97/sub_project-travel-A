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

<div class="container">

    <!-- ── 헤더 ── -->
    <div class="edit-header">
        <div class="edit-header__left">
            <h1>일정 편집하기</h1>
            <p>${result.summary.destination} · ${result.summary.days}일 여행</p>
        </div>
        <div class="edit-header__actions">
            <button class="btn-recalc" type="button">
                <span class="btn-icon">↺</span> 경로 재계산
            </button>
            <button class="btn-save" type="button" onclick="handleSave()">
                <span class="btn-icon">💾</span> 저장
            </button>
        </div>
    </div>

    <!-- ── 활동 추가 모달 (전역 1개) ── -->
    <div class="modal" id="activityModal">
        <div class="modal-content">
            <h2>활동 추가</h2>

            <label>시간</label>
            <input type="time" id="newTime">

            <label>제목</label>
            <input type="text" id="newTitle" placeholder="예: 점심 식사">

            <label>설명</label>
            <input type="text" id="newDesc" placeholder="간단 설명">

            <div class="modal-actions">
                <button id="closeModalBtn" type="button">취소</button>
                <button id="addActivityBtn" type="button">추가</button>
            </div>
        </div>
    </div>

    <!-- ── Day 블록 반복 ── -->
    <c:forEach var="item" items="${result.itinerary}" varStatus="dayStatus">

        <div class="day-block">

            <!-- Day 헤더 -->
            <div class="day-block__header">
                <span class="day-block__title">Day ${item.day} · ${item.date}</span>
                <button class="btn-add-activity" type="button"
                        data-list-id="day${item.day}-list">
                    <span>+</span> 활동 추가
                </button>
            </div>

            <!-- 일정 아이템 목록 -->
            <div class="activity-list" id="day${item.day}-list">

                <c:forEach var="act" items="${item.activities}" varStatus="actStatus">

                    <%-- type별 CSS 클래스 분기 --%>
                    <c:choose>
                        <c:when test="${act.type == 'TRANSPORT'}">
                            <c:set var="itemClass" value="activity-item--move"/>
                            <c:set var="iconEmoji" value="🚆"/>
                        </c:when>
                        <c:when test="${act.type == 'DINING'}">
                            <c:set var="itemClass" value="activity-item--food"/>
                            <c:set var="iconEmoji" value="🍽"/>
                        </c:when>
                        <c:when test="${act.type == 'ACCOMMODATION'}">
                            <c:set var="itemClass" value="activity-item--hotel"/>
                            <c:set var="iconEmoji" value="🏨"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="itemClass" value="activity-item--spot"/>
                            <c:set var="iconEmoji" value="📍"/>
                        </c:otherwise>
                    </c:choose>

                    <div class="activity-item ${itemClass}"
                         draggable="true"
                         data-day="${item.day}"
                         data-order="${actStatus.count}"
                         data-type="${act.type}">

                        <div class="activity-item__drag">⋮⋮</div>

                        <div class="activity-item__icon">${iconEmoji}</div>

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
                                        📍 ${fn:escapeXml(act.location)}
                                    </span>
                                </c:if>
                                <c:if test="${act.durationMinutes > 0}">
                                    <span class="meta-tag meta-tag--time">
                                        ⏱ ${act.durationMinutes}분
                                    </span>
                                </c:if>
                                <c:choose>
                                    <c:when test="${act.cost == 0}">
                                        <span class="meta-tag meta-tag--cost">$ 무료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="meta-tag meta-tag--cost">
                                            $ ${act.cost} ${act.currency}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <button class="activity-item__delete" type="button" title="삭제">🗑</button>
                    </div>

                </c:forEach>

            </div>
            <!-- /activity-list -->

            <!-- Day 요약 푸터 -->
            <div class="day-block__footer">
                <span>${fn:escapeXml(item.summary)}</span>
                <span>예상 비용: ${item.estimatedCost} ${item.currency}</span>
            </div>

        </div>
        <!-- /day-block -->

    </c:forEach>

</div>
<!-- /container -->

<script src="${pageContext.request.contextPath}/js/scheduleEdit.js"></script>
<script>
    // ── 저장 ──
    function handleSave() {
        showToast('💾 일정이 저장되었습니다!');
        setTimeout(() => {
            window.location.href = '${pageContext.request.contextPath}/result-page';
        }, 1000);
    }

    // ── 토스트 ──
    function showToast(msg) {
        let toast = document.getElementById('_globalToast');
        if (!toast) {
            toast = document.createElement('div');
            toast.id = '_globalToast';
            toast.style.cssText = [
                'position:fixed', 'bottom:24px', 'left:50%',
                'transform:translateX(-50%) translateY(20px)',
                'background:#1f2937', 'color:#fff',
                'padding:10px 20px', 'border-radius:999px',
                'font-size:13px', 'font-weight:600',
                'opacity:0', 'transition:.3s', 'z-index:9999',
                'pointer-events:none', 'white-space:nowrap'
            ].join(';');
            document.body.appendChild(toast);
        }
        toast.textContent = msg;
        toast.style.opacity = '1';
        toast.style.transform = 'translateX(-50%) translateY(0)';
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transform = 'translateX(-50%) translateY(20px)';
        }, 2000);
    }
</script>
</body>
</html>