<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .live-dashboard-error { padding: 12px 14px; background: #fef2f2; color: #991b1b; border-radius: 8px; margin-bottom: 12px; }
    .live-muted { color: #6b7280; font-size: 0.95rem; }
    .info-value.status-warn { color: #d97706; }
    .info-value.status-bad { color: #dc2626; }
</style>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/live.css" />

<c:if test="${empty selectedPlan}">
    <script>
        location.href='${pageContext.request.contextPath}/live-select';
    </script>
</c:if>

<div class="live-page"
     data-context-path="${pageContext.request.contextPath}"
     data-plan-id="${selectedPlan.planId}">

    <div class="live-header">
        <h1>실시간 여행</h1>
        <p>지금 이 순간의 여행을 실시간으로 관리하세요</p>
        <p id="liveDestinationHint" class="live-muted" style="margin-top:6px;">
            목적지: ${selectedPlan.destination}
        </p>
    </div>

    <div id="liveDashboardError" class="live-dashboard-error" style="display:none;"></div>

    <div class="realtime-box card-box">

        <div class="time-box">
            <div class="time-top">
                <span class="time-label"><i class="fa-regular fa-clock"></i> 현재 시각</span>
                <span class="time-display" id="currentTime">—</span>
            </div>
            <div class="time-bottom">
                <span class="date-display" id="currentDate">—</span>
            </div>
        </div>

        <div class="activity-card" id="liveCurrentActivityWrap">
            <div class="activity-header">
                <div class="status-badge">
                    <span class="dot"></span>
                    <span id="liveActivityStatus">${selectedPlan.status}</span>
                </div>
                <div class="time-remaining">남은 시간 <strong id="liveRemainingMin">—</strong>분</div>
            </div>

            <h3 class="activity-title" id="liveActivityTitle">${selectedPlan.displayTitle}</h3>

            <p class="activity-address" id="liveActivityAddress">
                <c:choose>
                    <c:when test="${not empty selectedPlan.overview}">
                        ${selectedPlan.overview}
                    </c:when>
                    <c:otherwise>
                        <i class="fa-solid fa-location-dot"></i> ] ${selectedPlan.destination}
                    </c:otherwise>
                </c:choose>
            </p>

            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">시작</span>
                    <span class="info-value" id="liveActivityStart">
                        <c:choose>
                            <c:when test="${not empty selectedPlan.startDate}">${selectedPlan.startDate}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">종료</span>
                    <span class="info-value" id="liveActivityEnd">
                        <c:choose>
                            <c:when test="${not empty selectedPlan.endDate}">${selectedPlan.endDate}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">혼잡도</span>
                    <span class="info-value status-good" id="liveCrowdLabel">보통</span>
                </div>
            </div>

            <div class="congestion-banner">
                <div class="banner-icon"><i class="fa-solid fa-user-group"></i></div>
                <div class="banner-text">
                    <strong id="liveCrowdSectionTitle">실시간 혼잡도</strong>
                    <p id="liveCrowdMessage">${selectedPlan.destination} 기준 정보를 불러오는 중입니다.</p>
                </div>
            </div>
        </div>

        <div class="next-schedule-box card-box">
            <div class="section-title">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                다음 일정
            </div>

            <div class="schedule-content">
                <div class="schedule-info">
                    <h3 id="liveNextTitle">${selectedPlan.displayTitle}</h3>
                    <p id="liveNextSummary">
                        <c:choose>
                            <c:when test="${not empty selectedPlan.startDate and not empty selectedPlan.endDate}">
                                ${selectedPlan.startDate} ~ ${selectedPlan.endDate}
                            </c:when>
                            <c:otherwise>
                                ${selectedPlan.destination}
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <button type="button" class="btn-dark" id="liveNextRouteBtn">경로 보기</button>
            </div>
        </div>

        <div class="nearby-booking-box card-box">
            <div class="section-header">
                <div class="section-title">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path><circle cx="12" cy="13" r="4"></circle></svg>
                    주변 인생샷 스폿
                </div>
                <span class="subtitle" id="liveSpotSubtitle">${selectedPlan.destination}</span>
            </div>

            <div class="booking-list" id="liveRecommendations">
                <p class="live-muted">${selectedPlan.destination} 주변 추천 장소를 불러오는 중…</p>
            </div>
        </div>

        <div class="weather-box card-box">
            <div class="section-title">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"></path></svg>
                실시간 날씨
            </div>
            <div id="weatherArea">${selectedPlan.destination} 날씨 불러오는 중...</div>
        </div>

        <div class="traffic-box card-box">
            <div class="section-title">
                <i class="fa-solid fa-car"></i>교통 상황
            </div>

            <div class="info-list" id="liveTraffic">
                <p class="live-muted">${selectedPlan.destination} 교통 정보를 불러오는 중…</p>
            </div>
        </div>

        <div class="emergency-box card-box">
            <div class="section-title">
                <i class="fa-solid fa-phone"></i>긴급 연락처
            </div>

            <div class="info-list" id="liveEmergency">
                <p class="live-muted">현지 긴급 연락처를 불러오는 중…</p>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    window.LIVE_PLAN_ID = ${selectedPlan.planId};
    window.LIVE_CTX = '${pageContext.request.contextPath}';
    window.LIVE_DESTINATION = '${selectedPlan.destination}';
</script>
<script src="${pageContext.request.contextPath}/js/livePage.js"></script>