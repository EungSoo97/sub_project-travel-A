<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/liveSelect.css">

<div class="live-select-wrap">
    <div class="live-select-header">
        <h1>실시간 여행 시작</h1>
        <p>실시간으로 관리할 여행 플랜을 선택하세요</p>
    </div>

    <div class="live-select-box">
        <h2 class="live-select-title">내 여행 플랜 선택</h2>
        <p class="live-select-subtitle">실시간으로 확인할 여행 플랜을 골라보세요</p>

        <form action="${pageContext.request.contextPath}/live-select" method="get" class="live-select-form" autocomplete="off">
            <div class="live-select-autocomplete">
                <div class="live-select-input-wrap">
                    <span class="live-select-search-icon">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                             stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                    </span>

                    <input type="text"
                           id="planKeyword"
                           name="planKeyword"
                           class="live-select-input"
                           placeholder="플랜명 또는 목적지 검색"
                           value="${planKeyword}">
                </div>

                <div id="autocompleteList" class="autocomplete-list"></div>
            </div>

            <button type="submit" class="live-select-btn">검색하기</button>
        </form>

        <div class="live-select-result-list">
            <c:choose>
                <c:when test="${empty planSearchList}">
                    <div class="live-select-empty">검색된 여행 플랜이 없습니다.</div>
                </c:when>

                <c:otherwise>
                    <c:forEach var="plan" items="${planSearchList}">
                        <div class="live-plan-card">
                            <div class="live-plan-card-top">
                                <div class="live-plan-main">
                                    <div class="live-plan-title">${plan.displayTitle}</div>
                                    <div class="live-plan-destination">목적지: ${plan.destination}</div>
                                </div>
                                <span class="live-plan-status ${plan.statusClass}">${plan.status}</span>
                            </div>

                            <div class="live-plan-date">
                                여행 기간: ${plan.startDate} ~ ${plan.endDate}
                            </div>

                            <div class="live-plan-meta">
                                <span>${plan.days}일</span>
                                <span class="meta-dot">·</span>
                                <span>${plan.travelers}명</span>
                                <span class="meta-dot">·</span>
                                <span>${plan.travelStyle}</span>
                            </div>

                            <a class="live-plan-start-btn"
                               href="${pageContext.request.contextPath}/my-live?planId=${plan.planId}&destination=${plan.destination}">
                                이 플랜으로 시작
                            </a>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const input = document.getElementById("planKeyword");
        const list = document.getElementById("autocompleteList");
        const contextPath = "${pageContext.request.contextPath}";

        if (!input || !list) return;

        input.addEventListener("input", function () {
            const keyword = input.value.trim();

            if (keyword.length < 1) {
                list.innerHTML = "";
                list.style.display = "none";
                return;
            }

            fetch(contextPath + "/live-search-suggest?keyword=" + encodeURIComponent(keyword))
                .then(res => res.json())
                .then(data => {
                    list.innerHTML = "";

                    if (!data.success || !data.suggestions || data.suggestions.length === 0) {
                        list.style.display = "none";
                        return;
                    }

                    data.suggestions.forEach(plan => {
                        const item = document.createElement("div");
                        item.className = "autocomplete-item";

                        const title = plan.title && plan.title.trim() !== ""
                            ? plan.title
                            : (plan.destination ? plan.destination + " 여행" : "저장된 여행");

                        item.innerHTML =
                            '<div class="autocomplete-item-title">' + title + '</div>' +
                            '<div class="autocomplete-item-sub">' + (plan.destination || '') + '</div>';

                        item.addEventListener("click", function () {
                            input.value = title;
                            list.innerHTML = "";
                            list.style.display = "none";
                        });

                        list.appendChild(item);
                    });

                    list.style.display = "block";
                })
                .catch(function (err) {
                    console.error(err);
                    list.innerHTML = "";
                    list.style.display = "none";
                });
        });

        document.addEventListener("click", function (e) {
            if (!e.target.closest(".live-select-autocomplete")) {
                list.innerHTML = "";
                list.style.display = "none";
            }
        });
    });
</script>