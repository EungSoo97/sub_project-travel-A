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
            var statusClass = isNormal ? "good" : "warning";
            var textClass = isNormal ? "status-text good" : "status-text warning";
            html +=
                "<div class='info-row'>" +
                "<span class='info-name'>" +
                esc(row.line || "") +
                "</span>" +
                "<span class='" +
                textClass +
                "'>" +
                trafficRowSvg(isNormal) +
                esc(row.message || "") +
                "</span></div>";
        }
        host.innerHTML = html;
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
        var h = "";
        for (var k = 0; k < items.length; k++) {
            var it = items[k];
            var badge = esc(it.category || it.type || "spot");
            var dist = esc(it.distanceText || "");
            var highlights = "";
            if (Array.isArray(it.highlights) && it.highlights.length) {
                for (var h = 0; h < it.highlights.length; h++) {
                    highlights += (h ? " &nbsp; " : "") + esc(it.highlights[h]);
                }
            } else {
                highlights = esc(it.subtitle || "");
            }
            var lat = it.lat != null ? it.lat : "";
            var lng = it.lng != null ? it.lng : "";
            h +=
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
                "<button type='button' class='btn-outline' data-action='map'>" +
                esc(it.actionLabel || "위치 보기") +
                "</button></div>";
        }
        host.innerHTML = h;
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

        var cur = d.currentActivity;
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

        var next = d.nextActivity;
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
        renderTraffic(d.traffic);
        renderEmergency(d.emergencyContacts);
    }

    function loadDashboard() {
        var url = ctx + "/live/dashboard-data?planId=" + encodeURIComponent(planId);
        if (destHint) {
            url += "&destination=" + encodeURIComponent(destHint);
        }
        fetch(url, { headers: { Accept: "application/json" } })
            .then(function (r) {
                if (!r.ok) {
                    return r.text().then(function (t) {
                        throw new Error("HTTP " + r.status + " " + t);
                    });
                }
                return r.json();
            })
            .then(renderDashboard)
            .catch(function (e) {
                console.error(e);
                showError(
                    "실시간 데이터를 불러오지 못했습니다. FastAPI가 실행 중인지, " +
                        "JVM 옵션 fastapi.url(또는 환경변수 FAST_API_URL)이 올바른지 확인하세요."
                );
            });
    }

    loadDashboard();
    setInterval(function () {
        if (!document.hidden) {
            loadDashboard();
        }
    }, DASHBOARD_POLL_MS);
})();
