<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Travel-A(AI) | AI 여행 플래너</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/settings.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/result-page.css" />
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
            <div class="login-register ${not empty sessionScope.user ? 'is-login' : ''}" id="headerLoginBtns">
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
              <div class="site-nav__auth">
                  <c:choose>
                      <c:when test="${not empty sessionScope.user}">
                          <span class="nav-auth-name">👤 ${sessionScope.user.name}님</span>
                          <a href="${pageContext.request.contextPath}/logout" class="btn--login">로그아웃</a>
                      </c:when>
                      <c:otherwise>
                          <a href="${pageContext.request.contextPath}/login" class="btn--login">로그인</a>
                          <a href="${pageContext.request.contextPath}/account" class="btn--register">회원가입</a>
                      </c:otherwise>
                  </c:choose>
              </div>
            <a href="${pageContext.request.contextPath}/">여행 계획</a>
            <a href="${pageContext.request.contextPath}/explore">탐색</a>
            <a href="${pageContext.request.contextPath}/live">실시간 여행</a>

              <c:choose>
                  <c:when test="${not empty sessionScope.user}">
                      <a href="${pageContext.request.contextPath}/mypage">마이페이지</a>
                  </c:when>
                  <c:otherwise>
                          <a href="login" onclick="loginAlert(event)">마이페이지</a>
                  </c:otherwise>
              </c:choose>
          </nav>
        </div>
      </header>
      <div class="drawer-overlay" id="drawerOverlay"></div>
      <div id="globalSnackbar" class="global-snackbar"></div>

      <div class="content">
        <jsp:include page="${content}"></jsp:include>
      </div>

      <footer class="site-footer">
        <div class="container site-footer__inner">
          <p>© 2026 Travel-A(AI). 여행의 모든 순간을 스마트하게.</p>
        </div>
      </footer>
    </div>
    <c:if test="${content ne 'view/explore/explore.jsp'}">
        <script src="${pageContext.request.contextPath}/js/main.js"></script>
    </c:if>
    <script>
        function loginAlert (event) {
            if (event) {
                event.preventDefault();
            }

            const snackbar = document.getElementById("globalSnackbar");
            if (!snackbar) {
                window.location.href = "${pageContext.request.contextPath}/login";
                return;
            }

            snackbar.textContent = "로그인이 필요한 기능입니다.";
            snackbar.classList.add("show");

            clearTimeout(snackbar._timer);
            snackbar._timer = setTimeout(function () {
                snackbar.classList.remove("show");
                window.location.href = "${pageContext.request.contextPath}/login";
            }, 900);
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

    <script>
    /* ── 실시간 여행 메뉴: 트래킹 중이면 myLive 페이지로 자동 연결 ── */
    (function () {
        /* 비로그인 상태: localStorage의 stale 트래킹 데이터 즉시 초기화 후 종료 */
        <c:if test="${empty sessionScope.user}">
        localStorage.removeItem('liveTrackingPlanId');
        return;
        </c:if>

        const trackingPlanId = localStorage.getItem('liveTrackingPlanId');
        const liveLink = document.querySelector('.site-nav a[href*="/live"]');

        if (!liveLink) return;

        if (trackingPlanId) {
            const ctx = '${pageContext.request.contextPath}';
            liveLink.href = ctx + '/my-live?planId=' + encodeURIComponent(trackingPlanId);

            /* 트래킹 중 시각적 표시: 텍스트 앞 빨간 점 (텍스트 위치 밀림 없음) */
            liveLink.style.position = 'relative';

            const dot = document.createElement('span');
            dot.style.cssText = [
                'position:absolute',
                'left:-4px',
                'top:50%',
                'transform:translateY(-50%)',
                'width:9px', 'height:9px', 'border-radius:50%',
                'background:#ef4444',
                'animation:livePulse 1.4s ease-in-out infinite',
                'pointer-events:none'
            ].join(';');
            liveLink.appendChild(dot);

            /* 펄스 키프레임 (중복 삽입 방지) */
            if (!document.getElementById('livePulseStyle')) {
                const style = document.createElement('style');
                style.id = 'livePulseStyle';
                style.textContent = '@keyframes livePulse{0%,100%{opacity:1;transform:translateY(-50%) scale(1)}50%{opacity:.4;transform:translateY(-50%) scale(1.4)}}';
                document.head.appendChild(style);
            }
        }

        /* ── 로그아웃 시 트래킹 상태 자동 해제 ── */
        document.querySelectorAll('a[href*="/logout"]').forEach(function (logoutLink) {
            logoutLink.addEventListener('click', function () {
                localStorage.removeItem('liveTrackingPlanId');
            });
        });
    })();
    </script>


  </body>

</html>

