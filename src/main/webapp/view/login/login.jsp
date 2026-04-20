<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        align-items: stretch;
        gap: 10px;
        width: 85%;
        max-width: 400px;
    }

    /* input */
    .login-box input {
        width: 100%;
        box-sizing: border-box;
        padding: 10px;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        transition: border-color 0.3s, box-shadow 0.3s;
    }

    .login-box input:focus {
        outline: none;
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
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

    /* 비밀번호 토글 버튼 */
    .password-toggle {
        position: relative;
        width: 100%;
    }

    .password-toggle input {
        padding-right: 40px;
    }

    .password-toggle .toggle-btn {
        position: absolute;
        right: 10px;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        border-radius: 0;
        cursor: pointer;
        font-size: 16px;
        color: #64748b;
        padding: 4px;
    }

    .password-toggle .toggle-btn:hover {
        background: none;
        color: #2563eb;
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
        display: flex;
        justify-content: center;
        transform: scale(1.0);
        transform-origin: center center;
        margin: 5px 0;
        overflow: hidden;
    }

    @media (max-width: 360px) {
        .g-recaptcha {
            transform: scale(0.85);
            transform-origin: center center;
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
        <input type="text" name="loginId" placeholder="아이디" required>
        <div class="password-toggle">
            <input type="password" id="loginPassword" name="password" placeholder="비밀번호" required>
            <button type="button" class="toggle-btn" onclick="togglePassword()">
                <i class="fa-solid fa-eye-slash"></i>
            </button>
        </div>
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

<script>
    function togglePassword() {
        const input = document.getElementById("loginPassword");
        const btn = document.querySelector(".toggle-btn");
        const isPassword = input.type === "password";

        input.type = isPassword ? "text" : "password";
        btn.innerHTML = isPassword ? '<i class="fa-solid fa-eye"></i>' : '<i class="fa-solid fa-eye-slash"></i>';
        btn.classList.toggle("active");
    }
</script>
</body>
</html>
