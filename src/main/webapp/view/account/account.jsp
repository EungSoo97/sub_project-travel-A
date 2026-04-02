<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
}</style>
</head>
<body>

<div class="section">
    <div class="container">
        <div class="search-card" style="max-width: 520px; margin: 0 auto;">

            <div class="search-card__header">
                <h2>회원 가입</h2>
                <p>간단한 정보 입력으로 서비스를 시작하세요</p>
            </div>

            <div class="form-grid">

                <div class="form-field">
                    <label>이름</label>
                    <input type="text" placeholder="이름을 입력해주세요 (필수)">
                </div>

                <div class="form-field">
                    <label>성별</label>
                    <div style="display:flex; gap:12px;">
                        <label><input type="radio" name="gender"> 남</label>
                        <label><input type="radio" name="gender"> 여</label>
                    </div>
                </div>

                <div class="form-field">
                    <label>생년월일</label>
                    <input type="date" name="birth" required>
                </div>

                <div class="form-field">
                    <label>Email</label>
                    <div style="display:flex; gap:8px;">
                        <input type="text" placeholder="아이디">
                        <select id="emailDomain">
                            <option value="naver.com">@naver.com</option>
                            <option value="gmail.com">@gmail.com</option>
                            <option value="daum.net">@daum.net</option>
                            <option value="kakao.com">@kakao.com</option>
                            <option value="direct">직접 입력</option>
                        </select>
                    </div>
                    <input type="text" id="customDomain" placeholder="도메인 직접 입력" style="display:none; margin-top:6px;">
                </div>

                <div class="form-field">
                    <label>ID</label>
                    <div style="display:flex; gap:8px;">
                        <input type="text" placeholder="(필수)">
                        <button class="btn btn--ghost">중복확인</button>
                    </div>
                </div>

                <div class="form-field">
                    <label>비밀번호</label>
                    <input type="password" placeholder="(필수)">
                </div>

                <div class="form-field">
                    <label>비밀번호 확인</label>
                    <input type="password" placeholder="(필수)">
                </div>

                <div class="form-field">
                    <label style="display:flex; align-items:center; gap:8px;">
                        <div class="acouunt-check">
                        <input type="checkbox" >
                </div>
                        <span>
                <a href="terms">이용약관</a>및
              <a href="terms" methods="post">개인정보처리방침</a> 동의
            </span>


                    </label>
                </div>

            </div>

            <button class="btn btn--primary btn--block">회원가입</button>

        </div>
    </div>
</div>

<script>
    const select = document.getElementById("emailDomain");
    const custom = document.getElementById("customDomain");

    select.addEventListener("change", function() {
        if (this.value === "direct") {
            custom.style.display = "inline";
        } else {
            custom.style.display = "none";
        }
    });
</script>

</body>
</html>