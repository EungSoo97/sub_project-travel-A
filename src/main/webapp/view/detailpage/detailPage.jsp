<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="result-page">


    <div class="container-result">

        <!-- 헤더 -->
        <div class="header">
            <div><a href="${pageContext.request.contextPath}/explore">← 목록으로 돌아가기</a></div>

            <div class="title-area">
                <h1>${plan.summary.destination}</h1>

                <div class="sub-row">
                    <p class="sub">${plan.summary.destination} · ${plan.summary.days}일 여행</p>

                </div>
            </div>

            <div class="actions">

                <!-- 아이콘 따로 -->
                <div class="icon-group">
                    <button class="ui-button">♡</button>
                    <button class="ui-button">🔗</button>
                    <a href="#" class="review-link"> ✨후기전체보기✨</a>
                </div>

                <!-- 버튼 3개 -->
                <div class="main-buttons">
                    <form action="${pageContext.request.contextPath}/pdf" method="get">
                        <button class="download" type="submit">PDF 다운로드</button>
                    </form>

                    <button class="download">저장하기</button>
                    <button class="download" onclick="openPlanSheet()">후기쓰기</button>
                </div>

            </div>

        </div>

        <!-- 여행 정보 -->
        <div class="info-cards">
            <div class="card">
                <p class="label">📅 여행 기간</p>
                <p class="value">${plan.summary.startDate} ~ ${plan.summary.endDate}</p>
            </div>

            <div class="card">
                <p class="label">👥 여행 인원</p>
                <p class="value">${plan.summary.travelers}명</p>
            </div>

            <div class="card">
                <p class="label">✨ 여행 스타일</p>
                <p class="value">${plan.summary.travelStyle}</p>
            </div>
        </div>

        <!-- 간단 일정 -->
        <div class="schedule">
            <c:forEach var="item" items="${plan.itinerary}">
                <div class="day">
                    <h3>${item.day}일차</h3>

                    <p class="route">
                        <c:forEach var="act" items="${item.activities}" varStatus="status">
                            ● ${act.name}<c:if test="${!status.last}"> → </c:if>
                        </c:forEach>
                    </p>
                </div>
            </c:forEach>
        </div>

        <!-- 상세 일정 -->
        <div class="detail-container">

            <div class="detail-header">
                <h2>상세 일정</h2>
                <div class="total-cost">
                    총 예상 비용: ${plan.summary.totalEstimatedCost} ${plan.summary.currency}
                </div>
            </div>

            <c:forEach var="item" items="${plan.itinerary}">
                <div class="day-card">

                    <div class="day-header">
                        <div class="day-left">
                            <div class="day-badge">D${item.day}</div>
                            <div>
                                <div class="day-title">${item.day}일차</div>
                                <div class="day-date">${item.date}</div>
                            </div>
                        </div>
                    </div>

                    <!-- 활동 -->
                    <div class="time-section">
                        <c:forEach var="act" items="${item.activities}">
                            <div class="item">

                                <div class="icon">📍</div>

                                <div class="content">
                                    <div class="top">
                                        <span class="time">${act.time}</span>
                                        <span class="title">${act.name}</span>
                                    </div>

                                    <div class="desc">${act.description}</div>
                                </div>

                                <div class="meta">
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

                    <div class="day-footer">
                        예상 비용: ${item.estimatedCost} ${plan.summary.currency}
                    </div>

                </div>
            </c:forEach>

        </div>

        <!-- 항공 / 숙박 -->
        <div class="recommend-section">

            <h2>추천 항공/숙박</h2>

            <div class="recommend-grid">

                <!-- 항공 -->
                <div class="recommend-card">
                    <h3>✈️ 항공권</h3>

                    <c:forEach var="flight" items="${plan.flights}">
                        <div class="recommend-item">
                            <div class="left">
                                <div class="title">${flight.airline}</div>
                                <div class="desc">${flight.departureAirport} → ${flight.arrivalAirport}</div>
                            </div>
                            <div class="right">
                                <div class="price">${flight.price}원</div>
                            </div>
                        </div>
                    </c:forEach>

                </div>

                <!-- 숙박 -->
                <div class="recommend-card">
                    <h3>🏨 숙소</h3>

                    <c:forEach var="hotel" items="${plan.hotels}">
                        <div class="recommend-item">
                            <div class="left">
                                <div class="title">${hotel.name}</div>
                                <div class="desc">⭐ ${hotel.rating}</div>
                            </div>
                            <div class="right">
                                <div class="price">${hotel.pricePerNight}원</div>
                            </div>
                        </div>
                    </c:forEach>

                </div>

            </div>

        </div>

    </div>


</div>

<div id="planBackdrop" onclick="closePlanSheet()"></div>

<div id="planSheet" role="dialog" aria-modal="true" aria-labelledby="planSheetTitle">
    <div class="plan-sheethandle-wrap">
        <div class="plan-sheethandle"></div>
    </div>

    <div class="plan-sheethead">
        <div>
            <p id="planSheetTitle" class="plan-sheettitle">모달 제목</p>
            <p class="plan-sheetsub" id="planSheetSub">여기에 보조 설명을 입력하세요</p>
        </div>
        <button class="plan-sheetclose" onclick="closePlanSheet()" aria-label="닫기">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <path d="M1 1l12 12M13 1L1 13" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
        </button>
    </div>

    <div class="plan-sheet__body" id="planSheetBody">
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/detailpage.js"></script>
<script src="${pageContext.request.contextPath}/js/reiviewModal.js"></script>
