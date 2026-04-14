<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Resultpage</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/result-page.css">
</head>
<body>
<div class="result-page">

    <div class="container-result">

        <div class="header">
            <div class="header-topbar">
                <a href="hello-servlet">← 검색으로 돌아가기</a>
                <button type="button" class="header-collapse-toggle" aria-expanded="true" aria-label="상단 정보 접기">
                    <span class="header-collapse-symbol">−</span>
                </button>
            </div>

            <div class="title-area">
                <h1>AI 맞춤 여행 일정</h1>
                <p class="sub">${result.summary.destination} · ${result.summary.days}일 여행</p>
            </div>

            <c:if test="${empty savedPlan}">
                <div class="actions result-save-choice">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <form action="${pageContext.request.contextPath}/save-plan" method="post">
                                <input type="hidden" name="title" value="${result.summary.title}">
                                <button type="submit" class="action-btn result-choice-btn save-btn" title="저장하기" aria-label="저장하기">💾</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/discard-plan" method="post">
                                <button type="submit" class="action-btn result-choice-btn discard-btn" title="저장하지 않기" aria-label="저장하지 않기">🗑</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="action-btn result-login-btn" onclick="goResultLogin()">로그인 하기</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>

        <!-- 여행 정보 -->
        <div class="mp-summary-grid">
            <div class="mp-summary-card mp-summary-card--full">
                <p class="mp-summary-label">📅 여행 기간</p>
                <p class="mp-summary-value">${result.summary.startDate} ~ ${result.summary.endDate}</p>
            </div>

            <div class="mp-summary-card">
                <p class="mp-summary-label">👥 여행 인원</p>
                <p class="mp-summary-value">${result.summary.travelers}명</p>
            </div>

            <div class="mp-summary-card">
                <p class="mp-summary-label">🎯 여행 스타일</p>
                <p class="mp-summary-value">${result.summary.travelStyle}</p>
            </div>
        </div>

        <!-- 지도 영역 -->
        <div class="map-section">
            <div class="map-header" role="button" tabindex="0" aria-expanded="true">
                <span>🧭 여행 동선 지도</span>
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
                    Google Maps API Key와 Map ID를 연결하면 여행 동선을 지도에서 볼 수 있습니다.
                </div>
            </div>
            <div class="map-toolbar">
                <div class="day-filter" id="dayFilter">
                    <c:forEach var="item" items="${result.itinerary}" varStatus="status">
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

        <!-- 일정 리스트 -->
        <div class="schedule">
            <c:forEach var="item" items="${result.itinerary}">
                <div class="day">
                    <h3>${item.day}일차 <span>(${item.activities.size()}개 장소)</span></h3>
                    <p class="route">
                        <c:forEach var="act" items="${item.activities}" varStatus="status">
                            ● ${act.name}<c:if test="${!status.last}"> → </c:if>
                        </c:forEach>
                    </p>
                </div>
            </c:forEach>
        </div>

        <div class="detail-container">

            <!-- 상단 -->
            <div class="detail-header">
                <h2>상세 일정</h2>
                <div class="total-cost">총 예상 비용: ${result.summary.totalEstimatedCost} ${result.summary.currency}</div>
            </div>

            <!-- 일차별 반복 -->
            <c:forEach var="item" items="${result.itinerary}">
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

        <div class="recommend-section">

            <h2>추천 항공/숙박</h2>

            <div class="recommend-grid">

                <!-- 항공 -->
                <div class="recommend-card">
                    <h3>✈️ 항공권 최저가</h3>
                    <c:choose>
                        <c:when test="${empty result.flights}">
                            <p>항공권 정보를 불러오지 못했습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="flight" items="${result.flights}">
                                <div class="recommend-item">
                                    <div class="left">
                                        <div class="title">${flight.airline} ${flight.flightNumber}</div>
                                        <div class="desc">${flight.departureAirport} → ${flight.arrivalAirport}</div>
                                    </div>
                                    <div class="right">
                                        <div class="price">${flight.price} ${flight.currency}</div>
                                        <div class="sub">왕복 1인</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 숙박 -->
                <div class="recommend-card">
                    <h3>🏨 숙박 추천</h3>
                    <c:forEach var="hotel" items="${result.hotels}">
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
                </div>

            </div>

        </div>

    </div>

</div>
<script>
    function goResultLogin() {
        window.location.href = "${pageContext.request.contextPath}/login?returnUrl=" + encodeURIComponent("/result-draft");
    }

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

    async function toggleStar(btn) {
        if (!btn) return;

        const planId = btn.dataset.planId;
        if (!planId) {
            showMpSnackbar("플랜 정보가 없습니다.");
            return;
        }

        if (btn.dataset.loading === "true") return;
        btn.dataset.loading = "true";
        btn.disabled = true;

        try {
            const response = await fetch("${pageContext.request.contextPath}/plan-like/toggle", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                },
                body: "planId=" + encodeURIComponent(planId)
            });

            const data = await response.json();

            if (response.status === 401) {
                showMpSnackbar("로그인이 필요합니다.");
                window.location.href = "${pageContext.request.contextPath}/login";
                return;
            }

            if (!response.ok || !data.success) {
                throw new Error(data.message || "즐겨찾기 처리에 실패했습니다.");
            }

            const liked = !!data.liked;

            btn.classList.toggle("is-liked", liked);
            btn.textContent = liked ? "★" : "☆";

            showMpSnackbar(liked ? "즐겨찾기에 저장했어요." : "즐겨찾기를 해제했어요.");
        } catch (e) {
            console.error("toggleStar error:", e);
            showMpSnackbar(e.message || "오류가 발생했습니다.");
        } finally {
            btn.dataset.loading = "false";
            btn.disabled = false;
        }
    }

    function showMpSnackbar(message) {
        const snackbar = document.getElementById("mpSnackbar");
        if (!snackbar) return;

        snackbar.textContent = message;
        snackbar.classList.add("show");

        clearTimeout(snackbar._timer);
        snackbar._timer = setTimeout(function () {
            snackbar.classList.remove("show");
        }, 2000);
    }

    (function () {
        const mapSection = document.querySelector(".map-section");
        const mapHeader = mapSection ? mapSection.querySelector(".map-header") : null;
        const mapToggleLabel = mapHeader ? mapHeader.querySelector(".map-toggle-label") : null;
        const mapElement = document.getElementById("travelMap");
        const fallbackElement = document.getElementById("mapFallbackMessage");
        const dayButtons = Array.from(document.querySelectorAll(".day-filter-button"));
        const scheduleItems = Array.from(document.querySelectorAll(".schedule-item"))
            // ── 새로 추가된 활동 제외 ──
            .filter(function(item) {
                return item.dataset.isNew !== "true";
            });
        initializeMapSectionToggle();
        if (!mapElement) {
            return;
        }

        const mapPoints = scheduleItems
            .map(function (item) {
                const lat = Number(item.dataset.lat);
                const lng = Number(item.dataset.lng);

                if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
                    return null;
                }

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
                if (a.day !== b.day) {
                    return a.day - b.day;
                }
                return a.order - b.order;
            });

        if (!mapPoints.length) {
            fallbackElement.textContent = "지도에 표시할 좌표 데이터가 아직 없습니다.";
            fallbackElement.classList.add("is-visible");
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
            fallbackElement.textContent = "Google Maps API Key를 연결하면 여행 동선을 지도에서 볼 수 있습니다.";
            fallbackElement.classList.add("is-visible");
            return;
        }

        loadGoogleMaps(apiKey)
            .then(initMap)
            .catch(function (error) {
                console.error("Google Maps load failed:", error);
                fallbackElement.textContent = "Google Maps를 불러오지 못했습니다. 브라우저 콘솔 오류를 확인해 주세요.";
                fallbackElement.classList.add("is-visible");
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
            if (!mapSection || !mapHeader) {
                return;
            }

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

            if (mapId) {
                mapOptions.mapId = mapId;
            }

            state.map = new state.MapClass(mapElement, mapOptions);

            mapElement.classList.add("is-ready");
            fallbackElement.classList.remove("is-visible");
            renderDay(state.activeDay);
        }

        function renderDay(day) {
            if (!state.map) {
                return;
            }

            clearMap();

            const dayPoints = mapPoints.filter(function (point) {
                return point.day === day;
            });

            if (!dayPoints.length) {
                return;
            }

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
                if (typeof marker.setMap === "function") {
                    marker.setMap(null);
                } else {
                    marker.map = null;
                }
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

            if (!point || !state.map) {
                return;
            }

            state.activePointKey = pointKey;
            scheduleItems.forEach(function (item) {
                const isActive = getPointKey(Number(item.dataset.day), Number(item.dataset.order)) === pointKey;
                item.classList.toggle("is-active", isActive);
            });

            const marker = state.markers.find(function (item) {
                return item.__travelKey === pointKey;
            });
            if (!marker) {
                return;
            }

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
            if (!state.map) {
                return;
            }

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
                script.addEventListener("load", function () { waitForGoogleMaps(resolve, reject); }, { once: true });
                script.addEventListener("error", function () { reject(new Error("Google Maps script request failed")); }, { once: true });
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
</script>
</body>
<script>
    function toggleHeart(btn) {
        if (btn.innerText === "♡") {
            btn.innerText = "❤";
        } else {
            btn.innerText = "♡";
        }
    }
</script>
</html>
