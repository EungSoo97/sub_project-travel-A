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
    <div class="search-wrap">
        <input type="text"
               id="searchInput"
               placeholder="여행지, 키워드 검색..."
               autocomplete="off" />
    </div>

    <div id="autocompleteList" class="autocomplete-list"></div>
</div>


<div class="search-tag-box">
    <c:forEach var="tag" items="${tagList}">
        <span class="search-tag" data-keyword="${tag}">#${tag}</span>
    </c:forEach>
</div>
<!-- 필터 -->

<div class="filter-box card-box">
    <h3>🔎 필터</h3>
    <div class="filter-items">
        <div class="filter-item active">🌍 전체</div>
        <div class="filter-item">🍽 미식</div>
        <div class="filter-item">🧘 힐링</div>
        <div class="filter-item">🏃 액티브</div>
        <div class="filter-item">🏛 문화</div>
        <div class="filter-item">🛍 쇼핑</div>
    </div>
</div>

<!-- 인기 플랜 -->

<div class="popular-box card-box">

    <div class="card-header">
        <h2>인기 여행 플랜</h2>
        <select>
            <option>인기순</option>
            <option>최신순</option>
        </select>
    </div>

    <div class="card-list">

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
                        <div class="user">👤 여행자</div>
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
    <div class="pagination">
        <c:if test="${page > 1}">
            <a href="?page=${page-1}">이전</a>
        </c:if>
        <c:forEach var="i" begin="1" end="${totalPage}">
            <a href="?page=${i}"
               style="${i == page ? 'font-weight:bold;' : ''}">
                    ${i}
            </a>
        </c:forEach>

        <c:if test="${page < totalPage}">
            <a href="?page=${page+1}">다음</a>
        </c:if>

    </div>

</div>
<script>
    const input = document.getElementById("searchInput");
    const list = document.getElementById("autocompleteList");

    let currentSuggestions = [];
    let activeIndex = -1;
    let latestRequestKeyword = "";

    input.addEventListener("input", function () {
        const value = this.value.trim();

        list.innerHTML = "";
        currentSuggestions = [];
        activeIndex = -1;

        if (!value) return;

        latestRequestKeyword = value;

        fetch("${pageContext.request.contextPath}/search-autocomplete?q=" + encodeURIComponent(value))
            .then(res => res.json())
            .then(data => {
                if (input.value.trim() !== latestRequestKeyword) {
                    return;
                }

                currentSuggestions = data;
                renderSuggestions(data, value);
            })
            .catch(err => {
                console.error("자동완성 오류:", err);
            });
    });

    input.addEventListener("keydown", function (e) {
        if (!currentSuggestions.length) {
            if (e.key === "Enter") {
                e.preventDefault();
            }
            return;
        }

        if (e.key === "ArrowDown") {
            e.preventDefault();
            activeIndex = (activeIndex + 1) % currentSuggestions.length;
            updateActiveItem();
        } else if (e.key === "ArrowUp") {
            e.preventDefault();
            activeIndex = (activeIndex - 1 + currentSuggestions.length) % currentSuggestions.length;
            updateActiveItem();
        } else if (e.key === "Enter") {
            e.preventDefault();

            if (activeIndex >= 0 && activeIndex < currentSuggestions.length) {
                moveToDetail(currentSuggestions[activeIndex]);
            } else {
                moveToDetail(currentSuggestions[0]);
            }
        } else if (e.key === "Escape") {
            list.innerHTML = "";
            activeIndex = -1;
        }
    });

    function renderSuggestions(data, keyword) {
        list.innerHTML = "";

        data.forEach((item, index) => {
            const div = document.createElement("div");
            div.className = "autocomplete-item";
            div.dataset.index = index;
            div.innerHTML = highlightKeyword(item.text, keyword);

            div.addEventListener("mouseenter", function () {
                activeIndex = index;
                updateActiveItem();
            });

            div.addEventListener("mousedown", function (e) {
                e.preventDefault();
                moveToDetail(item);
            });

            list.appendChild(div);
        });
    }

    function updateActiveItem() {
        const items = list.querySelectorAll(".autocomplete-item");

        items.forEach(item => item.classList.remove("is-active"));

        if (activeIndex >= 0 && items[activeIndex]) {
            items[activeIndex].classList.add("is-active");
            items[activeIndex].scrollIntoView({ block: "nearest" });
        }
    }

    function moveToDetail(item) {
        list.innerHTML = "";
        activeIndex = -1;
        location.href = "${pageContext.request.contextPath}/detail-page?id=" + item.id;
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
        return String(str).replace(/[.*+?\^$\{\}()|[\]\\]/g, "\\$&");
    }

    function highlightKeyword(text, keyword) {
        const safeText = escapeHtml(text);
        const trimmedKeyword = keyword.trim();

        if (!trimmedKeyword) return safeText;

        const pattern = new RegExp("(" + escapeRegExp(trimmedKeyword) + ")", "gi");
        return safeText.replace(pattern, '<span class="search-highlight">$1</span>');
    }

    document.addEventListener("click", function (e) {
        if (!e.target.closest(".search-box")) {
            list.innerHTML = "";
            activeIndex = -1;
        }
    });

    // ✅ 태그 클릭 시 검색창에 넣고 자동완성 실행
    document.addEventListener("click", function (e) {
        const tag = e.target.closest(".search-tag");
        if (!tag) return;

        const keyword = tag.dataset.keyword || tag.textContent.replace("#", "").trim();
        input.value = keyword;
        input.dispatchEvent(new Event("input"));
        input.focus();
    });
</script>

</body>

</html>
