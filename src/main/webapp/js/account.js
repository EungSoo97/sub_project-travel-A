const select = document.getElementById("emailDomain");
const custom = document.getElementById("customDomain");

// 도메인 선택
select.addEventListener("change", function () {
    if (this.value === "direct") {
        custom.style.display = "inline";
    } else {
        custom.style.display = "none";
    }
});

// 이메일 합치기
function setEmail() {
    const emailInput = document.querySelector('input[name="email"]');
    const domainSelect = document.getElementById("emailDomain").value;
    const customDomain = document.getElementById("customDomain").value.trim();

    let id = emailInput.value;
    let domain = "";

    if (domainSelect === "direct") {
        if (!customDomain) {
            alert("도메인을 입력해주세요");
            return false;
        }
        domain = customDomain.replace("@", "");
    } else {
        domain = domainSelect;
    }

    if (!id) {
        alert("이메일을 입력해주세요");
        return false;
    }

    emailInput.value = id + "@" + domain;
    return true;
}

// 비밀번호 체크
function checkPassword() {
    const pw1 = document.getElementById("pw1").value;
    const pw2 = document.getElementById("pw2").value;
    const msg = document.getElementById("pw-msg");

    if (!pw2) {
        msg.innerText = "";
        return;
    }

    if (pw1 === pw2) {
        msg.innerText = "비밀번호 일치";
        msg.style.color = "green";
    } else {
        msg.innerText = "비밀번호 불일치";
        msg.style.color = "red";
    }

}
function checkAgree() {
    const agree = document.getElementById("agree");

    if (!agree.checked) {
        alert("이용약관에 동의해주세요");
        return false;
    }

    return true;
}
function validateForm() {
    if (!checkAgree()) return false;
    if (!setEmail()) return false;

    return true;
}