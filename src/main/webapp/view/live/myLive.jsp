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
    <h1>Real-time Travel</h1>
    <p>Manage your trip in real-time</p>
    <p id="liveDestinationHint" class="live-muted" style="margin-top:6px;"></p>
</div>

<!-- Real-time tracking card -->
<c:if test="${not empty planDetail}">
    <div class="live-plan-card card-box">
        <div class="plan-header">
            <h2>Real-time Tracking</h2>
            <div class="plan-destination">${planDetail.summary.destination}</div>
        </div>
        <div class="plan-info">
            <div class="plan-details">
                <p><span>4</span> ${planDetail.summary.days} days</p>
                <p><span>1</span> ${planDetail.summary.travelers} people</p>
                <p><span>0</span> ${planDetail.summary.totalEstimatedCost}</p>
            </div>
            <div class="plan-actions">
                <button class="btn-stop-tracking" onclick="stopTracking()">Stop Tracking</button>
            </div>
        </div>
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="live-dashboard-error">${error}</div>
</c:if>

<!-- Daily schedule -->
<c:if test="${not empty planDetail}">
    <div class="schedule">
        <div class="detail-header">
            <h2>Detailed Schedule</h2>
            <div class="total-cost">Total estimated cost: ${planDetail.summary.totalEstimatedCost} ${planDetail.summary.currency}</div>
        </div>

        <!-- Daily repetition -->
        <c:forEach var="item" items="${planDetail.itinerary}">
            <div class="day-card">
                
                <!-- Day header -->
                <div class="day-header">
                    <div class="day-left">
                        <div class="day-badge">D${item.day}</div>
                        <div>
                            <div class="day-title">${item.day} Day</div>
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
                                <c:otherwise>No movement information</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="distance">
                            <c:choose>
                                <c:when test="${item.totalDistanceKm != null && item.totalTravelTimeMinutes != null}">
                                    About <c:out value="${item.totalDistanceKm}" />km · Daily movement about <c:out value="${item.totalTravelTimeMinutes}" /> min
                                </c:when>
                                <c:otherwise>No distance information</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- Activity list -->
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
                                    <div class="icon move">Up</div>
                                </c:when>
                                <c:when test="${activityCategory == 'DINING' or activityCategory == 'FOOD' or activityCategory == 'RESTAURANT'}">
                                    <div class="icon food">Dining</div>
                                </c:when>
                                <c:when test="${activityCategory == 'ACCOMMODATION' or activityCategory == 'HOTEL'}">
                                    <div class="icon hotel">Hotel</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="icon spot">Location</div>
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
                                <span>${act.durationMinutes} min</span>
                                <c:choose>
                                    <c:when test="${act.cost == 0}">
                                        <span>Free</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${act.cost} ${act.currency}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Bottom summary -->
                <div class="day-footer">
                    <span>${item.summary}</span>
                    <span>Estimated cost: ${item.estimatedCost} ${item.currency}</span>
                </div>
            </div>
        </c:forEach>
    </div>
</c:if>

<div id="liveDashboardError" class="live-dashboard-error" style="display:none;"></div>

<div class="realtime-box card-box">

    <div class="time-box">
        <div class="time-top">
            <span class="time-label">Current Time</span>
            <span class="time-display" id="currentTime">-</span>
        </div>
        <div class="time-bottom">
            <span class="date-display" id="currentDate">-</span>
        </div>
    </div>

    <div class="activity-card" id="liveCurrentActivityWrap">
        <div class="activity-header">
            <div class="status-badge"><span class="dot"></span> <span id="liveActivityStatus">-</span></div>
            <div class="time-remaining">Time remaining <strong id="liveRemainingMin">-</strong> min</div>
        </div>

        <h3 class="activity-title" id="liveActivityTitle">Loading...</h3>
        <p class="activity-address" id="liveActivityAddress">-</p>

        <div class="info-grid">
            <div class="info-item">
                <span class="info-label">Start</span>
                <span class="info-value" id="liveActivityStart">-</span>
            </div>
            <div class="info-item">
                <span class="info-label">End</span>
                <span class="info-value" id="liveActivityEnd">-</span>
            </div>
            <div class="info-item">
                <span class="info-label">Crowd Level</span>
                <span class="info-value status-good" id="liveCrowdLabel">-</span>
            </div>
        </div>

        <div class="congestion-banner">
            <div class="banner-icon">Crowd</div>
            <div class="banner-text">
                <strong id="liveCrowdSectionTitle">Real-time Crowd Level</strong>
                <p id="liveCrowdMessage">-</p>
            </div>
        </div>
    </div>
    <div class="next-schedule-box card-box">
        <div class="section-title">
            Next Schedule
        </div>

        <div class="schedule-content">
            <div class="schedule-info">
                <h3 id="liveNextTitle">-</h3>
                <p id="liveNextSummary">-</p>
            </div>
            <button type="button" class="btn-dark" id="liveNextRouteBtn">View Route</button>
        </div>
    </div>

    <div class="nearby-booking-box card-box">
        <div class="section-header">
            <div class="section-title">
                Nearby Photo Spots
            </div>
            <span class="subtitle" id="liveSpotSubtitle">Within 10 minutes walk</span>
        </div>

        <div class="booking-list" id="liveRecommendations">
            <p class="live-muted">Loading...</p>
        </div>
    </div>
    <div class="weather-box card-box">
        <div class="section-title">
            Real-time Weather
        </div>
        <div id="weatherArea">Loading weather...</div>
    </div>

    <div class="traffic-box card-box">
        <div class="section-title">
            Traffic Information
        </div>

        <div class="info-list" id="liveTraffic">
            <p class="live-muted">Loading...</p>
        </div>
    </div>

    <div class="emergency-box card-box">
        <div class="section-title">
            Emergency Contacts
        </div>

        <div class="info-list" id="liveEmergency">
            <p class="live-muted">Loading...</p>
        </div>
    </div>
</div>
</div>

<script type="text/javascript">
    window.LIVE_PLAN_ID = <%= livePlanId %>;
    window.LIVE_CTX = '${pageContext.request.contextPath}';
    window.LIVE_DESTINATION = <%= destJson %>;
    
    function stopTracking() {
        localStorage.removeItem('liveTrackingPlanId');
        window.location.href = window.LIVE_CTX + '/mypage?stopTracking=true';
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        console.log('My Live page loaded');
        console.log('planDetail data:', window.LIVE_PLAN_ID);
    });
</script>
<script src="${pageContext.request.contextPath}/js/live-itinerary-mobile.js"></script>
<script src="${pageContext.request.contextPath}/js/live-modal.js"></script>
<script src="${pageContext.request.contextPath}/js/livePage.js"></script>
