/**
 * FastAPI GET /api/v1/live-travel/dashboard — Java 프록시: GET /live/dashboard-data
 * 응답 스키마: LiveTravelDashboardResponse (camelCase)
 */
(function () {
    var ctx = typeof window.LIVE_CTX !== "undefined" ? window.LIVE_CTX : "";
    var planId = typeof window.LIVE_PLAN_ID !== "undefined" ? window.LIVE_PLAN_ID : 1;
    var destHint =
        typeof window.LIVE_DESTINATION !== "undefined" && window.LIVE_DESTINATION !== null
            ? String(window.LIVE_DESTINATION)
            : "";

    var DASHBOARD_POLL_MS = 60000;

    function esc(s) {
        if (s == null || s === undefined) return "";
        return String(s)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;");
    }

    function showError(msg) {
        var el = document.getElementById("liveDashboardError");
        if (!el) return;
        el.style.display = "block";
        el.textContent = msg;
    }

    function hideError() {
        var el = document.getElementById("liveDashboardError");
        if (!el) return;
        el.style.display = "none";
        el.textContent = "";
    }

    function crowdLevelClass(level) {
        if (level === "low") return "status-good";
        if (level === "medium") return "status-warn";
        if (level === "high") return "status-bad";
        return "status-good";
    }

    function trafficRowSvg(isNormal) {
        if (isNormal) {
            return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>';
        }
        return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>';
    }

    function renderWeather(w) {
        var host = document.getElementById("weatherArea");
        if (!host) return;
        if (!w) {
            host.innerHTML = "<p class='live-muted'>날씨 정보 없음</p>";
            return;
        }
        var t = w.temperatureC != null ? w.temperatureC : "—";
        var cond = esc(w.condition || "");
        var hum = w.humidityPercent != null ? w.humidityPercent : "—";
        var wind = w.windSpeedMps != null ? w.windSpeedMps : "—";
        host.innerHTML =
            "<div class='weather-main'>" +
            "<h2>" + esc(t) + "°C</h2>" +
            "<p>" + cond + "</p>" +
            "</div>" +
            "<div class='weather-details'>" +
            "<div class='detail-item'><span class='detail-label'>습도</span><span class='detail-value'>" +
            esc(hum) +
            "%</span></div>" +
            "<div class='detail-item'><span class='detail-label'>풍속</span><span class='detail-value'>" +
            esc(wind) +
            "m/s</span></div>" +
            "</div>";
    }

    function renderTraffic(list) {
        var host = document.getElementById("liveTraffic");
        if (!host) return;
        if (!list || list.length === 0) {
            host.innerHTML = "<p class='live-muted'>교통 정보 없음</p>";
            return;
        }
        var html = "";
        for (var i = 0; i < list.length; i++) {
            var row = list[i];
            var isNormal = (row.status || "").toLowerCase() === "normal";
            var textClass = isNormal ? "status-text good" : "status-text warning";
            var metaParts = [];
            if (row.operator) metaParts.push(esc(row.operator));
            if (row.departureStop || row.arrivalStop) metaParts.push(esc((row.departureStop || "-") + " → " + (row.arrivalStop || "-")));
            var detailParts = [];
            if (row.departureInMinutes != null) {
                detailParts.push("약 " + esc(row.departureInMinutes) + "분 후 출발");
            } else if (row.departureTimeText) {
                detailParts.push(esc(row.departureTimeText) + " 출발");
            }
            if (row.delayMinutes != null) {
                detailParts.push("현재 " + esc(row.delayMinutes) + "분 지연");
            } else if (row.statusLabel) {
                detailParts.push(esc(row.statusLabel));
            }
            if (row.durationMinutes != null) {
                detailParts.push(esc(row.durationMinutes) + "분 소요");
            }
            html +=
                "<div class='info-row traffic-row'>" +
                "<div class='traffic-main'>" +
                "<span class='info-name traffic-line'>" +
                esc(row.line || "교통") +
                "</span>" +
                (metaParts.length ? "<div class='traffic-meta'>" + metaParts.join(" · ") + "</div>" : "") +
                "<span class='traffic-message " +
                textClass +
                "'>" +
                trafficRowSvg(isNormal) +
                esc(row.message || "") +
                "</span>" +
                (detailParts.length ? "<div class='traffic-subdetail'>" + detailParts.join(" · ") + "</div>" : "") +
                "</div>" +
                "</div>";
        }
        host.innerHTML = html;
    }

    function selectedDayIndexFromActivity(activity) {
        if (activity && activity.dayIndex !== undefined && activity.dayIndex !== null && !isNaN(activity.dayIndex)) {
            return Number(activity.dayIndex);
        }
        if (activity && activity.day !== undefined && activity.day !== null && !isNaN(activity.day)) {
            return Number(activity.day) - 1;
        }
        return null;
    }

    function getSelectedDayData(activity) {
        var dayIdx = selectedDayIndexFromActivity(activity);
        if (dayIdx === null || isNaN(dayIdx)) return null;
        if (!window.PLAN_DETAIL || !Array.isArray(window.PLAN_DETAIL.itinerary)) return null;
        return window.PLAN_DETAIL.itinerary[dayIdx] || null;
    }

    function findActivityIndexInDay(activity, day) {
        var acts = day && Array.isArray(day.activities) ? day.activities : [];
        if (!activity || !acts.length) return -1;
        for (var i = 0; i < acts.length; i++) {
            var act = acts[i] || {};
            if (activity.id && act.id === activity.id) return i;
            if (activity.googlePlaceId && act.googlePlaceId === activity.googlePlaceId) return i;
            if (activity.time && act.time === activity.time && act.name === activity.name) return i;
        }
        return -1;
    }

    function activeSelectedActivity() {
        return window._liveSelectedActivity || null;
    }

    function selectedActivityBlock(activity) {
        if (!activity) return null;
        return {
            status: activity.status || "진행 중",
            remainingMinutes: activity.remainingMinutes != null ? activity.remainingMinutes : activity.durationMinutes,
            name: activity.name || "",
            location: activity.location || activity.address || "",
            startTime: activity.startTime || activity.time || "-",
            endTime: activity.endTime || activity.end || "-"
        };
    }

    function selectedNextActivityBlock(activity) {
        var day = getSelectedDayData(activity);
        var acts = day && Array.isArray(day.activities) ? day.activities : [];
        var idx = findActivityIndexInDay(activity, day);
        if (idx < 0 || idx >= acts.length - 1) return null;
        var next = acts[idx + 1] || {};
        var leg = day && day.dayRoute && Array.isArray(day.dayRoute.legs) ? day.dayRoute.legs[idx] : null;
        var parts = [];
        if (next.time) parts.push(next.time + " 예정");
        if (leg && leg.distanceMeters != null) parts.push((Number(leg.distanceMeters) / 1000).toFixed(1) + "km");
        if (leg && leg.durationMinutes != null) parts.push(String(leg.durationMinutes) + "분");
        return {
            name: next.name || "",
            startTime: next.time || "",
            distanceText: leg && leg.distanceMeters != null ? (Number(leg.distanceMeters) / 1000).toFixed(1) + "km" : "",
            travelTimeText: leg && leg.durationMinutes != null ? String(leg.durationMinutes) + "분" : "",
            summaryText: parts.join(" · "),
            routeActionLabel: "경로 보기"
        };
    }

    function selectedTrafficRows(activity) {
        var day = getSelectedDayData(activity);
        var idx = findActivityIndexInDay(activity, day);
        var leg = day && day.dayRoute && Array.isArray(day.dayRoute.legs) && idx >= 0 ? day.dayRoute.legs[idx] : null;
        if (leg) {
            var travelLabel = String(leg.travelModesLabelKo || "");
            var travelModes = Array.isArray(leg.travelModes) ? leg.travelModes.map(function (mode) { return String(mode).toUpperCase(); }) : [];
            var isCarLeg = /차|자동차/.test(travelLabel) || travelModes.indexOf("CAR") >= 0 || travelModes.indexOf("DRIVE") >= 0 || travelModes.indexOf("TAXI") >= 0;
            if (isCarLeg) {
                return [];
            }
            var line = leg.travelModesLabelKo || (Array.isArray(leg.travelModes) ? leg.travelModes.join(", ") : "교통");
            if (Array.isArray(leg.lineNames) && leg.lineNames.length) {
                line += " · " + leg.lineNames.join(", ");
            }
            var msgParts = [];
            if (leg.distanceMeters != null) msgParts.push((Number(leg.distanceMeters) / 1000).toFixed(1) + "km");
            if (leg.durationMinutes != null) msgParts.push(String(leg.durationMinutes) + "분");
            if (leg.stepsSummary) msgParts.push(leg.stepsSummary);
            return [{ line: line, status: "normal", message: msgParts.join(" · ") }];
        }
        if (activity && activity.transport) {
            return [{
                line: activity.transport.line || activity.transport.mode || "교통",
                status: "normal",
                message: activity.transport.mode ? String(activity.transport.mode) : "선택 일정 교통 정보"
            }];
        }
        return [];
    }

    function renderEmergency(list) {
        var host = document.getElementById("liveEmergency");
        if (!host) return;
        if (!list || list.length === 0) {
            host.innerHTML = "<p class='live-muted'>연락처 정보 없음</p>";
            return;
        }
        var html = "";
        for (var j = 0; j < list.length; j++) {
            var c = list[j];
            html +=
                "<div class='info-row'>" +
                "<span class='info-name text-gray'>" +
                esc(c.label || "") +
                "</span>" +
                "<span class='info-value'>" +
                esc(c.number || "") +
                "</span></div>";
        }
        host.innerHTML = html;
    }

    function renderRecommendations(items, walkLabel) {
        var host = document.getElementById("liveRecommendations");
        var sub = document.getElementById("liveSpotSubtitle");
        if (sub && walkLabel) sub.textContent = walkLabel;
        if (!host) return;
        if (!items || items.length === 0) {
            host.innerHTML = "<p class='live-muted'>추천 장소 없음</p>";
            return;
        }
        var html = "";
        for (var k = 0; k < items.length; k++) {
            var it = items[k];
            var badge = esc(it.category || it.type || "spot");
            var dist = esc(it.distanceText || "");
            var highlights = "";
            if (Array.isArray(it.highlights) && it.highlights.length) {
                for (var hi = 0; hi < it.highlights.length; hi++) {
                    highlights += (hi ? " &nbsp; " : "") + esc(it.highlights[hi]);
                }
            } else {
                highlights = esc(it.subtitle || "");
            }
            var lat = it.lat != null ? it.lat : "";
            var lng = it.lng != null ? it.lng : "";
            html +=
                "<div class='booking-item' data-lat='" +
                esc(lat) +
                "' data-lng='" +
                esc(lng) +
                "'>" +
                "<div class='place-info'>" +
                "<div class='place-title-row'>" +
                "<h4>" +
                esc(it.name || "") +
                "</h4>" +
                "<span class='badge badge-gray'>" +
                badge +
                "</span></div>" +
                "<p>" +
                dist +
                " &nbsp;" +
                highlights +
                "</p></div>" +
                "<div class='place-action'>" +
                "<button type='button' class='btn-outline' data-action='map'>" +
                esc(it.actionLabel || "위치 보기") +
                "</button></div></div>";
        }
        host.innerHTML = html;
    }

    function renderDashboard(d) {
        if (!d || d.success === false) {
            showError((d && d.message) || "대시보드를 불러오지 못했습니다.");
            return;
        }
        hideError();

        var hintEl = document.getElementById("liveDestinationHint");
        if (hintEl) {
            if (d.destinationLabel || d.destinationCanonical) {
                hintEl.textContent =
                    "목적지: " +
                    (d.destinationLabel || "") +
                    (d.destinationCanonical ? " (" + d.destinationCanonical + ")" : "");
            } else {
                hintEl.textContent = "";
            }
        }

        if (d.currentTimeText) {
            var ct = document.getElementById("currentTime");
            if (ct) ct.textContent = d.currentTimeText;
        }
        if (d.currentDateText) {
            var cd = document.getElementById("currentDate");
            if (cd) cd.textContent = d.currentDateText;
        }

        var selected = activeSelectedActivity();
        var cur = selectedActivityBlock(selected) || d.currentActivity;
        if (cur) {
            var st = document.getElementById("liveActivityStatus");
            if (st) st.textContent = cur.status || "진행 중";
            var rm = document.getElementById("liveRemainingMin");
            if (rm && cur.remainingMinutes != null) rm.textContent = String(cur.remainingMinutes);
            var t1 = document.getElementById("liveActivityTitle");
            if (t1) t1.textContent = cur.name || "";
            var ad = document.getElementById("liveActivityAddress");
            if (ad) ad.textContent = "\uD83D\uDCCD " + (cur.location || "");
            var s1 = document.getElementById("liveActivityStart");
            if (s1) s1.textContent = cur.startTime || "—";
            var e1 = document.getElementById("liveActivityEnd");
            if (e1) e1.textContent = cur.endTime || "—";
        }

        var crowd = d.crowd;
        var crowdLabelEl = document.getElementById("liveCrowdLabel");
        if (crowdLabelEl && crowd) {
            crowdLabelEl.textContent = crowd.label || "—";
            crowdLabelEl.className = "info-value " + crowdLevelClass(crowd.level);
        }
        if (crowd) {
            var cst = document.getElementById("liveCrowdSectionTitle");
            if (cst && crowd.sectionSubtitle) cst.textContent = crowd.sectionSubtitle;
            var cm = document.getElementById("liveCrowdMessage");
            if (cm) cm.textContent = crowd.message || "";
        }

        var next = selectedNextActivityBlock(selected) || d.nextActivity;
        if (next) {
            var nt = document.getElementById("liveNextTitle");
            if (nt) nt.textContent = next.name || "";
            var ns = document.getElementById("liveNextSummary");
            if (ns) {
                ns.textContent =
                    next.summaryText ||
                    [next.startTime, next.distanceText, next.travelTimeText].filter(Boolean).join(" \u00a0\u00b7\u00a0 ");
            }
            var nb = document.getElementById("liveNextRouteBtn");
            if (nb) nb.textContent = next.routeActionLabel || "경로 보기";
        }

        var walkLabel = "도보 10분 이내";
        if (d.instantRecommendations && d.instantRecommendations.length && d.instantRecommendations[0].walkRadiusLabel) {
            walkLabel = d.instantRecommendations[0].walkRadiusLabel;
        }
        renderRecommendations(d.instantRecommendations, walkLabel);
        renderWeather(d.weather);
        var hasDetailedTraffic = !!(d.traffic && d.traffic.length && (d.traffic[0].departureStop || d.traffic[0].delayMinutes != null || d.traffic[0].departureInMinutes != null || d.traffic[0].operator));
        var trafficRows = (!hasDetailedTraffic && selected) ? selectedTrafficRows(selected) : null;
        renderTraffic(hasDetailedTraffic ? d.traffic : (trafficRows && trafficRows.length ? trafficRows : d.traffic));
        renderEmergency(d.emergencyContacts);
    }

    function selectedDay(selected) {
        if (selected && selected.dayIndex !== undefined && selected.dayIndex !== null && !isNaN(selected.dayIndex)) {
            return Number(selected.dayIndex) + 1;
        }
        if (selected && selected.day !== undefined && selected.day !== null && !isNaN(selected.day)) {
            return Number(selected.day);
        }
        return null;
    }

    function selectedLocation(selected) {
        if (!selected || selected.lat === undefined || selected.lng === undefined || selected.lat === null || selected.lng === null || selected.lat === "" || selected.lng === "") {
            return null;
        }
        var lat = Number(selected.lat);
        var lng = Number(selected.lng);
        if (isNaN(lat) || isNaN(lng)) {
            return null;
        }
        return { lat: lat, lng: lng };
    }

    function loadDashboard(focus) {
        var selected = focus || window._liveSelectedActivity || null;
        var body = {
            planId: Number(planId) || 1,
            planDetail: window.PLAN_DETAIL || null,
            day: selectedDay(selected)
        };
        var loc = selectedLocation(selected);
        if (loc) {
            body.lastLocation = loc;
        }

        fetch(ctx + "/live/dashboard-data", {
            method: "POST",
            headers: {
                "Accept": "application/json",
                "Content-Type": "application/json; charset=UTF-8"
            },
            body: JSON.stringify(body)
        })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                renderDashboard(data || {});
            })
            .catch(function (e) {
                console.error(e);
                showError(
                    "실시간 데이터를 불러오지 못했습니다. FastAPI가 실행 중인지, " +
                        "JVM 옵션 fastapi.url(또는 환경변수 FAST_API_URL)이 올바른지 확인하세요."
                );
            });
    }

    window.liveLoadDashboard = loadDashboard;

    var recHost = document.getElementById("liveRecommendations");
    if (recHost) {
        recHost.addEventListener("click", function (ev) {
            var btn = ev.target.closest("[data-action='map']");
            if (!btn) return;
            var card = btn.closest(".booking-item");
            if (!card) return;
            var lat = card.getAttribute("data-lat");
            var lng = card.getAttribute("data-lng");
            if (!lat || !lng) return;
            var mapsUrl = "https://www.google.com/maps/search/?api=1&query=" + encodeURIComponent(lat + "," + lng);
            window.open(mapsUrl, "_blank", "noopener");
        });
    }

    function liveHasLatLng(activity) {
        return !!(activity && activity.lat !== undefined && activity.lng !== undefined && activity.lat !== null && activity.lng !== null && activity.lat !== "" && activity.lng !== "" && !isNaN(Number(activity.lat)) && !isNaN(Number(activity.lng)));
    }

    function liveCoord(activity) {
        return Number(activity.lat) + "," + Number(activity.lng);
    }

    function openLiveRouteFromSelection() {
        var selected = window._liveSelectedActivity || null;
        var routeActivities = [];

        if (selected && window.PLAN_DETAIL && Array.isArray(window.PLAN_DETAIL.itinerary)) {
            var dayIdx = selected.dayIndex !== undefined && selected.dayIndex !== null ? Number(selected.dayIndex) : null;
            if ((dayIdx === null || isNaN(dayIdx)) && selected.day !== undefined && selected.day !== null) {
                dayIdx = Number(selected.day) - 1;
            }
            var day = !isNaN(dayIdx) && window.PLAN_DETAIL.itinerary[dayIdx] ? window.PLAN_DETAIL.itinerary[dayIdx] : null;
            var acts = day && Array.isArray(day.activities) ? day.activities : [];
            var startIdx = acts.findIndex(function (act) {
                return (selected.id && act.id === selected.id) ||
                    (selected.googlePlaceId && act.googlePlaceId === selected.googlePlaceId) ||
                    (selected.time && act.time === selected.time && act.name === selected.name);
            });
            if (startIdx < 0) {
                startIdx = 0;
            }
            routeActivities = acts.slice(startIdx).filter(liveHasLatLng);
        }

        if (routeActivities.length >= 2) {
            var origin = liveCoord(routeActivities[0]);
            var destination = liveCoord(routeActivities[routeActivities.length - 1]);
            var url = "https://www.google.com/maps/dir/?api=1&origin=" + encodeURIComponent(origin) + "&destination=" + encodeURIComponent(destination);
            var waypoints = routeActivities.slice(1, -1).map(liveCoord);
            if (waypoints.length) {
                url += "&waypoints=" + encodeURIComponent(waypoints.join("|"));
            }
            window.open(url, "_blank", "noopener");
            return;
        }

        if (selected && selected.googleMapsUrl) {
            window.open(selected.googleMapsUrl, "_blank", "noopener");
            return;
        }

        if (liveHasLatLng(selected)) {
            window.open("https://www.google.com/maps/search/?api=1&query=" + encodeURIComponent(liveCoord(selected)), "_blank", "noopener");
        }
    }

    var nextRouteBtn = document.getElementById("liveNextRouteBtn");
    if (nextRouteBtn) {
        nextRouteBtn.addEventListener("click", openLiveRouteFromSelection);
    }

    loadDashboard();
    setInterval(function () {
        if (!document.hidden) {
            loadDashboard();
        }
    }, DASHBOARD_POLL_MS);
})();
