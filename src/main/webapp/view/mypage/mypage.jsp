<html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<head>
    <title>Mypage</title>
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<section class="profile-section">
    <div class="profile-inner">
        <div class="profile-header">
            <div class="profile-img-wrap">
                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80"
                     alt="프로필">
            </div>

            <div class="profile-info">
                <div class="name-row">
                    <h2>김여행</h2>
                    <div class="action-icons">
                        <button title="설정" onclick="location.href='${pageContext.request.contextPath}/settings'">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="3"></circle>
                                <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                            </svg>
                        </button>

                        <button title="로그아웃" onclick="location.href='${pageContext.request.contextPath}/logout'">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                <polyline points="16 17 21 12 16 7"></polyline>
                                <line x1="21" y1="12" x2="9" y2="12"></line>
                            </svg>
                        </button>
                    </div>
                </div>
                <p class="email">travel.lover@email.com</p>

                <div class="badges">
                    <span class="badge">🏅 여행 마스터</span>
                    <span class="badge">📍 18개 도시 방문</span>
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-box">
                <span class="stat-num">12</span>
                <span class="stat-label">총 여행</span>
            </div>
            <div class="stat-box">
                <span class="stat-num">43</span>
                <span class="stat-label">여행 일수</span>
            </div>
            <div class="stat-box">
                <span class="stat-num">5</span>
                <span class="stat-label">방문 국가</span>
            </div>
            <div class="stat-box">
                <span class="stat-num">18</span>
                <span class="stat-label">방문 도시</span>
            </div>
        </div>
    </div>
</section>

<nav class="tabs">
    <button class="tab active" data-target="content-saved">저장된 여행</button>
    <button class="tab" data-target="content-liked">좋아요한 플랜</button>
    <button class="tab" data-target="content-reviews">후기</button>
    <button class="tab" data-target="content-stats">통계</button>
</nav>

<section class="mypage-content">

    <div id="content-saved" class="tab-content active">

        <c:choose>
            <c:when test="${not empty savedTrips}">
                <c:forEach var="trip" items="${savedTrips}">
                    <article class="trip-card">
                        <div class="card-img-wrap">

                            <c:choose>
                                <c:when test="${trip.destination eq 'Tokyo' || trip.destination eq '도쿄'}">
                                    <img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=800&q=80"
                                         alt="도쿄">
                                </c:when>
                                <c:when test="${trip.destination eq 'Osaka' || trip.destination eq '오사카'}">
                                    <img src="https://images.unsplash.com/photo-1590559899731-a382839e5549?auto=format&fit=crop&w=800&q=80"
                                         alt="오사카">
                                </c:when>
                                <c:when test="${trip.destination eq 'Seoul' || trip.destination eq '서울'}">
                                    <img src="https://images.unsplash.com/photo-1538485399081-7c897c8e6b7b?auto=format&fit=crop&w=800&q=80"
                                         alt="서울">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-1480796927426-f609979314bd?auto=format&fit=crop&w=800&q=80"
                                         alt="${trip.destination}">
                                </c:otherwise>
                            </c:choose>

                            <span class="status-badge ${trip.statusClass}">
                                    ${trip.status}
                            </span>
                        </div>

                        <div class="card-body">
                            <h3>${trip.displayTitle}</h3>

                            <div class="trip-details">
                                <p>
                                    <span>📍</span>
                                    <c:out value="${trip.destination}" default="여행지 미정"/>
                                </p>

                                <p>
                                    <span>📅</span>
                                    <c:choose>
                                        <c:when test="${not empty trip.startDate and not empty trip.endDate}">
                                            <fmt:formatDate value="${trip.startDate}" pattern="yyyy.MM.dd"/>
                                            -
                                            <fmt:formatDate value="${trip.endDate}" pattern="yyyy.MM.dd"/>
                                        </c:when>
                                        <c:otherwise>
                                            일정 미정
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <p>
                                    <span>🗓️</span>
                                    <c:choose>
                                        <c:when test="${trip.days > 0}">
                                            ${trip.days}일
                                        </c:when>
                                        <c:otherwise>
                                            기간 미정
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <p>
                                    <span>👥</span>
                                    <c:choose>
                                        <c:when test="${trip.travelers > 0}">
                                            ${trip.travelers}명
                                        </c:when>
                                        <c:otherwise>
                                            인원 미정
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <button type="button"
                                    class="btn-detail"
                                    onclick="location.href='${pageContext.request.contextPath}/myplan-page?id=${trip.planId}'">
                                자세히 보기
                            </button>


                                <%-- 확인용. 정상 동작 확인 후 지워도 됨 --%>
                            <p>id: ${trip.planId}</p>
                        </div>
                    </article>
                </c:forEach>
            </c:when>

            <c:otherwise>
                <div class="empty-state">
                    <p>🧳 아직 저장된 여행이 없어요!</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <%-- 좋아요한 플랜 카드--%>
<%--    <p>likedPlans 크기: ${fn:length(likedPlans)}</p>--%>
<%--좋아요 갯수 확인용--%>
    <div id="content-liked" class="tab-content active">
        <c:choose>
            <c:when test="${not empty likedPlans}">
                <c:forEach var="trip" items="${likedPlans}">
                    <article class="trip-card">
                        <div class="card-img-wrap">
                            <c:choose>
                                <c:when test="${trip.destination eq 'Tokyo' || trip.destination eq '도쿄'}">
                                    <img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=800&q=80" alt="도쿄">
                                </c:when>
                                <c:when test="${trip.destination eq 'Osaka' || trip.destination eq '오사카'}">
                                    <img src="https://images.unsplash.com/photo-1590559899731-a382839e5549?auto=format&fit=crop&w=800&q=80" alt="오사카">
                                </c:when>
                                <c:when test="${trip.destination eq 'Seoul' || trip.destination eq '서울'}">
                                    <img src="https://images.unsplash.com/photo-1538485399081-7c897c8e6b7b?auto=format&fit=crop&w=800&q=80" alt="서울">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-1480796927426-f609979314bd?auto=format&fit=crop&w=800&q=80" alt="${trip.destination}">
                                </c:otherwise>
                            </c:choose>
                            <span class="status-badge ${trip.statusClass}">${trip.status}</span>
                        </div>

                        <div class="card-body">
                            <h3>${trip.displayTitle}</h3>
                            <div class="trip-details">
                                <p><span>📍</span><c:out value="${trip.destination}" default="여행지 미정"/></p>
                                <p>
                                    <span>📅</span>
                                    <c:choose>
                                        <c:when test="${not empty trip.startDate and not empty trip.endDate}">
                                            <fmt:formatDate value="${trip.startDate}" pattern="yyyy.MM.dd"/> - <fmt:formatDate value="${trip.endDate}" pattern="yyyy.MM.dd"/>
                                        </c:when>
                                        <c:otherwise>일정 미정</c:otherwise>
                                    </c:choose>
                                </p>
                                <p><span>🗓️</span><c:choose><c:when test="${trip.days > 0}">${trip.days}일</c:when><c:otherwise>기간 미정</c:otherwise></c:choose></p>
                                <p><span>👥</span><c:choose><c:when test="${trip.travelers > 0}">${trip.travelers}명</c:when><c:otherwise>인원 미정</c:otherwise></c:choose></p>
                            </div>
                            <button type="button" class="btn-detail"
                                    onclick="location.href='${pageContext.request.contextPath}/myplan-page?id=${trip.planId}'">
                                자세히 보기
                            </button>
                        </div>
                    </article>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <p>❤️ 아직 좋아요를 누른 여행이 없어요!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>  <%-- content-liked 닫기 --%>

    <%-- 후기 --%>
    <div id="content-reviews" class="tab-content">
        <div class="empty-state">
            <p>📝 아직 작성한 후기가 없어요!</p>
        </div>
    </div>

    <%-- 통계 --%>
    <div id="content-stats" class="tab-content">
        <div class="empty-state">
            <p>📊📈 아직 준비된 통계 없어요!</p>
        </div>
    </div>

</section>

<script>
    const tabBtns = document.querySelectorAll('.tab');
    const tabContents = document.querySelectorAll('.tab-content');

    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            tabBtns.forEach(t => t.classList.remove('active'));
            tabContents.forEach(c => c.classList.remove('active'));

            btn.classList.add('active');

            const targetId = btn.getAttribute('data-target');
            document.getElementById(targetId).classList.add('active');
        });
    });
</script>
</body>
</html>