<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Travel-A(AI) | AI 여행 플래너</title>
    <link rel="stylesheet" href="css/base.css" />
    <link rel="stylesheet" href="css/result-page.css" />
    <link rel="stylesheet" href="css/edit-schedule.css" />

    <!-- 푸터 하단 고정 -->
    <style>
      .page {
        display: flex;
        flex-direction: column;
        min-height: 100vh;
      }
      .content {
        flex: 1;
      }
    </style>
  </head>
  <body>
    <div class="page"

    >
      <header class="site-header">
        <div class="container site-header__inner">
          <a href="${pageContext.request.contextPath}/" class="site-logo"
            >✈ Travel-A(AI)</a
          >

          <div class="site-actions">
            <div class="login-register" id="headerLoginBtns">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="drawer-user-name">👤 ${sessionScope.user.name}님</div>
                        <a href="${pageContext.request.contextPath}/logout" class="drawer-logout">로그아웃</a>
                    </c:when>
                    <c:otherwise>
                        <div class="drawer-links" style="display:flex; gap:8px; padding: 8px 14px;">
                            <a href="login" class="btn--login">로그인</a>
                            <a href="account" class="btn--register">회원가입</a>
                        </div>
                    </c:otherwise>
                </c:choose>
<%--              <a href="login" class="btn--login">로그인</a>--%>
<%--              <a href="account" class="btn--register">회원가입</a>--%>
            </div>
            <div class="mobile-menu-btn" id="mobileMenuBtn">
              <a class="menu-trigger">
                <span></span>
                <span></span>
                <span></span>
              </a>
            </div>
          </div>

          <nav class="site-nav" id="siteNav">
            <%--
            <div class="login-register">
              --%> <%--
              <a
                href="${pageContext.request.contextPath}/login"
                class="btn--login"
                >로그인</a
              >--%> <%--
              <a href="account" class="btn--register">회원가입</a>--%> <%--
            </div>
            --%>
            <a href="${pageContext.request.contextPath}/">여행 계획</a>
            <a href="${pageContext.request.contextPath}/explore">탐색</a>
            <a href="${pageContext.request.contextPath}/live">실시간 여행</a>
            <a href="${pageContext.request.contextPath}/mypage">마이페이지</a>
          </nav>
        </div>
      </header>
      <div class="drawer-overlay" id="drawerOverlay"></div>

      <nav class="site-nav" id="siteNav">
        <div class="drawer-header">
          <span class="drawer-title">✈ Travel-A(AI)</span>
          <button class="drawer-close" id="drawerClose">✕</button>
        </div>
        <div class="drawer-links">
          <a href="...">🗺 여행 계획</a>
          <a href="...">🔍 탐색</a>
          <a href="...">📍 실시간 여행</a>
          <a href="...">👤 마이페이지</a>
        </div>
      </nav>

      <div class="content">
        <jsp:include page="${content}"></jsp:include>
      </div>

      <footer class="site-footer">
        <div class="container site-footer__inner">
          <p>© 2026 Travel-A(AI). 여행의 모든 순간을 스마트하게.</p>
        </div>
      </footer>
    </div>
    <script src="js/main.js"></script>
  </body>
  <script>
    const trigger = document.querySelector(".menu-trigger");
    const nav = document.querySelector(".site-nav");
    const loginBtns = document.getElementById("headerLoginBtns");

    if (trigger && nav) {
      trigger.addEventListener("click", function (e) {
        e.preventDefault();
        const isActive = this.classList.toggle("is-active");
        loginBtns && loginBtns.classList.toggle("is-visible", isActive);

        if (isActive) {
          // display:flex 먼저 적용 후 transition 실행
          nav.style.display = "flex";
          requestAnimationFrame(() => nav.classList.add("is-open"));
        } else {
          nav.classList.remove("is-open");
          nav.addEventListener(
            "transitionend",
            () => {
              if (!nav.classList.contains("is-open"))
                nav.style.display = "none";
            },
            { once: true },
          );
        }
      });
    }
  </script>
</html>
