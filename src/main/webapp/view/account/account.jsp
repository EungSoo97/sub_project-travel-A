<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Account</title>

    <style>
        .search-card {
            padding: 28px;
        }

        .form-field input[type="radio"] {
            width: auto;
            height: auto;
        }

        .form-field select {
            height: 48px;
            border: 1px solid var(--line);
            border-radius: 12px;
            padding: 0 10px;
            background: #fbfdff;
        }

        .form-field a {
            color: var(--primary);
            font-weight: 500;
        }

        .form-field a:hover {
            text-decoration: underline;
        }

        .email-row,
        .id-check-row {
            display: flex;
            gap: 8px;
            align-items: stretch;
        }

        .email-row input,
        .id-check-row input {
            min-width: 0;
            flex: 1 1 auto;
        }

        .email-row span {
            display: inline-flex;
            align-items: center;
        }

        .id-check-row .dup-check {
            flex: 0 0 auto;
            white-space: nowrap;
        }

        .account-error {
            margin: 0 0 16px;
            color: #dc2626;
            font-weight: 700;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
<form action="account" method="post" onsubmit="return validateForm()">
    <div class="section">
        <div class="container">
            <div class="search-card" style="max-width: 520px; margin: 0 auto;">
                <div class="search-card__header">
                    <h2>회원 가입</h2>
                    <p>간단한 정보 입력으로 서비스를 시작하세요.</p>
                </div>

                <c:if test="${not empty accountError}">
                    <p class="account-error">${accountError}</p>
                </c:if>

                <div class="form-grid">
                    <div class="form-field">
                        <label>이름</label>
                        <input type="text" placeholder="이름을 입력해주세요 (필수)" name="name" required>
                    </div>

                    <div class="form-field">
                        <label>성별</label>
                        <div style="display:flex; gap:12px;">
                            <label><input type="radio" name="gender" value="M"> 남</label>
                            <label><input type="radio" name="gender" value="F"> 여</label>
                        </div>
                    </div>

                    <div class="form-field">
                        <label>생년월일</label>
                        <input type="date" name="birth_date" value="2010-01-01" required>
                    </div>

                    <div class="form-field">
                        <label>Email</label>
                        <div class="email-row">
                            <input type="text" placeholder="email id" name="email" required>
                            <span>@</span>
                            <select id="emailDomain">
                                <option value="naver.com">naver.com</option>
                                <option value="gmail.com">gmail.com</option>
                                <option value="daum.net">daum.net</option>
                                <option value="kakao.com">kakao.com</option>
                                <option value="direct">직접 입력</option>
                            </select>
                        </div>
                        <input type="text" id="customDomain" placeholder="도메인 직접 입력" style="display:none; margin-top:6px;">
                    </div>

                    <div class="form-field">
                        <label>ID</label>
                        <div class="id-check-row">
                            <input type="text" placeholder="(필수)" name="login_id" required>
                            <button type="button" id="check-btn" class="dup-check">중복확인</button>
                        </div>
                        <div class="result"></div>
                    </div>

                    <div class="form-field">
                        <label>비밀번호</label>
                        <input type="password" id="pw1" placeholder="(필수)" name="password" onkeyup="checkPassword()" required>
                    </div>

                    <div class="form-field">
                        <label>비밀번호 확인</label>
                        <input type="password" id="pw2" placeholder="(필수)" onkeyup="checkPassword()" required>
                        <span id="pw-msg"></span>
                    </div>

                    <div class="form-field">
                        <label style="display:flex; align-items:center; gap:8px;">
                            <div class="acouunt-check">
                                <input type="checkbox" id="agree">
                            </div>
                            <span>
                                <a href="terms">이용약관</a> 및
                                <a href="terms">개인정보처리방침</a> 동의
                            </span>
                        </label>
                    </div>
                </div>

                <button class="btn btn--primary btn--block">회원가입</button>
            </div>
        </div>
    </div>
</form>

<script src="${pageContext.request.contextPath}/js/idcheck.js"></script>
<script src="${pageContext.request.contextPath}/js/account.js"></script>
</body>
</html>
