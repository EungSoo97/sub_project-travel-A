<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.es.ta.account.AccountDTO" %>
<%
    AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
    boolean isLoggedIn = (user != null);
    pageContext.setAttribute("isLoggedIn", isLoggedIn);
    pageContext.setAttribute("currentUserId", isLoggedIn ? user.getUser_id() : 0);
%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/result-page.css" />

<c:choose>
    <c:when test="${empty plan}">
        <section class="detail-container">
            <div class="day-card" style="padding:24px;">
                <h2>여행 계획을 불러오지 못했습니다.</h2>
                <p>잠시 후 다시 시도해주세요.</p>
                <button type="button" onclick="location.href='${pageContext.request.contextPath}/mypage'">마이페이지로 돌아가기</button>
            </div>
        </section>
    </c:when>
    <c:otherwise>
        <div class="result-page mp-page detail-page-shell">
            <div class="container-result mp-container detail-page-container">

                <div class="mp-header">
                    <div class="mp-header-topbar">
                        <a class="mp-back-link" href="${pageContext.request.contextPath}/explore">
                            <i class="fa-solid fa-arrow-left"></i> 목록으로 돌아가기
                        </a>
                        <button type="button" class="header-collapse-toggle" aria-expanded="true" aria-label="상단 정보 접기">
                            <span class="header-collapse-symbol">−</span>
                        </button>
                    </div>

                    <div class="mp-title-area detail-title-area">
                        <div class="detail-title-row">
                            <div class="detail-title-text">
                                <h1 class="mp-title">
                                    ${empty plan.summary.title ? plan.summary.destination : plan.summary.title}
                                </h1>
                                <p class="mp-sub">
                                    ${plan.summary.destination} · ${plan.summary.days}일 여행
                                </p>
                            </div>

                            <button type="button" class="dp-review-link-btn" id="dpOpenModalBtn">
                                후기 <span class="dp-review-link-count">${fn:length(reviews)}</span>
                            </button>

                        </div>

                        <div class="detail-title-divider"></div>
                        <div class="detail-plan-meta plan-creator-meta">
                            <span class="plan-creator-pill"><i class="fa-regular fa-user"></i>
                                <c:out value="${empty sourcePlan.creatorName ? '여행자' : sourcePlan.creatorName}" />
                            </span>
                            <c:if test="${not empty sourcePlan.editorName and sourcePlan.editorName ne sourcePlan.creatorName}">
                                <span class="plan-editor-pill"><i class="fa-solid fa-pen"></i>
                                    <c:out value="${sourcePlan.editorName}" />
                                </span>
                            </c:if>
                            <span class="plan-like-pill"><i class="fa-solid fa-heart"></i> ${plan.likeCnt}</span>
                        </div>
                    </div>

                    <div class="actions">
                        <c:choose>
                            <c:when test="${isLoggedIn}">
                                <button
                                    type="button"
                                    class="action-btn icon-btn ${liked ? 'is-heart' : ''}"
                                    onclick="toggleHeart(this, ${plan.planId})">
                                    ${liked ? '♥' : '♡'}
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button
                                    type="button"
                                    class="action-btn icon-btn"
                                    onclick="showLoginAlert()">
                                    ♡
                                </button>
                            </c:otherwise>
                        </c:choose>

                        <button type="button" class="action-btn icon-btn" onclick="copyUrl()"><i class="fa-solid fa-link"></i></button>

                        <form action="${pageContext.request.contextPath}/pdf" method="get">
                            <input type="hidden" name="planId" value="${plan.planId}">
                            <button type="submit" class="action-btn download-btn">PDF</button>
                        </form>

                        <c:choose>
                            <c:when test="${canSavePlan}">
                                <form action="${pageContext.request.contextPath}/save-plan" method="post">
                                    <input type="hidden" name="sourcePlanId" value="${plan.planId}">
                                    <button type="submit" class="action-btn edit-btn">저장</button>
                                </form>
                            </c:when>
                            <c:when test="${alreadySavedPlan}">
                                <button type="button" class="action-btn saved-plan-btn" disabled>저장됨</button>
                            </c:when>
                            <c:when test="${not isLoggedIn and isPostedPlan}">
                                <button type="button" class="action-btn edit-btn" onclick="showLoginAlert()">저장</button>
                            </c:when>
                        </c:choose>

                    </div>
                </div>

                <div id="dpSnackbar" class="dp-snackbar"></div>

                <div id="dpReviewModal" class="dp-modal">
                    <div class="dp-modal-content">
                        <div class="dp-modal-header">
                            <h2>후기 작성</h2>
                            <button type="button" class="dp-modal-close" id="dpCloseModalBtn">&times;</button>
                        </div>

                        <form action="${pageContext.request.contextPath}/review" method="post">
                            <input type="hidden" name="planId" value="${plan.planId}">
                            <textarea class="dp-textarea" name="content" rows="5" placeholder="여행 후기를 작성해주세요"></textarea>
                            <button class="dp-submit-btn" type="submit">작성 완료</button>
                        </form>
                    </div>
                </div>

                <div class="mp-summary-grid">
                    <div class="mp-summary-card mp-summary-card--full">
                        <p class="mp-summary-label"><span class="mp-label-icon"><i class="fa-regular fa-calendar"></i></span>여행 기간</p>
                        <p class="mp-summary-value">${plan.summary.startDate} ~ ${plan.summary.endDate}</p>
                    </div>

                    <div class="mp-summary-card">
                        <p class="mp-summary-label"><span class="mp-label-icon"><i class="fa-solid fa-user-group"></i></span>여행 인원</p>
                        <p class="mp-summary-value">${plan.summary.travelers}명</p>
                    </div>

                    <div class="mp-summary-card">
                        <p class="mp-summary-label"><span class="mp-label-icon"><i class="fa-solid fa-bullseye"></i></span>여행 스타일</p>
                        <p class="mp-summary-value">${plan.summary.travelStyle}</p>
                    </div>
                </div>

                <div class="map-section">
                        <div class="map-header" role="button" tabindex="0" aria-expanded="true">
                            <span class="map-title"><span class="mp-inline-icon"><i class="fa-regular fa-map"></i></span>여행 동선 지도</span>
                            <span class="map-toggle-indicator map-toggle-label">지도 접기</span>
                            <div class="legend">
                                <span class="dot blue"></span> 관광지
                                <span class="dot orange"></span> 식당
                                <span class="dot purple"></span> 숙소
                            </div>
                        </div>

                        <div class="map-area">
                            <div
                                id="travelMap"
                                class="travel-map"
                                data-google-maps-api-key="${googleMapsApiKey}"
                                data-google-maps-map-id="${googleMapsMapId}">
                            </div>
                            <div id="mapFallbackMessage" class="map-fallback-message">
                                Google Maps API Key와 Map ID를 연결하면 여행 동선을 지도에서 확인할 수 있습니다.
                            </div>
                        </div>

                        <div class="map-toolbar">
                            <div class="day-filter" id="dayFilter">
                                <c:forEach var="item" items="${plan.itinerary}" varStatus="status">
                                    <button
                                        type="button"
                                        class="day-filter-button<c:if test='${status.first}'> active</c:if>"
                                        data-day="${item.day}">
                                        Day ${item.day}
                                    </button>
                                </c:forEach>
                            </div>
                        </div>
                </div>

                <div class="schedule">
                    <c:forEach var="item" items="${plan.itinerary}">
                        <div class="day">
                            <h3>${item.day}일차 <span>(${fn:length(item.activities)}개 장소)</span></h3>
                            <p class="route">
                                <c:forEach var="act" items="${item.activities}" varStatus="status">
                                    ● ${act.name}<c:if test="${!status.last}"> → </c:if>
                                </c:forEach>
                            </p>
                        </div>
                    </c:forEach>
                </div>

                <div class="detail-container">

                    <div class="detail-header">
                        <h2>상세 일정</h2>
                        <div class="total-cost">총 예상 비용: ${plan.summary.totalEstimatedCost} ${plan.summary.currency}</div>
                    </div>

                    <c:forEach var="item" items="${plan.itinerary}" varStatus="dayStatus">
                        <div class="day-card">
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
                                            <c:when test="${not empty item.transportation}">
                                                <c:out value="${item.transportation}" />
                                            </c:when>
                                            <c:otherwise>이동 정보 없음</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="distance">
                                        <c:choose>
                                            <c:when test="${item.totalDistanceKm != null and item.totalTravelTimeMinutes != null}">
                                                총 <c:out value="${item.totalDistanceKm}" />km · 당일 이동 약 <c:out value="${item.totalTravelTimeMinutes}" />분
                                            </c:when>
                                            <c:otherwise>거리 정보 없음</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>

                            <div class="time-section">
                                <c:forEach var="act" items="${item.activities}" varStatus="activityStatus">
                                    <c:set var="activityCategory" value="${fn:toUpperCase(not empty act.categoryCode ? act.categoryCode : (not empty act.category ? act.category : act.type))}" />
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

                                        <c:choose>
                                            <c:when test="${activityCategory == 'TRANSPORT' or activityCategory == 'MOVE'}">
                                                <div class="icon move"><i class="fa-solid fa-car"></i></div>
                                            </c:when>
                                            <c:when test="${activityCategory == 'DINING' or activityCategory == 'FOOD' or activityCategory == 'RESTAURANT'}">
                                                <div class="icon food"><i class="fa-solid fa-utensils"></i></div>
                                            </c:when>
                                            <c:when test="${activityCategory == 'ACCOMMODATION' or activityCategory == 'HOTEL'}">
                                                <div class="icon hotel"><i class="fa-solid fa-hotel"></i></div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="icon spot"><i class="fa-solid fa-location-dot"></i></div>
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
                                                    <span>${act.cost} ${empty act.currency ? plan.summary.currency : act.currency}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <div class="day-footer">
                                <span>${empty item.summary ? '하루 일정 요약' : item.summary}</span>
                                <span>예상 비용: ${item.estimatedCost} ${empty item.currency ? plan.summary.currency : item.currency}</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="recommend-section">
                    <h2>추천 항공/호텔</h2>

                    <div class="recommend-grid">
                        <div class="recommend-card">
                            <h3><i class="fa-solid fa-plane"></i> 저가 항공권 최저가</h3>
                            <c:choose>
                                <c:when test="${empty plan.flights}">
                                    <p>항공권 정보를 불러오지 못했습니다.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="flight" items="${plan.flights}">
                                        <div class="recommend-item">
                                            <div class="left">
                                                <div class="title">${flight.airline} ${flight.flightNumber}</div>
                                                <div class="desc">${flight.departureAirport} → ${flight.arrivalAirport}</div>
                                            </div>
                                            <div class="right">
                                                <div class="price">${flight.price} ${empty flight.currency ? plan.summary.currency : flight.currency}</div>
                                                <div class="sub">항공 1인</div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="recommend-card">
                            <h3><i class="fa-solid fa-hotel"></i> 숙박 추천</h3>
                            <c:choose>
                                <c:when test="${empty plan.hotels}">
                                    <p>숙박 정보를 불러오지 못했습니다.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="hotel" items="${plan.hotels}">
                                        <div class="recommend-item">
                                            <div class="left">
                                                <div class="title">${hotel.name}</div>
                                                <div class="desc">⭐ ${hotel.rating} · ${hotel.location}</div>
                                            </div>
                                            <div class="right">
                                                <div class="price">${hotel.pricePerNight} ${hotel.currency}</div>
                                                <div class="sub">1박</div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="dpPlanBackdrop" class="dp-sheet-backdrop" onclick="closePlanSheet()"></div>

        <div id="dpPlanSheet" class="dp-sheet" role="dialog" aria-modal="true" aria-labelledby="dpPlanSheetTitle">
            <div class="dp-sheet-handle-wrap">
                <div class="dp-sheet-handle"></div>
            </div>

            <div class="dp-sheet-head">
                <div>
                    <p id="dpPlanSheetTitle" class="dp-sheet-title">여행 후기</p>
                    <p class="dp-sheet-sub">${plan.summary.destination} 여행 후기 모음</p>
                </div>

                <button class="dp-sheet-close" onclick="closePlanSheet()" aria-label="닫기">
                    <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                        <path d="M1 1l12 12M13 1L1 13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
                    </svg>
                </button>
            </div>

            <div class="dp-sheet-body">
                <div class="dp-review-compose">
                    <div class="dp-review-compose-head">
                        <span class="dp-review-compose-avatar">+</span>
                        <div>
                            <p class="dp-review-compose-title">후기 남기기</p>
                            <p class="dp-review-compose-sub">이 여행을 다녀온 느낌을 남겨주세요.</p>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${isLoggedIn}">
                            <form class="dp-review-compose-form" action="${pageContext.request.contextPath}/review" method="post">
                                <input type="hidden" name="planId" value="${plan.planId}">
                                <textarea class="dp-review-compose-textarea" name="content" rows="2" placeholder="후기를 작성해주세요."></textarea>
                                <div class="dp-review-compose-actions">
                                    <span>삭제 전까지 계속 보관됩니다.</span>
                                    <button class="dp-review-compose-submit" type="submit">등록</button>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="dp-review-compose-login">
                                <span>로그인 후 후기를 남길 수 있습니다.</span>
                                <button type="button" onclick="goLoginWithReturn()">로그인</button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:choose>
                    <c:when test="${empty reviews}">
                        <p class="mp-empty-text">아직 작성된 후기가 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviews}">
                            <c:set var="reviewProfileImg" value="${pageContext.request.contextPath}/img/profile/default.png" />
                            <c:if test="${not empty review.profileImg}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(review.profileImg, 'http://') or fn:startsWith(review.profileImg, 'https://')}">
                                        <c:set var="reviewProfileImg" value="${review.profileImg}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:url var="reviewProfileImg" value="/${review.profileImg}" />
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <div class="dp-review-item">
                                <img class="dp-review-avatar"
                                     src="${reviewProfileImg}"
                                     alt="${review.userName} 프로필"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/img/profile/default.png';">
                                <div class="dp-review-top">
                                    <p class="dp-review-writer">
                                        <c:out value="${review.userName}" />
                                        <span class="dp-review-date">
                                            <fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd HH:mm" timeZone="Asia/Seoul" />
                                        </span>
                                    </p>
                                    <c:if test="${isLoggedIn and currentUserId == review.userId}">
                                        <form action="${pageContext.request.contextPath}/review" method="post" data-dp-review-delete-form>
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="planId" value="${plan.planId}">
                                            <input type="hidden" name="reviewId" value="${review.reviewId}">
                                            <button type="submit" class="dp-review-delete-btn">삭제</button>
                                        </form>
                                    </c:if>
                                </div>
                                <p class="dp-review-text"><c:out value="${review.content}" /></p>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="dp-confirm-backdrop" id="dpReviewDeleteConfirm" aria-hidden="true">
            <div class="dp-confirm-sheet" role="dialog" aria-modal="true" aria-labelledby="dpReviewDeleteConfirmTitle">
                <p class="dp-confirm-title" id="dpReviewDeleteConfirmTitle">후기를 삭제할까요?</p>
                <p class="dp-confirm-text">삭제한 후기는 다시 복구할 수 없습니다.</p>
                <div class="dp-confirm-actions">
                    <button type="button" class="dp-confirm-cancel" id="dpReviewDeleteCancel">취소</button>
                    <button type="button" class="dp-confirm-delete" id="dpReviewDeleteConfirmBtn">삭제</button>
                </div>
            </div>
        </div>

        <script>
            (function initHeaderCollapse() {
                const toggleBtn = document.querySelector(".header-collapse-toggle");
                const page = toggleBtn ? toggleBtn.closest(".container-result") : null;
                const symbol = toggleBtn ? toggleBtn.querySelector(".header-collapse-symbol") : null;

                if (!toggleBtn || !page || !symbol) return;

                toggleBtn.addEventListener("click", function () {
                    const isCollapsed = page.classList.toggle("is-header-collapsed");
                    toggleBtn.setAttribute("aria-expanded", String(!isCollapsed));
                    toggleBtn.setAttribute("aria-label", isCollapsed ? "상단 정보 펼치기" : "상단 정보 접기");
                    symbol.textContent = isCollapsed ? "+" : "−";
                });
            })();

            (function () {
                const mapSection = document.querySelector(".map-section");
                const mapHeader = mapSection ? mapSection.querySelector(".map-header") : null;
                const mapToggleLabel = mapHeader ? mapHeader.querySelector(".map-toggle-label") : null;
                const mapElement = document.getElementById("travelMap");
                const fallbackElement = document.getElementById("mapFallbackMessage");
                const dayButtons = Array.from(document.querySelectorAll(".day-filter-button"));
                const scheduleItems = Array.from(document.querySelectorAll(".schedule-item"))
                    .filter(function(item) {
                        return item.dataset.isNew !== "true";
                    });
                initializeMapSectionToggle();

                if (!mapElement) return;

                const mapPoints = scheduleItems
                    .map(function (item) {
                        const lat = Number(item.dataset.lat);
                        const lng = Number(item.dataset.lng);

                        if (!Number.isFinite(lat) || !Number.isFinite(lng)) return null;

                        return {
                            day: Number(item.dataset.day),
                            order: Number(item.dataset.order),
                            name: item.dataset.name || "",
                            category: normalizeCategory(item.dataset.category || ""),
                            lat: lat,
                            lng: lng,
                            time: item.dataset.time || ""
                        };
                    })
                    .filter(Boolean)
                    .sort(function (a, b) {
                        if (a.day !== b.day) return a.day - b.day;
                        return a.order - b.order;
                    });

                if (!mapPoints.length) {
                    if (fallbackElement) {
                        fallbackElement.textContent = "지도에 표시할 좌표 데이터가 아직 없습니다.";
                        fallbackElement.classList.add("is-visible");
                    }
                    return;
                }

                const apiKey = (mapElement.dataset.googleMapsApiKey || "").trim();
                const mapId = (mapElement.dataset.googleMapsMapId || "").trim();
                const initialDay = dayButtons.length ? Number(dayButtons[0].dataset.day) : mapPoints[0].day;

                const state = {
                    map: null,
                    infoWindow: null,
                    markers: [],
                    polyline: null,
                    activeDay: initialDay,
                    activePointKey: null,
                    MapClass: null,
                    AdvancedMarkerElement: null,
                    PinElement: null,
                    useAdvancedMarker: false
                };

                bindDayButtons();
                bindScheduleItems();

                if (!apiKey) {
                    if (fallbackElement) {
                        fallbackElement.textContent = "Google Maps API Key를 연결하면 여행 동선을 지도에서 확인할 수 있습니다.";
                        fallbackElement.classList.add("is-visible");
                    }
                    return;
                }

                loadGoogleMaps(apiKey)
                    .then(initMap)
                    .catch(function (error) {
                        console.error("Google Maps load failed:", error);
                        if (fallbackElement) {
                            fallbackElement.textContent = "Google Maps를 불러오지 못했습니다. 브라우저 콘솔 오류를 확인해주세요.";
                            fallbackElement.classList.add("is-visible");
                        }
                    });

                function bindDayButtons() {
                    dayButtons.forEach(function (button) {
                        button.addEventListener("click", function () {
                            const day = Number(button.dataset.day);
                            setActiveDay(day);
                            renderDay(day);
                        });
                    });
                }

                function bindScheduleItems() {
                    scheduleItems.forEach(function (item) {
                        item.addEventListener("click", function () {
                            activateScheduleItem(item);

                            const lat = Number(item.dataset.lat);
                            const lng = Number(item.dataset.lng);
                            if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
                                return;
                            }

                            const day = Number(item.dataset.day);
                            const order = Number(item.dataset.order);

                            if (state.activeDay !== day) {
                                setActiveDay(day);
                                renderDay(day);
                            }

                            focusSchedulePoint(day, order);
                        });
                    });
                }

                function initializeMapSectionToggle() {
                    if (!mapSection || !mapHeader) return;

                    function toggleMapSection(forceExpanded) {
                        const shouldExpand = typeof forceExpanded === "boolean"
                            ? forceExpanded
                            : mapSection.classList.contains("is-collapsed");

                        mapSection.classList.toggle("is-collapsed", !shouldExpand);
                        mapHeader.setAttribute("aria-expanded", String(shouldExpand));

                        if (mapToggleLabel) {
                            mapToggleLabel.textContent = shouldExpand ? "지도 접기" : "지도 펼치기";
                        }

                        if (shouldExpand) {
                            refreshMapLayout();
                        }
                    }

                    mapHeader.addEventListener("click", function () {
                        toggleMapSection();
                    });
                    mapHeader.addEventListener("keydown", function (event) {
                        if (event.key === "Enter" || event.key === " ") {
                            event.preventDefault();
                            toggleMapSection();
                        }
                    });
                }

                function expandMapSection() {
                    if (!mapSection || !mapHeader || !mapSection.classList.contains("is-collapsed")) {
                        return false;
                    }

                    mapSection.classList.remove("is-collapsed");
                    mapHeader.setAttribute("aria-expanded", "true");

                    if (mapToggleLabel) {
                        mapToggleLabel.textContent = "지도 접기";
                    }

                    refreshMapLayout();
                    return true;
                }

                function focusSchedulePoint(day, order) {
                    const wasExpanded = expandMapSection();
                    scrollToMapSection(wasExpanded ? 260 : 0);

                    if (wasExpanded) {
                        window.setTimeout(function () {
                            focusPoint(day, order, true);
                        }, 260);
                        return;
                    }

                    focusPoint(day, order, true);
                }

                function scrollToMapSection(delay) {
                    if (!mapSection) {
                        return;
                    }

                    window.setTimeout(function () {
                        const target = mapHeader || mapSection;
                        const headerOffset = getVisibleHeaderOffset();
                        const targetTop = target.getBoundingClientRect().top + window.pageYOffset - headerOffset - 12;
                        window.scrollTo({ top: Math.max(targetTop, 0), behavior: "smooth" });
                    }, delay);
                }

                function getVisibleHeaderOffset() {
                    const headers = Array.from(document.querySelectorAll(".header, .mp-header, header"));
                    return headers.reduce(function (offset, header) {
                        const style = window.getComputedStyle(header);
                        const rect = header.getBoundingClientRect();

                        if ((style.position === "fixed" || style.position === "sticky") && rect.bottom > 0) {
                            return Math.max(offset, rect.bottom);
                        }

                        return offset;
                    }, 0);
                }

                function activateScheduleItem(activeItem) {
                    scheduleItems.forEach(function (item) {
                        item.classList.toggle("is-active", item === activeItem);
                    });
                }

                async function initMap() {
                    const mapsLibrary = await google.maps.importLibrary("maps");
                    const markerLibrary = await google.maps.importLibrary("marker");
                    const centerPoint = mapPoints[0];

                    state.MapClass = mapsLibrary.Map;
                    state.AdvancedMarkerElement = markerLibrary.AdvancedMarkerElement;
                    state.PinElement = markerLibrary.PinElement;
                    state.useAdvancedMarker = Boolean(mapId);
                    state.infoWindow = new google.maps.InfoWindow();

                    const mapOptions = {
                        center: { lat: centerPoint.lat, lng: centerPoint.lng },
                        zoom: 12,
                        gestureHandling: "greedy",
                        streetViewControl: false,
                        mapTypeControl: false,
                        fullscreenControl: false
                    };

                    if (mapId) mapOptions.mapId = mapId;

                    state.map = new state.MapClass(mapElement, mapOptions);
                    mapElement.classList.add("is-ready");
                    if (fallbackElement) fallbackElement.classList.remove("is-visible");

                    renderDay(state.activeDay);
                }

                function renderDay(day) {
                    if (!state.map) return;

                    clearMap();

                    const dayPoints = mapPoints.filter(function (point) {
                        return point.day === day;
                    });

                    if (!dayPoints.length) return;

                    const bounds = new google.maps.LatLngBounds();
                    const path = [];

                    dayPoints.forEach(function (point) {
                        const color = getColor(point.category);
                        const marker = createMarker(point, color);

                        marker.__travelKey = getPointKey(point.day, point.order);
                        state.markers.push(marker);
                        path.push({ lat: point.lat, lng: point.lng });
                        bounds.extend({ lat: point.lat, lng: point.lng });
                    });

                    state.polyline = new google.maps.Polyline({
                        path: path,
                        geodesic: true,
                        strokeColor: "#2563EB",
                        strokeOpacity: 0.9,
                        strokeWeight: 4
                    });
                    state.polyline.setMap(state.map);

                    if (dayPoints.length === 1) {
                        state.map.setCenter(path[0]);
                        state.map.setZoom(14);
                    } else {
                        state.map.fitBounds(bounds, 60);
                    }

                    focusPoint(dayPoints[0].day, dayPoints[0].order, false);
                }

                function clearMap() {
                    state.markers.forEach(function (marker) {
                        if (typeof marker.setMap === "function") marker.setMap(null);
                        else marker.map = null;
                    });
                    state.markers = [];

                    if (state.polyline) {
                        state.polyline.setMap(null);
                        state.polyline = null;
                    }
                }

                function focusPoint(day, order, panToMarker) {
                    const pointKey = getPointKey(day, order);
                    const point = mapPoints.find(function (item) {
                        return getPointKey(item.day, item.order) === pointKey;
                    });

                    if (!point || !state.map) return;

                    state.activePointKey = pointKey;

                    scheduleItems.forEach(function (item) {
                        const isActive = getPointKey(Number(item.dataset.day), Number(item.dataset.order)) === pointKey;
                        item.classList.toggle("is-active", isActive);
                    });

                    const marker = state.markers.find(function (item) {
                        return item.__travelKey === pointKey;
                    });

                    if (!marker) return;

                    state.infoWindow.setContent(
                        "<div class='map-info-window'>" +
                        "<strong>" + escapeHtml(point.name) + "</strong>" +
                        (point.time ? "<div>" + escapeHtml(point.time) + "</div>" : "") +
                        "</div>"
                    );

                    if (state.useAdvancedMarker) {
                        state.infoWindow.open({ anchor: marker, map: state.map });
                    } else {
                        state.infoWindow.open(state.map, marker);
                    }

                    if (panToMarker) {
                        state.map.panTo({ lat: point.lat, lng: point.lng });
                    }
                }

                function refreshMapLayout() {
                    if (!state.map) return;

                    const center = typeof state.map.getCenter === "function" ? state.map.getCenter() : null;

                    window.setTimeout(function () {
                        if (window.google && google.maps && google.maps.event && typeof google.maps.event.trigger === "function") {
                            google.maps.event.trigger(state.map, "resize");
                        }
                        if (center && typeof state.map.setCenter === "function") {
                            state.map.setCenter(center);
                        }
                    }, 220);
                }

                function setActiveDay(day) {
                    state.activeDay = day;
                    state.activePointKey = null;
                    dayButtons.forEach(function (button) {
                        button.classList.toggle("active", Number(button.dataset.day) === day);
                    });
                }

                function getColor(category) {
                    switch (category) {
                        case "DINING":
                        case "FOOD":
                            return "#F97316";
                        case "ACCOMMODATION":
                        case "HOTEL":
                            return "#8B5CF6";
                        default:
                            return "#2563EB";
                    }
                }

                function createMarker(point, color) {
                    let marker;

                    if (state.useAdvancedMarker) {
                        const pin = new state.PinElement({
                            background: color,
                            borderColor: color,
                            glyphColor: "#FFFFFF"
                        });

                        marker = new state.AdvancedMarkerElement({
                            map: state.map,
                            position: { lat: point.lat, lng: point.lng },
                            title: point.name,
                            content: pin.element
                        });
                    } else {
                        marker = new google.maps.Marker({
                            map: state.map,
                            position: { lat: point.lat, lng: point.lng },
                            title: point.name,
                            icon: {
                                path: google.maps.SymbolPath.CIRCLE,
                                scale: 8,
                                fillColor: color,
                                fillOpacity: 1,
                                strokeColor: "#FFFFFF",
                                strokeWeight: 2
                            }
                        });
                    }

                    marker.addListener("click", function () {
                        focusPoint(point.day, point.order, true);
                    });

                    return marker;
                }

                function normalizeCategory(category) {
                    if (!category) return "ATTRACTION";
                    const upperCategory = category.toUpperCase();
                    if (upperCategory === "RESTAURANT") return "DINING";
                    if (upperCategory === "MOVE") return "TRANSPORT";
                    if (upperCategory === "HOTEL") return "ACCOMMODATION";
                    return upperCategory;
                }

                function getPointKey(day, order) {
                    return String(day) + "-" + String(order);
                }

                function loadGoogleMaps(key) {
                    if (window.google && window.google.maps && typeof window.google.maps.importLibrary === "function") {
                        return Promise.resolve();
                    }

                    return new Promise(function (resolve, reject) {
                        const existingScript = document.querySelector("script[data-google-maps-loader='true']");
                        if (existingScript) {
                            waitForGoogleMaps(resolve, reject);
                            existingScript.addEventListener("error", reject, { once: true });
                            return;
                        }

                        const script = document.createElement("script");
                        script.src = "https://maps.googleapis.com/maps/api/js?key=" + encodeURIComponent(key) + "&v=weekly&loading=async&libraries=maps,marker";
                        script.async = true;
                        script.defer = true;
                        script.dataset.googleMapsLoader = "true";
                        script.addEventListener("load", function () {
                            waitForGoogleMaps(resolve, reject);
                        }, { once: true });
                        script.addEventListener("error", function () {
                            reject(new Error("Google Maps script request failed"));
                        }, { once: true });
                        document.head.appendChild(script);
                    });
                }

                function waitForGoogleMaps(resolve, reject) {
                    let attempts = 0;

                    (function checkGoogleMapsReady() {
                        if (window.google && window.google.maps && typeof window.google.maps.importLibrary === "function") {
                            resolve();
                            return;
                        }

                        attempts += 1;
                        if (attempts > 50) {
                            reject(new Error("Google Maps API loaded but google.maps.importLibrary is unavailable"));
                            return;
                        }

                        window.setTimeout(checkGoogleMapsReady, 100);
                    })();
                }

                function escapeHtml(value) {
                    return String(value)
                        .replace(/&/g, "&amp;")
                        .replace(/</g, "&lt;")
                        .replace(/>/g, "&gt;")
                        .replace(/\"/g, "&quot;")
                        .replace(/'/g, "&#39;");
                }
            })();

            const dpContextPath = "${pageContext.request.contextPath}";
            const dpReviewModal = document.getElementById("dpReviewModal");
            const dpOpenModalBtn = document.getElementById("dpOpenModalBtn");
            const dpCloseModalBtn = document.getElementById("dpCloseModalBtn");
            const dpSnackbar = document.getElementById("dpSnackbar");
            const dpReviewDeleteConfirm = document.getElementById("dpReviewDeleteConfirm");
            const dpReviewDeleteCancel = document.getElementById("dpReviewDeleteCancel");
            const dpReviewDeleteConfirmBtn = document.getElementById("dpReviewDeleteConfirmBtn");
            let pendingDpReviewDeleteForm = null;

            function closeDpReviewDeleteConfirm() {
                pendingDpReviewDeleteForm = null;
                if (!dpReviewDeleteConfirm) return;
                dpReviewDeleteConfirm.classList.remove("is-open");
                dpReviewDeleteConfirm.setAttribute("aria-hidden", "true");
            }

            document.querySelectorAll("[data-dp-review-delete-form]").forEach(function(form) {
                form.addEventListener("submit", function(event) {
                    event.preventDefault();
                    pendingDpReviewDeleteForm = form;
                    if (!dpReviewDeleteConfirm) {
                        form.submit();
                        return;
                    }
                    dpReviewDeleteConfirm.classList.add("is-open");
                    dpReviewDeleteConfirm.setAttribute("aria-hidden", "false");
                    if (dpReviewDeleteConfirmBtn) dpReviewDeleteConfirmBtn.focus();
                });
            });

            if (dpReviewDeleteCancel) {
                dpReviewDeleteCancel.addEventListener("click", closeDpReviewDeleteConfirm);
            }

            if (dpReviewDeleteConfirmBtn) {
                dpReviewDeleteConfirmBtn.addEventListener("click", function() {
                    const form = pendingDpReviewDeleteForm;
                    closeDpReviewDeleteConfirm();
                    if (form) form.submit();
                });
            }

            if (dpReviewDeleteConfirm) {
                dpReviewDeleteConfirm.addEventListener("click", function(event) {
                    if (event.target === dpReviewDeleteConfirm) {
                        closeDpReviewDeleteConfirm();
                    }
                });
            }

            if (dpOpenModalBtn) {
                dpOpenModalBtn.addEventListener("click", function () {
                    openReviewSheet();
                });
            }

            if (dpCloseModalBtn && dpReviewModal) {
                dpCloseModalBtn.addEventListener("click", function () {
                    dpReviewModal.classList.remove("is-open");
                    document.body.style.overflow = "";
                });
            }

            window.addEventListener("click", function (e) {
                if (e.target === dpReviewModal) {
                    dpReviewModal.classList.remove("is-open");
                    document.body.style.overflow = "";
                }
            });

            function openReviewSheet() {
                document.getElementById("dpPlanBackdrop").classList.add("show");
                document.getElementById("dpPlanSheet").classList.add("show");
                document.body.style.overflow = "hidden";
            }

            function closePlanSheet() {
                document.getElementById("dpPlanBackdrop").classList.remove("show");
                document.getElementById("dpPlanSheet").classList.remove("show");
                document.body.style.overflow = "";
            }

            if (new URLSearchParams(window.location.search).has("reviewSuccess")) {
                openReviewSheet();
                if (window.matchMedia("(max-width: 768px)").matches) {
                    showDpSnackbar("후기가 등록되었습니다.");
                }
            }

            function copyUrl() {
                var url = window.location.href;

                function onSuccess() {
                    showDpSnackbar("링크가 복사되었습니다.");
                }

                function onFail() {
                    var textArea = document.createElement("textarea");
                    textArea.value = url;
                    textArea.setAttribute("readonly", "");
                    textArea.style.position = "fixed";
                    textArea.style.opacity = "0";
                    textArea.style.pointerEvents = "none";
                    document.body.appendChild(textArea);
                    textArea.focus();
                    textArea.select();

                    try {
                        var copied = document.execCommand("copy");
                        document.body.removeChild(textArea);
                        if (copied) {
                            onSuccess();
                            return;
                        }
                    } catch (error) {
                        document.body.removeChild(textArea);
                    }

                    showDpSnackbar("링크 복사에 실패했습니다.");
                }

                if (navigator.clipboard && window.isSecureContext) {
                    navigator.clipboard.writeText(url).then(onSuccess).catch(onFail);
                    return;
                }

                onFail();
            }

            function toggleHeart(btn, planId) {
                fetch(dpContextPath + "/like", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ planId: planId })
                })
                    .then(function (res) {
                        if (!res.ok) {
                            throw new Error("좋아요 처리에 실패했습니다.");
                        }
                        return res.json();
                    })
                    .then(function (data) {
                        btn.innerText = data.liked ? "♥" : "♡";
                        btn.classList.toggle("is-heart", data.liked);
                        updateLikeCount(data.likeCount);
                        showDpSnackbar(data.liked ? "좋아요가 반영되었습니다." : "좋아요를 취소했습니다.");
                    })
                    .catch(function (err) {
                        console.error(err);
                        showDpSnackbar("좋아요 처리 중 오류가 발생했습니다.");
                    });
            }

            function updateLikeCount(likeCount) {
                const likePill = document.querySelector(".plan-like-pill");
                const nextCount = Number(likeCount);

                if (!likePill || !Number.isFinite(nextCount)) {
                    return;
                }

                likePill.textContent = "♥ " + nextCount;
            }

            function showLoginAlert() {
                showDpSnackbar("로그인 후 이용 가능합니다.");
            }

            function goLoginWithReturn() {
                const returnTarget = new URL(window.location.href);
                returnTarget.searchParams.delete("reviewSuccess");
                returnTarget.searchParams.delete("reviewDeleted");

                let returnUrl = returnTarget.pathname + returnTarget.search;
                if (dpContextPath && returnUrl.indexOf(dpContextPath + "/") === 0) {
                    returnUrl = returnUrl.substring(dpContextPath.length);
                }
                window.location.href = dpContextPath + "/login?returnUrl=" + encodeURIComponent(returnUrl);
            }

            function showDpSnackbar(message) {
                if (!dpSnackbar) return;
                dpSnackbar.textContent = message;
                dpSnackbar.classList.add("show");

                clearTimeout(dpSnackbar._timer);
                dpSnackbar._timer = setTimeout(function () {
                    dpSnackbar.classList.remove("show");
                }, 1800);
            }
        </script>
    </c:otherwise>
</c:choose>
