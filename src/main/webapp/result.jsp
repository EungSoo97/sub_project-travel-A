<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>여행 결과</title>
</head>
<body>

<c:if test="${not empty error}">
  <h2 style="color:red;">에러</h2>
  <p>${error}</p>
  <hr>
</c:if>

<c:if test="${not empty result}">
  <c:choose>
    <c:when test="${not result.success}">
      <h2 style="color:red;">AI 오류 발생</h2>
      <p style="color:red;"><b>상세 원인:</b> ${result.message}</p>
      <hr>
    </c:when>
    <c:otherwise>
      <h2>여행 결과</h2>
      <p>목적지: ${result.summary.destination}</p>
      <p>총 비용: ${result.summary.estimatedTotalCost}</p>

      <c:forEach var="day" items="${result.itinerary}">
        <h3>Day ${day.day} (${day.date}) / 반경: ${day.totalDistance} / 일일예산: ${day.estimatedCost}</h3>
        <ul>
          <c:forEach var="activity" items="${day.activities}">
            <li style="margin-bottom:8px;">
              <b>${activity.time}</b> [${activity.type}] <strong>${activity.name}</strong><br>
              <span style="color:gray; font-size:14px;">${activity.description} / 위치: ${activity.location} / 비용: ${activity.cost}</span>
            </li>
          </c:forEach>
        </ul>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</c:if>

</body>
</html>
