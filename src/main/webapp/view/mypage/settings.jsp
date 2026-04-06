
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<section class="settings-section">
    <div class="settings-container">
        <div class="settings-header">
            <h2>프로필 수정</h2>
            <p>내 정보를 수정할 수 있습니다.</p>
        </div>

        <form action="#" method="post" class="settings-form" enctype="multipart/form-data">
            <div class="profile-image-box">
                <img src="${pageContext.request.contextPath}/img/profile/gundam.PNG" alt="기본 프로필">
                <label for="profileImage" class="change-photo-btn">사진 변경</label>
                <input type="file" id="profileImage" name="profileImage" accept="image/*" hidden>
            </div>

            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" id="name" name="name" value="JO YEJIN">
            </div>

            <div class="form-group">
                <label for="userId">아이디</label>
                <input type="text" id="userId" name="userId" value="joyejin" readonly>
            </div>

            <div class="form-group">
                <label for="password">새 비밀번호</label>
                <input type="password" id="password" name="password" placeholder="변경할 경우에만 입력">
            </div>

            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" value="yejin@example.com">
            </div>

            <div class="form-group">
                <label for="gender">성별</label>
                <select id="gender" name="gender">
                    <option value="">선택하세요</option>
                    <option value="female" selected>여성</option>
                    <option value="male">남성</option>
                    <option value="other">기타</option>
                </select>
            </div>

            <div class="form-actions">
                <button type="submit" class="save-btn">저장</button>
                <button type="button" class="cancel-btn" onclick="history.back()">취소</button>
            </div>
        </form>
    </div>
</section>