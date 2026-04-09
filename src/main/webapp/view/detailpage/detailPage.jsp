<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.es.ta.account.AccountDTO" %>

<%
    AccountDTO user = (AccountDTO) request.getSession().getAttribute("user");
    boolean isLoggedIn = (user != null);
    request.setAttribute("isLoggedIn", isLoggedIn);
%>

<div class="dp-page">
    <div class="dp-container">

        <!-- 헤더 -->
        <div class="dp-header">
            <a class="dp-back-link" href="${pageContext.request.contextPath}/explore">
                ← 목록으로 돌아가기
            </a>

            <div class="dp-title-area">
                <div class="dp-title-row">
                    <div class="dp-title-text">
                        <h1>${plan.summary.destination}</h1>
                        <p class="dp-sub">
                            ${plan.summary.destination} · ${plan.summary.days}일 여행
                        </p>
                    </div>

                    <button type="button" class="dp-review-link-btn" onclick="openReviewSheet()">
                        후기전체보기 &gt;
                    </button>
                </div>
            </div>

            <div class="dp-title-divider"></div>

            <div class="dp-actions">
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <button type="button" class="dp-icon-btn" onclick="toggleHeart(this, ${plan.planId})">♡</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="dp-icon-btn" onclick="showLoginAlert()">♡</button>
                    </c:otherwise>
                </c:choose>

                <button type="button" class="dp-icon-btn" onclick="copyUrl()">🔗</button>

                <form action="${pageContext.request.contextPath}/pdf" method="get">
                    <button class="dp-primary-btn" type="submit">PDF<br>다운로드</button>
                </form>

                <button type="button" class="dp-primary-btn">저장하기</button>
                <button type="button" class="dp-primary-btn" id="dpOpenModalBtn">후기쓰기</button>
            </div>
        </div>

        <!-- 스낵바 -->
        <div id="dpSnackbar" class="dp-snackbar"></div>

        <!-- 후기 작성 모달 -->
        <div id="dpReviewModal" class="dp-modal">
            <div class="dp-modal-content">
                <div class="dp-modal-header">
                    <h2>후기 작성</h2>
                    <button type="button" class="dp-modal-close" id="dpCloseModalBtn">&times;</button>
                </div>

                <form action="review" method="post">
                    <input type="hidden" name="planId" value="${plan.planId}">
                    <textarea
                            class="dp-textarea"
                            name="content"
                            rows="5"
                            placeholder="여기에 후기를 작성해주세요"></textarea>
                    <button class="dp-submit-btn" type="submit">작성 완료</button>
                </form>
            </div>
        </div>

        <!-- 여행 정보 -->
        <div class="dp-info-cards">
            <div class="dp-info-card dp-info-card--full">
                <p class="dp-info-label"><span>📅</span> 여행 기간</p>
                <p class="dp-info-value">${plan.summary.startDate} ~ ${plan.summary.endDate}</p>
            </div>

            <div class="dp-info-card">
                <p class="dp-info-label">👥 여행 인원</p>
                <p class="dp-info-value">${plan.summary.travelers}명</p>
            </div>

            <div class="dp-info-card">
                <p class="dp-info-label">✨ 여행 스타일</p>
                <p class="dp-info-value">${plan.summary.travelStyle}</p>
            </div>
        </div>

        <!-- 간단 일정 -->
        <div class="dp-schedule">
            <c:forEach var="item" items="${plan.itinerary}">
                <div class="dp-schedule-day">
                    <h3>${item.day}일차</h3>
                    <p class="dp-route">
                        <c:forEach var="act" items="${item.activities}" varStatus="status">
                            ● ${act.name}<c:if test="${!status.last}"> → </c:if>
                        </c:forEach>
                    </p>
                </div>
            </c:forEach>
        </div>

        <!-- 상세 일정 -->
        <div class="dp-detail-container">
            <div class="dp-detail-header">
                <h2>상세 일정</h2>
                <div class="dp-total-cost">
                    총 예상 비용: ${plan.summary.totalEstimatedCost} ${plan.summary.currency}
                </div>
            </div>

            <c:forEach var="item" items="${plan.itinerary}">
                <div class="dp-day-card">
                    <div class="dp-day-header">
                        <div class="dp-day-left">
                            <div class="dp-day-badge">D${item.day}</div>
                            <div>
                                <div class="dp-day-title">${item.day}일차</div>
                                <div class="dp-day-date">${item.date}</div>
                            </div>
                        </div>
                    </div>

                    <div class="dp-time-section">
                        <c:forEach var="act" items="${item.activities}">
                            <div class="dp-item">
                                <div class="dp-item-icon">📍</div>

                                <div class="dp-item-content">
                                    <div class="dp-item-top">
                                        <span class="dp-item-time">${act.time}</span>
                                        <span class="dp-item-title">${act.name}</span>
                                    </div>
                                    <div class="dp-item-desc">${act.description}</div>
                                </div>

                                <div class="dp-item-meta">
                                    <c:choose>
                                        <c:when test="${act.cost == 0}">
                                            <span>무료</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>${act.cost} ${plan.summary.currency}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="dp-day-footer">
                        예상 비용: ${item.estimatedCost} ${plan.summary.currency}
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- 추천 항공 / 숙박 -->
        <div class="dp-recommend-section">
            <h2>추천 항공/숙박</h2>

            <div class="dp-recommend-grid">
                <div class="dp-recommend-card">
                    <h3>✈️ 항공권</h3>

                    <c:forEach var="flight" items="${plan.flights}">
                        <div class="dp-recommend-item">
                            <div class="dp-recommend-left">
                                <div class="dp-recommend-title">${flight.airline}</div>
                                <div class="dp-recommend-desc">
                                        ${flight.departureAirport} → ${flight.arrivalAirport}
                                </div>
                            </div>
                            <div class="dp-recommend-right">
                                <div class="dp-recommend-price">${flight.price}원</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="dp-recommend-card">
                    <h3>🏨 숙소</h3>

                    <c:forEach var="hotel" items="${plan.hotels}">
                        <div class="dp-recommend-item">
                            <div class="dp-recommend-left">
                                <div class="dp-recommend-title">${hotel.name}</div>
                                <div class="dp-recommend-desc">⭐ ${hotel.rating}</div>
                            </div>
                            <div class="dp-recommend-right">
                                <div class="dp-recommend-price">${hotel.pricePerNight}원</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 후기 전체보기 바텀시트 -->
<div id="dpPlanBackdrop" class="dp-sheet-backdrop" onclick="closePlanSheet()"></div>

<div id="dpPlanSheet" class="dp-sheet" role="dialog" aria-modal="true" aria-labelledby="dpPlanSheetTitle">
    <div class="dp-sheet-handle-wrap">
        <div class="dp-sheet-handle"></div>
    </div>

    <div class="dp-sheet-head">
        <div>
            <p id="dpPlanSheetTitle" class="dp-sheet-title">여행 후기</p>
            <p class="dp-sheet-sub">${plan.summary.destination} 여행 후기 모음</p>
        </div>

        <button class="dp-sheet-close" onclick="closePlanSheet()" aria-label="닫기">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <path d="M1 1l12 12M13 1L1 13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
        </button>
    </div>

    <div class="dp-sheet-body">
        <div class="dp-review-item">
            <p class="dp-review-writer">김민지</p>
            <p class="dp-review-text">동선이 깔끔해서 여행하기 편했어요.</p>
        </div>

        <div class="dp-review-item">
            <p class="dp-review-writer">이준호</p>
            <p class="dp-review-text">맛집이랑 야경 코스가 특히 좋았습니다.</p>
        </div>
    </div>
</div>

<script>
    const dpReviewModal = document.getElementById("dpReviewModal");
    const dpOpenModalBtn = document.getElementById("dpOpenModalBtn");
    const dpCloseModalBtn = document.getElementById("dpCloseModalBtn");
    const dpSnackbar = document.getElementById("dpSnackbar");

    if (dpOpenModalBtn && dpReviewModal) {
        dpOpenModalBtn.addEventListener("click", function () {
            dpReviewModal.classList.add("is-open");
            document.body.style.overflow = "hidden";
        });
    }

    if (dpCloseModalBtn && dpReviewModal) {
        dpCloseModalBtn.addEventListener("click", function () {
            dpReviewModal.classList.remove("is-open");
            document.body.style.overflow = "";
        });
    }

    window.addEventListener("click", function (e) {
        if (e.target === dpReviewModal) {
            dpReviewModal.classList.remove("is-open");
            document.body.style.overflow = "";
        }
    });

    function openReviewSheet() {
        document.getElementById("dpPlanBackdrop").classList.add("show");
        document.getElementById("dpPlanSheet").classList.add("show");
        document.body.style.overflow = "hidden";
    }

    function closePlanSheet() {
        document.getElementById("dpPlanBackdrop").classList.remove("show");
        document.getElementById("dpPlanSheet").classList.remove("show");
        document.body.style.overflow = "";
    }

    function copyUrl() {
        navigator.clipboard.writeText(window.location.href).then(function () {
            showDpSnackbar("링크가 복사되었습니다.");
        });
    }

    function toggleHeart(button, planId) {
        button.classList.toggle("is-liked");
        button.textContent = button.classList.contains("is-liked") ? "♥" : "♡";
        showDpSnackbar("좋아요가 반영되었습니다.");
    }

    function showLoginAlert() {
        alert("로그인 후 이용 가능합니다.");
    }

    function showDpSnackbar(message) {
        if (!dpSnackbar) return;
        dpSnackbar.textContent = message;
        dpSnackbar.classList.add("show");

        setTimeout(function () {
            dpSnackbar.classList.remove("show");
        }, 1800);
    }
</script>