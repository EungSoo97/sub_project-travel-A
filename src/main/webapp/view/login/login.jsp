<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Login</title>
    <style>/* 전체 wrapper */
    .login-wrap {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 20px;
    }

    /* 로고 */
    .site-logo__login {
        font-size: 24px;
        font-weight: bold;
        text-decoration: none;
        color: #2563eb;
    }

    /* 로그인 박스 */
    .login-box {
        display: flex;
        flex-direction: column;
        gap: 10px;
        width: 250px;
    }

    /* input */
    .login-box input {
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 8px;
    }

    /* 버튼 */
    .login-box button {
        padding: 10px;
        background: #2563eb;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
    }

    .login-box button:hover {
        background: #1d4ed8;
    }
    /* 오류 메시지 */
    .login-error {
        color: #dc2626;
        font-size: 0.85rem;
        text-align: center;
        background: #fee2e2;
        border-radius: 8px;
        padding: 8px 12px;
    }

    /* 회원가입 링크 */
    .login-footer {
        font-size: 0.85rem;
        color: #64748b;
        text-align: center;
    }
    .login-footer a {
        color: #2563eb;
        font-weight: 600;
        text-decoration: none;
    }
    .login-footer a:hover {
        text-decoration: underline;
    }

    /* 캡챠 스타일 - 모바일 최적화 */
    .g-recaptcha {
        transform: scale(0.85);
        transform-origin: left center;
        margin: 10px 0 10px -4px;
    }

    @media (max-width: 400px) {
        .login-box {
            width: 280px;
        }

        .g-recaptcha {
            transform: scale(0.75);
            transform-origin: left center;
        }
    }

    </style>
</head>
<body>
<div class="login-wrap">
    <a href="${pageContext.request.contextPath}/" class="site-logo__login">✈ Travel-A(AI)</a>
<c:if test="${not empty loginError}">
<div class="login-error">${loginError}</div>
</c:if >

<form class="login-box" method="post" action="${pageContext.request.contextPath}/login">
    <input type="hidden" name="returnUrl" value="${returnUrl}">
    <input type="text"     name="loginId"  placeholder="아이디" required  value="yw">
    <input type="password" name="password" placeholder="비밀번호" required value="yw">
    <button type="submit">로그인</button>
    <%--   캡챠--%>
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>

    <c:if test="${sessionScope.loginFailCount >= 3 || true}">
        <div class="g-recaptcha" data-sitekey="6LcYR7osAAAAANhJOfK_4cUSe0H8pDfz99ZxrdKg"></div>
    </c:if>
</form>

<div class="login-footer">
    아직 계정이 없으신가요? <a href="${pageContext.request.contextPath}/account">회원가입</a>
</div>

</div>
</body>
</html>
