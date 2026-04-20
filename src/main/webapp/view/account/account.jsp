<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Account</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 0 10px;
            background: #ffffff;
            transition: border-color 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }

        .form-field select:hover {
            border-color: #9ca3af;
        }

        .form-field select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        /* 커스텀 드롭다운 스타일 */
        .custom-select {
            position: relative;
            width: 140px;
            flex: 0 0 auto;
        }

        .select-trigger {
            height: 48px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            padding: 0 36px 0 12px;
            background: #ffffff;
            display: flex;
            align-items: center;
            cursor: pointer;
            transition: border-color 0.3s, box-shadow 0.3s;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%236b7280'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            background-size: 16px;
        }

        .select-trigger:hover {
            border-color: #9ca3af;
        }

        .custom-select.active .select-trigger {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .options {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            margin-top: 8px;
            background: #ffffff;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            list-style: none;
            padding: 8px 0;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: opacity 0.3s, transform 0.3s, visibility 0.3s;
            z-index: 100;
        }

        .custom-select.active .options {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .options li {
            padding: 10px 16px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .options li:hover {
            background: #f1f5f9;
        }

        .options li.selected {
            background: #eff6ff;
            color: #2563eb;
            font-weight: 500;
        }

        .form-field input[type="text"],
        .form-field input[type="password"],
        .form-field input[type="date"],
        .form-field input[type="email"] {
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-field input[type="text"]:focus,
        .form-field input[type="password"]:focus,
        .form-field input[type="date"]:focus,
        .form-field input[type="email"]:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        /* 반응형 레이아웃 개선 */
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .form-field input[type="text"],
            .form-field input[type="password"],
            .form-field input[type="date"],
            .form-field select {
                padding: 12px;
                font-size: 16px; /* 모바일에서 자동 확대 방지 */
            }

            .toggle-btn {
                padding: 8px;
                font-size: 18px;
            }

            .dup-check {
                padding: 12px 16px;
                font-size: 14px;
            }

            .btn--block {
                padding: 14px;
                font-size: 16px;
            }
        }

        .form-field a {
            color: var(--primary);
            font-weight: 500;
        }

        .form-field a:hover {
            text-decoration: underline;
        }

        /* 인라인 에러 메시지 */
        .inline-error {
            font-size: 12px;
            color: #dc2626;
            margin-top: 4px;
            display: none;
        }

        .inline-error.show {
            display: block;
        }

        /* 비밀번호 토글 버튼 */
        .password-toggle {
            position: relative;
        }

        .password-toggle input {
            padding-right: 40px;
        }

        .toggle-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 16px;
            color: #64748b;
            padding: 4px;
        }

        .toggle-btn:hover {
            color: #2563eb;
        }

        /* 비밀번호 보안 강도 표시 */
        .password-strength {
            margin-top: 8px;
        }

        .strength-bar-container {
            width: 100%;
            height: 6px;
            background: #ddd;
            border-radius: 3px;
            overflow: hidden;
        }

        .strength-bar {
            height: 100%;
            width: 0%;
            background: #ddd;
            transition: width 0.3s, background 0.3s;
        }

        .strength-bar.weak {
            background: linear-gradient(90deg, #dc2626, #ef4444);
        }

        .strength-bar.medium {
            background: linear-gradient(90deg, #f59e0b, #fbbf24);
        }

        .strength-bar.strong {
            background: linear-gradient(90deg, #16a34a, #22c55e);
        }

        .strength-text {
            font-size: 12px;
            margin-top: 4px;
            font-weight: 500;
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

        /* 스낵바 스타일 */
        .snackbar {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: #333;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 14px;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s, visibility 0.3s;
        }

        .snackbar.show {
            opacity: 1;
            visibility: visible;
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
                            <label><input type="radio" name="gender" value="M" required> 남</label>
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
                            <input type="text" placeholder="email id" name="email" required onkeyup="checkEmailRealtime()">
                            <div class="custom-select" id="emailDomainSelect">
                                <div class="select-trigger" data-value="@naver.com">@naver.com</div>
                                <ul class="options">
                                    <li data-value="@naver.com" class="selected">@naver.com</li>
                                    <li data-value="@gmail.com">@gmail.com</li>
                                    <li data-value="@daum.net">@daum.net</li>
                                    <li data-value="@kakao.com">@kakao.com</li>
                                    <li data-value="direct">직접 입력</li>
                                </ul>
                            </div>
                            <input type="hidden" id="emailDomain" value="@naver.com">
                        </div>
                        <input type="text" id="customDomain" placeholder="@example.com" style="display:none; margin-top:6px;" onkeyup="checkDomainRealtime()">
                        <div class="inline-error" id="email-error"></div>
                    </div>

                    <div class="form-field">
                        <label>ID</label>
                        <div class="id-check-row">
                            <input type="text" placeholder="(필수)" name="login_id" required onkeyup="checkIdRealtime()">
                            <button type="button" id="check-btn" class="dup-check">중복확인</button>
                        </div>
                        <div class="result"></div>
                        <div class="inline-error" id="id-error"></div>
                    </div>

                    <div class="form-field">
                        <label>비밀번호</label>
                        <div class="password-toggle">
                            <input type="password" id="pw1" placeholder="(필수)" name="password" onkeyup="checkPassword(); checkPasswordRealtime()" onfocus="showStrengthBar()" onblur="hideStrengthBar()" required>
                            <button type="button" class="toggle-btn" onclick="togglePassword('pw1', this)">
                                <i class="fa-solid fa-eye-slash"></i>
                            </button>
                        </div>
                        <div class="password-strength" id="password-strength">
                            <div class="strength-bar-container">
                                <div class="strength-bar" id="strength-bar"></div>
                            </div>
                            <div class="strength-text" id="strength-text"></div>
                        </div>
                    </div>

                    <div class="form-field">
                        <label>비밀번호 확인</label>
                        <div class="password-toggle">
                            <input type="password" id="pw2" placeholder="(필수)" onkeyup="checkPassword()" required>
                            <button type="button" class="toggle-btn" onclick="togglePassword('pw2', this)">
                                <i class="fa-solid fa-eye-slash"></i>
                            </button>
                        </div>
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

                <button class="btn btn--primary btn--block" type="submit">회원가입</button>
            </div>
        </div>
    </div>
</form>

<script src="${pageContext.request.contextPath}/js/idcheck.js"></script>
<script src="${pageContext.request.contextPath}/js/account.js"></script>
<div id="snackbar" class="snackbar"></div>
</body>
</html>
