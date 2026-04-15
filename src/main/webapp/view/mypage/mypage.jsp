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
<c:set var="settingsUpdated" value="${param.settingsSuccess eq '1'}" />
<div id="mypageSnackbar" class="mypage-snackbar ${settingsUpdated ? 'show' : ''}" role="status" aria-live="polite">
    회원 정보 수정이 완료되었습니다.
</div>
<section class="profile-section">
    <div class="profile-inner">
        <div class="profile-header">
            <div class="profile-img-wrap">
                <c:set var="profileImg" value="${pageContext.request.contextPath}/img/profile/default.png" />
                <c:if test="${not empty sessionScope.user.profileImg}">
                    <c:choose>
                        <c:when test="${fn:startsWith(sessionScope.user.profileImg, 'http://') or fn:startsWith(sessionScope.user.profileImg, 'https://')}">
                            <c:set var="profileImg" value="${sessionScope.user.profileImg}" />
                        </c:when>
                        <c:otherwise>
                            <c:url var="profileImg" value="/${sessionScope.user.profileImg}" />
                        </c:otherwise>
                    </c:choose>
                </c:if>
                <img src="${profileImg}"
                     alt="프로필">
            </div>
            <div class="profile-info">
                <div class="name-row">
                    <h2><c:out value="${sessionScope.user.name}" /></h2>
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
                <p class="email"><c:out value="${sessionScope.user.email}" /></p>
                <div class="badges">
                <%--<span class="badge" onclick="openTitleModal()">🏅 여행 플랜 마스터</span>--%>
                    <span class="badge" onclick="openTitleModal()">
                    <c:choose>
                    <c:when test="${receivedLikes >= 500}">🏆 여행 플랜 전설</c:when>
                    <c:when test="${receivedLikes >= 100}">🏅 여행 플랜 마스터</c:when>
                    <c:when test="${receivedLikes >= 30}">🧭 여행 플랜 탐험가</c:when>
                    <c:otherwise>🌱 여행 플랜 새싹</c:otherwise>
                    </c:choose>
                </span>
                <%-- <h2>데이터 확인: ${reviewList}</h2>--%>
                    <span class="badge">📍 ${fn:length(savedTrips)}개 도시 방문</span>
                </div>
            </div>
        </div>
        <div class="stats-grid">
            <%-- 1. 총 여행 플랜 -> content-saved --%>
            <div class="stat-box" onclick="triggerTab('content-saved')" style="cursor: pointer;">
                <span class="stat-num">${fn:length(savedTrips)}</span>
                <span class="stat-label">총 여행 플랜</span>
            </div>

            <%-- 2. 좋아요한 플랜 -> content-liked (여기가 'content-saved'였음) --%>
            <div class="stat-box" onclick="triggerTab('content-liked')" style="cursor: pointer;">
                <span class="stat-num">${fn:length(likedPlans)}</span>
                <span class="stat-label">좋아요한 플랜</span>
            </div>

            <%-- 3. 받은 좋아요 (탭 없음) --%>
                <div class="stat-box" onclick="triggerTab('content-stats')" style="cursor: pointer;">
                <span class="stat-num">${receivedLikes}</span>
                <span class="stat-label">받은 좋아요</span>
            </div>

            <%-- 4. 작성한 후기 -> content-reviews (여기도 'content-saved'였음) --%>
            <div class="stat-box" onclick="triggerTab('content-reviews')" style="cursor: pointer;">
                <span class="stat-num">${fn:length(reviewList)}</span>
                <span class="stat-label">작성한 후기</span>
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

                <li class="title-item ${receivedLikes >= 0 && receivedLikes < 30 ? 'active-title' : ''}">
                    <span class="title-icon">🌱</span>
                    <div class="title-info">
                        <span class="title-name">여행 플랜 새싹</span>
                        <span class="title-condition">좋아요 0개 누적</span>
                    </div>
                    <c:if test="${receivedLikes >= 0 && receivedLikes < 30}">
                        <span class="current-badge">현재</span>
                    </c:if>
                </li>

                <li class="title-item ${receivedLikes >= 30 && receivedLikes < 100 ? 'active-title' : ''}">
                    <span class="title-icon">🧭</span>
                    <div class="title-info">
                        <span class="title-name">여행 플랜 탐험가</span>
                        <span class="title-condition">좋아요 30개 누적</span>
                    </div>
                    <c:if test="${receivedLikes >= 30 && receivedLikes < 100}">
                        <span class="current-badge">현재</span>
                    </c:if>
                </li>

                <li class="title-item ${receivedLikes >= 100 && receivedLikes < 500 ? 'active-title' : ''}">
                    <span class="title-icon">🏅</span>
                    <div class="title-info">
                        <span class="title-name">여행 플랜 마스터</span>
                        <span class="title-condition">좋아요 100개 누적</span>
                    </div>
                    <c:if test="${receivedLikes >= 100 && receivedLikes < 500}">
                        <span class="current-badge">현재</span>
                    </c:if>
                </li>

                <li class="title-item ${receivedLikes >= 500 ? 'active-title' : ''}">
                    <span class="title-icon">🏆</span>
                    <div class="title-info">
                        <span class="title-name">여행 플랜 전설</span>
                        <span class="title-condition">좋아요 500개 누적</span>
                    </div>
                    <c:if test="${receivedLikes >= 500}">
                        <span class="current-badge">현재</span>
                    </c:if>
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
<%-- 저장된 여행--%>
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
                            <c:if test="${trip.posted == 1}">
                                <div class="trip-publish-meta">
                                    <span class="publish-badge">게시됨</span>
                                    <span class="heart-count">♥ ${trip.likeCnt}</span>
                                </div>
                            </c:if>
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
                            <div class="trip-card-actions">
                                <button type="button" class="btn-detail"
                                        onclick="location.href='${pageContext.request.contextPath}/myplan-page?id=${trip.planId}'">
                                    자세히 보기
                                </button>
                                <form action="${pageContext.request.contextPath}/delete-plan" method="post"
                                      onsubmit="return confirm('이 여행 플랜을 삭제할까요?');">
                                    <input type="hidden" name="planId" value="${trip.planId}">
                                    <button type="submit" class="btn-delete-plan">삭제</button>
                                </form>
                            </div>
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
        <c:choose>
            <c:when test="${not empty reviewList}">
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

                            <button class="review-tag" onclick= "location.href ='detail-page?id=${review.planId}'">일정 상세보기</button>

                        </div>
                    </div>
                </div>

            </c:forEach>
        </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <p>📝 아직 작성한 후기가 없어요!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- ===================== /후기 탭 ===================== --%>
    <%-- 통계 --%>
    <%-- ===================== 통계 탭 ===================== --%>
    <div id="content-stats" class="tab-content">


            <div class="section">
            <div class="section-title">현재 칭호 (${receivedLikes})</div>
            <div class="level-row">

                <%-- 칭호 아이콘 뱃지 --%>
                <div class="level-badge">
                    <c:choose>
                        <c:when test="${receivedLikes >= 500}">&#x1F3C6;</c:when>
                        <c:when test="${receivedLikes >= 100}">&#x1F3C5;</c:when>
                        <c:when test="${receivedLikes >= 30}">&#x1F9ED;</c:when>
                        <c:otherwise>&#x1F331;</c:otherwise>
                    </c:choose>
                </div>

                <div class="level-info">
                    <%-- 칭호 이름 --%>
                    <div class="level-name">
                        <c:choose>
                            <c:when test="${receivedLikes >= 500}">여행 플랜 전설</c:when>
                            <c:when test="${receivedLikes >= 100}">여행 플랜 마스터</c:when>
                            <c:when test="${receivedLikes >= 30}">여행 플랜 탐험가</c:when>
                            <c:otherwise>여행 플랜 새싹</c:otherwise>
                        </c:choose>
                    </div>

                    <%-- 다음 칭호까지 남은 좋아요 수 --%>
                    <div class="level-sub">
                        <c:choose>
                            <c:when test="${receivedLikes >= 500}">최고 칭호를 달성했어요!</c:when>
                            <c:when test="${receivedLikes >= 100}">다음 칭호까지 좋아요 ${500 - receivedLikes}개 남았어요!</c:when>
                            <c:when test="${receivedLikes >= 30}">다음 칭호까지 좋아요 ${100 - receivedLikes}개 남았어요!</c:when>
                            <c:otherwise>다음 칭호까지 좋아요 ${30 - receivedLikes}개 남았어요!</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <%-- 진행 바 --%>
            <div class="bar-track">
                <div class="bar-fill" style="width:
                <c:choose>
                <c:when test="${receivedLikes >= 500}">100</c:when>
                    <c:when test="${receivedLikes >= 100}">${(receivedLikes - 100) * 100 / 400}</c:when>
                    <c:when test="${receivedLikes >= 30}">${(receivedLikes - 30) * 100 / 70}</c:when>
                    <c:otherwise>${receivedLikes * 100 / 30}</c:otherwise>
                </c:choose>%;">
                </div>
            </div>

            <%-- 구간 레이블 --%>
            <div class="bar-label">
                <c:choose>
                    <c:when test="${receivedLikes >= 500}">
                        <span>전설 (500)</span><span>MAX</span>
                    </c:when>
                    <c:when test="${receivedLikes >= 100}">
                        <span>마스터 (100)</span><span>전설 (500) →</span>
                    </c:when>
                    <c:when test="${receivedLikes >= 30}">
                        <span>탐험가 (30)</span><span>마스터 (100) →</span>
                    </c:when>
                    <c:otherwise>
                        <span>새싹 (0)</span><span>탐험가 (30) →</span>
                    </c:otherwise>
                </c:choose>
            </div>
            </div><%-- /칭호 section 닫기 --%>
        <%-- 월별 차트 --%>
        <div class="section">
            <div class="section-title">월별 여행 횟수</div>
            <div style="position: relative; width: 100%; height: 200px;">
                <canvas id="barChart" role="img" aria-label="월별 여행 횟수 바차트"></canvas>
            </div>
        </div>

        <%-- 여행 트렌드 + 선호 스타일 2열 --%>
<%--        <div class="stats-two-col">--%>

            <%-- 여행 트렌드 --%>
        <div class="section stats-trend-section">
            <div class="section-title">📈 내 여행 트랜드</div>
            <div class="trend-list">
                <c:choose>
                    <%-- 1. 데이터가 있을 때 --%>
                    <c:when test="${not empty trendList}">
                        <c:forEach var="trend" items="${trendList}" varStatus="status">
                            <div class="trend-item">
                                <div class="trend-top">
                            <span class="trend-rank">
                                <c:choose>
                                    <c:when test="${status.first}">&#x1F947;</c:when>
                                    <c:when test="${status.index == 1}">&#x1F948;</c:when>
                                    <c:when test="${status.index == 2}">&#x1F949;</c:when>
                                    <c:otherwise>&#x1F4CD;</c:otherwise>
                                </c:choose>
                            </span>
                                    <span class="trend-name">${trend.destination}</span>
                                    <span class="trend-count">${trend.planId}회</span>
                                </div>
                                <div class="trend-bar-wrap">
                                        <%-- 중요: style 속성 오타 수정 및 1.0 곱하기로 정밀도 확보 --%>
                                    <div class="trend-bar" style="width: ${maxCount > 0 ? (trend.planId * 1.0 / maxCount * 100) : 0}%;"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>

                    <%-- 2. 데이터가 없을 때 (DB 연결 전이나 여행 기록이 없을 때) --%>
                    <c:otherwise>
                        <div class="empty-state" style="padding: 30px; text-align: center; color: #aaa;">
                            <p style="font-size: 24px; margin-bottom: 10px;">📊</p>
                            <p>아직 여행 기록이 없어서<br>통계를 불러올 수 없어요!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

            <%-- 선호 여행 스타일 --%>
            <div class="section stats-style-section">
                <div class="section-title">선호 스타일</div>
<%--                <div class="style-list">--%>
<%--                    <div class="style-item">--%>
<%--                        <div class="style-icon-wrap style-icon-food">--%>
<%--                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 11l19-9-9 19-2-8-8-2z"/></svg>--%>
<%--                        </div>--%>
<%--                        <div class="style-info">--%>
<%--                            <span class="style-name">식도락</span>--%>
<%--                            <div class="style-bar-wrap">--%>
<%--                                <div class="style-bar style-bar-food" style="width: 45%;"></div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <span class="style-pct">45%</span>--%>
<%--                    </div>--%>
<%--                    <div class="style-item">--%>
<%--                        <div class="style-icon-wrap style-icon-culture">--%>
<%--                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>--%>
<%--                        </div>--%>
<%--                        <div class="style-info">--%>
<%--                            <span class="style-name">문화</span>--%>
<%--                            <div class="style-bar-wrap">--%>
<%--                                <div class="style-bar style-bar-culture" style="width: 30%;"></div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <span class="style-pct">30%</span>--%>
<%--                    </div>--%>
<%--                    <div class="style-item">--%>
<%--                        <div class="style-icon-wrap style-icon-active">--%>
<%--                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>--%>
<%--                        </div>--%>
<%--                        <div class="style-info">--%>
<%--                            <span class="style-name">액티브</span>--%>
<%--                            <div class="style-bar-wrap">--%>
<%--                                <div class="style-bar style-bar-active" style="width: 15%;"></div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <span class="style-pct">15%</span>--%>
<%--                    </div>--%>
<%--                    <div class="style-item">--%>
<%--                        <div class="style-icon-wrap style-icon-shop">--%>
<%--                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>--%>
<%--                        </div>--%>
<%--                        <div class="style-info">--%>
<%--                            <span class="style-name">쇼핑</span>--%>
<%--                            <div class="style-bar-wrap">--%>
<%--                                <div class="style-bar style-bar-shop" style="width: 10%;"></div>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <span class="style-pct">10%</span>--%>
<%--                    </div>--%>
<%--                </div>--%>

<%--                --%>
<%--            </div>--%>
                <div class="style-list">
                    <c:choose>
                        <c:when test="${empty styleStats}">
                            <div class="empty-state">
                                <p>아직 분석된 여행 스타일이 없습니다.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="stat" items="${styleStats}" varStatus="status" begin="0" end="4">
                                <div class="style-item">
                                    <div class="style-icon-wrap style-color-${(status.index % 5) + 1}">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M3 11l19-9-9 19-2-8-8-2z"/>
                                        </svg>
                                    </div>
                                    <div class="style-info">
                                        <span class="style-name">${stat.styleName}</span>
                                        <div class="style-bar-wrap">
                                            <div class="style-bar style-bg-${(status.index % 5) + 1}"
                                                 style="width: ${stat.percentage}%;"></div>
                                        </div>
                                    </div>
                                    <span class="style-pct">${stat.percentage}%</span>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
    </div>

    </div>
    <%-- ===================== /통계 탭 ===================== --%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script>
    /* 1. 모달 함수를 가장 먼저, 그리고 '바깥'에 선언합니다. */
    function openTitleModal() {
        console.log("모달 열기 실행"); // 확인x용
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
        const monthlyData = [
            ${monthlyData[0]}, ${monthlyData[1]}, ${monthlyData[2]},
            ${monthlyData[3]}, ${monthlyData[4]}, ${monthlyData[5]},
            ${monthlyData[6]}, ${monthlyData[7]}, ${monthlyData[8]},
            ${monthlyData[9]}, ${monthlyData[10]}, ${monthlyData[11]}

            ];
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
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        legend: { display: false }  // undefined 제거
                    },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: {
                                callback: function(val, index) {
                                    // 홀수 인덱스(1월,3월,5월...)만 표시 = 2개월 단위
                                    return index % 2 === 0 ? this.getLabelForValue(val) : '';
                                }
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: { stepSize: 1 },
                            grid: { color: 'rgba(0,0,0,0.05)' }
                        }
                    }
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

    window.triggerTab = function(targetId) {
// 모든 버튼과 콘텐츠 가져오기
        const tabBtns = document.querySelectorAll('.tabs .tab');
        const tabContents = document.querySelectorAll('.tab-content');

        // 1. 기존 active 클래스 전부 싹 지우기
        tabBtns.forEach(btn => btn.classList.remove('active'));
        tabContents.forEach(content => content.classList.remove('active'));

        // 2. targetId에 맞는 버튼 찾아 활성화
        const targetBtn = document.querySelector(`.tab[data-target="${targetId}"]`);
        if (targetBtn) {
            targetBtn.classList.add('active');
        }

        // 3. targetId에 맞는 콘텐츠 찾아 활성화
        const targetContent = document.getElementById(targetId);
        if (targetContent) {
            targetContent.classList.add('active');
        }

        // 4. 클릭 후 탭 위치로 자동 스크롤 (화면이 클 때 편리함)
        const tabsElement = document.querySelector('.tabs');
        if(tabsElement) {
            tabsElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    };

    /* 2. 기존의 DOMContentLoaded 로직은 그대로 유지 */
    document.addEventListener('DOMContentLoaded', function () {
        // ... 기존 탭 클릭 이벤트 및 차트 로직 ...
    });
    const mypageSnackbar = document.getElementById('mypageSnackbar');
    if (mypageSnackbar && mypageSnackbar.classList.contains('show')) {
        setTimeout(() => {
            mypageSnackbar.classList.remove('show');
        }, 5000);
    }
</script>
</body>
</html>
