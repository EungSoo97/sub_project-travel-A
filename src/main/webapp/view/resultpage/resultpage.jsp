<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Resultpage</title>
    <link rel="stylesheet" href="result-page.css">
</head>
<body>
<div class="result-page">

    <div class="container-result">

        <div class="header">
            <div><a href="hello-servlet">← 검색으로 돌아가기</a></div>

            <div class="title-area">
                <h1>AI 맞춤 여행 일정</h1>
                <p class="sub">${result.summary.destination} · ${result.summary.days}일 여행</p>
            </div>

            <div class="actions">
                <form action="edit-plan" >
                    <button>✏️</button>
                </form>
                <button onclick="toggleHeart(this)">♡</button>
                <%-- 공유 버튼은 url 복사만 --%>
                <form action="pdf" method="get">
                    <button type="submit"  style="background-color: #2563eb; color: white; font-size: 13px;font-weight: 600;">PDF 다운로드</button>
                </form>
                <button class="download">게시하기</button>
            </div>
        </div>

        <!-- 여행 정보 카드 -->
        <div class="info-cards">
            <div class="card">
                <p class="label">📅 여행 기간</p>
                <p class="value">${result.summary.startDate} ~ ${result.summary.endDate}</p>
            </div>

            <div class="card">
                <p class="label">👥 여행 인원</p>
                <p class="value">${result.summary.travelers}명</p>
            </div>

            <div class="card">
                <p class="label">✨ 여행 스타일</p>
                <p class="value">${result.summary.travelStyle}</p>
            </div>
        </div>

        <!-- 지도 영역 -->
        <div class="map-section">
            <div class="map-header">
                <span>🧭 여행 동선 지도</span>
                <div class="legend">
                    <span class="dot blue"></span> 관광지
                    <span class="dot orange"></span> 식당
                    <span class="dot purple"></span> 숙소
                </div>
            </div>

            <div class="map-area">
                <!-- 지도 들어갈 자리 -->
            </div>
        </div>

        <!-- 일정 리스트 -->
        <div class="schedule">
            <c:forEach var="item" items="${result.itinerary}">
                <div class="day">
                    <h3>${item.day}일차 <span>(${item.activities.size()}개 장소)</span></h3>
                    <p class="route">
                        <c:forEach var="act" items="${item.activities}" varStatus="status">
                            ● ${act.name}<c:if test="${!status.last}"> → </c:if>
                        </c:forEach>
                    </p>
                </div>
            </c:forEach>
        </div>

        <div class="detail-container">

            <!-- 상단 -->
            <div class="detail-header">
                <h2>상세 일정</h2>
                <div class="total-cost">총 예상 비용: ${result.summary.totalEstimatedCost} ${result.summary.currency}</div>
            </div>

            <!-- 일차별 반복 -->
            <c:forEach var="item" items="${result.itinerary}">
                <div class="day-card">

                    <!-- day header -->
                    <div class="day-header">
                        <div class="day-left">
                            <div class="day-badge">D${item.day}</div>
                            <div>
                                <div class="day-title">${item.day}일차</div>
                                <div class="day-date">${item.date}</div>
                            </div>
                        </div>

                        <div class="day-right">
                            <span class="transport">🚆 ${item.transportation}</span>
                            <span class="distance">총 거리: ${item.totalDistanceKm}km</span>
                        </div>
                    </div>

                    <!-- 활동 목록 -->
                    <div class="time-section">
                        <c:forEach var="act" items="${item.activities}">
                            <div class="item">
                                <c:choose>
                                    <c:when test="${act.categoryCode == 'TRANSPORT'}">
                                        <div class="icon move">▲</div>
                                    </c:when>
                                    <c:when test="${act.categoryCode == 'DINING'}">
                                        <div class="icon food">🍽</div>
                                    </c:when>
                                    <c:when test="${act.categoryCode == 'ACCOMMODATION'}">
                                        <div class="icon hotel">🏨</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="icon spot">📍</div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="content">
                                    <div class="top">
                                        <span class="time">${act.time}</span>
                                        <span class="title">${act.name}</span>
                                    </div>
                                    <div class="desc">${act.description}</div>
                                </div>

                                <div class="meta">
                                    <span>${act.durationMinutes}분</span>
                                    <c:choose>
                                        <c:when test="${act.cost == 0}">
                                            <span>무료</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>${act.cost} ${act.currency}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- 하단 요약 -->
                    <div class="day-footer">
                        <span>${item.summary}</span>
                        <span>예상 비용: ${item.estimatedCost} ${item.currency}</span>
                    </div>

                </div>
            </c:forEach>

        </div>

        <div class="recommend-section">

            <h2>추천 항공/숙박</h2>

            <div class="recommend-grid">

                <!-- 항공 -->
                <div class="recommend-card">
                    <h3>✈️ 항공권 최저가</h3>
                    <c:choose>
                        <c:when test="${empty result.flights}">
                            <p>항공권 정보를 불러오지 못했습니다.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="flight" items="${result.flights}">
                                <div class="recommend-item">
                                    <div class="left">
                                        <div class="title">${flight.airline} ${flight.flightNumber}</div>
                                        <div class="desc">${flight.departureAirport} → ${flight.arrivalAirport}</div>
                                    </div>
                                    <div class="right">
                                        <div class="price">${flight.price} ${flight.currency}</div>
                                        <div class="sub">왕복 1인</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 숙박 -->
                <div class="recommend-card">
                    <h3>🏨 숙박 추천</h3>
                    <c:forEach var="hotel" items="${result.hotels}">
                        <div class="recommend-item">
                            <div class="left">
                                <div class="title">${hotel.name}</div>
                                <div class="desc">⭐ ${hotel.rating} · ${hotel.location}</div>
                            </div>
                            <div class="right">
                                <div class="price">${hotel.pricePerNight} ${hotel.currency}</div>
                                <div class="sub">1박</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

            </div>

        </div>

    </div>
</div>
</body>
<script>

    function toggleHeart(btn) {
        if (btn.innerText === "♡") {
            btn.innerText = "❤";
        } else {
            btn.innerText = "♡";
        }
    }
</script>

</html>
