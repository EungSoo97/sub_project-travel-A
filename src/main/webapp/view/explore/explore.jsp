<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<%@ page import="com.es.ta.userreaction.UserreactionDAO" %>

<html>
<head>
    <title>Explore</title>
    <link rel="stylesheet" href="/css/explore.css">
</head>

<body class="explore-body">

<c:if test="${param.reviewSuccess == 'true'}">
    <div class="success-message" style="background-color: #d4edda; color: #155724; padding: 10px; margin: 10px 0; border-radius: 5px; text-align: center;">
        후기 작성이 완료되었습니다!
    </div>
</c:if>
<div class="explore-header">
    <h1>여행 플랜 탐색</h1>
    <p>다른 여행자들의 멋진 여행 계획을 둘러보고 영감을 받아보세요</p>
</div>
<div class="search-box">
    <form id="searchForm" action="${pageContext.request.contextPath}/explore" method="get">
        <div class="search-input-wrap">
            <input
                    type="text"
                    id="searchInput"
                    name="q"
                    placeholder="여행지, 태그, 키워드 검색"
                    value="${param.q}"
            />
            <button type="button" id="searchBtn" class="search-btn" aria-label="검색">🔍</button>
        </div>

        <input type="hidden" id="selectedTagsInput" name="selectedTags" value="${param.selectedTags}" />
        <input type="hidden" id="sortInput" name="sort" value="${sort}" />
    </form>

    <div id="autocompleteList" class="autocomplete-list"></div>
</div>

<div class="search-tag-box">
    <c:forEach var="tag" items="${tagList}">
        <button type="button" class="search-tag" data-value="${tag}">
            #${tag}
        </button>
    </c:forEach>
</div>
<!-- 필터 -->

<div class="filter-box card-box" id="filterBox">
    <div class="filter-header">
        <h3>🔎 필터</h3>
        <div class="filter-header-actions">
            <div class="filter-summary" id="filterSummary" aria-live="polite"></div>
            <button type="button" class="filter-toggle" id="filterToggle" aria-expanded="true" aria-controls="filterContent" aria-label="필터 접기">
                <span class="filter-toggle-icon" aria-hidden="true">-</span>
            </button>
        </div>
    </div>
    <div class="filter-content" id="filterContent">
    <div class="filter-items">
        <button type="button" class="filter-item" data-value="전체">🌍 전체</button>
        <button type="button" class="filter-item" data-value="식도락">🍽 식도락</button>
        <button type="button" class="filter-item" data-value="힐링">🧘 힐링</button>
        <button type="button" class="filter-item" data-value="액티브">🏃 액티브</button>
        <button type="button" class="filter-item" data-value="문화">🏛 문화</button>
        <button type="button" class="filter-item" data-value="쇼핑">🛍 쇼핑</button>
    </div>
    </div>
</div>

<!-- 인기 플랜 -->

<div class="popular-box card-box" id="popularTravelBlock" tabindex="-1">

    <div class="card-header">
        <h2>인기 여행 플랜</h2>
        <select id="sortOrder">
            <option value="popular" ${sort == 'popular' ? 'selected' : ''}>인기순</option>
            <option value="latest" ${sort == 'latest' ? 'selected' : ''}>최신순</option>
        </select>
    </div>

    <div id="cardList" class="card-list">

        <!-- ✅ DB 데이터 반복 -->
        <c:forEach var="plan" items="${planList}">

            <form action="detail-page" method="get">
                <!-- ✅ PK -->
                <input type="hidden" name="id" value="${plan.planId}">

                <div class="card">

                    <div class="card-img">
                        <!-- 이미지 없으면 기본 이미지 -->
                        <img src="${empty plan.hotels[0].name ? '/img/defaultplan/default.jpg' : '/img/defaultplan/default.jpg'}">
                        <span class="price">₩${plan.summary.totalEstimatedCost}</span>
                    </div>

                    <div class="card-body">
                        <div class="user">
                            <span>👤 <c:out value="${empty plan.userName ? '여행자' : plan.userName}" /></span>
                            <c:if test="${not empty plan.postDate}">
                                <span class="post-date"><c:out value="${plan.postDate}" /></span>
                            </c:if>
                        </div>
                        <h3>${plan.summary.destination}</h3>
                        <div class="info">
                            <span>📅 ${plan.summary.days}일</span>
                            <span>👥 ${plan.summary.travelers}명</span>
<%--                            체크 필요--%>
<%--                            <c:set var="currentPlanId" value="${plan.planId}" scope="page"/>--%>
<%--                            <c:set var="currentPlanId" value="${plan.planId}" />--%>
<%--                            <c:set var="currentPlanId" value="${plan.planId}" scope="page"/>--%>
<%--                            <%--%>
<%--                                int likeCount = 0;--%>
<%--                                try {--%>
<%--                                    // Debug: Check if currentPlanId is set--%>
<%--                                    Object planIdObj = pageContext.getAttribute("currentPlanId");--%>
<%--                                    if (planIdObj != null) {--%>
<%--                                        int planId = Integer.parseInt(String.valueOf(planIdObj));--%>
<%--                                        UserreactionDAO dao = new UserreactionDAO();--%>
<%--                                        likeCount = dao.countLikeByPlan(planId);--%>
<%--                                    } else {--%>
<%--                                    }--%>
<%--                                } catch (Exception e) {--%>
<%--                                    e.printStackTrace();--%>
<%--                                }--%>
<%--                            %>--%>
<%--                            <span><%= likeCount %>❤ </span>--%>
                            <span>${plan.likeCnt}❤</span>
                        </div>
                        <div class="tags">
                            <c:forEach var="style" items="${plan.summary.requestStyles}">
                                <span>#${style}</span>
                            </c:forEach>
                            <c:forEach var="theme" items="${plan.summary.requestThemes}">
                                <span>#${theme}</span>
                            </c:forEach>
                            <c:forEach var="tag" items="${plan.summary.customTags}">
                                <span>#${tag}</span>
                            </c:forEach>
                            <span>#${plan.summary.destination}</span>
                        </div>
                        <div>
                            <button class="ui-button" type="submit">자세히 보기</button>
                        </div>
                    </div>
                </div>
            </form>

        </c:forEach>
    </div>

<%--     페이징  아직  하는중 ,,,,--%>
    <c:set var="pageGroupSize" value="5" />
    <c:set var="startPage" value="${((page - 1) / pageGroupSize) * pageGroupSize + 1}" />
    <c:set var="endPage" value="${startPage + pageGroupSize - 1}" />
    <c:if test="${endPage > totalPage}">
        <c:set var="endPage" value="${totalPage}" />
    </c:if>

    <div id="pagination" class="pagination">

        <!-- 이전 페이지 -->
        <c:if test="${page > 1}">
            <c:url var="prevUrl" value="/explore">
                <c:param name="page" value="${page-1}"/>
                <c:param name="sort" value="${sort}"/>
                <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
                <c:if test="${not empty selectedTags}"><c:param name="selectedTags" value="${selectedTags}"/></c:if>
            </c:url>
            <a href="${prevUrl}" class="page-nav prev">‹</a>
        </c:if>

        <!-- 현재 5개 그룹만 출력 -->
        <c:forEach var="i" begin="${startPage}" end="${endPage}">
            <c:url var="pageUrl" value="/explore">
                <c:param name="page" value="${i}"/>
                <c:param name="sort" value="${sort}"/>
                <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
                <c:if test="${not empty selectedTags}"><c:param name="selectedTags" value="${selectedTags}"/></c:if>
            </c:url>
            <a href="${pageUrl}" class="page-number ${i == page ? 'is-current' : ''}">${i}</a>
        </c:forEach>

        <!-- 다음 페이지 -->
        <c:if test="${page < totalPage}">
            <c:url var="nextUrl" value="/explore">
                <c:param name="page" value="${page+1}"/>
                <c:param name="sort" value="${sort}"/>
                <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
                <c:if test="${not empty selectedTags}"><c:param name="selectedTags" value="${selectedTags}"/></c:if>
            </c:url>
            <a href="${nextUrl}" class="page-nav next">›</a>
        </c:if>
    </div>
<script>
    const searchBtn = document.getElementById("searchBtn");
    const searchForm = document.getElementById("searchForm");
    const searchInput = document.getElementById("searchInput");
    const selectedTagsInput = document.getElementById("selectedTagsInput");
    const autocompleteList = document.getElementById("autocompleteList");
    const sortOrder = document.getElementById("sortOrder");
    const sortInput = document.getElementById("sortInput");
    const cardList = document.getElementById("cardList");
    const pagination = document.getElementById("pagination");
    const popularTravelBlock = document.getElementById("popularTravelBlock");
    const contextPath = "${pageContext.request.contextPath}";
    const focusPopularBlockAfterSearchKey = "focusPopularBlockAfterExploreSearch";
    let isLoadingPlans = false;

    const filterBox = document.getElementById("filterBox");
    const filterToggle = document.getElementById("filterToggle");
    const filterToggleIcon = filterToggle ? filterToggle.querySelector(".filter-toggle-icon") : null;
    const filterSummary = document.getElementById("filterSummary");
    const filterButtons = document.querySelectorAll(".filter-item");
    const tagButtons = document.querySelectorAll(".search-tag");
    const allButtons = [...filterButtons, ...tagButtons];

    const selectedTags = new Set();

    let currentSuggestions = [];
    let activeIndex = -1;
    let latestRequestKeyword = "";

    function normalize(text) {
        return (text || "").toLowerCase().replace(/#/g, "").trim();
    }

    function splitTokens(text) {
        return (text || "")
            .split(/[\s,]+/)
            .map(token => normalize(token))
            .filter(token => token.length > 0);
    }

    function escapeHtml(str) {
        return String(str)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    function escapeRegExp(str) {
        return String(str).replace(/[.*+?^$()|[\]\\{}]/g, "\\$&");
    }

    function highlightKeyword(text, keyword) {
        const safeText = escapeHtml(text || "");
        const trimmedKeyword = (keyword || "").trim();
        if (!trimmedKeyword) return safeText;

        const pattern = new RegExp("(" + escapeRegExp(trimmedKeyword) + ")", "gi");
        return safeText.replace(pattern, '<span class="search-highlight">$1</span>');
    }

    function updateHiddenInput() {
        selectedTagsInput.value = Array.from(selectedTags).join(",");
    }

    function getSelectedFilterLabels() {
        const activeFilters = [...filterButtons].filter(btn => btn.classList.contains("active"));
        const nonWholeFilters = activeFilters.filter(btn => normalize(btn.dataset.value) !== "전체");
        const visibleFilters = nonWholeFilters.length ? nonWholeFilters : activeFilters;

        return visibleFilters.map(btn => btn.textContent.trim());
    }

    function updateFilterSummary() {
        if (!filterSummary) return;

        const labels = getSelectedFilterLabels();
        filterSummary.innerHTML = "";

        if (!labels.length) {
            const chip = document.createElement("span");
            chip.className = "filter-summary-chip";
            chip.textContent = "전체";
            filterSummary.appendChild(chip);
            return;
        }

        labels.forEach(label => {
            const chip = document.createElement("span");
            chip.className = "filter-summary-chip";
            chip.textContent = label;
            filterSummary.appendChild(chip);
        });
    }

    function setFilterCollapsed(isCollapsed) {
        if (!filterBox || !filterToggle || !filterToggleIcon) return;

        filterBox.classList.toggle("is-collapsed", isCollapsed);
        filterToggle.setAttribute("aria-expanded", String(!isCollapsed));
        filterToggle.setAttribute("aria-label", isCollapsed ? "Open filters" : "Close filters");
        filterToggleIcon.textContent = isCollapsed ? "+" : "-";
        updateFilterSummary();
    }

    function focusPopularTravelBlock() {
        if (!popularTravelBlock) return;

        const startY = window.scrollY;
        const targetY = popularTravelBlock.getBoundingClientRect().top + window.scrollY;
        const distance = targetY - startY;
        const duration = 160;
        const startTime = performance.now();

        function scrollFrame(now) {
            const progress = Math.min((now - startTime) / duration, 1);
            const easedProgress = 1 - Math.pow(1 - progress, 3);

            window.scrollTo(0, startY + distance * easedProgress);

            if (progress < 1) {
                requestAnimationFrame(scrollFrame);
            } else {
                popularTravelBlock.focus({ preventScroll: true });
            }
        }

        requestAnimationFrame(scrollFrame);
    }

    function addToInput(value) {
        const normalizedValue = normalize(value);
        const currentTokens = splitTokens(searchInput.value);

        if (!currentTokens.includes(normalizedValue)) {
            searchInput.value = searchInput.value.trim()
                ? searchInput.value.trim() + " " + value
                : value;
        }
    }

    function removeFromInput(value) {
        const normalizedValue = normalize(value);
        const newTokens = splitTokens(searchInput.value)
            .filter(token => token !== normalizedValue);

        searchInput.value = newTokens.join(" ");
    }

    function clearAutocomplete() {
        autocompleteList.innerHTML = "";
        currentSuggestions = [];
        activeIndex = -1;
    }

    function clearAllSelections() {
        allButtons.forEach(btn => btn.classList.remove("active"));
        selectedTags.clear();
    }

    function setWholeButtonState() {
        const wholeButton = [...filterButtons].find(
            btn => normalize(btn.dataset.value) === "전체"
        );

        if (!wholeButton) return;

        if (selectedTags.size === 0 && searchInput.value.trim() === "") {
            wholeButton.classList.add("active");
        } else {
            wholeButton.classList.remove("active");
        }
    }

    function updateActiveStateFromInput() {
        clearAllSelections();

        const tokensFromInput = splitTokens(searchInput.value);
        const allTokens = [...new Set(tokensFromInput)];

        allButtons.forEach(btn => {
            const value = normalize(btn.dataset.value);
            if (value === "전체") return;

            const matched = allTokens.some(token =>
                token === value || token.includes(value) || value.includes(token)
            );

            if (matched) {
                btn.classList.add("active");
                selectedTags.add(btn.dataset.value);
            }
        });

        setWholeButtonState();
        updateFilterSummary();
    }

    function renderSuggestions(data, keyword) {
        autocompleteList.innerHTML = "";

        if (!data || data.length === 0) {
            clearAutocomplete();
            return;
        }

        currentSuggestions = data;
        activeIndex = -1;

        data.forEach((item, index) => {
            const div = document.createElement("div");
            div.className = "autocomplete-item";
            div.dataset.index = index;

            const mainText = item.text || item.title || item.destination || "";
            const subText =
                item.destination && item.destination !== mainText
                    ? item.destination
                    : (item.travelStyle || "");

            div.innerHTML =
                '<div>' + highlightKeyword(mainText, keyword) + '</div>' +
                (subText ? '<small>' + escapeHtml(subText) + '</small>' : '');

            div.addEventListener("mouseenter", function () {
                activeIndex = index;
                updateActiveItem();
            });

            div.addEventListener("mousedown", function (e) {
                e.preventDefault();
                applySuggestion(item);
            });

            autocompleteList.appendChild(div);
        });
    }

    function updateActiveItem() {
        const items = autocompleteList.querySelectorAll(".autocomplete-item");
        items.forEach(item => item.classList.remove("is-active"));

        if (activeIndex >= 0 && items[activeIndex]) {
            items[activeIndex].classList.add("is-active");
            items[activeIndex].scrollIntoView({ block: "nearest" });
        }
    }

    function applySuggestion(item) {
        clearAutocomplete();
        const value = item.text || item.title || item.destination || "";
        searchInput.value = value;
        updateActiveStateFromInput();
        updateHiddenInput();
    }

    function toggleButton(button) {
        const value = button.dataset.value;
        const normalizedValue = normalize(value);

        if (normalizedValue === "전체") {
            clearAllSelections();
            searchInput.value = "";
            clearAutocomplete();
            updateHiddenInput();
            setWholeButtonState();
            updateFilterSummary();
            return;
        }

        filterButtons.forEach(btn => {
            if (normalize(btn.dataset.value) === "전체") {
                btn.classList.remove("active");
            }
        });

        const isActive = button.classList.contains("active");

        if (isActive) {
            button.classList.remove("active");
            selectedTags.delete(value);
            removeFromInput(value);
        } else {
            button.classList.add("active");
            selectedTags.add(value);
            addToInput(value);
        }

        updateHiddenInput();
        setWholeButtonState();
        updateFilterSummary();
        searchInput.dispatchEvent(new Event("input"));
        searchInput.focus();
    }

    searchInput.addEventListener("input", function () {
        const value = this.value.trim();

        updateActiveStateFromInput();
        updateHiddenInput();
        clearAutocomplete();

        if (!value) {
            setWholeButtonState();
            return;
        }

        latestRequestKeyword = value;

        fetch("${pageContext.request.contextPath}/search-autocomplete?q=" + encodeURIComponent(value))
            .then(res => {
                if (!res.ok) throw new Error("자동완성 요청 실패: " + res.status);
                return res.json();
            })
            .then(data => {
                console.log("autocomplete data =", data);
                if (searchInput.value.trim() !== latestRequestKeyword) return;
                renderSuggestions(data, value);
            })
            .catch(err => {
                console.error("자동완성 오류:", err);
                clearAutocomplete();
            });
    });

    searchInput.addEventListener("keydown", function (e) {
        if (e.key === "ArrowDown") {
            if (!currentSuggestions.length) return;
            e.preventDefault();
            activeIndex = (activeIndex + 1) % currentSuggestions.length;
            updateActiveItem();
            return;
        }

        if (e.key === "ArrowUp") {
            if (!currentSuggestions.length) return;
            e.preventDefault();
            activeIndex = (activeIndex - 1 + currentSuggestions.length) % currentSuggestions.length;
            updateActiveItem();
            return;
        }

        if (e.key === "Escape") {
            clearAutocomplete();
            return;
        }

        if (e.key === "Enter") {
            e.preventDefault();
            if (currentSuggestions.length > 0 && activeIndex >= 0) {
                applySuggestion(currentSuggestions[activeIndex]);
            }
        }
    });

    allButtons.forEach(button => {
        button.addEventListener("click", function () {
            toggleButton(this);
        });
    });

    if (filterToggle) {
        filterToggle.addEventListener("click", function () {
            setFilterCollapsed(!filterBox.classList.contains("is-collapsed"));
        });
    }

    document.addEventListener("click", function (e) {
        if (!e.target.closest(".search-box")) {
            clearAutocomplete();
        }
    });

    window.addEventListener("DOMContentLoaded", function () {
        updateActiveStateFromInput();
        updateHiddenInput();
        updateFilterSummary();

        if (sessionStorage.getItem(focusPopularBlockAfterSearchKey) === "true") {
            sessionStorage.removeItem(focusPopularBlockAfterSearchKey);
            setFilterCollapsed(true);
            window.setTimeout(focusPopularTravelBlock, 120);
        }
    });

    searchBtn.addEventListener("click", function () {
        updateActiveStateFromInput();
        updateHiddenInput();
        clearAutocomplete();
        setFilterCollapsed(true);
        sessionStorage.setItem(focusPopularBlockAfterSearchKey, "true");
        searchForm.submit();
    });

    sortOrder.addEventListener("change", function () {
        sortInput.value = this.value;
        loadExploreSection({sort: this.value, page: 1, pushState: true});
    });

    pagination.addEventListener("click", function (e) {
        const link = e.target.closest("a");
        if (!link) return;

        e.preventDefault();
        const url = new URL(link.href, window.location.origin);
        const page = Number(url.searchParams.get("page") || 1);
        const sort = url.searchParams.get("sort") || sortOrder.value || "popular";
        loadExploreSection({sort, page, pushState: true});
    });

    window.addEventListener("popstate", function () {
        const params = new URLSearchParams(window.location.search);
        const sort = params.get("sort") || "popular";
        const page = Number(params.get("page") || 1);
        const q = params.get("q") || "";
        const tags = params.get("selectedTags") || "";

        searchInput.value = q;
        selectedTagsInput.value = tags;
        sortInput.value = sort;
        sortOrder.value = sort;
        updateActiveStateFromInput();

        loadExploreSection({sort, page, pushState: false});
    });

    function loadExploreSection({sort, page, pushState}) {
        if (isLoadingPlans) return;

        isLoadingPlans = true;
        sortOrder.disabled = true;
        cardList.style.opacity = "0.55";
        pagination.style.opacity = "0.55";

        const targetUrl = new URL(contextPath + "/explore", window.location.origin);
        targetUrl.searchParams.set("sort", sort);
        if (page > 1) {
            targetUrl.searchParams.set("page", page);
        }
        const currentQ = searchInput.value.trim();
        const currentTags = selectedTagsInput.value.trim();
        if (currentQ) targetUrl.searchParams.set("q", currentQ);
        if (currentTags) targetUrl.searchParams.set("selectedTags", currentTags);

        fetch(targetUrl.toString(), {
            headers: {"X-Requested-With": "XMLHttpRequest"}
        })
            .then(res => {
                if (!res.ok) throw new Error("Failed to load explore page");
                return res.text();
            })
            .then(html => {
                const parsed = new DOMParser().parseFromString(html, "text/html");
                const nextCardList = parsed.querySelector("#cardList");
                const nextPagination = parsed.querySelector("#pagination");
                const nextSortOrder = parsed.querySelector("#sortOrder");

                if (!nextCardList || !nextPagination || !nextSortOrder) {
                    throw new Error("Explore fragment not found");
                }

                cardList.innerHTML = nextCardList.innerHTML;
                pagination.innerHTML = nextPagination.innerHTML;
                sortOrder.value = nextSortOrder.value;

                if (pushState) {
                    window.history.pushState({}, "", targetUrl);
                }
            })
            .catch(() => {
                window.location.href = targetUrl.toString();
            })
            .finally(() => {
                isLoadingPlans = false;
                sortOrder.disabled = false;
                cardList.style.opacity = "1";
                pagination.style.opacity = "1";
            });
    }
</script>
</body>

</html>
