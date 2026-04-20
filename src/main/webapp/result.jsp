<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>${result.summary.title}</title>
  <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/favicon.svg">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@400;600;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { font-family: 'Pretendard', sans-serif; background-color: #f8f9fa; color: #333; line-height: 1.6; margin: 0; padding: 20px; }
    .container { max-width: 900px; margin: 0 auto; }
    .card { background: white; border-radius: 16px; padding: 24px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 24px; }
    .summary-header { background: #007bff; color: white; margin-bottom: 30px; }
    .btn-tag { display: inline-block; padding: 4px 12px; border-radius: 20px; background: #e7f1ff; color: #007bff; font-weight: 600; font-size: 14px; margin-right: 8px; }
    .timeline { border-left: 2px solid #e9ecef; margin-left: 20px; padding-left: 30px; position: relative; }
    .day-title { margin-top: 40px; color: #007bff; font-weight: 800; font-size: 24px; }
    .activity-item { position: relative; margin-bottom: 20px; }
    .activity-item::before { content: ''; position: absolute; left: -41px; top: 10px; width: 20px; height: 20px; background: #007bff; border: 4px solid white; border-radius: 50%; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
    .time-label { font-weight: 600; color: #666; font-size: 14px; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .price { font-weight: 800; color: #dc3545; }
    .badge { font-size: 12px; padding: 2px 8px; border-radius: 4px; background: #eee; color: #666; margin-left: 10px; }
  </style>
</head>
<body>

<div class="container">
  <!-- 에러 메시지 처리 -->
  <c:if test="${not empty error}">
    <div class="card" style="border-left: 5px solid #dc3545;">
      <h2 style="color: #dc3545;"><i class="fa-solid fa-triangle-exclamation"></i> 알림</h2>
      <p>${error}</p>
    </div>
  </c:if>

  <c:if test="${not empty result and result.success}">
    <!-- 1. 여행 요약 (Summary) / totalEstimatedCost 필드 매칭 -->
    <div class="card summary-header">
      <h1 style="margin:0;"><i class="fa-solid fa-plane"></i> ${result.summary.title}</h1>
      <p style="font-size: 18px; opacity: 0.9;">${result.summary.overview}</p>
      <div style="margin-top: 15px;">
        <span style="font-weight: 600;"><i class="fa-solid fa-location-dot"></i> ${result.summary.destination}</span> |
        <span><i class="fa-regular fa-calendar"></i> ${result.summary.startDate} ~ ${result.summary.endDate} (${result.summary.days}일)</span> |
        <span><i class="fa-regular fa-user"></i> ${result.summary.travelers}인</span>
      </div>
      <h2 style="margin-top:20px;">총 예상 비용: <span class="price"><fmt:formatNumber value="${result.summary.totalEstimatedCost}" type="number"/> ${result.summary.currency}</span></h2>
    </div>

    <!-- 2. 추천 항공권 (Flights) -->
    <h2 style="margin-bottom:15px;"><i class="fa-solid fa-ticket"></i> 추천 항공권</h2>
    <div class="grid">
      <c:forEach var="f" items="${result.flights}">
        <div class="card">
          <div style="display: flex; justify-content: space-between;">
            <span class="btn-tag">${f.airline}</span>
            <span class="badge">${f.tripType}</span>
          </div>
          <h3 style="margin: 10px 0;">${f.departureAirportCode} ↔ ${f.arrivalAirportCode}</h3>
          <p style="color: #888; font-size: 14px;">편명: ${f.flightNumber} | 경유: ${f.stops}회</p>
          <p class="price" style="font-size: 20px;"><fmt:formatNumber value="${f.price}" type="number"/> ${f.currency}</p>
        </div>
      </c:forEach>
    </div>

    <!-- 3. 상세 일정 (Itinerary) / totalDistanceKm 필드 매칭 -->
    <h2 style="margin-top:40px;"><i class="fa-regular fa-calendar"></i> 상세 일정</h2>
    <c:forEach var="day" items="${result.itinerary}">
      <div class="day-title">${day.dayLabel} <span style="font-size: 16px; color: #666; font-weight: 400;">(${day.date})</span></div>
      <div style="margin-bottom: 10px; color: #666;">
        <i class="fa-solid fa-bus"></i> 주 교통수단: <b>${day.transportation}</b> | <i class="fa-solid fa-ruler-horizontal"></i>  총 이동: <b>${day.totalDistanceKm}km</b> | <i class="fa-solid fa-sack-dollar"></i> 일일 예상: <b><fmt:formatNumber value="${day.estimatedCost}" type="number"/> ${day.currency}</b>
      </div>
      <p style="font-size: 15px; background: #f1f3f5; padding: 10px 15px; border-radius: 8px;"><i class="fa-regular fa-lightbulb"></i> ${day.summary}</p>

      <div class="timeline">
        <c:forEach var="act" items="${day.activities}">
          <div class="activity-item">
            <div class="time-label">${act.time} ~ ${act.endTime} (${act.durationMinutes}분)</div>
            <div class="card" style="padding: 16px; margin: 10px 0;">
              <div style="font-weight: 800; font-size: 18px; margin-bottom: 5px;">
                [${act.type}] ${act.name}
                <c:if test="${not empty act.rating}"><span style="color:#ffc107; font-size: 14px; margin-left:10px;"><i class="fa-solid fa-star"></i> ${act.rating}</span></c:if>
              </div>
              <div style="color: #666; font-size: 14px; margin-bottom: 10px;">${act.description}</div>
              <div style="font-size: 13px; color: #888;"><i class="fa-solid fa-location-dot"></i> ${act.location} / ${act.address}</div>
              <c:if test="${act.cost > 0}">
                <div class="price" style="margin-top: 10px;">비용: <fmt:formatNumber value="${act.cost}" type="number"/> ${act.currency}</div>
              </c:if>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:forEach>

    <!-- 4. 추천 숙소 (Hotels) -->
    <h2 style="margin-top:40px;"><i class="fa-solid fa-hotel"></i> 추천 숙소</h2>
    <div class="grid">
      <c:forEach var="h" items="${result.hotels}">
        <div class="card">
          <h3>${h.name} <span style="color:#ffc107; font-size: 15px;"><i class="fa-solid fa-star"></i> ${h.rating}</span></h3>
          <p style="color: #666; font-size: 14px;">${h.location} | 등급: ${h.hotelClass}성급</p>
          <p style="font-size: 13px; color: #888;">${h.address}</p>
          <p class="price" style="font-size: 18px;">1박 예상: <fmt:formatNumber value="${h.pricePerNight}" type="number"/> ${h.currency}</p>
        </div>
      </c:forEach>
    </div>
  </c:if>
</div>

</body>
</html>
