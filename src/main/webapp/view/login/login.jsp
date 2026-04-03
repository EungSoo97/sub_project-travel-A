<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    .site-logo {
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


    </style>
</head>
<body>
<div class="login-wrap">
    <a href="${pageContext.request.contextPath}/" class="site-logo">✈ Travel-A(AI)</a>

    <div class="login-box">
        <input type="text" placeholder="아이디">
        <input type="password" placeholder="비밀번호">
        <button>로그인</button>
    </div>
</div>
</body>
</html>
