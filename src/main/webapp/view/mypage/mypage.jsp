<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
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
                    <span class="badge" onclick="openTitleModal()">🏅 여행 플랜 마스터</span>
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
                <span class="stat-label">받은 좋아요</span>
            </div>
            <div class="stat-box">
                <span class="stat-num">18</span>
                <span class="stat-label">방문 도시</span>
            </div>
        </div>
    </div>
</section>

<%-- 칭호 모달  --%>
<div id="titleModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-header">
            <h3>칭호 등급표</h3>
            <button class="modal-close" onclick="closeTitleModal()">✕</button>
        </div>
        <div class="modal-body">
            <ul class="title-list">
                <li class="title-item">
                    <span class="title-icon">🌱</span>
                    <div class="title-info">
                        <span class="title-name">여행 플랜 새싹</span>
                        <span class="title-condition">좋아요 1개 누적</span>
                    </div>
                </li>
                <li class="title-item">
                    <span class="title-icon">🧭</span>
                    <div class="title-info">
                        <span class="title-name">여행 플랜 탐험가</span>
                        <span class="title-condition">좋아요 30개 누적</span>
                    </div>
                </li>
                <li class="title-item active-title">
                    <span class="title-icon">🏅</span>
                    <div class="title-info">
                        <span class="title-name">여행 플랜 마스터</span>
                        <span class="title-condition">좋아요 100개 누적</span>
                    </div>
                    <span class="current-badge">현재</span>
                </li>
                <li class="title-item">
                    <span class="title-icon">🏆</span>
                    <div class="title-info">
                        <span class="title-name">여행 플랜 전설</span>
                        <span class="title-condition">좋아요 500개 누적</span>
                    </div>
                </li>
            </ul>
        </div>
        <div class="modal-footer">
            <button class="btn-confirm" onclick="closeTitleModal()">닫기</button>
        </div>
    </div>
</div>

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
                                            <fmt:formatDate value="${trip.startDate}" pattern="yyyy.MM.dd"/>
                                            -
                                            <fmt:formatDate value="${trip.endDate}" pattern="yyyy.MM.dd"/>
                                        </c:when>
                                        <c:otherwise>일정 미정</c:otherwise>
                                    </c:choose>
                                </p>
                                <p><span>🗓️</span>
                                    <c:choose>
                                        <c:when test="${trip.days > 0}">${trip.days}일</c:when>
                                        <c:otherwise>기간 미정</c:otherwise>
                                    </c:choose>
                                </p>
                                <p><span>👥</span>
                                    <c:choose>
                                        <c:when test="${trip.travelers > 0}">${trip.travelers}명</c:when>
                                        <c:otherwise>인원 미정</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <button type="button" class="btn-detail"
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

    <%--    <p>likedPlans 크기: ${fn:length(likedPlans)}</p>--%>
    <%--좋아요 갯수 확인용--%>
    <div id="content-liked" class="tab-content">
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
                                            <fmt:formatDate value="${trip.startDate}" pattern="yyyy.MM.dd"/> -
                                            <fmt:formatDate value="${trip.endDate}" pattern="yyyy.MM.dd"/>
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
    </div>
    <%--내가쓴 리뷰 돔--%>
    <div id="content-reviews" class="tab-content">
        <c:choose>
            <c:when test="${not empty reviewList}">

                <div class="review-timeline">
                    <c:set var="currentYear" value="0" />

                    <c:forEach var="review" items="${reviewList}" varStatus="status">

                        <%-- 연도 구분선: 연도가 바뀔 때마다 출력 --%>
                        <c:if test="${review.year != currentYear}">
                            <div class="review-year-divider">${review.year}</div>
                            <c:set var="currentYear" value="${review.year}" />
                        </c:if>

                        <div class="review-tl-wrap">

                                <%-- 타임라인 축 (점 + 선) --%>
                            <div class="review-tl-axis">
                                <div class="review-tl-dot"></div>
                                <c:if test="${not status.last}">
                                    <div class="review-tl-line"></div>
                                </c:if>
                            </div>

                                <%-- 후기 카드 --%>
                            <div class="review-card">

                                    <%-- 카드 헤더: 도시/국가 태그 + 날짜·기간 --%>
                                <div class="review-card-head">
                                    <span class="review-dest-tag">
                                        ${review.city} &middot; ${review.country}
                                    </span>
                                    <span class="review-meta-date">
                                        <fmt:formatDate value="${review.travelDate}" pattern="yyyy.MM"/> &middot; ${review.duration}일
                                    </span>
                                </div>

                                    <%-- 제목 --%>
                                <div class="review-title">${review.title}</div>

                                    <%-- 본문 --%>
                                <div class="review-body">${review.content}</div>

                                    <%-- 사진 썸네일 (최대 3장 + 나머지 +N) --%>
                                <c:if test="${not empty review.photos}">
                                    <div class="review-photos">
                                        <c:forEach var="photo" items="${review.photos}" varStatus="ps">
                                            <c:if test="${ps.index < 3}">
                                                <img class="review-photo-thumb"
                                                     src="${photo.thumbUrl}"
                                                     alt="여행 사진 ${ps.index + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${fn:length(review.photos) > 3}">
                                            <div class="review-photo-more">
                                                +${fn:length(review.photos) - 3}
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>

                                    <%-- 해시태그 --%>
                                <c:if test="${not empty review.tags}">
                                    <div class="review-tags">
                                        <c:forEach var="tag" items="${review.tags}">
                                            <span class="review-tag"># ${tag}</span>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                    <%-- 별점 + 좋아요/댓글 수 --%>
                                <div class="review-card-footer">
                                    <span class="review-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= review.rating}">&#9733;</c:when>
                                                <c:otherwise>&#9734;</c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </span>
                                    <span class="review-foot-stat">
                                        좋아요 <strong>${review.likeCount}</strong>
                                    </span>
                                    <span class="review-foot-stat">
                                        댓글 <strong>${review.commentCount}</strong>
                                    </span>
                                </div>

                            </div><%-- /review-card --%>
                        </div><%-- /review-tl-wrap --%>

                    </c:forEach>
                </div><%-- /review-timeline --%>

            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <p>📝 아직 작성한 후기가 없어요!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <%-- ===================== /후기 탭 ===================== --%>
    <div id="content-stats" class="tab-content">
        <div class="stat-grid">
            <div class="stat-card">
                <div class="num">${stats.totalTrips}</div>
                <div class="lbl">총 여행</div>
            </div>
            <div class="stat-card">
                <div class="num">${stats.totalDays}</div>
                <div class="lbl">여행 일수</div>
            </div>
            <div class="stat-card">
                <div class="num">${stats.totalCountries}</div>
                <div class="lbl">좋아요 받은 수</div>
            </div>
            <div class="stat-card">
                <div class="num">${stats.totalCities}</div>
                <div class="lbl">방문 도시</div>
            </div>
        </div>
        <div class="section">
            <div class="section-title">현재 칭호</div>
            <div class="level-row">
                <div class="badge">${stats.title}</div>
                <div class="level-info">
                    <div class="level-name">${stats.title}</div>
                    <div class="level-sub">다음 칭호까지 ${stats.tripsToNextLevel}번 더 여행하면 돼요!</div>
                </div>
            </div>
            <div class="bar-track">
                <div class="bar-fill" style="width: ${stats.levelPercent}%;"></div>
            </div>
            <div class="bar-label">
                <span>${stats.currentLevelName} (${stats.currentLevelMin}회)</span>
                <span>${stats.nextLevelName} (${stats.nextLevelMin}회) →</span>
            </div>
        </div>
        <div class="section">
            <div class="section-title">월별 여행 횟수</div>
            <div style="position: relative; width: 100%; height: 200px;">
                <canvas id="barChart" role="img" aria-label="월별 여행 횟수 바차트"></canvas>
            </div>
            <button>가장 많이 간 여행지</button>
            <button>총 예산 비용</button>
            <button>내 여행 스타일</button>
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
    const monthlyData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script>
    new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
            labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
            datasets: [{
                data: monthlyData,
                backgroundColor: '#378ADD',
                borderRadius: 6,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {legend: {display: false}},
            scales: {
                x: {grid: {display: false}},
                y: {beginAtZero: true, ticks: {stepSize: 1}, grid: {color: 'rgba(0,0,0,0.05)'}}
            }
        }
    });

    function openTitleModal() {
        document.getElementById('titleModal').classList.add('show');
    }

    function closeTitleModal() {
        document.getElementById('titleModal').classList.remove('show');
    }

    document.getElementById('titleModal').addEventListener('click', function(e) {
        if (e.target === this) closeTitleModal();
    });
</script>
</body>
</html>