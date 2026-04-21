<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Mypage</title>
    <link rel="stylesheet" href="/css/mypage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypage-review-stack.css">
</head>
<body>
<c:set var="settingsUpdated" value="${param.settingsSuccess eq '1'}" />
<c:set var="reviewDeleted" value="${param.reviewDeleted eq 'true'}" />
<c:url var="defaultPlanImage" value="/img/defaultplan/default.jpg" />
<div id="mypageSnackbar" class="mypage-snackbar ${settingsUpdated or reviewDeleted ? 'show' : ''}" role="status" aria-live="polite">
    <c:choose>
        <c:when test="${reviewDeleted}">후기가 삭제되었습니다.</c:when>
        <c:otherwise>회원 정보 수정이 완료되었습니다.</c:otherwise>
    </c:choose>
</div>
<div class="review-confirm-backdrop" id="reviewDeleteConfirm" aria-hidden="true">
    <div class="review-confirm-sheet" role="dialog" aria-modal="true" aria-labelledby="reviewDeleteConfirmTitle">
        <p class="review-confirm-title" id="reviewDeleteConfirmTitle">후기를 삭제할까요?</p>
        <p class="review-confirm-text">삭제한 후기는 다시 복구할 수 없습니다.</p>
        <div class="review-confirm-actions">
            <button type="button" class="review-confirm-cancel" id="reviewDeleteCancel">취소</button>
            <button type="button" class="review-confirm-delete" id="reviewDeleteConfirmBtn">삭제</button>
        </div>
    </div>
</div>
<div class="review-confirm-backdrop" id="planDeleteConfirm" aria-hidden="true">
    <div class="review-confirm-sheet" role="dialog" aria-modal="true" aria-labelledby="planDeleteConfirmTitle">
        <p class="review-confirm-title" id="planDeleteConfirmTitle">여행 플랜을 삭제할까요?</p>
        <p class="review-confirm-text">저장된 일정과 관련 기록이 함께 삭제됩니다.</p>
        <div class="review-confirm-actions">
            <button type="button" class="review-confirm-cancel" id="planDeleteCancel">취소</button>
            <button type="button" class="review-confirm-delete" id="planDeleteConfirmBtn">삭제</button>
        </div>
    </div>
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

            <%-- 2. 좋아요한 플랜 -> content-liked --%>
            <div class="stat-box" onclick="triggerTab('content-liked')" style="cursor: pointer;">
                <span class="stat-num">${fn:length(likedPlans)}</span>
                <span class="stat-label">좋아요한 플랜</span>
            </div>

            <%-- 3. 받은 좋아요 --%>
            <div class="stat-box" onclick="triggerTab('content-stats')" style="cursor: pointer;">
                <span class="stat-num">${receivedLikes}</span>
                <span class="stat-label">받은 좋아요</span>
            </div>

            <%-- 4. 작성한 후기 -> content-reviews --%>
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
    <%-- 저장된 여행 --%>
    <div id="content-saved" class="tab-content active plan-folder-tab" data-folder-tab="saved">
        <c:choose>
            <c:when test="${not empty savedTrips}">
                <div class="plan-folder-shell" data-folder-shell data-source="saved">
                    <div class="plan-folder-toolbar" aria-label="saved plan grouping">
                        <button type="button" class="plan-sort-chip active" data-group-mode="date">날짜 별</button>
                        <button type="button" class="plan-sort-chip" data-group-mode="destination">목적지 별</button>
                        <div class="plan-folder-search" data-folder-search>
                            <input type="text"
                                   class="plan-folder-search__input"
                                   data-folder-search-input
                                   placeholder="날짜로 바로가기"
                                   autocomplete="off">
                            <div class="plan-folder-search__list" data-folder-search-list hidden></div>
                        </div>
                    </div>
                    <div class="plan-folder-view" data-folder-view></div>
                    <div class="plan-seed-list" data-plan-seed-list hidden>
                <c:forEach var="trip" items="${savedTrips}">
                    <article class="trip-card"
                             data-plan-id="${trip.planId}"
                             data-live-tracking="${trip.liveTracking}"
                             data-starred="${trip.starred}"
                             data-posted="${trip.posted}"
                             data-like-count="${trip.likeCnt}"
                             data-created-time="${empty trip.postDate ? (empty trip.createdAt ? 0 : trip.createdAt.time) : trip.postDate.time}"
                             data-destination="${empty trip.destination ? '여행지 미정' : trip.destination}"
                             data-travel-style="${empty trip.travelStyle ? '여행 스타일' : trip.travelStyle}">
                        <div class="card-img-wrap">
                            <img src="${empty trip.thumbnailUrl ? defaultPlanImage : trip.thumbnailUrl}"
                                 alt="${empty trip.destination ? '여행 플랜 이미지' : trip.destination}"
                                 onerror="this.src='${defaultPlanImage}'">
                            <c:if test="${trip.starred}">
                                <span class="favorite-badge" aria-label="즐겨찾기">★</span>
                            </c:if>
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
                            <div class="trip-publish-meta trip-creator-meta">
                                <span class="creator-badge"><i class="fa-regular fa-user"></i>
                                    <c:out value="${empty trip.creatorName ? '여행자' : trip.creatorName}" />
                                </span>
                                <c:if test="${not empty trip.editorName and trip.editorName ne trip.creatorName}">
                                    <span class="editor-badge">✏️
                                        <c:out value="${trip.editorName}" />
                                    </span>
                                </c:if>
                                <c:if test="${trip.originalUserId != 0 && trip.copiedModified != 1}">
                                    <span class="publish-badge">수정 후 게시 가능</span>
                                </c:if>
                            </div>
                            <div class="trip-details">
                                <p><span><i class="fa-solid fa-location-dot"></i></span><c:out value="${trip.destination}" default="여행지 미정"/></p>
                                <p>
                                    <span><i class="fa-regular fa-calendar"></i></span>
                                    <c:choose>
                                        <c:when test="${not empty trip.startDate and not empty trip.endDate}">
                                            <fmt:formatDate value="${trip.startDate}" pattern="yyyy.MM.dd"/>
                                            -
                                            <fmt:formatDate value="${trip.endDate}" pattern="yyyy.MM.dd"/>
                                        </c:when>
                                        <c:otherwise>일정 미정</c:otherwise>
                                    </c:choose>
                                </p>
                                <p><span><i class="fa-regular fa-calendar"></i></span>
                                    <c:choose>
                                        <c:when test="${trip.days > 0}">${trip.days}일</c:when>
                                        <c:otherwise>기간 미정</c:otherwise>
                                    </c:choose>
                                </p>
                                <p><span><i class="fa-solid fa-user-group"></i></span>
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
                                      data-plan-delete-form>
                                    <input type="hidden" name="planId" value="${trip.planId}">
                                    <button type="submit" class="btn-delete-plan">삭제</button>
                                </form>
                            </div>
                        </div>
                    </article>
                </c:forEach>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state plan-folder-empty" data-folder-empty>
                    <p>🧳 아직 저장된 여행이 없어요!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%--    <p>likedPlans 크기: ${fn:length(likedPlans)}</p>--%>
    <%-- 좋아요 갯수 확인용 --%>
    <div id="content-liked" class="tab-content plan-folder-tab" data-folder-tab="liked">
        <c:choose>
            <c:when test="${not empty likedPlans}">
                <div class="plan-folder-shell" data-folder-shell data-source="liked">
                    <div class="plan-folder-toolbar" aria-label="liked plan grouping">
                        <button type="button" class="plan-sort-chip active" data-group-mode="date">날짜 별</button>
                        <button type="button" class="plan-sort-chip" data-group-mode="destination">목적지 별</button>
                        <div class="plan-folder-search" data-folder-search>
                            <input type="text"
                                   class="plan-folder-search__input"
                                   data-folder-search-input
                                   placeholder="날짜로 바로가기"
                                   autocomplete="off">
                            <div class="plan-folder-search__list" data-folder-search-list hidden></div>
                        </div>
                    </div>
                    <div class="plan-folder-view" data-folder-view></div>
                    <div class="plan-seed-list" data-plan-seed-list hidden>
                <c:forEach var="trip" items="${likedPlans}">
                    <article class="trip-card"
                             data-plan-id="${trip.planId}"
                             data-live-tracking="${trip.liveTracking}"
                             data-starred="${trip.starred}"
                             data-created-time="${empty trip.createdAt ? 0 : trip.createdAt.time}"
                             data-destination="${empty trip.destination ? '여행지 미정' : trip.destination}"
                             data-travel-style="${empty trip.travelStyle ? '여행 스타일' : trip.travelStyle}">
                        <div class="card-img-wrap">
                            <img src="${empty trip.thumbnailUrl ? defaultPlanImage : trip.thumbnailUrl}"
                                 alt="${empty trip.destination ? '여행 플랜 이미지' : trip.destination}"
                                 onerror="this.src='${defaultPlanImage}'">
                            <span class="liked-plan-price">
                                <c:choose>
                                    <c:when test="${trip.totalEstimatedCost > 0}">
                                        ₩<fmt:formatNumber value="${trip.totalEstimatedCost}" pattern="#,###" />
                                    </c:when>
                                    <c:otherwise>비용 미정</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="card-body">
                            <h3>${trip.displayTitle}</h3>
                            <div class="trip-publish-meta trip-creator-meta">
                                <span class="creator-badge"><i class="fa-regular fa-user"></i>
                                    <c:out value="${empty trip.creatorName ? '여행자' : trip.creatorName}" />
                                </span>
                                <span class="heart-count">♥ ${trip.likeCnt}</span>
                                <c:if test="${not empty trip.editorName and trip.editorName ne trip.creatorName}">
                                    <span class="editor-badge">✏️
                                        <c:out value="${trip.editorName}" />
                                    </span>
                                </c:if>
                            </div>
                            <div class="trip-details">
                                <p><span><i class="fa-solid fa-location-dot"></i></span><c:out value="${trip.destination}" default="여행지 미정"/></p>
                                <p>
                                    <span><i class="fa-regular fa-calendar"></i></span>
                                    <c:choose>
                                        <c:when test="${not empty trip.startDate and not empty trip.endDate}">
                                            <fmt:formatDate value="${trip.startDate}" pattern="yyyy.MM.dd"/> -
                                            <fmt:formatDate value="${trip.endDate}" pattern="yyyy.MM.dd"/>
                                        </c:when>
                                        <c:otherwise>일정 미정</c:otherwise>
                                    </c:choose>
                                </p>
                                <p><span><i class="fa-regular fa-calendar"></i></span><c:choose><c:when test="${trip.days > 0}">${trip.days}일</c:when><c:otherwise>기간 미정</c:otherwise></c:choose></p>
                                <p><span><i class="fa-solid fa-user-group"></i></span><c:choose><c:when test="${trip.travelers > 0}">${trip.travelers}명</c:when><c:otherwise>인원 미정</c:otherwise></c:choose></p>
                            </div>
                            <c:choose>
                                <c:when test="${trip.posted == 1}">
                                    <button type="button" class="btn-detail"
                                            onclick="location.href='${pageContext.request.contextPath}/detail-page?id=${trip.planId}'">
                                        자세히 보기
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="btn-detail btn-detail--disabled" disabled>
                                        작성자에 의해 게시 중단 된 플랜 입니다
                                    </button>
                                    <button type="button"
                                            class="btn-cancel-like"
                                            data-cancel-like-plan-id="${trip.planId}">
                                        좋아요 취소
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </article>
                </c:forEach>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state plan-folder-empty" data-folder-empty>
                    <p>❤️ 아직 좋아요를 누른 여행이 없어요!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="plan-modal-backdrop" id="planPreviewModal" aria-hidden="true">
        <div class="plan-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="planPreviewTitle">
            <div class="plan-modal-head">
                <h3 id="planPreviewTitle">플랜 상세 보기</h3>
                <button type="button" class="plan-modal-close" id="planPreviewClose" aria-label="close plan preview">×</button>
            </div>
            <div class="plan-modal-body" id="planPreviewBody"></div>
        </div>
    </div>

    <%--    <div id="content-reviews" class="tab-content">--%>


    <%-- 후기탭 --%>
    <%-- ===================== /후기 탭 ===================== --%>
    <div id="content-reviews" class="tab-content">
        <c:choose>
            <c:when test="${not empty reviewGroups}">
                <div class="review-timeline review-stack-list">
                    <c:set var="currentYear" value="" />
                    <c:forEach var="reviewGroup" items="${reviewGroups}" varStatus="groupStatus">
                        <c:set var="groupReviews" value="${reviewGroup.value}" />
                        <c:set var="mainReview" value="${groupReviews[0]}" />
                        <c:set var="reviewCount" value="${fn:length(groupReviews)}" />
                        <fmt:formatDate var="groupYear" value="${mainReview.createdAt}" pattern="yyyy" timeZone="Asia/Seoul" />

                        <c:if test="${groupYear ne currentYear}">
                            <div class="review-year-divider">${groupYear}</div>
                            <c:set var="currentYear" value="${groupYear}" />
                        </c:if>

                        <div class="review-tl-wrap">
                            <div class="review-tl-axis">
                                <div class="review-tl-dot" style="background: ${groupStatus.index % 2 == 0 ? '#378ADD' : '#1BBA53'};"></div>
                                <c:if test="${not groupStatus.last}">
                                    <div class="review-tl-line"></div>
                                </c:if>
                            </div>

                            <section class="review-stack-group is-collapsed has-stack"
                                     data-review-stack>
                                <button type="button"
                                        class="review-stack-toggle"
                                        aria-expanded="false">
                                    <span class="review-stack-toggle__content">
                                        <span class="review-stack-toggle__main">
                                            <span class="review-dest-tag" style="background: ${groupStatus.index % 2 == 0 ? '#E6F1FB' : '#E8F8EE'}; color: ${groupStatus.index % 2 == 0 ? '#185FA5' : '#12803B'};">
                                                <i class="fa-solid fa-location-dot"></i> <c:out value="${mainReview.city}" />
                                            </span>
                                            <span class="review-plan-id">plan #${reviewGroup.key}</span>
                                        <span class="review-stack-count">${reviewCount}개 후기</span>
                                        </span>
                                        <span class="review-stack-title">
                                            <c:choose>
                                                <c:when test="${not empty mainReview.planTitle}">
                                                    <c:out value="${mainReview.planTitle}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${mainReview.city}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="review-stack-meta">
                                            <i class="fa-regular fa-user"></i> <c:out value="${mainReview.planCreatorName}" default="여행자" />
                                            <span>♥ ${mainReview.likeCnt}</span>
                                        </span>
                                    </span>
                                    <span class="review-stack-toggle__hint">
                                        <c:choose>
                                            <c:when test="${reviewCount > 0}">펼치기</c:when>
                                            <c:otherwise>후기 없음</c:otherwise>
                                        </c:choose>
                                    </span>
                                </button>

                                <div class="review-stack-cards">
                                    <c:forEach var="review" items="${groupReviews}" varStatus="status">
                                        <article class="review-card review-stack-card">
                                            <div class="review-card-head">
                                                <span class="review-plan-id">plan #${review.planId}</span>
                                                <span class="review-meta-date">
                                                    <fmt:formatDate value="${review.createdAt}" pattern="yyyy.MM.dd HH:mm" timeZone="Asia/Seoul"/>
                                                </span>
                                            </div>

                                            <div class="review-body">
                                                <c:out value="${review.content}" />
                                            </div>

                                            <div class="review-card-footer">
                                                <button type="button" class="review-tag" onclick="location.href='detail-page?id=${review.planId}'">일정 상세보기</button>
                                                <form class="review-delete-form"
                                                      action="${pageContext.request.contextPath}/review"
                                                      method="post"
                                                      data-review-delete-form>
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="returnTo" value="mypage">
                                                    <input type="hidden" name="planId" value="${review.planId}">
                                                    <input type="hidden" name="reviewId" value="${review.reviewId}">
                                                    <button type="submit" class="review-delete-btn">삭제</button>
                                                </form>
                                            </div>
                                        </article>
                                    </c:forEach>
                                </div>
                            </section>
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

        <%-- 상단 요약 미니 카드 3열 --%>
        <div class="stats-summary-row">
            <div class="stats-sum-card">
                <span class="stats-sum-icon">✈️</span>
                <span class="stats-sum-num">${fn:length(savedTrips)}</span>
                <span class="stats-sum-lbl">총 플랜</span>
            </div>
            <div class="stats-sum-card">
                <span class="stats-sum-icon">❤️</span>
                <span class="stats-sum-num">${receivedLikes}</span>
                <span class="stats-sum-lbl">받은 좋아요</span>
            </div>
            <div class="stats-sum-card">
                <span class="stats-sum-icon">📝</span>
                <span class="stats-sum-num">${fn:length(reviewList)}</span>
                <span class="stats-sum-lbl">작성 후기</span>
            </div>
        </div>

        <%-- 현재 칭호 --%>
        <div class="section">
            <div class="section-title-row">
                <span class="section-title-text">현재 칭호</span>
                <span class="section-like-chip">❤️ ${receivedLikes}개</span>
            </div>
            <div class="level-row">
                <div class="level-badge level-badge-${receivedLikes >= 500 ? '4' : (receivedLikes >= 100 ? '3' : (receivedLikes >= 30 ? '2' : '1'))}">
                    <c:choose>
                        <c:when test="${receivedLikes >= 500}">&#x1F3C6;</c:when>
                        <c:when test="${receivedLikes >= 100}">&#x1F3C5;</c:when>
                        <c:when test="${receivedLikes >= 30}">&#x1F9ED;</c:when>
                        <c:otherwise>&#x1F331;</c:otherwise>
                    </c:choose>
                </div>
                <div class="level-info">
                    <div class="level-name">
                        <c:choose>
                            <c:when test="${receivedLikes >= 500}">여행 플랜 전설</c:when>
                            <c:when test="${receivedLikes >= 100}">여행 플랜 마스터</c:when>
                            <c:when test="${receivedLikes >= 30}">여행 플랜 탐험가</c:when>
                            <c:otherwise>여행 플랜 새싹</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="level-sub">
                        <c:choose>
                            <c:when test="${receivedLikes >= 500}">최고 칭호를 달성했어요! 🎉</c:when>
                            <c:when test="${receivedLikes >= 100}">다음 칭호까지 좋아요 ${500 - receivedLikes}개 남았어요</c:when>
                            <c:when test="${receivedLikes >= 30}">다음 칭호까지 좋아요 ${100 - receivedLikes}개 남았어요</c:when>
                            <c:otherwise>다음 칭호까지 좋아요 ${30 - receivedLikes}개 남았어요</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <%-- 진행 바 비율 계산 --%>
            <c:set var="barPct" value="0"/>
            <c:choose>
                <c:when test="${receivedLikes >= 500}"><c:set var="barPct" value="100"/></c:when>
                <c:when test="${receivedLikes >= 100}"><c:set var="barPct" value="${(receivedLikes - 100) * 100 / 400}"/></c:when>
                <c:when test="${receivedLikes >= 30}"><c:set var="barPct" value="${(receivedLikes - 30) * 100 / 70}"/></c:when>
                <c:otherwise><c:set var="barPct" value="${receivedLikes * 100 / 30}"/></c:otherwise>
            </c:choose>
            <div class="bar-track">
                <div class="bar-fill" data-pct="${barPct}"></div>
            </div>
            <div class="bar-label">
                <c:choose>
                    <c:when test="${receivedLikes >= 500}">
                        <span>전설 (500)</span><span>MAX ✨</span>
                    </c:when>
                    <c:when test="${receivedLikes >= 100}">
                        <span>마스터 (100)</span><span>전설 (500)</span>
                    </c:when>
                    <c:when test="${receivedLikes >= 30}">
                        <span>탐험가 (30)</span><span>마스터 (100)</span>
                    </c:when>
                    <c:otherwise>
                        <span>새싹 (0)</span><span>탐험가 (30)</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- 월별 차트 --%>
        <div class="section">
            <div class="section-title">📅 월별 여행 횟수</div>
            <div style="position: relative; width: 100%; height: 200px;">
                <canvas id="barChart" role="img" aria-label="월별 여행 횟수 바차트"></canvas>
            </div>
        </div>

        <%-- 여행 트렌드 --%>
        <div class="section stats-trend-section">
            <div class="section-title">📈 내 여행 트렌드</div>
            <div class="trend-list">
                <c:choose>
                    <c:when test="${not empty trendList}">
                        <c:forEach var="trend" items="${trendList}" varStatus="status">
                            <div class="trend-item">
                                <div class="trend-top">
                                    <span class="trend-rank">
                                        <c:choose>
                                            <c:when test="${status.first}">🥇</c:when>
                                            <c:when test="${status.index == 1}">🥈</c:when>
                                            <c:when test="${status.index == 2}">🥉</c:when>
                                            <c:otherwise>📍</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="trend-name">${trend.destination}</span>
                                    <span class="trend-count">${trend.planId}회</span>
                                </div>
                                <div class="trend-bar-wrap">
                                    <div class="trend-bar" data-pct="${maxCount > 0 ? (trend.planId * 100 / maxCount) : 0}"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
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
            <div class="section-title">🎨 선호 여행 스타일</div>
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
                                        <div class="style-bar style-bg-${(status.index % 5) + 1}" data-pct="${stat.percentage}"></div>
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
    <button type="button" class="mypage-top-nav" id="mypageTopNav" aria-label="맨 위로 이동">
        <span class="mypage-top-nav__icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
                <path d="M12 19V5"></path>
                <path d="M6.5 10.5L12 5l5.5 5.5"></path>
            </svg>
        </span>
        <span class="mypage-top-nav__label">맨 위로</span>
    </button>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
    <script>
        /* ── 진행 바 애니메이션: data-pct 속성 → style.width 적용 ── */
        function applyBarAnimations() {
            var bars = document.querySelectorAll('[data-pct]');
            bars.forEach(function(el) { el.style.width = '0%'; });
            requestAnimationFrame(function() {
                requestAnimationFrame(function() {
                    bars.forEach(function(el) {
                        var pct = Math.min(parseFloat(el.dataset.pct) || 0, 100);
                        el.style.width = pct + '%';
                    });
                });
            });
        }

        /* 1. 모달 함수를 가장 먼저, 그리고 '바깥'에 선언합니다. */
        function openTitleModal() {
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

                    // 통계 탭 열릴 때 진행 바 애니메이션
                    if (targetId === 'content-stats') {
                        setTimeout(applyBarAnimations, 50);
                    }
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
            const targetBtn = document.querySelector('.tab[data-target="' + targetId + '"]');
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

            // 5. 통계 탭 진행 바 애니메이션
            if (targetId === 'content-stats') {
                setTimeout(applyBarAnimations, 80);
            }
        };

        var mypageSnackbar = document.getElementById('mypageSnackbar');
        if (mypageSnackbar && mypageSnackbar.classList.contains('show')) {
            setTimeout(() => {
                mypageSnackbar.classList.remove('show');
            }, 5000);
        }

    const initialTab = new URLSearchParams(window.location.search).get('tab');
    if (initialTab === 'reviews') {
        window.addEventListener('load', function () {
            if (typeof window.triggerTab === 'function') {
                window.triggerTab('content-reviews');
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        const reviewConfirm = document.getElementById('reviewDeleteConfirm');
        const reviewCancel = document.getElementById('reviewDeleteCancel');
        const reviewConfirmBtn = document.getElementById('reviewDeleteConfirmBtn');
        let pendingReviewDeleteForm = null;
        const planConfirm = document.getElementById('planDeleteConfirm');
        const planCancel = document.getElementById('planDeleteCancel');
        const planConfirmBtn = document.getElementById('planDeleteConfirmBtn');
        let pendingPlanDeleteForm = null;

        function openConfirm(confirmEl, focusEl) {
            if (!confirmEl) return;
            confirmEl.classList.add('is-open');
            confirmEl.setAttribute('aria-hidden', 'false');
            if (focusEl) focusEl.focus();
        }

        function closeConfirm(confirmEl) {
            if (!confirmEl) return;
            confirmEl.classList.remove('is-open');
            confirmEl.setAttribute('aria-hidden', 'true');
        }

        function closeReviewConfirm() {
            pendingReviewDeleteForm = null;
            closeConfirm(reviewConfirm);
        }

        function closePlanConfirm() {
            pendingPlanDeleteForm = null;
            closeConfirm(planConfirm);
        }

        document.querySelectorAll('[data-review-delete-form]').forEach(form => {
            form.addEventListener('submit', function (event) {
                event.preventDefault();
                pendingReviewDeleteForm = form;
                if (!reviewConfirm) {
                    form.submit();
                    return;
                }
                openConfirm(reviewConfirm, reviewConfirmBtn);
            });
        });

        document.querySelectorAll('[data-plan-delete-form]').forEach(form => {
            form.addEventListener('submit', function (event) {
                event.preventDefault();
                pendingPlanDeleteForm = form;
                if (!planConfirm) {
                    form.submit();
                    return;
                }
                openConfirm(planConfirm, planConfirmBtn);
            });
        });

        document.querySelectorAll('[data-cancel-like-plan-id]').forEach(button => {
            button.addEventListener('click', function () {
                const planId = this.dataset.cancelLikePlanId;
                if (!planId || this.disabled) return;

                this.disabled = true;
                this.textContent = '취소 중...';

                fetch('${pageContext.request.contextPath}/like', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({ planId: Number(planId) })
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('like request failed');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (!data.success || data.liked) {
                            throw new Error('unexpected like state');
                        }

                        const card = this.closest('.trip-card');
                        if (card) {
                            card.remove();
                        }

                        const likedCount = document.querySelector('.stat-box[onclick*="content-liked"] .stat-num');
                        if (likedCount) {
                            const nextCount = Math.max((parseInt(likedCount.textContent, 10) || 1) - 1, 0);
                            likedCount.textContent = nextCount;
                        }

                        const likedTab = document.getElementById('content-liked');
                        if (likedTab && !likedTab.querySelector('.trip-card')) {
                            likedTab.innerHTML = '<div class="empty-state"><p>❤️ 아직 좋아요를 누른 여행이 없어요!</p></div>';
                        }
                    })
                    .catch(() => {
                        this.disabled = false;
                        this.textContent = '좋아요 취소';
                        alert('좋아요 취소에 실패했습니다. 잠시 후 다시 시도해주세요.');
                    });
            });
        });

        if (reviewCancel) {
            reviewCancel.addEventListener('click', closeReviewConfirm);
        }

        if (reviewConfirmBtn) {
            reviewConfirmBtn.addEventListener('click', function () {
                const form = pendingReviewDeleteForm;
                closeReviewConfirm();
                if (form) form.submit();
            });
        }

        if (planCancel) {
            planCancel.addEventListener('click', closePlanConfirm);
        }

        if (planConfirmBtn) {
            planConfirmBtn.addEventListener('click', function () {
                const form = pendingPlanDeleteForm;
                closePlanConfirm();
                if (form) form.submit();
            });
        }

        if (reviewConfirm) {
            reviewConfirm.addEventListener('click', function (event) {
                if (event.target === reviewConfirm) {
                    closeReviewConfirm();
                }
            });
        }

        if (planConfirm) {
            planConfirm.addEventListener('click', function (event) {
                if (event.target === planConfirm) {
                    closePlanConfirm();
                }
            });
        }

        document.querySelectorAll('[data-review-stack]').forEach(stack => {
            const toggle = stack.querySelector('.review-stack-toggle');
            const cards = stack.querySelector('.review-stack-cards');
            if (!toggle || toggle.disabled) return;

            const toggleStack = function () {
                const isExpanded = stack.classList.toggle('is-expanded');
                stack.classList.toggle('is-collapsed', !isExpanded);
                toggle.setAttribute('aria-expanded', String(isExpanded));

                const hint = toggle.querySelector('.review-stack-toggle__hint');
                if (hint) {
                    hint.textContent = isExpanded ? '접기' : '펼치기';
                }

                if (isExpanded) {
                    setTimeout(function () {
                        stack.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }, 80);
                }
            };

            toggle.addEventListener('click', toggleStack);
            if (cards) {
                cards.addEventListener('click', function () {
                    if (stack.classList.contains('is-collapsed')) {
                        toggleStack();
                    }
                });
            }
        });
    });

    document.addEventListener('DOMContentLoaded', function () {
        const planPreviewModal = document.getElementById('planPreviewModal');
        const planPreviewBody = document.getElementById('planPreviewBody');
        const planPreviewClose = document.getElementById('planPreviewClose');
        const folderState = {
            saved: { mode: 'date', expandedKey: null, plans: [] },
            liked: { mode: 'date', expandedKey: null, plans: [] }
        };

        function cleanDetailText(card, index) {
            const row = card.querySelectorAll('.trip-details p')[index];
            if (!row) return '';
            const clonedRow = row.cloneNode(true);
            const iconWrap = clonedRow.querySelector('span');
            if (iconWrap) {
                iconWrap.remove();
            }
            return clonedRow.textContent.replace(/\s+/g, ' ').trim();
        }

        function formatCreatedLabel(time) {
            if (!time) return '\uB0A0\uC9DC \uBBF8\uC815';
            const date = new Date(time);
            if (Number.isNaN(date.getTime())) return '\uB0A0\uC9DC \uBBF8\uC815';
            return date.getFullYear() + '\uB144 ' + (date.getMonth() + 1) + '\uC6D4 ' + date.getDate() + '\uC77C';
        }

        function getCreatedDateMeta(time) {
            if (!time) {
                return {
                    yearKey: 'unknown',
                    yearLabel: '날짜 미정',
                    yearMonthKey: 'unknown',
                    monthLabel: '미정'
                };
            }

            const date = new Date(time);
            if (Number.isNaN(date.getTime())) {
                return {
                    yearKey: 'unknown',
                    yearLabel: '날짜 미정',
                    yearMonthKey: 'unknown',
                    monthLabel: '미정'
                };
            }

            const year = date.getFullYear();
            const month = date.getMonth() + 1;
            return {
                yearKey: String(year),
                yearLabel: String(year),
                yearMonthKey: year + '-' + String(month).padStart(2, '0'),
                monthLabel: month + '월'
            };
        }

        function escapeHtml(value) {
            return String(value || '')
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function parsePlanCard(card, source) {
            const statusBadge = card.querySelector('.status-badge');
            const destinationValue = (card.dataset.destination || '').trim();
            const travelStyleValue = (card.dataset.travelStyle || '').trim();
            const createdTime = Number(card.dataset.createdTime || 0);
            const createdMeta = getCreatedDateMeta(createdTime);
            return {
                source: source,
                planId: Number(card.dataset.planId || 0),
                posted: String(card.dataset.posted) === '1',
                likeCount: Number(card.dataset.likeCount || 0),
                createdTime: createdTime,
                createdLabel: formatCreatedLabel(createdTime),
                createdYearKey: createdMeta.yearKey,
                createdYearLabel: createdMeta.yearLabel,
                createdYearMonthKey: createdMeta.yearMonthKey,
                createdMonthLabel: createdMeta.monthLabel,
                title: ((card.querySelector('h3') || {}).textContent || '').trim(),
                destination: destinationValue || '여행지 미정',
                dateRange: cleanDetailText(card, 1) || '일정 미정',
                duration: cleanDetailText(card, 2) || '기간 미정',
                travelers: cleanDetailText(card, 3) || '인원 미정',
                travelStyle: travelStyleValue || '여행 스타일',
                status: statusBadge ? statusBadge.textContent.trim() : '상태 미정',
                statusClass: statusBadge ? Array.from(statusBadge.classList).find(function (name) { return name !== 'status-badge'; }) || 'blue' : 'blue',
                liveTracking: String(card.dataset.liveTracking) === '1',
                starred: String(card.dataset.starred) === 'true',
                originalCard: card
            };
        }

        function sortPlans(plans) {
            return plans.slice().sort(function (a, b) {
                if (a.liveTracking !== b.liveTracking) return a.liveTracking ? -1 : 1;
                if (a.starred !== b.starred) return a.starred ? -1 : 1;
                return (b.createdTime || 0) - (a.createdTime || 0);
            });
        }

        function groupPlans(plans, mode) {
            const grouped = new Map();

            plans.forEach(function (plan) {
                const key = mode === 'destination' ? plan.destination : plan.createdLabel;
                if (!grouped.has(key)) grouped.set(key, []);
                grouped.get(key).push(plan);
            });

            return Array.from(grouped.entries()).map(function (entry) {
                const items = sortPlans(entry[1]);
                const anchorPlan = items.slice().sort(function (a, b) {
                    return (b.createdTime || 0) - (a.createdTime || 0);
                })[0] || items[0];
                return {
                    key: entry[0],
                    title: entry[0],
                    latestTime: Math.max.apply(null, items.map(function (item) { return item.createdTime || 0; })),
                    yearKey: anchorPlan ? anchorPlan.createdYearKey : 'unknown',
                    yearLabel: anchorPlan ? anchorPlan.createdYearLabel : '날짜 미정',
                    yearMonthKey: anchorPlan ? anchorPlan.createdYearMonthKey : 'unknown',
                    monthLabel: anchorPlan ? anchorPlan.createdMonthLabel : '미정',
                    hasLivePlan: items.some(function (item) { return item.liveTracking; }),
                    items: items
                };
            }).sort(function (a, b) {
                if (mode === 'destination') {
                    if (a.hasLivePlan !== b.hasLivePlan) {
                        return a.hasLivePlan ? -1 : 1;
                    }
                    if (b.items.length !== a.items.length) {
                        return b.items.length - a.items.length;
                    }
                }
                return b.latestTime - a.latestTime;
            });
        }

        function normalizeFolderQuery(value) {
            return String(value || '').toLowerCase().replace(/\s+/g, '').trim();
        }

        function extractDigits(value) {
            return String(value || '').replace(/\D/g, '');
        }

        function getFolderSearchPlaceholder(mode) {
            return mode === 'destination' ? '목적지로 바로가기' : '날짜로 바로가기';
        }

        function rankFolderSearchGroups(groups, mode, query) {
            const rawQuery = String(query || '').trim();
            if (!rawQuery) {
                return groups.slice(0, 6);
            }

            const normalizedQuery = normalizeFolderQuery(rawQuery);
            const digitQuery = extractDigits(rawQuery);

            return groups.map(function (group, index) {
                const normalizedTitle = normalizeFolderQuery(group.title);
                const digitTitle = extractDigits(group.title);
                let score = -1;

                if (mode === 'destination') {
                    if (normalizedTitle === normalizedQuery) {
                        score = 1000;
                    } else if (normalizedTitle.indexOf(normalizedQuery) !== -1) {
                        score = 800 - (normalizedTitle.length - normalizedQuery.length);
                    } else if (normalizedQuery.indexOf(normalizedTitle) !== -1) {
                        score = 640 - (normalizedQuery.length - normalizedTitle.length);
                    }
                } else {
                    if (digitQuery) {
                        if (digitTitle === digitQuery) {
                            score = 1000;
                        } else if (digitTitle.indexOf(digitQuery) !== -1) {
                            score = 820 - (digitTitle.length - digitQuery.length);
                        } else {
                            const chunks = rawQuery.match(/\d+/g) || [];
                            const hitCount = chunks.filter(function (chunk) {
                                return chunk && group.title.indexOf(chunk) !== -1;
                            }).length;
                            if (hitCount) {
                                score = 500 + hitCount * 80;
                            }
                        }
                    }

                    if (score < 0 && normalizedTitle.indexOf(normalizedQuery) !== -1) {
                        score = 300 - (normalizedTitle.length - normalizedQuery.length);
                    }
                }

                return {
                    group: group,
                    score: score,
                    index: index
                };
            }).filter(function (item) {
                return item.score >= 0;
            }).sort(function (a, b) {
                if (b.score !== a.score) return b.score - a.score;
                return a.index - b.index;
            }).slice(0, 6).map(function (item) {
                return item.group;
            });
        }

        function closeFolderSearchList(shell) {
            if (!shell) return;
            const list = shell.querySelector('[data-folder-search-list]');
            if (!list) return;
            list.hidden = true;
            list.innerHTML = '';
        }

        function renderFolderSearch(source, groups) {
            const state = folderState[source];
            const shell = document.querySelector('.plan-folder-shell[data-source="' + source + '"]');
            if (!state || !shell) return;

            state.renderedGroups = groups.slice();

            const input = shell.querySelector('[data-folder-search-input]');
            const list = shell.querySelector('[data-folder-search-list]');
            if (!input || !list) return;

            input.placeholder = getFolderSearchPlaceholder(state.mode);

            const query = input.value || '';
            const suggestions = rankFolderSearchGroups(groups, state.mode, query);

            if (!query.trim()) {
                list.hidden = true;
                list.innerHTML = '';
                return;
            }

            if (!suggestions.length) {
                list.hidden = false;
                list.innerHTML = '<div class="plan-folder-search__empty">바로 이동할 폴더를 찾지 못했어요.</div>';
                return;
            }

            list.hidden = false;
            list.innerHTML = suggestions.map(function (group) {
                const subText = state.mode === 'destination'
                    ? '목적지 폴더 · 최신 저장 시점 ' + escapeHtml(group.yearLabel) + '년'
                    : '날짜 폴더 · ' + escapeHtml(group.monthLabel);
                return [
                    '<button type="button" class="plan-folder-search__item" data-folder-search-jump="' + escapeHtml(group.key) + '" data-folder-search-source="' + source + '">',
                        '<span class="plan-folder-search__main">',
                            '<span class="plan-folder-search__label">' + escapeHtml(group.title) + '</span>',
                            '<span class="plan-folder-search__sub">' + subText + '</span>',
                        '</span>',
                        '<span class="plan-folder-search__count">' + group.items.length + '개</span>',
                    '</button>'
                ].join('');
            }).join('');
        }

        function jumpToFolder(source, key) {
            const state = folderState[source];
            if (!state) return;

            state.expandedKey = key;
            renderFolderView(source);

            const shell = document.querySelector('.plan-folder-shell[data-source="' + source + '"]');
            if (shell) {
                const input = shell.querySelector('[data-folder-search-input]');
                if (input) input.blur();
                closeFolderSearchList(shell);
            }

            requestAnimationFrame(function () {
                const shellEl = document.querySelector('.plan-folder-shell[data-source="' + source + '"]');
                const target = shellEl ? Array.from(shellEl.querySelectorAll('[data-folder-group]')).find(function (group) {
                    return group.dataset.folderKey === String(key);
                }) : null;
                if (!target) return;
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                const toggle = target.querySelector('[data-folder-toggle]');
                if (toggle) toggle.focus({ preventScroll: true });
            });
        }

        function setPanelHeight(group) {
            const panel = group.querySelector('.plan-folder-panel');
            if (!panel) return;
            panel.style.maxHeight = group.classList.contains('is-expanded') ? panel.scrollHeight + 'px' : '0px';
        }
        function createMiniCard(plan) {
            const safeTitle = escapeHtml(plan.title);
            const safeDestination = escapeHtml(plan.destination);
            const safeDuration = escapeHtml(plan.duration);
            const safeTravelers = escapeHtml(plan.travelers);
            const safeLikeCount = escapeHtml(String(plan.likeCount || 0));
            const styleTags = String(plan.travelStyle || '')
                .split(/[#,/|]/)
                .map(function (value) { return value.trim(); })
                .filter(function (value, index, array) {
                    return value && array.indexOf(value) === index;
                });
            const safeStyleTags = (styleTags.length ? styleTags : ['여행 스타일']).map(function (style) {
                return '<span>#' + escapeHtml(style) + '</span>';
            }).join('');

            return [
                '<button type="button" class="plan-mini-card ' + (plan.liveTracking ? 'is-live' : '') + '" data-mini-plan-id="' + plan.planId + '" data-mini-source="' + plan.source + '">',
                    '<div class="plan-mini-card__top">',
                        '<h4 class="plan-mini-card__title">' + safeTitle + '</h4>',
                        '<div class="plan-mini-card__badges">',
                            (plan.starred ? '<span class="plan-mini-flag star" aria-label="즐겨찾기">★</span>' : ''),
                            (plan.liveTracking ? '<span class="plan-mini-flag live" aria-label="실시간"><span class="plan-live-dot"></span></span>' : ''),
                        '</div>',
                    '</div>',
                    '<div class="plan-mini-card__subline">',
                        '<span class="plan-mini-card__destination"><i class="fa-solid fa-location-dot"></i> ' + safeDestination + '</span>',
                        '<span class="plan-mini-card__plan-id">plan #' + plan.planId + '</span>',
                    '</div>',
                    '<div class="plan-mini-tags" data-mini-tags>',
                        '<div class="plan-mini-tags__viewport">',
                            '<div class="plan-mini-tags__rail">' + safeStyleTags + '</div>',
                        '</div>',
                        '<span class="plan-mini-tags__toggle" data-mini-tags-toggle aria-expanded="false" hidden>...</span>',
                    '</div>',
                    '<div class="plan-mini-info">',
                        '<span><i class="fa-regular fa-calendar"></i> ' + safeDuration + '</span>',
                        '<span><i class="fa-solid fa-user-group"></i> ' + safeTravelers + '</span>',
                        '<span><i class="fa-solid fa-heart"></i> ' + safeLikeCount + '</span>',
                        (plan.posted ? '<span class="plan-mini-post-badge">게시됨</span>' : ''),
                    '</div>',
                '</button>'
            ].join('');
        }

        function createPeekStackCard(plan, index) {
            const safeTitle = escapeHtml(plan.title);
            const safeDestination = escapeHtml(plan.destination);
            const safeStyle = escapeHtml(plan.travelStyle);
            const starFlag = plan.starred ? '<span class="plan-folder-stack-badge star" aria-label="즐겨찾기">★</span>' : '';
            const liveFlag = plan.liveTracking ? '<span class="plan-folder-stack-badge live" aria-label="실시간"><span class="plan-live-dot"></span></span>' : '';

            return [
                '<span class="plan-folder-stack-card">',
                    '<span class="plan-folder-stack-card__top">',
                        '<span class="plan-folder-stack-card__title">' + safeTitle + '</span>',
                        '<span class="plan-folder-stack-card__badges">' + starFlag + liveFlag + '</span>',
                    '</span>',
                    '<span class="plan-folder-stack-card__meta"><i class="fa-solid fa-location-dot"></i> ' + safeDestination + '</span>',
                    '<span class="plan-folder-stack-card__style">' + safeStyle + '</span>',
                '</span>'
            ].join('');
        }

        function renderFolderView(source) {
            const state = folderState[source];
            const shell = document.querySelector('.plan-folder-shell[data-source="' + source + '"]');
            if (!shell) return;

            const view = shell.querySelector('[data-folder-view]');
            const empty = document.querySelector('#content-' + source + ' [data-folder-empty]');
            const groups = groupPlans(state.plans, state.mode);

            if (!groups.length) {
                if (view) view.innerHTML = '';
                if (empty) empty.hidden = false;
                return;
            }

            if (empty) empty.hidden = true;

            let lastYearKey = null;
            view.innerHTML = groups.map(function (group, groupIndex) {
                const expanded = state.expandedKey === group.key;
                const liveCount = group.items.filter(function (item) { return item.liveTracking; }).length;
                const starCount = group.items.filter(function (item) { return item.starred; }).length;
                const safeGroupTitle = escapeHtml(group.title);
                const previewCards = group.items.slice(0, 3).map(function (item, index) {
                    return createPeekStackCard(item, index);
                }).join('');
                const nextGroup = groups[groupIndex + 1];
                const previousGroup = groups[groupIndex - 1];
                const showYearDivider = group.yearKey !== lastYearKey;
                const connectMonthLine = nextGroup && nextGroup.yearMonthKey === group.yearMonthKey && group.yearMonthKey !== 'unknown';
                const showMonthLabel = state.mode === 'date' && (!previousGroup || previousGroup.yearMonthKey !== group.yearMonthKey);
                const folderBody = [
                    '<section class="plan-folder-group has-stack ' + (expanded ? 'is-expanded' : 'is-collapsed') + (liveCount ? ' has-live-plan' : '') + '" data-folder-group data-folder-key="' + group.key + '">',
                        '<button type="button" class="plan-folder-cover" data-folder-toggle aria-expanded="' + expanded + '">',
                            '<div class="plan-folder-cover__main">',
                                '<h3 class="plan-folder-cover__title">' + safeGroupTitle + '</h3>',
                                '<div class="plan-folder-cover__meta">',
                                    '<span class="plan-folder-count">' + group.items.length + '개 플랜</span>',
                                    (liveCount ? '<span class="plan-folder-flag plan-folder-flag--live"><span class="plan-live-dot"></span> 실시간 ' + liveCount + '</span>' : ''),
                                    (starCount ? '<span class="plan-folder-flag">즐겨찾기 ' + starCount + '</span>' : ''),
                                '</div>',
                            '</div>',
                            '<span class="plan-folder-toggle__hint">' + (expanded ? '접기' : '펼치기') + '</span>',
                        '</button>',
                        '<div class="plan-folder-preview-stack" data-folder-preview aria-hidden="true">' + previewCards + '</div>',
                        '<div class="plan-folder-panel">',
                            '<div class="plan-mini-slider" data-plan-slider>',
                                '<div class="plan-mini-slider__viewport" data-plan-slider-viewport>',
                                    '<div class="plan-mini-grid" data-plan-slider-track>',
                                        group.items.map(createMiniCard).join(''),
                                    '</div>',
                                '</div>',
                                '<div class="plan-mini-slider__dots" data-plan-slider-dots>',
                                    group.items.map(function (item, itemIndex) {
                                        return '<button type="button" class="plan-mini-slider__dot' + (itemIndex === 0 ? ' is-active' : '') + '" data-plan-slider-dot="' + itemIndex + '" aria-label="플랜 ' + (itemIndex + 1) + '번으로 이동"></button>';
                                    }).join(''),
                                '</div>',
                            '</div>',
                        '</div>',
                    '</section>'
                ].join('');

                const parts = [];
                if (showYearDivider) {
                    parts.push('<div class="plan-year-divider">' + escapeHtml(group.yearLabel) + '</div>');
                    lastYearKey = group.yearKey;
                }
                parts.push([
                    '<div class="plan-folder-tl-wrap">',
                        '<div class="plan-folder-tl-axis">',
                            '<div class="plan-folder-tl-head">',
                                (showMonthLabel ? '<div class="plan-folder-tl-month">' + escapeHtml(group.monthLabel) + '</div>' : ''),
                                '<div class="plan-folder-tl-dot"></div>',
                            '</div>',
                            (connectMonthLine ? '<div class="plan-folder-tl-line"></div>' : ''),
                        '</div>',
                        '<div class="plan-folder-tl-content">',
                            folderBody,
                        '</div>',
                    '</div>'
                ].join(''));
                return parts.join('');
            }).join('');

            view.querySelectorAll('[data-folder-group]').forEach(setPanelHeight);
            renderFolderSearch(source, groups);
            setupMiniTagOverflow(view);
            setupMiniSliders(view);
            hidePlanSeedLists();
        }

        function setupMiniTagOverflow(scope) {
            (scope || document).querySelectorAll('[data-mini-tags]').forEach(function (wrap) {
                const viewport = wrap.querySelector('.plan-mini-tags__viewport');
                const rail = wrap.querySelector('.plan-mini-tags__rail');
                const toggle = wrap.querySelector('[data-mini-tags-toggle]');
                if (!viewport || !rail || !toggle) return;

                wrap.classList.remove('is-open');
                toggle.setAttribute('aria-expanded', 'false');
                rail.style.transform = 'translateX(0)';
                rail.style.transition = 'none';

                const overflowAmount = Math.max(0, Math.ceil(rail.scrollWidth - viewport.clientWidth));
                wrap.dataset.tagsOverflow = String(overflowAmount);
                toggle.hidden = overflowAmount <= 4;
            });
        }

        function setupMiniSliders(scope) {
            const isMobile = window.matchMedia('(max-width: 767px)').matches;

            (scope || document).querySelectorAll('[data-plan-slider]').forEach(function (slider) {
                const viewport = slider.querySelector('[data-plan-slider-viewport]');
                const track = slider.querySelector('[data-plan-slider-track]');
                const dots = Array.from(slider.querySelectorAll('[data-plan-slider-dot]'));
                if (!viewport || !track) return;

                const cards = Array.from(track.querySelectorAll('.plan-mini-card'));
                if (!cards.length) return;

                if (!isMobile) {
                    viewport.dataset.dragging = '';
                    viewport.style.height = '';
                    track.style.height = '';
                    cards.forEach(function (card) {
                        card.style.transform = '';
                        card.style.opacity = '';
                        card.style.zIndex = '';
                        card.style.pointerEvents = '';
                        card.style.transition = '';
                    });
                    slider.dataset.sliderReady = '';
                    slider.dataset.sliderIndex = slider.dataset.sliderIndex || '0';
                    return;
                }

                const total = cards.length;
                let currentIndex = Number(slider.dataset.sliderIndex || 0);
                if (!Number.isFinite(currentIndex) || currentIndex < 0) {
                    currentIndex = 0;
                }
                currentIndex = currentIndex % total;

                const viewportWidth = viewport.clientWidth || slider.clientWidth || 1;
                const activeWidth = viewportWidth * 0.72;
                const stackOffsetX = Math.max(20, Math.round(viewportWidth * 0.12));
                const stackOffsetY = 0;
                const hiddenLeftX = -Math.round(activeWidth * 0.72);
                const dragThreshold = Math.max(28, Math.round(activeWidth * 0.16));

                function wrapIndex(index) {
                    return (index + total) % total;
                }

                function syncDots() {
                    dots.forEach(function (dot, dotIndex) {
                        dot.classList.toggle('is-active', dotIndex === currentIndex);
                    });
                }

                function toRelative(index) {
                    let diff = index - currentIndex;
                    if (diff > total / 2) diff -= total;
                    if (diff < -total / 2) diff += total;
                    return diff;
                }

                function cardPose(relative, dragX) {
                    const progress = Math.max(-1, Math.min(1, dragX / activeWidth));
                    const rightPull = Math.max(0, progress);
                    const leftPull = Math.max(0, -progress);
                    let x = 0;
                    let y = 0;
                    let scale = 1;
                    let opacity = 1;
                    let z = 6;

                    if (relative === 0) {
                        x = dragX;
                        y = 0;
                        scale = 1 - rightPull * 0.02;
                    } else if (relative === 1) {
                        x = stackOffsetX + dragX * (leftPull > 0 ? 0.28 : 0.08);
                        y = 0;
                        scale = 0.95 + leftPull * 0.02;
                        opacity = 1;
                        z = 5;
                    } else if (relative === 2) {
                        x = stackOffsetX * 2 + dragX * (leftPull > 0 ? 0.18 : 0.05);
                        y = 0;
                        scale = 0.9;
                        opacity = 1;
                        z = 4;
                    } else if (relative >= 3) {
                        x = stackOffsetX * 2.6 + dragX * (leftPull > 0 ? 0.12 : 0.03);
                        y = 0;
                        scale = 0.86;
                        opacity = 1;
                        z = 3;
                    } else if (relative === -1) {
                        x = hiddenLeftX - 28 + Math.max(0, dragX) * 1.02;
                        y = 0;
                        scale = 0.94 + rightPull * 0.06;
                        opacity = rightPull > 0 ? Math.min(1, 0.12 + rightPull * 0.88) : 0;
                        z = rightPull > 0 ? 7 : 2;
                    } else {
                        x = hiddenLeftX - stackOffsetX;
                        y = 0;
                        scale = 0.9;
                        opacity = 0;
                        z = 1;
                    }

                    return { x: x, y: y, scale: scale, opacity: opacity, z: z };
                }

                function renderStack(dragX, animate) {
                    let maxHeight = 0;

                    cards.forEach(function (card, index) {
                        const relative = toRelative(index);
                        const pose = cardPose(relative, dragX);

                        card.style.transition = animate ? 'transform 0.28s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.22s ease' : 'none';
                        card.style.transform = 'translate3d(' + pose.x + 'px, ' + pose.y + 'px, 0) scale(' + pose.scale + ')';
                        card.style.opacity = String(pose.opacity);
                        card.style.zIndex = String(pose.z);
                        card.style.pointerEvents = relative === 0 ? 'auto' : 'none';

                        maxHeight = Math.max(maxHeight, card.offsetHeight + Math.max(pose.y, 0));
                    });

                    const nextHeight = Math.max(180, Math.ceil(maxHeight) + 6);
                    viewport.style.height = nextHeight + 'px';
                    track.style.height = nextHeight + 'px';
                    slider.dataset.sliderIndex = String(currentIndex);
                    syncDots();
                }

                renderStack(0, false);

                if (slider.dataset.sliderReady === 'true') {
                    return;
                }

                slider.dataset.sliderReady = 'true';

                let startX = 0;
                let dragX = 0;
                let pointerActive = false;
                let moved = false;
                let pointerId = null;

                function endDrag(clientX) {
                    if (!pointerActive) return;
                    pointerActive = false;

                    dragX = clientX - startX;

                    if (dragX <= -dragThreshold) {
                        currentIndex = wrapIndex(currentIndex + 1);
                    } else if (dragX >= dragThreshold) {
                        currentIndex = wrapIndex(currentIndex - 1);
                    }

                    renderStack(0, true);

                    if (moved) {
                        viewport.dataset.dragging = 'true';
                        setTimeout(function () {
                            viewport.dataset.dragging = '';
                        }, 140);
                    }
                }

                viewport.addEventListener('pointerdown', function (event) {
                    if (!window.matchMedia('(max-width: 767px)').matches) return;
                    if (event.pointerType === 'mouse') return;

                    pointerActive = true;
                    moved = false;
                    pointerId = event.pointerId;
                    startX = event.clientX;
                    dragX = 0;
                    viewport.setPointerCapture(event.pointerId);
                    cards.forEach(function (card) {
                        card.style.transition = 'none';
                    });
                });

                viewport.addEventListener('pointermove', function (event) {
                    if (!pointerActive || pointerId !== event.pointerId) return;

                    dragX = event.clientX - startX;
                    if (Math.abs(dragX) > 6) {
                        moved = true;
                    }

                    renderStack(dragX, false);
                });

                viewport.addEventListener('pointerup', function (event) {
                    if (pointerId !== event.pointerId) return;
                    endDrag(event.clientX);
                    pointerId = null;
                });

                viewport.addEventListener('pointercancel', function (event) {
                    if (pointerId !== event.pointerId) return;
                    endDrag(event.clientX);
                    pointerId = null;
                });

                viewport.addEventListener('lostpointercapture', function (event) {
                    if (pointerActive && pointerId === event.pointerId) {
                        endDrag(startX + dragX);
                        pointerId = null;
                    }
                });

                viewport.addEventListener('click', function (event) {
                    if (viewport.dataset.dragging === 'true') {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                }, true);

                dots.forEach(function (dot) {
                    dot.addEventListener('click', function (event) {
                        event.preventDefault();
                        event.stopPropagation();
                        currentIndex = wrapIndex(Number(dot.dataset.planSliderDot || 0));
                        renderStack(0, true);
                    });
                });
            });
        }

        function refreshFolderCounts() {
            const savedCount = document.querySelectorAll('#content-saved [data-plan-seed-list] .trip-card').length;
            const likedCount = document.querySelectorAll('#content-liked [data-plan-seed-list] .trip-card').length;
            const savedStat = document.querySelector('.stat-box[onclick*="content-saved"] .stat-num');
            const likedStat = document.querySelector('.stat-box[onclick*="content-liked"] .stat-num');

            if (savedStat) savedStat.textContent = savedCount;
            if (likedStat) likedStat.textContent = likedCount;
        }

        function hidePlanSeedLists() {
            document.querySelectorAll('[data-plan-seed-list]').forEach(function (list) {
                list.hidden = true;
                list.setAttribute('aria-hidden', 'true');
                list.style.display = 'none';
                list.style.visibility = 'hidden';
                list.style.opacity = '0';
                list.style.width = '0';
                list.style.height = '0';
                list.style.maxHeight = '0';
                list.style.overflow = 'hidden';
                list.style.pointerEvents = 'none';
                list.style.position = 'absolute';
                list.style.left = '-99999px';
                list.style.top = '0';

                list.querySelectorAll('.trip-card').forEach(function (card) {
                    card.hidden = true;
                    card.setAttribute('aria-hidden', 'true');
                });
            });
        }

        function bootstrapFolders() {
            hidePlanSeedLists();
            ['saved', 'liked'].forEach(function (source) {
                const cards = document.querySelectorAll('#content-' + source + ' [data-plan-seed-list] .trip-card');
                folderState[source].plans = Array.from(cards).map(function (card) {
                    return parsePlanCard(card, source);
                });
                renderFolderView(source);
            });
            refreshFolderCounts();
        }

        function openPlanPreview(source, planId) {
            if (!planPreviewModal || !planPreviewBody) return;
            const state = folderState[source];
            if (!state) return;
            const plan = state.plans.find(function (item) {
                return item.planId === Number(planId);
            });
            if (!plan || !plan.originalCard) return;

            planPreviewBody.innerHTML = '';
            const previewCard = plan.originalCard.cloneNode(true);
            previewCard.hidden = false;
            previewCard.removeAttribute('hidden');
            previewCard.removeAttribute('aria-hidden');
            previewCard.style.display = '';
            previewCard.style.visibility = '';
            previewCard.style.opacity = '';
            previewCard.style.width = '';
            previewCard.style.height = '';
            previewCard.style.maxHeight = '';
            previewCard.style.overflow = '';
            previewCard.style.pointerEvents = '';
            previewCard.style.left = '';
            previewCard.style.top = '';
            if (previewCard.querySelector('.live-track-btn')) {
                previewCard.style.position = 'relative';
            } else {
                previewCard.style.position = '';
            }
            planPreviewBody.appendChild(previewCard);
            syncModalLiveTracking(plan, source);
            planPreviewModal.classList.add('is-open');
            planPreviewModal.setAttribute('aria-hidden', 'false');
            document.body.style.overflow = 'hidden';
        }

        function updateSavedPlanTrackingState(planId, isLive) {
            document.querySelectorAll('#content-saved .trip-card[data-plan-id="' + planId + '"]').forEach(function (card) {
                card.dataset.liveTracking = isLive ? '1' : '0';
                if (isLive) {
                    card.classList.add('active-card');
                } else {
                    card.classList.remove('active-card');
                }

                const liveBtn = card.querySelector('.live-track-btn');
                if (liveBtn) {
                    liveBtn.textContent = isLive ? '🔴실시간 트래킹중' : '🚀 실시간 트래킹 하기';
                    liveBtn.innerHTML = liveBtn.textContent;
                    liveBtn.style.backgroundColor = isLive ? '#ef444480' : '#1d4ed8ab';
                }
            });

            folderState.saved.plans.forEach(function (item) {
                item.liveTracking = String(item.planId) === String(planId) ? isLive : false;
            });
            renderFolderView('saved');
        }

        function resetOtherSavedTrackingStates(activePlanId) {
            document.querySelectorAll('#content-saved .trip-card').forEach(function (card) {
                if (String(card.dataset.planId) === String(activePlanId)) return;
                card.dataset.liveTracking = '0';
                card.classList.remove('active-card');

                const liveBtn = card.querySelector('.live-track-btn');
                if (liveBtn) {
                    liveBtn.textContent = '🚀 실시간 트래킹 하기';
                    liveBtn.innerHTML = liveBtn.textContent;
                    liveBtn.style.backgroundColor = '#1d4ed8ab';
                }
            });

            folderState.saved.plans.forEach(function (item) {
                if (String(item.planId) !== String(activePlanId)) {
                    item.liveTracking = false;
                }
            });
        }

        function syncModalLiveTracking(plan, source) {
            if (source !== 'saved') return;

            const modalCard = planPreviewBody.querySelector('.trip-card');
            const liveBtn = modalCard ? modalCard.querySelector('.live-track-btn') : null;
            if (!modalCard || !liveBtn) return;
            liveBtn.setAttribute('type', 'button');

            const planId = String(plan.planId);
            const ctx = window.MYPAGE_CTX || '';
            const destination = encodeURIComponent(plan.destination || '');

            function paintModalLiveState(isLive) {
                modalCard.dataset.liveTracking = isLive ? '1' : '0';
                if (isLive) {
                    modalCard.classList.add('active-card');
                    liveBtn.textContent = '🔴실시간 트래킹중';
                    liveBtn.innerHTML = liveBtn.textContent;
                    liveBtn.style.backgroundColor = '#ef444480';
                } else {
                    modalCard.classList.remove('active-card');
                    liveBtn.textContent = '🚀 실시간 트래킹 하기';
                    liveBtn.innerHTML = liveBtn.textContent;
                    liveBtn.style.backgroundColor = '#1d4ed8ab';
                }
            }

            liveBtn.addEventListener('click', function (event) {
                event.preventDefault();
                event.stopPropagation();
                const isTracking = localStorage.getItem('liveTrackingPlanId') === planId || modalCard.dataset.liveTracking === '1';

                if (isTracking) {
                    paintModalLiveState(false);
                    localStorage.removeItem('liveTrackingPlanId');
                    fetch(ctx + '/live-tracking', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json'
                        },
                        body: JSON.stringify({ action: 'stop', planId: planId })
                    }).finally(function () {
                        updateSavedPlanTrackingState(planId, false);
                    });
                    return;
                }

                resetOtherSavedTrackingStates(planId);
                localStorage.setItem('liveTrackingPlanId', planId);
                paintModalLiveState(true);
                updateSavedPlanTrackingState(planId, true);
                window.location.href = ctx + '/my-live?planId=' + encodeURIComponent(planId) + '&destination=' + destination;
            });
        }

        function closePlanPreview() {
            if (!planPreviewModal) return;
            planPreviewModal.classList.remove('is-open');
            planPreviewModal.setAttribute('aria-hidden', 'true');
            if (planPreviewBody) planPreviewBody.innerHTML = '';
            document.body.style.overflow = '';
        }

        function removeLikedPlan(planId) {
            document.querySelectorAll('#content-liked [data-plan-seed-list] .trip-card[data-plan-id="' + planId + '"]').forEach(function (card) {
                card.remove();
            });
            folderState.liked.plans = folderState.liked.plans.filter(function (plan) {
                return plan.planId !== Number(planId);
            });
            folderState.liked.expandedKey = null;
            renderFolderView('liked');
            refreshFolderCounts();
            closePlanPreview();
        }

        if (planPreviewClose) {
            planPreviewClose.addEventListener('click', closePlanPreview);
        }

        if (planPreviewModal) {
            planPreviewModal.addEventListener('click', function (event) {
                if (event.target === planPreviewModal) {
                    closePlanPreview();
                }
            });
        }

        const delegatedPlanConfirmBtn = document.getElementById('planDeleteConfirmBtn');
        if (delegatedPlanConfirmBtn) {
            delegatedPlanConfirmBtn.addEventListener('click', function () {
                if (window.pendingPlanDeleteForm) {
                    const form = window.pendingPlanDeleteForm;
                    window.pendingPlanDeleteForm = null;
                    form.submit();
                }
            });
        }

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                closePlanPreview();
            }
        });

        document.addEventListener('submit', function (event) {
            const planForm = event.target.closest('[data-plan-delete-form]');
            if (!planForm) return;

            event.preventDefault();
            const planConfirm = document.getElementById('planDeleteConfirm');
            const planConfirmBtn = document.getElementById('planDeleteConfirmBtn');
            window.pendingPlanDeleteForm = planForm;

            if (!planConfirm) {
                planForm.submit();
                return;
            }

            planConfirm.classList.add('is-open');
            planConfirm.setAttribute('aria-hidden', 'false');
            if (planConfirmBtn) planConfirmBtn.focus();
        }, true);

        document.addEventListener('click', function (event) {
            document.querySelectorAll('[data-mini-tags].is-open').forEach(function (openWrap) {
                if (!openWrap.contains(event.target)) {
                    openWrap.classList.remove('is-open');
                    const openToggle = openWrap.querySelector('[data-mini-tags-toggle]');
                    if (openToggle) openToggle.setAttribute('aria-expanded', 'false');
                    const openRail = openWrap.querySelector('.plan-mini-tags__rail');
                    if (openRail) {
                        openRail.style.transition = 'transform 0.22s ease';
                        openRail.style.transform = 'translateX(0)';
                    }
                }
            });

            document.querySelectorAll('[data-folder-search]').forEach(function (searchWrap) {
                if (!searchWrap.contains(event.target)) {
                    closeFolderSearchList(searchWrap.closest('.plan-folder-shell'));
                }
            });

            const chip = event.target.closest('.plan-sort-chip');
            if (chip) {
                const shell = chip.closest('.plan-folder-shell');
                const source = shell ? shell.dataset.source : '';
                if (!source || !folderState[source]) return;

                shell.querySelectorAll('.plan-sort-chip').forEach(function (button) {
                    button.classList.toggle('active', button === chip);
                });

                folderState[source].mode = chip.dataset.groupMode || 'date';
                folderState[source].expandedKey = null;
                const input = shell.querySelector('[data-folder-search-input]');
                if (input) input.value = '';
                closeFolderSearchList(shell);
                renderFolderView(source);
                return;
            }

            const jumpButton = event.target.closest('[data-folder-search-jump]');
            if (jumpButton) {
                const source = jumpButton.dataset.folderSearchSource || '';
                const key = jumpButton.dataset.folderSearchJump || '';
                if (!source || !key) return;
                jumpToFolder(source, key);
                return;
            }

            const tagToggle = event.target.closest('[data-mini-tags-toggle]');
            if (tagToggle) {
                const tagsWrap = tagToggle.closest('[data-mini-tags]');
                if (!tagsWrap) return;
                const rail = tagsWrap.querySelector('.plan-mini-tags__rail');
                const overflowAmount = Number(tagsWrap.dataset.tagsOverflow || 0);
                const nextState = !tagsWrap.classList.contains('is-open');
                document.querySelectorAll('[data-mini-tags].is-open').forEach(function (openWrap) {
                    if (openWrap !== tagsWrap) {
                        openWrap.classList.remove('is-open');
                        const openToggle = openWrap.querySelector('[data-mini-tags-toggle]');
                        if (openToggle) openToggle.setAttribute('aria-expanded', 'false');
                        const openRail = openWrap.querySelector('.plan-mini-tags__rail');
                        if (openRail) {
                            openRail.style.transition = 'transform 0.22s ease';
                            openRail.style.transform = 'translateX(0)';
                        }
                    }
                });
                tagsWrap.classList.toggle('is-open', nextState);
                tagToggle.setAttribute('aria-expanded', String(nextState));
                if (rail) {
                    rail.style.transition = 'transform 0.22s ease';
                    rail.style.transform = nextState && overflowAmount > 0 ? 'translateX(-' + overflowAmount + 'px)' : 'translateX(0)';
                }
                return;
            }

            const preview = event.target.closest('[data-folder-preview]');
            if (preview) {
                const group = preview.closest('[data-folder-group]');
                const shell = preview.closest('.plan-folder-shell');
                const source = shell ? shell.dataset.source : '';
                if (!source || !group || !folderState[source]) return;

                const key = group.dataset.folderKey || '';
                folderState[source].expandedKey = folderState[source].expandedKey === key ? null : key;
                renderFolderView(source);
                return;
            }

            const toggle = event.target.closest('[data-folder-toggle]');
            if (toggle) {
                const shell = toggle.closest('.plan-folder-shell');
                const group = toggle.closest('[data-folder-group]');
                const source = shell ? shell.dataset.source : '';
                if (!source || !group || !folderState[source]) return;

                const key = group.dataset.folderKey || '';
                folderState[source].expandedKey = folderState[source].expandedKey === key ? null : key;
                renderFolderView(source);
                return;
            }

            const miniCard = event.target.closest('[data-mini-plan-id]');
            if (miniCard) {
                openPlanPreview(miniCard.dataset.miniSource, miniCard.dataset.miniPlanId);
                return;
            }

            const cancelLikeButton = event.target.closest('[data-cancel-like-plan-id]');
            if (cancelLikeButton) {
                const planId = cancelLikeButton.dataset.cancelLikePlanId;
                if (!planId || cancelLikeButton.disabled) return;

                cancelLikeButton.disabled = true;
                cancelLikeButton.textContent = '취소 중...';

                fetch('${pageContext.request.contextPath}/like', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({ planId: Number(planId) })
                })
                    .then(function (response) {
                        if (!response.ok) throw new Error('like request failed');
                        return response.json();
                    })
                    .then(function (data) {
                        if (!data.success || data.liked) throw new Error('unexpected like state');
                        removeLikedPlan(planId);
                    })
                    .catch(function () {
                        cancelLikeButton.disabled = false;
                        cancelLikeButton.textContent = '좋아요 취소';
                        alert('좋아요 취소에 실패했습니다. 잠시 후 다시 시도해주세요.');
                    });
            }
        });

        window.addEventListener('resize', function () {
            setupMiniTagOverflow(document);
            setupMiniSliders(document);
            hidePlanSeedLists();
        });

        document.addEventListener('input', function (event) {
            const input = event.target.closest('[data-folder-search-input]');
            if (!input) return;
            const shell = input.closest('.plan-folder-shell');
            const source = shell ? shell.dataset.source : '';
            if (!source || !folderState[source]) return;
            renderFolderSearch(source, folderState[source].renderedGroups || groupPlans(folderState[source].plans, folderState[source].mode));
        });

        document.addEventListener('focusin', function (event) {
            const input = event.target.closest('[data-folder-search-input]');
            if (!input) return;
            const shell = input.closest('.plan-folder-shell');
            const source = shell ? shell.dataset.source : '';
            if (!source || !folderState[source]) return;
            renderFolderSearch(source, folderState[source].renderedGroups || groupPlans(folderState[source].plans, folderState[source].mode));
        });

        document.addEventListener('keydown', function (event) {
            const input = event.target.closest('[data-folder-search-input]');
            if (!input) return;
            const shell = input.closest('.plan-folder-shell');
            const source = shell ? shell.dataset.source : '';
            if (!source || !folderState[source]) return;

            if (event.key === 'Escape') {
                closeFolderSearchList(shell);
                return;
            }

            if (event.key === 'Enter') {
                const firstSuggestion = shell.querySelector('[data-folder-search-jump]');
                if (!firstSuggestion) return;
                event.preventDefault();
                jumpToFolder(source, firstSuggestion.dataset.folderSearchJump || '');
            }
        });

        const mypageTopNav = document.getElementById('mypageTopNav');
        if (mypageTopNav) {
            mypageTopNav.addEventListener('click', function () {
                window.scrollTo({ top: 0, behavior: 'smooth' });
            });
        }

        bootstrapFolders();
    });
</script>
<script src="${pageContext.request.contextPath}/js/mypageBridge.js"></script>
</body>
</html>


