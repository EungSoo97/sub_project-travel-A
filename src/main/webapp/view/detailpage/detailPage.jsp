<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.es.ta.account.AccountDTO" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
    boolean isLoggedIn = (user != null);
    pageContext.setAttribute("isLoggedIn", isLoggedIn);
%>

<div class="mp-page">
    <div class="mp-container">

        <div class="mp-header">
            <a class="mp-back-link" href="${pageContext.request.contextPath}/explore">
                ← 목록으로 돌아가기
            </a>

            <div class="mp-title-area">
                <div style="display:flex; justify-content:space-between; align-items:flex-start; gap:12px;">
                    <div>
                        <h1 class="mp-title">${plan.summary.destination}</h1>
                        <p class="mp-sub">
                            ${plan.summary.startDate} ~ ${plan.summary.endDate}
                            · ${plan.summary.days}일 여행
                        </p>
                    </div>

                    <button type="button" class="dp-review-link-btn" onclick="openReviewSheet()">
                        후기 전체보기 &gt;
                    </button>
                </div>
            </div>

            <div class="actions">
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <button type="button" class="action-btn icon-btn" onclick="toggleHeart(this, ${plan.planId})">♡</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="action-btn icon-btn" onclick="showLoginAlert()">♡</button>
                    </c:otherwise>
                </c:choose>

                <button type="button" class="action-btn icon-btn" onclick="copyUrl()">🔗</button>

                <form action="${pageContext.request.contextPath}/pdf" method="get">
                    <button type="submit" class="action-btn">⬇ PDF</button>
                </form>

                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <form action="${pageContext.request.contextPath}/save-plan" method="post">
                            <input type="hidden" name="title" value="${plan.summary.title}">
                            <button type="submit" class="action-btn">💾 저장</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="action-btn" onclick="showLoginAlert()">💾 저장</button>
                    </c:otherwise>
                </c:choose>

                <button type="button" class="action-btn" id="dpOpenModalBtn">✍ 후기</button>
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
                <p class="mp-summary-label">📅 여행 기간</p>
                <p class="mp-summary-value">${plan.summary.startDate} ~ ${plan.summary.endDate}</p>
            </div>

            <div class="mp-summary-card">
                <p class="mp-summary-label">👥 여행 인원</p>
                <p class="mp-summary-value">${plan.summary.travelers}명</p>
            </div>

            <div class="mp-summary-card">
                <p class="mp-summary-label">🎯 여행 스타일</p>
                <p class="mp-summary-value">${plan.summary.travelStyle}</p>
            </div>
        </div>

        <div class="mp-section">
            <div class="map-section mp-day-card">
                <div class="map-header">
                    <span>🗺 여행 동선 지도</span>
                    <div class="legend">
                        <span class="dot blue"></span> 관광지
                        <span class="dot orange"></span> 식당
                        <span class="dot purple"></span> 숙소
                    </div>
                </div>

                <div class="map-area">
                    <div id="travelMap" class="travel-map"
                         data-google-maps-api-key="${googleMapsApiKey}"
                         data-google-maps-map-id="${googleMapsMapId}">
                    </div>
                    <div id="mapFallbackMessage" class="map-fallback-message">
                        Google Maps API Key와 Map ID를 연결하면 여행 동선을 지도에서 볼 수 있습니다.
                    </div>
                </div>

                <div class="map-toolbar">
                    <div class="day-filter" id="dayFilter">
                        <c:forEach var="item" items="${plan.itinerary}" varStatus="status">
                            <button type="button"
                                    class="day-filter-button<c:if test='${status.first}'> active</c:if>"
                                    data-day="${item.day}">
                                Day ${item.day}
                            </button>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div class="mp-section">
            <div class="mp-section-head">
                <h2 class="mp-section-title">여행 일정 요약</h2>
                <span class="mp-section-badge">
                    총 ${plan.summary.totalEstimatedCost} ${plan.summary.currency}
                </span>
            </div>

            <div class="mp-schedule-list">
                <c:forEach var="item" items="${plan.itinerary}">
                    <div class="mp-day-card">
                        <div class="mp-day-head">
                            <div class="mp-day-left">
                                <div class="mp-day-badge">D${item.day}</div>
                                <div>
                                    <p class="mp-day-title">${item.day}일차</p>
                                    <p class="mp-day-date">${item.date}</p>
                                </div>
                            </div>

                            <div class="mp-day-right">
                                <span class="mp-day-cost">${item.estimatedCost} ${plan.summary.currency}</span>
                            </div>
                        </div>

                        <div class="mp-day-body">
                            <c:forEach var="act" items="${item.activities}" varStatus="status">
                                <div
                                        class="mp-item schedule-item"
                                        data-day="${item.day}"
                                        data-order="${status.count}"
                                        data-name="${fn:escapeXml(act.name)}"
                                        data-category="${fn:escapeXml(empty act.categoryCode ? act.category : act.categoryCode)}"
                                        data-lat="${act.lat}"
                                        data-lng="${act.lng}"
                                        data-time="${fn:escapeXml(act.time)}">

                                    <div class="mp-item-icon">📍</div>

                                    <div class="mp-item-content">
                                        <div class="mp-item-top">
                                            <span class="mp-item-time">${act.time}</span>
                                            <span class="mp-item-title">${act.name}</span>
                                        </div>
                                        <p class="mp-item-desc">${act.description}</p>
                                    </div>

                                    <div class="mp-item-meta">
                                        <span>${act.durationMinutes}분</span>
                                        <span>
                                            <c:choose>
                                                <c:when test="${act.cost == 0}">무료</c:when>
                                                <c:otherwise>${act.cost} ${plan.summary.currency}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="mp-section">
            <h2 class="mp-section-title">추천 항공 / 숙소</h2>

            <div class="mp-recommend-grid">
                <div class="mp-recommend-card">
                    <h3 class="mp-recommend-card-title">✈ 항공권</h3>
                    <c:choose>
                        <c:when test="${empty plan.flights}">
                            <p class="mp-empty-text">항공권 추천 정보가 없습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="flight" items="${plan.flights}">
                                <div class="mp-recommend-item">
                                    <div>
                                        <p class="mp-recommend-title">${flight.airline}</p>
                                        <p class="mp-recommend-desc">${flight.departureAirport} → ${flight.arrivalAirport}</p>
                                    </div>
                                    <div class="mp-recommend-right">
                                        <p class="mp-recommend-price">${flight.price} ${flight.currency}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="mp-recommend-card">
                    <h3 class="mp-recommend-card-title">🏨 숙소</h3>
                    <c:choose>
                        <c:when test="${empty plan.hotels}">
                            <p class="mp-empty-text">숙소 추천 정보가 없습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="hotel" items="${plan.hotels}">
                                <div class="mp-recommend-item">
                                    <div>
                                        <p class="mp-recommend-title">${hotel.name}</p>
                                        <p class="mp-recommend-desc">
                                            ⭐ ${hotel.rating}
                                            <c:if test="${not empty hotel.location}">
                                                · ${hotel.location}
                                            </c:if>
                                        </p>
                                    </div>
                                    <div class="mp-recommend-right">
                                        <p class="mp-recommend-price">${hotel.pricePerNight} ${hotel.currency}</p>
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
        <c:choose>
            <c:when test="${empty reviews}">
                <p class="mp-empty-text">아직 작성된 후기가 없습니다.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${reviews}">
                    <div class="dp-review-item">
                        <p class="dp-review-writer">${review.userName}</p>
                        <p class="dp-review-text">${review.content}</p>
                        <p class="dp-review-date">
                            <fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd" />
                        </p>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    (function () {
        const mapElement = document.getElementById("travelMap");
        const fallbackElement = document.getElementById("mapFallbackMessage");
        const dayButtons = Array.from(document.querySelectorAll(".day-filter-button"));
        const scheduleItems = Array.from(document.querySelectorAll(".schedule-item"));

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
                fallbackElement.textContent = "지도에 표시할 좌표 데이터가 없습니다.";
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
                fallbackElement.textContent = "Google Maps API Key를 연결하면 여행 동선을 지도에서 볼 수 있습니다.";
                fallbackElement.classList.add("is-visible");
            }
            return;
        }

        loadGoogleMaps(apiKey)
            .then(initMap)
            .catch(function (error) {
                console.error("Google Maps load failed:", error);
                if (fallbackElement) {
                    fallbackElement.textContent = "Google Maps를 불러오지 못했습니다. 브라우저 콘솔 오류를 확인해 주세요.";
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
                    const lat = Number(item.dataset.lat);
                    const lng = Number(item.dataset.lng);
                    if (!Number.isFinite(lat) || !Number.isFinite(lng)) return;

                    const day = Number(item.dataset.day);
                    const order = Number(item.dataset.order);

                    if (state.activeDay !== day) {
                        setActiveDay(day);
                        renderDay(day);
                    }

                    focusPoint(day, order, true);
                });
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

            const marker = state.markers.find(function (m) {
                return m.__travelKey === pointKey;
            });
            if (!marker) return;

            state.infoWindow.setContent(
                "<div class='mp-map-info-window'>" +
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
                script.src =
                    "https://maps.googleapis.com/maps/api/js?key=" +
                    encodeURIComponent(key) +
                    "&v=weekly&loading=async&libraries=maps,marker";
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

    const dpReviewModal = document.getElementById("dpReviewModal");
    const dpOpenModalBtn = document.getElementById("dpOpenModalBtn");
    const dpCloseModalBtn = document.getElementById("dpCloseModalBtn");
    const dpSnackbar = document.getElementById("dpSnackbar");

    if (dpOpenModalBtn && dpReviewModal) {
        dpOpenModalBtn.addEventListener("click", function () {
            dpReviewModal.classList.add("is-open");
            document.body.style.overflow = "hidden";
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

    function copyUrl() {
        navigator.clipboard.writeText(window.location.href).then(function () {
            showDpSnackbar("링크가 복사되었습니다.");
        });
    }

    function toggleHeart(button, planId) {
        button.classList.toggle("is-liked");
        button.textContent = button.classList.contains("is-liked") ? "♥" : "♡";
        showDpSnackbar("좋아요가 반영되었습니다.");
    }

    function showLoginAlert() {
        alert("로그인 후 이용 가능합니다.");
    }

    function showDpSnackbar(message) {
        if (!dpSnackbar) return;
        dpSnackbar.textContent = message;
        dpSnackbar.classList.add("show");

        setTimeout(function () {
            dpSnackbar.classList.remove("show");
        }, 1800);
    }
</script>
