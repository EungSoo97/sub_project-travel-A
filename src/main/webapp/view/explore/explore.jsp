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

        <div id="exAutocompleteList" class="ex-search-suggest"></div>
    </form>
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
                        <img src="${empty plan.hotels[0].name ? '/img/default.jpg' : '/img/default.jpg'}">
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
                            <span>#${plan.summary.travelStyle}</span>
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

    input.addEventListener("input", function () {
        const value = this.value.trim();

        list.innerHTML = "";
        currentSuggestions = [];

        if (!value) return;

        fetch("${pageContext.request.contextPath}/search-autocomplete?q=" + encodeURIComponent(value))
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

    // 🔥 엔터 → 첫번째 선택
    input.addEventListener("keydown", function (e) {
        if (e.key === "Enter") {
            e.preventDefault();

            if (currentSuggestions.length > 0) {
                moveToDetail(currentSuggestions[0]);
            }
        }
    });

    function moveToDetail(item) {
        location.href = "${pageContext.request.contextPath}/detail-page?id=" + item.id;
    }

    // 바깥 클릭 → 닫기
    document.addEventListener("click", function (e) {
        if (!e.target.closest(".search-box")) {
            list.innerHTML = "";
        }
    });
</script>

</body>

</html>
