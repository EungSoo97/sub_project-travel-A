<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
    .live-dashboard-error { padding: 12px 14px; background: #fef2f2; color: #991b1b; border-radius: 8px; margin-bottom: 12px; }
    .live-muted { color: #6b7280; font-size: 0.95rem; }
    .info-value.status-warn { color: #d97706; }
    .info-value.status-bad { color: #dc2626; }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/live-unified.css" />
<%
    String planParam = request.getParameter("planId");
    int livePlanId = 1;
    if (planParam != null) {
        try {
            livePlanId = Integer.parseInt(planParam.trim());
            if (livePlanId < 1) livePlanId = 1;
        } catch (NumberFormatException ignored) { }
    }
    String destParam = request.getParameter("destination");
    String destJson;
    if (destParam == null || destParam.isBlank()) {
        destJson = "null";
    } else {
        String e = destParam.trim().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
        destJson = "\"" + e + "\"";
    }
%>
<div class="live-page" data-context-path="${pageContext.request.contextPath}" data-plan-id="<%= livePlanId %>">

    <div class="live-header">
        <h1>실시간 여행</h1>
        <p>지금 이 순간의 여행을 실시간으로 관리하세요</p>
    </div>

    <!-- Real-time tracking card -->
    <c:if test="${not empty planDetail}">
        <%--    <p id="liveDestinationHint" class="live-muted" style="margin-top:6px; text-align:center;">-</p>--%>
        <br>
        <div class="live-plan-card card-box" id="livePlanCard">
            <!-- 헤더: 항상 표시, 클릭 시 아코디언 토글 -->
            <div class="live-card-header" onclick="toggleLivePlanCard()">
                <div class="live-status-badge">
                    <div class="live-pulse-wrapper">
                        <span class="live-pulse-ring"></span>
                        <span class="live-pulse-dot"></span>
                    </div>
                    <span class="live-badge-label">실시간 트래킹 중</span>
                </div>
                <span class="live-card-dest">${planDetail.summary.destination}</span>
                <!-- 접혔을 때만 표시되는 간략 정보 -->
                <div class="live-card-mini-info">
                    <span>📅 ${planDetail.summary.days}</span>
                    <span>👥 ${planDetail.summary.travelers}</span>
                </div>
                <div class="live-card-chevron">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                         stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="6 9 12 15 18 9"/>
                    </svg>
                </div>
            </div>
            <!-- 바디: 접기/펼치기 -->
            <div class="live-card-body">
                <div class="live-plan-meta">
                    <span class="live-meta-chip">📅 ${planDetail.summary.days}일</span>
                    <span class="live-meta-chip">👥 ${planDetail.summary.travelers}명</span>
                    <span class="live-meta-chip">💰 ${planDetail.summary.totalEstimatedCost} KRW</span>
                </div>
                <button class="btn-stop-tracking" onclick="event.stopPropagation(); stopTracking();">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
                        <rect x="4" y="4" width="16" height="16" rx="2"/>
                    </svg>
                    트래킹 중지
                </button>
            </div>
        </div>

        <!-- 카드가 스크롤 아웃 시 우측 하단에 나타나는 플로팅 중지 버튼 -->
        <button class="float-stop-btn" id="floatStopBtn" onclick="stopTracking()">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                <rect x="4" y="4" width="16" height="16" rx="2"/>
            </svg>
            트래킹 중지
        </button>
    </c:if>

    <c:if test="${not empty error}">
        <div class="live-dashboard-error">${error}</div>
    </c:if>

    <!-- Full detailed schedule button -->
    <c:if test="${not empty planDetail}">
        <div class="schedule-trigger-box card-box" onclick="openFullScheduleModal()">
            <div class="sched-icon-wrap">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                    <line x1="16" y1="2" x2="16" y2="6"/>
                    <line x1="8" y1="2" x2="8" y2="6"/>
                    <line x1="3" y1="10" x2="21" y2="10"/>
                </svg>
            </div>
            <div class="sched-text-wrap">
                <h3 class="sched-title">상세 일정 확인하기</h3>
                <p class="sched-subtitle">일자별 상세 일정 및 여행 동선 보기</p>
            </div>
            <div class="sched-arrow-wrap">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 18 15 12 9 6"/>
                </svg>
            </div>
        </div>
    </c:if>

    <div id="liveDashboardError" class="live-dashboard-error" style="display:none;"></div>

    <div class="realtime-box card-box">

        <div class="time-box">
            <div class="time-top">
                <span class="time-label">🕒 현재 시각</span>
                <span class="time-display" id="currentTime">-</span>
            </div>
            <div class="time-bottom">
                <span class="date-display" id="currentDate">-</span>
            </div>
        </div>

        <div class="activity-card" id="liveCurrentActivityWrap">
            <div class="activity-header">
                <div class="status-badge"><span class="dot"></span> <span id="liveActivityStatus">-</span></div>
                <div class="time-remaining">남은 시간 <strong id="liveRemainingMin">-</strong> 분</div>
            </div>

            <h3 class="activity-title" id="liveActivityTitle">로딩중...</h3>
            <p class="activity-address" id="liveActivityAddress">-</p>

            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">시작</span>
                    <span class="info-value" id="liveActivityStart">-</span>
                </div>
                <div class="info-item">
                    <span class="info-label">종료</span>
                    <span class="info-value" id="liveActivityEnd">-</span>
                </div>
                <div class="info-item">
                    <span class="info-label">혼잡도</span>
                    <span class="info-value status-good" id="liveCrowdLabel">-</span>
                </div>
            </div>

            <div class="congestion-banner">
                <div class="banner-icon">👥</div>
                <div class="banner-text">
                    <strong id="liveCrowdSectionTitle">실시간 혼잡도</strong>
                    <p id="liveCrowdMessage">-</p>
                </div>
            </div>
        </div>
        <div class="next-schedule-box card-box">
            <div class="section-title">
                다음 일정
            </div>

            <div class="schedule-content">
                <div class="schedule-info">
                    <h3 id="liveNextTitle">-</h3>
                    <p id="liveNextSummary">-</p>
                </div>
                <button type="button" class="btn-dark" id="liveNextRouteBtn">경로 보기</button>
            </div>
        </div>

        <div class="nearby-booking-box card-box">
            <div class="section-header">
                <div class="section-title">
                    📷 주변 인생샷 스폿
                </div>
                <span class="subtitle" id="liveSpotSubtitle">도보 10분 이내</span>
            </div>

            <div class="booking-list" id="liveRecommendations">
                <p class="live-muted">로딩중...</p>
            </div>
        </div>
        <div class="weather-box card-box">
            <div class="section-title">
                실시간 날씨
            </div>
            <div id="weatherArea">날씨 로딩중...</div>
        </div>

        <div class="traffic-box card-box">
            <div class="section-title">
                교통 상황
            </div>

            <div class="info-list" id="liveTraffic">
                <p class="live-muted">로딩중...</p>
            </div>
        </div>

        <div class="emergency-box card-box">
            <div class="section-title">
                긴급 연락처
            </div>

            <div class="info-list" id="liveEmergency">
                <p class="live-muted">로딩중...</p>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    window.LIVE_PLAN_ID = <%= livePlanId %>;
    window.LIVE_CTX = '${pageContext.request.contextPath}';
    window.LIVE_DESTINATION = <%= destJson %>;

    // Add planDetail data for modal use
    <c:if test="${not empty planDetail}">
    window.PLAN_DETAIL = {
        summary: {
            destination: '${planDetail.summary.destination}',
            days: '${planDetail.summary.days}',
            travelers: '${planDetail.summary.travelers}',
            totalEstimatedCost: '${planDetail.summary.totalEstimatedCost}',
            currency: '${planDetail.summary.currency}'
        },
        itinerary: [
            <c:forEach var="item" items="${planDetail.itinerary}" varStatus="status">
            {
                day: ${item.day},
                date: '${item.date}',
                summary: '${item.summary}',
                estimatedCost: '${item.estimatedCost}',
                currency: '${item.currency}',
                activities: [
                    <c:forEach var="act" items="${item.activities}" varStatus="actStatus">
                    {
                        time: '${act.time}',
                        name: '${fn:escapeXml(act.name)}',
                        description: '${fn:escapeXml(act.description)}',
                        durationMinutes: '${act.durationMinutes}',
                        cost: '${act.cost}',
                        currency: '${act.currency}',
                        lat: '${act.lat}',
                        lng: '${act.lng}',
                        category: '${fn:escapeXml(empty act.categoryCode ? act.category : act.categoryCode)}'
                    }<c:if test="${not actStatus.last}">,</c:if>
                    </c:forEach>
                ]
            }<c:if test="${not status.last}">,</c:if>
            </c:forEach>
        ]
    };
    </c:if>

    function toggleLivePlanCard() {
        document.getElementById('livePlanCard').classList.toggle('expanded');
    }

    function stopTracking() {
        localStorage.removeItem('liveTrackingPlanId');
        window.location.href = window.LIVE_CTX + '/mypage?stopTracking=true';
    }

    document.addEventListener('DOMContentLoaded', function() {
        // 트래킹 카드가 뷰포트에서 사라지면 플로팅 중지 버튼 표시
        const livePlanCard  = document.getElementById('livePlanCard');
        const floatStopBtn  = document.getElementById('floatStopBtn');
        if (livePlanCard && floatStopBtn) {
            const cardObserver = new IntersectionObserver(
                ([entry]) => {
                    floatStopBtn.classList.toggle('visible', !entry.isIntersecting);
                },
                { threshold: 0 }
            );
            cardObserver.observe(livePlanCard);
        }
    });
</script>
<script src="${pageContext.request.contextPath}/js/live-itinerary-mobile.js"></script>
<script src="${pageContext.request.contextPath}/js/live-modal.js"></script>
<script src="${pageContext.request.contextPath}/js/livePage.js"></script>
