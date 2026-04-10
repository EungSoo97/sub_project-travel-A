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
<%--                    <h2>데이터 확인: ${reviewList}</h2>--%>
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
<%----%>
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

<%--    <div id="content-reviews" class="tab-content">--%>


<%--리뷰탭--%>
    <%-- ===================== /후기 탭 ===================== --%>
    <div id="content-reviews" class="tab-content active">
        <div class="review-timeline">
            <c:set var="currentYear" value="0" />

            <c:forEach var="review" items="${reviewList}" varStatus="status">

                <%-- 1. 연도 구분 (에러 방지를 위해 단순 비교로 변경) --%>
                <c:set var="thisYear" value="${fn:substring(review.createdAt, 0, 4)}" />
                <c:if test="${thisYear != currentYear}">
                    <div class="review-year-divider">${thisYear}</div>
                    <c:set var="currentYear" value="${thisYear}" />
                </c:if>

                <div class="review-tl-wrap">
                    <div class="review-tl-axis">
                        <div class="review-tl-dot" style="background: ${status.index % 2 == 0 ? '#378ADD' : '#1BBA53'};"></div>
                        <c:if test="${not status.last}">
                            <div class="review-tl-line"></div>
                        </c:if>
                    </div>

                    <div class="review-card">
                        <div class="review-card-head">
                        <span class="review-dest-tag" style="background: ${status.index % 2 == 0 ? '#E6F1FB' : '#E8F8EE'}; color: ${status.index % 2 == 0 ? '#185FA5' : '#12803B'};">
                            📍 ${review.city}
                        </span>
                            <span class="review-meta-date relative-date" data-date="${review.createdAt}">
                            <fmt:formatDate value="${review.createdAt}" pattern="yyyy.MM.dd"/> · ${review.createdAt}
                            </span>
                        </div>

                        <div class="review-title">${review.city}</div>

                        <div class="review-body">
                                ${review.content}
                        </div>

                        <div class="review-tags">
                            <span class="review-tag">#여행기록</span>
                            <span class="review-tag">#기록</span>
                        </div>

                        <div class="review-card-footer">

                            <button class="review-tag" onclick= "location.href ='detail-page?id=${review.reviewId}'">일정 상세보기</button>

                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <%-- ===================== /후기 탭 ===================== --%>
    <%-- 통계 --%>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script>
    /* 1. 모달 함수를 가장 먼저, 그리고 '바깥'에 선언합니다. */
    function openTitleModal() {
        console.log("모달 열기 실행"); // 확인용
        const modal = document.getElementById('titleModal');
        if (modal) {
            modal.classList.add('show');
        } else {
            console.error("titleModal 요소를 찾을 수 없습니다.");
        }
    }

    function closeTitleModal() {
        const modal = document.getElementById('titleModal');
        if (modal) modal.classList.remove('show');
    }

    /* 2. 탭 전환과 차트는 페이지 로드 후에 실행되도록 합니다. */
    document.addEventListener('DOMContentLoaded', function () {
        // 탭 기능
        const tabBtns = document.querySelectorAll('.tabs .tab');
        const tabContents = document.querySelectorAll('.tab-content');

        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const targetId = btn.getAttribute('data-target');

                // 전부 끄기
                tabBtns.forEach(t => t.classList.remove('active'));
                tabContents.forEach(c => c.classList.remove('active'));

                // 누른 것만 켜기
                btn.classList.add('active');
                const target = document.getElementById(targetId);
                if(target) target.classList.add('active');
            });
        });

        // 차트 데이터 및 생성
        const monthlyData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        const ctx = document.getElementById('barChart');
        if (ctx) {
            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                    datasets: [{
                        data: monthlyData,
                        backgroundColor: '#378ADD',
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        }
    });
    document.addEventListener('DOMContentLoaded', function() {
        const dateElements = document.querySelectorAll('.relative-date');

        dateElements.forEach(el => {
            const dateStr = el.getAttribute('data-date'); // "2026-04-10"
            if(!dateStr) return;

            const postDate = new Date(dateStr);
            const nowDate = new Date();

            // 1. 차이 계산
            const diffMS = nowDate - postDate;
            const diffHours = Math.floor(diffMS / (1000 * 60 * 60));
            const diffDays = Math.floor(diffMS / (1000 * 60 * 60 * 24));

            // 2. 표시할 시간 텍스트 결정
            let timeText = "";
            if (diffDays === 0) {
                timeText = diffHours <= 0 ? "방금 전" : diffHours + "시간 전";
            } else if (diffDays < 7) {
                timeText = diffDays + "일 전";
            } else {
                // 7일 이상이면 yyyy.MM 형식
                const year = postDate.getFullYear();
                const month = ('0' + (postDate.getMonth() + 1)).slice(-2);
                timeText = year + "." + month;
            }

            // 3. 기존의 "2026-04-10" 부분(원본 날짜)만 추출
            // JSP에서 처음 그려진 텍스트가 "2026-04-10 · 3일" 형태라면 [0]번 인덱스가 날짜입니다.
            const originalText = el.innerText;
            const rawDatePart = originalText.includes('·') ? originalText.split('·')[0].trim() : dateStr;

            // 4. 최종 결과 조립: [시간차] · [원본날짜]
            // 예: 9시간 전 · 2026-04-10
            el.innerText = timeText + " · " + rawDatePart;
        });
    });

</script>
</body>
</html>