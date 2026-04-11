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
    <form action="${pageContext.request.contextPath}/explore" method="get">
        <input type="text"
               name="q"
               value="${param.q}"
               placeholder="여행지, 키워드, 작성자 검색..." />
        <button type="submit" class="search-btn">검색</button>
    </form>
</div>

<div class="search-box">
    <form action="${pageContext.request.contextPath}/explore" method="get" class="search-form">
        <input type="text" name="q" placeholder="여행지, 키워드, 작성자 검색..." />
        <button type="submit" class="search-btn">검색</button>
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
                            <c:set var="currentPlanId" value="${plan.planId}" />
                            <c:set var="currentPlanId" value="${plan.planId}" scope="page"/>
                            <%
                                int likeCount = 0;
                                try {
                                    // Debug: Check if currentPlanId is set
                                    Object planIdObj = pageContext.getAttribute("currentPlanId");

                                    if (planIdObj != null) {
                                        int planId = Integer.parseInt(String.valueOf(planIdObj));

                                        UserreactionDAO dao = new UserreactionDAO();
                                        likeCount = dao.countLikeByPlan(planId);
                                    } else {
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                            <span><%= likeCount %>❤ </span>
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


</div>
<script>
    function searchPlan() {
        const keyword = document.getElementById("searchInput").value.trim().toLowerCase();

        if (!keyword) {
            alert("검색어를 입력해주세요.");
            return;
        }

        // ✅ 임시 하드코딩 데이터
        const plans = [
            {
                id: 1,
                destination: "도쿄",
                writer: "예진",
                keywords: ["도쿄", "쇼핑", "도심", "야경", "예진"]
            },
            {
                id: 2,
                destination: "오사카",
                writer: "민준",
                keywords: ["오사카", "미식", "맛집", "민준"]
            },
            {
                id: 3,
                destination: "교토",
                writer: "서연",
                keywords: ["교토", "힐링", "문화", "사찰", "서연"]
            },
            {
                id: 4,
                destination: "후쿠오카",
                writer: "지훈",
                keywords: ["후쿠오카", "온천", "힐링", "지훈"]
            }
        ];

        const matchedPlan = plans.find(plan =>
            plan.destination.toLowerCase().includes(keyword) ||
            plan.writer.toLowerCase().includes(keyword) ||
            plan.keywords.some(k => k.toLowerCase().includes(keyword))
        );

        if (matchedPlan) {
            location.href = "${pageContext.request.contextPath}/detail-page?id=" + matchedPlan.id;
        } else {
            alert("검색 결과가 없습니다.");
        }
    }

    // 엔터로도 검색 가능
    document.getElementById("searchInput").addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            searchPlan();
        }
    });
</script>
</body>

</html>
