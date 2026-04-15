<%@ page import="com.es.ta.account.AccountDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    AccountDTO u = (AccountDTO) request.getAttribute("userInfo");

    String profileImg = request.getContextPath() + "/img/profile/default.png";
    if (u != null && u.getProfileImg() != null && !u.getProfileImg().trim().isEmpty()) {
        String savedProfileImg = u.getProfileImg().trim();
        if (savedProfileImg.startsWith("http://") || savedProfileImg.startsWith("https://")) {
            profileImg = savedProfileImg;
        } else {
            profileImg = request.getContextPath() + "/" + savedProfileImg.replaceFirst("^/+", "");
        }
    }
%>
<section class="settings-section">
    <div class="settings-container">
        <div class="settings-header">
            <h2>회원정보 수정</h2>
            <p>프로필과 계정 정보를 관리할 수 있어요</p>
        </div>

        <form action="settings" method="post" class="settings-form" enctype="multipart/form-data">

            <div class="profile-image-box">
                <img id="profilePreview" src="<%= profileImg %>" alt="프로필">
                <button type="button" class="change-photo-btn"
                        onclick="document.getElementById('profileFile').click();">
                    사진 변경
                </button>
                <input type="file" id="profileFile" name="profileFile" accept="image/*" hidden>
            </div>

            <div class="form-group">
                <label for="name">이름</label>
                <input id="name" type="text" name="name"
                       value="<%= (u != null) ? u.getName() : "" %>">
            </div>

            <div class="form-group">
                <label for="loginId">아이디</label>
                <input id="loginId" type="text" name="loginId"
                       value="<%= (u != null) ? u.getLoginId() : "" %>" readonly>
            </div>

            <div class="form-group">
                <label for="password">비밀번호</label>
                <input id="password" type="password" name="password" placeholder="새 비밀번호 입력">
            </div>

            <div class="form-group">
                <label for="email">이메일</label>
                <input id="email" type="email" name="email"
                       value="<%= (u != null) ? u.getEmail() : "" %>">
            </div>

            <div class="form-group">
                <label for="gender">성별</label>
                <select id="gender" name="gender">
                    <option value="M" <%= (u != null && "M".equals(u.getGender())) ? "selected" : "" %>>남</option>
                    <option value="F" <%= (u != null && "F".equals(u.getGender())) ? "selected" : "" %>>여</option>
                </select>
            </div>

            <div class="form-actions">
                <button type="submit" name="action" value="update" class="save-btn">저장</button>
                <button type="submit" name="action" value="delete" class="cancel-btn"
                        onclick="return confirm('정말 탈퇴하시겠습니까?');">
                    회원탈퇴
                </button>
            </div>
            <input type="hidden" name="birthDate"
                   value="<%= (u != null && u.getBirthDate() != null) ? u.getBirthDate() : "" %>">
        </form>
    </div>
</section>

<script>
    document.getElementById('profileFile').addEventListener('change', function (e) {
        const file = e.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = function (event) {
            document.getElementById('profilePreview').src = event.target.result;
        };
        reader.readAsDataURL(file);
    });

</script>
