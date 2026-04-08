<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Travel-A(AI) | AI 여행 플래너</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/result-page.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/edit-schedule.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/settings.css">

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
    <div class="page">
      <header class="site-header">
        <div class="container site-header__inner">
          <a href="${pageContext.request.contextPath}/" class="site-logo">✈ Travel-A(AI)</a>
          <div class="site-actions">
            <div class="login-register" id="headerLoginBtns">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="drawer-user-name">👤 ${sessionScope.user.name}님</div>
                        <a href="${pageContext.request.contextPath}/logout" class="drawer-logout" style="color:#1d4ed8; font-weight:600">로그아웃</a>
                    </c:when>
                    <c:otherwise>
                        <div class="drawer-links" style="display:flex; gap:8px; padding: 8px 14px;">
                            <a href="login" class="btn--login">로그인</a>
                            <a href="account" class="btn--register">회원가입</a>
                        </div>
                    </c:otherwise>
                </c:choose>
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
            <a href="${pageContext.request.contextPath}/">여행 계획</a>
            <a href="${pageContext.request.contextPath}/explore">탐색</a>
            <a href="${pageContext.request.contextPath}/live">실시간 여행</a>
            <a href="${pageContext.request.contextPath}/mypage">마이페이지</a>

<%--              <c:choose>--%>
<%--                  <c:when test="${not empty sessionScope.user}">--%>
<%--                      <a href="${pageContext.request.contextPath}/mypage?no=${}">마이페이지</a>--%>
<%--                  </c:when>--%>
<%--                  <c:otherwise>--%>
<%--                          <a href="login" onclick="loginAlert()">마이페이지</a>--%>
<%--                  </c:otherwise>--%>
<%--              </c:choose>--%>
          </nav>
        </div>
      </header>
      <div class="drawer-overlay" id="drawerOverlay"></div>

      <div class="content">
        <jsp:include page="${content}"></jsp:include>
      </div>

      <footer class="site-footer">
        <div class="container site-footer__inner">
          <p>© 2026 Travel-A(AI). 여행의 모든 순간을 스마트하게.</p>
        </div>
      </footer>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function loginAlert () {
            alert("로그인이 필요한 기능 입니다.");
        }
    </script>
    <script>
    (() => {
        const menuTriggerEl = document.querySelector(".menu-trigger");
        const navEl = document.querySelector(".site-nav");
        const loginBtnsEl = document.getElementById("headerLoginBtns");

        if (!menuTriggerEl || !navEl) {
            return;
        }

        menuTriggerEl.addEventListener("click", function (e) {
            e.preventDefault();
            const isActive = this.classList.toggle("is-active");
            loginBtnsEl && loginBtnsEl.classList.toggle("is-visible", isActive);

            if (isActive) {
                navEl.style.display = "flex";
                requestAnimationFrame(() => navEl.classList.add("is-open"));
            } else {
                navEl.classList.remove("is-open");
                navEl.addEventListener(
                    "transitionend",
                    () => {
                        if (!navEl.classList.contains("is-open")) {
                            navEl.style.display = "none";
                        }
                    },
                    { once: true },
                );
            }
        });
    })();
    </script>
  </body>

</html>
