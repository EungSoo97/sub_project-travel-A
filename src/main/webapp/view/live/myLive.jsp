
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
    .live-dashboard-error { padding: 12px 14px; background: #fef2f2; color: #991b1b; border-radius: 8px; margin-bottom: 12px; }
    .live-muted { color: #6b7280; font-size: 0.95rem; }
    .info-value.status-warn { color: #d97706; }
    .info-value.status-bad { color: #dc2626; }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/live.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/live-itinerary-mobile.css" />
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
    <p id="liveDestinationHint" class="live-muted" style="margin-top:6px;"></p>
</div>

<!-- 실시간 트래킹 중인 일정 카드 -->
<c:if test="${not empty planDetail}">
    <div class="live-plan-card card-box">
        <div class="plan-header">
            <h2>🔴 실시간 트래킹 중</h2>
            <div class="plan-destination">${planDetail.summary.destination}</div>
        </div>
        <div class="plan-info">
            <div class="plan-details">
                <p><span>📅</span> ${planDetail.summary.days}일</p>
                <p><span>👥</span> ${planDetail.summary.travelers}명</p>
                <p><span>💰</span> ₩${planDetail.summary.totalEstimatedCost}</p>
            </div>
            <div class="plan-actions">
                <button class="btn-stop-tracking" onclick="stopTracking()">트래킹 중지</button>
            </div>
        </div>
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="live-dashboard-error">${error}</div>
</c:if>

<!-- 일자별 상세 일정 -->
<c:if test="${not empty planDetail}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/live-itinerary.css">
    
    <!-- 디버깅 정보 -->
    <div style="background: #f0f0f0; padding: 10px; margin: 10px 0; border-radius: 5px;">
        <p><strong>디버깅 정보:</strong></p>
        <p>planDetail: ${not empty planDetail ? '존재함' : '없음'}</p>
        <p>planDetail.itinerary: ${not empty planDetail.itinerary ? '존재함' : '없음'}</p>
        <p>itinerary 크기: ${not empty planDetail.itinerary ? fn:length(planDetail.itinerary) : 'N/A'}</p>
        <c:if test="${not empty planDetail.summary}">
            <p>목적지: ${planDetail.summary.destination}</p>
            <p>일수: ${planDetail.summary.days}일</p>
        </c:if>
    </div>
    
    <div class="schedule">
        <div class="detail-header">
            <h2>상세 일정</h2>
            <div class="total-cost">총 예상 비용: ${planDetail.summary.totalEstimatedCost} ${planDetail.summary.currency}</div>
        </div>

        <!-- 일차별 반복 -->
        <c:forEach var="item" items="${planDetail.itinerary}">
            <div class="day-card">
                
                <!-- day header -->
                <div class="day-header">
                    <div class="day-left">
                        <div class="day-badge">D${item.day}</div>
                        <div>
                            <div class="day-title">${item.day}일차</div>
                            <div class="day-date">${item.date}</div>
                        </div>
                    </div>

                    <div class="day-right">
                        <span class="transport">
                            <c:choose>
                                <c:when test="${not empty item.dayRoute && not empty item.dayRoute.routePreferenceLabelKo}">
                                    <c:out value="${item.dayRoute.routePreferenceLabelKo}" />
                                </c:when>
                                <c:when test="${not empty item.transportation}">
                                    <c:out value="${item.transportation}" />
                                </c:when>
                                <c:otherwise>이동 정보 없음</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="distance">
                            <c:choose>
                                <c:when test="${item.totalDistanceKm != null && item.totalTravelTimeMinutes != null}">
                                    약 <c:out value="${item.totalDistanceKm}" />km · 당일 이동 약 <c:out value="${item.totalTravelTimeMinutes}" />분
                                </c:when>
                                <c:otherwise>거리 정보 없음</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- 활동 목록 -->
                <div class="time-section">
                    <c:forEach var="act" items="${item.activities}" varStatus="activityStatus">
                        <div
                            class="item schedule-item"
                            data-day="${item.day}"
                            data-order="${activityStatus.count}"
                            data-name="${fn:escapeXml(act.name)}"
                            data-category="${fn:escapeXml(empty act.categoryCode ? act.category : act.categoryCode)}"
                            data-lat="${act.lat}"
                            data-lng="${act.lng}"
                            data-time="${fn:escapeXml(act.time)}"
                            data-is-new="${(empty act.lat || empty act.lng) ? 'true' : 'false'}">
                            
                            <c:set var="activityCategory" value="${fn:toUpperCase(not empty act.categoryCode ? act.categoryCode : (not empty act.category ? act.category : act.type))}" />
                            
                            <c:choose>
                                <c:when test="${activityCategory == 'TRANSPORT' or activityCategory == 'MOVE'}">
                                    <div class="icon move">▲</div>
                                </c:when>
                                <c:when test="${activityCategory == 'DINING' or activityCategory == 'FOOD' or activityCategory == 'RESTAURANT'}">
                                    <div class="icon food">🍽</div>
                                </c:when>
                                <c:when test="${activityCategory == 'ACCOMMODATION' or activityCategory == 'HOTEL'}">
                                    <div class="icon hotel">🏨</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="icon spot">📍</div>
                                </c:otherwise>
                            </c:choose>

                            <div class="content">
                                <div class="top">
                                    <span class="time">${act.time}</span>
                                    <span class="title">${act.name}</span>
                                </div>
                                <div class="desc">${act.description}</div>
                            </div>

                            <div class="meta">
                                <span>${act.durationMinutes}분</span>
                                <c:choose>
                                    <c:when test="${act.cost == 0}">
                                        <span>무료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${act.cost} ${act.currency}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 하단 요약 -->
                <div class="day-footer">
                    <span>${item.summary}</span>
                    <span>예상 비용: ${item.estimatedCost} ${item.currency}</span>
                </div>
            </div>
        </c:forEach>
    </div>
</c:if>

<div id="liveDashboardError" class="live-dashboard-error" style="display:none;"></div>

<div class="realtime-box card-box">

    <div class="time-box">
        <div class="time-top">
            <span class="time-label">🕒 현재 시각</span>
            <span class="time-display" id="currentTime">—</span>
        </div>
        <div class="time-bottom">
            <span class="date-display" id="currentDate">—</span>
        </div>
    </div>

    <div class="activity-card" id="liveCurrentActivityWrap">
        <div class="activity-header">
            <div class="status-badge"><span class="dot"></span> <span id="liveActivityStatus">—</span></div>
            <div class="time-remaining">남은 시간 <strong id="liveRemainingMin">—</strong>분</div>
        </div>

        <h3 class="activity-title" id="liveActivityTitle">불러오는 중…</h3>
        <p class="activity-address" id="liveActivityAddress">📍 —</p>

        <div class="info-grid">
            <div class="info-item">
                <span class="info-label">시작</span>
                <span class="info-value" id="liveActivityStart">—</span>
            </div>
            <div class="info-item">
                <span class="info-label">종료</span>
                <span class="info-value" id="liveActivityEnd">—</span>
            </div>
            <div class="info-item">
                <span class="info-label">혼잡도</span>
                <span class="info-value status-good" id="liveCrowdLabel">—</span>
            </div>
        </div>

        <div class="congestion-banner">
            <div class="banner-icon">👥</div>
            <div class="banner-text">
                <strong id="liveCrowdSectionTitle">실시간 혼잡도</strong>
                <p id="liveCrowdMessage">—</p>
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
                <h3 id="liveNextTitle">—</h3>
                <p id="liveNextSummary">—</p>
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
            <span class="subtitle" id="liveSpotSubtitle">도보 10분 이내</span>
        </div>

        <div class="booking-list" id="liveRecommendations">
            <p class="live-muted">불러오는 중…</p>
        </div>
    </div>
    <div class="weather-box card-box">
        <div class="section-title">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"></path></svg>
            실시간 날씨
        </div>
        <div id="weatherArea">날씨 불러오는 중...</div>
    </div>

    <div class="traffic-box card-box">
        <div class="section-title">
            교통 상황
        </div>

        <div class="info-list" id="liveTraffic">
            <p class="live-muted">불러오는 중…</p>
        </div>
    </div>

    <div class="emergency-box card-box">
        <div class="section-title">
            긴급 연락처
        </div>

        <div class="info-list" id="liveEmergency">
            <p class="live-muted">불러오는 중…</p>
        </div>
    </div>
</div>
</div>

<script type="text/javascript">
    window.LIVE_PLAN_ID = <%= livePlanId %>;
    window.LIVE_CTX = '${pageContext.request.contextPath}';
    window.LIVE_DESTINATION = <%= destJson %>;
    
    // 일자별 접었다 펼쳐지는 기능
    let allDaysExpanded = true;
    
    function toggleDay(dayNum) {
        const dayContent = document.getElementById(`day-${dayNum}`);
        const toggleIcon = document.querySelector(`[data-day="${dayNum}"] .toggle-icon`);
        
        // null 체크 추가
        if (!dayContent || !toggleIcon) {
            console.log(`toggleDay: day-${dayNum} 요소를 찾을 수 없음`);
            return;
        }
        
        if (dayContent.style.display === 'none') {
            dayContent.style.display = 'block';
            toggleIcon.textContent = '▼';
        } else {
            dayContent.style.display = 'none';
            toggleIcon.textContent = '▶';
        }
    }
    
    function toggleAllDays() {
        const allDayContents = document.querySelectorAll('.day-content');
        const allToggleIcons = document.querySelectorAll('.toggle-icon');
        const toggleBtn = document.querySelector('.toggle-all');
        
        // null 체크 추가
        if (!allDayContents || !allToggleIcons || !toggleBtn) {
            console.log('toggleAllDays: DOM 요소를 찾을 수 없음');
            return;
        }
        
        if (allDaysExpanded) {
            // 모두 접기
            allDayContents.forEach(content => {
                if (content) {
                    content.style.display = 'none';
                }
            });
            allToggleIcons.forEach(icon => {
                if (icon) {
                    icon.textContent = '▶';
                }
            });
            toggleBtn.textContent = '모두 펼치기';
            allDaysExpanded = false;
        } else {
            // 모두 펼치기
            allDayContents.forEach(content => {
                if (content) {
                    content.style.display = 'block';
                }
            });
            allToggleIcons.forEach(icon => {
                if (icon) {
                    icon.textContent = '▼';
                }
            });
            toggleBtn.textContent = '모두 접기';
            allDaysExpanded = true;
        }
    }
    
    function stopTracking() {
        // Clear tracking state from localStorage
        localStorage.removeItem('liveTrackingPlanId');
        
        // Redirect to mypage with stop tracking parameter
        window.location.href = window.LIVE_CTX + '/mypage?stopTracking=true';
    }
    
    // 페이지 로드 시 초기 상태 설정
    document.addEventListener('DOMContentLoaded', function() {
        console.log('마이 라이브 페이지 로드됨');
        console.log('planDetail 데이터:', window.LIVE_PLAN_ID);
        
        // 약간의 지연 후 실행하여 DOM이 완전히 로드된 것을 보장
        setTimeout(function() {
            console.log('setTimeout 실행됨');
            
            // 일자별 일정은 기본적으로 접어있도록 설정
            allDaysExpanded = false;
            toggleAllDays();
            
            // day-content 초기 스타일 설정 (접어있는 상태)
            const dayContents = document.querySelectorAll('.day-content');
            console.log('찾은 day-content 개수:', dayContents.length);
            dayContents.forEach(content => {
                content.style.display = 'none';
            });
            
            // toggle-icon 초기 설정
            const toggleIcons = document.querySelectorAll('.toggle-icon');
            console.log('찾은 toggle-icon 개수:', toggleIcons.length);
            toggleIcons.forEach(icon => {
                icon.textContent = '▶';
            });
            
            // toggle-all 버튼 텍스트 초기 설정
            const toggleBtn = document.querySelector('.toggle-all');
            if (toggleBtn) {
                toggleBtn.textContent = '모두 펼치기';
            }
            
            console.log('초기화 완료');
        }, 100); // 100ms 지연
    });
</script>
<script src="${pageContext.request.contextPath}/js/live-itinerary-mobile.js"></script>
<script src="${pageContext.request.contextPath}/js/livePage.js"></script>
