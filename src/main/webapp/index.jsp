<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Travel-A(AI) | AI 여행 플래너</title>
    <link rel="stylesheet" href="css/base.css">

</head>
<body>
<div class="page">
    <header class="site-header">
        <div class="container site-header__inner">
            <a href="${pageContext.request.contextPath}/" class="site-logo">✈ Travel-A(AI)</a>

            <nav class="site-nav" id="siteNav">
                <div class="login-register">
                    <a href="${pageContext.request.contextPath}/login" class="btn--login">로그인</a>
                    <a href="account" class="btn--register">회원가입</a>
                </div>
                <a href="${pageContext.request.contextPath}/">여행 계획</a>
                <a href="${pageContext.request.contextPath}/explore">탐색</a>
                <a href="${pageContext.request.contextPath}/live">실시간 여행</a>
                <a href="result-page">마이페이지</a>
            </nav>

            <div class="site-actions">
                <div class="mobile-menu-btn" id="mobileMenuBtn">
                    <a class="menu-trigger">
                        <span></span>
                        <span></span>
                        <span></span>
                    </a>
                </div>
            </div>
        </div>
    </header>


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
<script> // 햄버거 아이콘
const trigger = document.querySelector('.menu-trigger');
const nav = document.querySelector('.site-nav');

if (trigger && nav) {
    trigger.addEventListener('click', function (e) {
        e.preventDefault();
        this.classList.toggle('is-active');
        nav.classList.toggle('is-open');
    });
}</script>
</html>
