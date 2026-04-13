<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .edit-form-card {
        margin: 0 16px 14px;
        padding: 18px 16px;
        background: #fff;
        border: 1px solid #E5E7EB;
        border-radius: 16px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04);
    }

    .edit-error {
        margin: 0 16px 14px;
        padding: 12px 14px;
        border-radius: 12px;
        background: #FEF2F2;
        border: 1px solid #FECACA;
        color: #B91C1C;
        font-size: 13px;
        font-weight: 600;
    }

    .edit-form-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 14px;
    }

    .edit-field {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .edit-field.full {
        grid-column: 1 / -1;
    }

    .edit-field label {
        font-size: 12px;
        font-weight: 700;
        color: #374151;
    }

    .edit-field input,
    .edit-field textarea {
        width: 100%;
        border: 1px solid #D1D5DB;
        border-radius: 12px;
        padding: 12px 14px;
        font-size: 14px;
        font-family: inherit;
        color: #111827;
        background: #FFFFFF;
        box-sizing: border-box;
    }

    .edit-field textarea {
        min-height: 120px;
        resize: vertical;
    }

    .json-editor {
        min-height: 280px;
        font-family: Consolas, "Courier New", monospace;
        font-size: 12px;
        line-height: 1.6;
    }

    .edit-actions {
        display: flex;
        gap: 10px;
        margin-top: 18px;
    }

    .edit-actions button,
    .edit-actions a {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 120px;
        padding: 12px 16px;
        border-radius: 12px;
        border: 1px solid #2563EB;
        background: #2563EB;
        color: #FFFFFF;
        font-size: 14px;
        font-weight: 700;
        text-decoration: none;
        cursor: pointer;
    }

    .edit-actions .secondary {
        background: #FFFFFF;
        color: #2563EB;
    }

    @media (max-width: 768px) {
        .edit-form-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="result-page">
    <div class="container-result">
        <div class="header">
            <div>
                <a href="${pageContext.request.contextPath}/myplan-page?id=${savedPlan.planId}">상세 페이지로 돌아가기</a>
            </div>

            <div class="title-area">
                <h1 class="result-h1">여행 계획 편집</h1>
                <p class="sub">${result.summary.destination} · ${result.summary.days}일 여행 수정</p>
            </div>
        </div>

        <c:if test="${not empty editError}">
            <div class="edit-error">${editError}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/myplan-edit" method="post" class="edit-form-card">
            <input type="hidden" name="id" value="${savedPlan.planId}">

            <div class="edit-form-grid">
                <div class="edit-field">
                    <label for="title">여행 제목</label>
                    <input id="title" type="text" name="title" value="${result.summary.title}" required>
                </div>

                <div class="edit-field">
                    <label for="destination">목적지</label>
                    <input id="destination" type="text" name="destination" value="${result.summary.destination}" required>
                </div>

                <div class="edit-field">
                    <label for="startDate">출발일</label>
                    <input id="startDate" type="date" name="startDate" value="${result.summary.startDate}" required>
                </div>

                <div class="edit-field">
                    <label for="endDate">도착일</label>
                    <input id="endDate" type="date" name="endDate" value="${result.summary.endDate}" required>
                </div>

                <div class="edit-field">
                    <label for="travelers">여행 인원</label>
                    <input id="travelers" type="number" min="1" name="travelers" value="${result.summary.travelers}" required>
                </div>

                <div class="edit-field">
                    <label for="travelStyle">여행 스타일</label>
                    <input id="travelStyle" type="text" name="travelStyle" value="${result.summary.travelStyle}">
                </div>

                <div class="edit-field full">
                    <label for="overview">여행 요약</label>
                    <textarea id="overview" name="overview">${result.summary.overview}</textarea>
                </div>

                <div class="edit-field full">
                    <label for="responseJson">전체 JSON 편집</label>
                    <textarea id="responseJson" name="responseJson" class="json-editor">${responseJsonText}</textarea>
                </div>
            </div>

            <div class="edit-actions">
                <button type="submit">수정 완료</button>
                <a href="${pageContext.request.contextPath}/myplan-page?id=${savedPlan.planId}" class="secondary">취소</a>
            </div>
        </form>

        <div class="map-section">
            <div class="map-header">
                <span>여행 동선 지도</span>
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
                    Google Maps API Key를 연결하면 여행 동선을 지도에서 볼 수 있습니다.
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

        <div class="detail-container">
            <div class="detail-header">
                <h2>현재 일정 미리보기</h2>
                <div class="total-cost">총 예상 비용: ${result.summary.totalEstimatedCost} ${result.summary.currency}</div>
            </div>

            <c:forEach var="item" items="${result.itinerary}">
                <div class="day-card">
                    <div class="day-header">
                        <div class="day-left">
                            <div class="day-badge">D${item.day}</div>
                            <div>
                                <div class="day-title">${item.day}일차</div>
                                <div class="day-date">${item.date}</div>
                            </div>
                        </div>
                    </div>

                    <div class="time-section">
                        <c:forEach var="act" items="${item.activities}" varStatus="activityStatus">
                            <div
                                    class="item schedule-item"
                                    data-day="${item.day}"
                                    data-order="${activityStatus.count}"
                                    data-name="${fn:escapeXml(act.name)}"
                                    data-category="${fn:escapeXml(act.category)}"
                                    data-lat="${act.lat}"
                                    data-lng="${act.lng}"
                                    data-time="${fn:escapeXml(act.time)}">
                                <div class="icon ${act.category eq 'HOTEL' || act.category eq 'ACCOMMODATION' ? 'hotel' : (act.category eq 'FOOD' || act.category eq 'DINING' ? 'food' : 'spot')}">
                                    <c:choose>
                                        <c:when test="${act.category eq 'HOTEL' || act.category eq 'ACCOMMODATION'}">H</c:when>
                                        <c:when test="${act.category eq 'FOOD' || act.category eq 'DINING'}">F</c:when>
                                        <c:otherwise>S</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="content">
                                    <div class="top">
                                        <span class="time">${act.time}</span>
                                        <span class="title">${act.name}</span>
                                    </div>
                                    <div class="desc">${act.description}</div>
                                </div>
                                <div class="meta">
                                    <span>${act.category}</span>
                                    <span>${act.cost} ${result.summary.currency}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    (function () {
        const mapElement = document.getElementById("travelMap");
        const fallbackElement = document.getElementById("mapFallbackMessage");
        const dayButtons = Array.from(document.querySelectorAll(".day-filter-button"));
        const scheduleItems = Array.from(document.querySelectorAll(".schedule-item"))
            // ── 새로 추가된 활동 제외 ──
            .filter(function(item) {
                return item.dataset.isNew !== "true";
            });
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
            useAdvancedMarker: false,
            AdvancedMarkerElement: null,
            PinElement: null
        };

        dayButtons.forEach(function (button) {
            button.addEventListener("click", function () {
                const day = Number(button.dataset.day);
                state.activeDay = day;
                dayButtons.forEach(function (item) {
                    item.classList.toggle("active", item === button);
                });
                renderDay(day);
            });
        });

        scheduleItems.forEach(function (item) {
            item.addEventListener("click", function () {
                focusPoint(Number(item.dataset.day), Number(item.dataset.order), true);
            });
        });

        if (!apiKey) {
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

        async function initMap() {
            const mapsLibrary = await google.maps.importLibrary("maps");
            const markerLibrary = await google.maps.importLibrary("marker");
            const centerPoint = mapPoints[0];

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

            state.map = new mapsLibrary.Map(mapElement, mapOptions);
            mapElement.classList.add("is-ready");
            renderDay(state.activeDay);
        }

        function renderDay(day) {
            clearMap();

            const dayPoints = mapPoints.filter(function (point) {
                return point.day === day;
            });

            if (!dayPoints.length || !state.map) {
                return;
            }

            const bounds = new google.maps.LatLngBounds();
            const path = [];

            dayPoints.forEach(function (point) {
                const marker = createMarker(point, getColor(point.category));
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

            if (!point) {
                return;
            }

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
                "<div class='map-info-window'><strong>" + escapeHtml(point.name) + "</strong>" +
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

        function normalizeCategory(category) {
            const upperCategory = category.toUpperCase();
            if (upperCategory === "RESTAURANT") {
                return "DINING";
            }
            return upperCategory || "ATTRACTION";
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
</script>
