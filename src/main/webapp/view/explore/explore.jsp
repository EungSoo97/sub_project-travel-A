<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Explore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/explore.css">
</head>

<body class="explore-body">

<c:if test="${param.reviewSuccess == 'true'}">
    <div class="success-message"
         style="background-color: #d4edda; color: #155724; padding: 10px; margin: 10px 0; border-radius: 5px; text-align: center;">
        &#54980;&#44592; &#51089;&#49457;&#51060; &#50756;&#47308;&#46104;&#50632;&#49845;&#45768;&#45796;.
    </div>
</c:if>

<div class="explore-header">
    <h1>&#50668;&#54665; &#54540;&#47004; &#53456;&#49353;</h1>
    <p>&#45796;&#47480; &#50668;&#54665;&#51088;&#46308;&#51032; &#50668;&#54665; &#44228;&#54925;&#51012; &#46168;&#47084;&#48372;&#44256; &#50689;&#44048;&#51012; &#48155;&#50500;&#48372;&#49464;&#50836;.</p>
</div>

<div class="search-box">
    <div class="search-wrap">
        <input type="text"
               id="searchInput"
               placeholder="&#50668;&#54665;&#51648;, &#53412;&#50892;&#46300; &#44160;&#49353;..."
               autocomplete="off"/>
    </div>
    <div id="autocompleteList" class="autocomplete-list"></div>
</div>

<div class="filter-box card-box">
    <h3>&#x1F50E; &#54596;&#53552;</h3>
    <div class="filter-items">
        <div class="filter-item active">&#x1F30D; &#51204;&#52404;</div>
        <div class="filter-item">&#x1F37D; &#49885;&#46020;&#46973;</div>
        <div class="filter-item">&#x1F9D8; &#55184;&#47553;</div>
        <div class="filter-item">&#x1F3C3; &#50529;&#54000;&#48652;</div>
        <div class="filter-item">&#x1F3DB; &#47928;&#54868;</div>
        <div class="filter-item">&#x1F6CD; &#49660;&#54609;</div>
    </div>
</div>

<div class="popular-box card-box">
    <div class="card-header">
        <h2>&#x1F3C6; &#51064;&#44592; &#50668;&#54665; &#54540;&#47004;</h2>
        <select id="sortOrder">
            <option value="popular" ${sort == 'popular' ? 'selected' : ''}>&#51064;&#44592;&#49692;</option>
            <option value="latest" ${sort == 'latest' ? 'selected' : ''}>&#52572;&#49888;&#49692;</option>
        </select>
    </div>

    <div id="cardList" class="card-list">
        <c:forEach var="plan" items="${planList}">
            <form action="${pageContext.request.contextPath}/detail-page" method="get">
                <input type="hidden" name="id" value="${plan.planId}">
                <div class="card">
                    <div class="card-img">
                        <img src="/img/defaultplan/default.jpg" alt="travel plan thumbnail">
                        <span class="price">&#8361;${plan.summary.totalEstimatedCost}</span>
                    </div>

                    <div class="card-body">
                        <span class="card-date">&#x1F5D3; ${plan.createdAt}</span>
                        <div class="user">&#x1F464; &#50668;&#54665;&#51088;</div>
                        <h3>${plan.summary.destination}</h3>
                        <div class="info">
                            <span>&#x1F4C5; ${plan.summary.days}&#51068;</span>
                            <span>&#x1F465; ${plan.summary.travelers}&#47749;</span>
                            <span>&#x2764; ${plan.likeCnt}</span>
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
                            <button class="ui-button" type="submit">&#51088;&#49464;&#55176; &#48372;&#44592;</button>
                        </div>
                    </div>
                </div>
            </form>
        </c:forEach>
    </div>

    <div id="pagination" class="pagination">
        <c:if test="${page > 1}">
            <a href="${pageContext.request.contextPath}/explore?page=${page - 1}&sort=${sort}">&#51060;&#51204;</a>
        </c:if>
        <c:forEach var="i" begin="1" end="${totalPage}">
            <a href="${pageContext.request.contextPath}/explore?page=${i}&sort=${sort}"
               style="${i == page ? 'font-weight:bold;' : ''}">${i}</a>
        </c:forEach>
        <c:if test="${page < totalPage}">
            <a href="${pageContext.request.contextPath}/explore?page=${page + 1}&sort=${sort}">&#45796;&#51020;</a>
        </c:if>
    </div>
</div>

<script>
    const input = document.getElementById("searchInput");
    const list = document.getElementById("autocompleteList");
    const sortOrder = document.getElementById("sortOrder");
    const cardList = document.getElementById("cardList");
    const pagination = document.getElementById("pagination");
    const contextPath = "${pageContext.request.contextPath}";

    let currentSuggestions = [];
    let isLoadingPlans = false;

    input.addEventListener("input", function () {
        const value = this.value.trim();

        list.innerHTML = "";
        currentSuggestions = [];

        if (!value) {
            return;
        }

        fetch(contextPath + "/search-autocomplete?q=" + encodeURIComponent(value))
            .then(res => res.json())
            .then(data => {
                currentSuggestions = data;

                data.forEach(item => {
                    const div = document.createElement("div");
                    div.className = "autocomplete-item";
                    div.textContent = item.text;
                    div.onclick = function () {
                        moveToDetail(item);
                    };
                    list.appendChild(div);
                });
            });
    });

    input.addEventListener("keydown", function (e) {
        if (e.key === "Enter") {
            e.preventDefault();
            if (currentSuggestions.length > 0) {
                moveToDetail(currentSuggestions[0]);
            }
        }
    });

    document.addEventListener("click", function (e) {
        if (!e.target.closest(".search-box")) {
            list.innerHTML = "";
        }
    });

    sortOrder.addEventListener("change", function () {
        loadExploreSection({sort: this.value, page: 1, pushState: true});
    });

    pagination.addEventListener("click", function (e) {
        const link = e.target.closest("a");
        if (!link) {
            return;
        }

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
        loadExploreSection({sort, page, pushState: false});
    });

    function moveToDetail(item) {
        location.href = contextPath + "/detail-page?id=" + item.id;
    }

    function loadExploreSection({sort, page, pushState}) {
        if (isLoadingPlans) {
            return;
        }

        isLoadingPlans = true;
        sortOrder.disabled = true;
        cardList.style.opacity = "0.55";
        pagination.style.opacity = "0.55";

        const targetUrl = new URL(contextPath + "/explore", window.location.origin);
        targetUrl.searchParams.set("sort", sort);
        if (page > 1) {
            targetUrl.searchParams.set("page", page);
        }

        fetch(targetUrl.toString(), {
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        })
            .then(res => {
                if (!res.ok) {
                    throw new Error("Failed to load explore page");
                }
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