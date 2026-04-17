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

        <form action="settings" method="post" class="settings-form" id="settingsForm" enctype="multipart/form-data">

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
                <button type="button" class="cancel-btn" id="openWithdrawConfirm">
                    회원탈퇴
                </button>
            </div>
            <input type="hidden" name="birthDate"
                   value="<%= (u != null && u.getBirthDate() != null) ? u.getBirthDate() : "" %>">
        </form>
    </div>
</section>

<div class="settings-confirm-backdrop" id="withdrawConfirm" aria-hidden="true">
    <div class="settings-confirm-sheet" role="dialog" aria-modal="true" aria-labelledby="withdrawConfirmTitle">
        <p class="settings-confirm-title" id="withdrawConfirmTitle">회원탈퇴 할까요?</p>
        <p class="settings-confirm-text">계정 정보와 저장된 여행 기록이 삭제됩니다.</p>
        <div class="settings-confirm-actions">
            <button type="button" class="settings-confirm-cancel" id="withdrawCancel">취소</button>
            <button type="button" class="settings-confirm-delete" id="withdrawSubmit">탈퇴</button>
        </div>
    </div>
</div>

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

    const settingsForm = document.getElementById('settingsForm');
    const openWithdrawConfirm = document.getElementById('openWithdrawConfirm');
    const withdrawConfirm = document.getElementById('withdrawConfirm');
    const withdrawCancel = document.getElementById('withdrawCancel');
    const withdrawSubmit = document.getElementById('withdrawSubmit');

    function closeWithdrawConfirm() {
        withdrawConfirm.classList.remove('is-open');
        withdrawConfirm.setAttribute('aria-hidden', 'true');
    }

    openWithdrawConfirm.addEventListener('click', function () {
        withdrawConfirm.classList.add('is-open');
        withdrawConfirm.setAttribute('aria-hidden', 'false');
        withdrawSubmit.focus();
    });

    withdrawCancel.addEventListener('click', closeWithdrawConfirm);

    withdrawConfirm.addEventListener('click', function (event) {
        if (event.target === withdrawConfirm) {
            closeWithdrawConfirm();
        }
    });

    withdrawSubmit.addEventListener('click', function () {
        let actionInput = settingsForm.querySelector('input[name="action"][data-withdraw-action]');
        if (!actionInput) {
            actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.dataset.withdrawAction = 'true';
            settingsForm.appendChild(actionInput);
        }
        actionInput.value = 'delete';
        settingsForm.submit();
    });
</script>
