const select = document.getElementById("emailDomain");
const custom = document.getElementById("customDomain");

select.addEventListener("change", function () {
    if (this.value === "direct") {
        custom.style.display = "inline";
    } else {
        custom.style.display = "none";
    }
});

function setEmail() {
    const emailInput = document.querySelector('input[name="email"]');
    const domainSelect = document.getElementById("emailDomain").value;
    const customDomain = document.getElementById("customDomain").value.trim();

    let id = emailInput.value.trim();
    let domain = "";

    if (domainSelect === "direct") {
        if (!customDomain) {
            alert("\ub3c4\uba54\uc778\uc744 \uc785\ub825\ud574\uc8fc\uc138\uc694.");
            return false;
        }
        domain = customDomain.replace("@", "");
    } else {
        domain = domainSelect;
    }

    if (!id) {
        alert("\uc774\uba54\uc77c \uc544\uc774\ub514\ub97c \uc785\ub825\ud574\uc8fc\uc138\uc694.");
        return false;
    }

    if (id.includes("@")) {
        id = id.split("@")[0];
    }

    emailInput.value = id + "@" + domain;
    return true;
}

function checkPassword() {
    const pw1 = document.getElementById("pw1").value;
    const pw2 = document.getElementById("pw2").value;
    const msg = document.getElementById("pw-msg");

    if (!pw2) {
        msg.innerText = "";
        return;
    }

    if (pw1 === pw2) {
        msg.innerText = "\ube44\ubc00\ubc88\ud638 \uc77c\uce58";
        msg.style.color = "green";
    } else {
        msg.innerText = "\ube44\ubc00\ubc88\ud638 \ubd88\uc77c\uce58";
        msg.style.color = "red";
    }
}

function checkIdRealtime() {
    const loginId = document.querySelector('input[name="login_id"]').value.trim();
    const alphanumericRegex = /^[a-zA-Z0-9]+$/;

    if (loginId && !alphanumericRegex.test(loginId)) {
        showSnackbar("ID는 영어와 숫자만 입력 가능합니다.");
    }
}

function checkEmailRealtime() {
    const emailId = document.querySelector('input[name="email"]').value.trim();
    const emailIdRegex = /^[A-Za-z0-9._%+-]+$/;

    if (emailId && !emailIdRegex.test(emailId)) {
        showSnackbar("이메일 아이디는 영어, 숫자, ._ %+- 만 입력 가능합니다.");
    }
}

function checkDomainRealtime() {
    const customDomain = document.getElementById("customDomain").value.trim();
    const domainRegex = /^(?!-)([A-Za-z0-9-]+\.)+[A-Za-z]{2,}$/;

    if (customDomain && !domainRegex.test(customDomain)) {
        showSnackbar("도메인 형식이 올바르지 않습니다. (예: example.com)");
    }
}

function checkPasswordRealtime() {
    const password = document.getElementById("pw1").value.trim();
    const alphanumericRegex = /^[a-zA-Z0-9]+$/;

    if (password && !alphanumericRegex.test(password)) {
        showSnackbar("비밀번호는 영어와 숫자만 입력 가능합니다.");
    }
}

function togglePassword(inputId, btn) {
    const input = document.getElementById(inputId);
    const isPassword = input.type === "password";

    input.type = isPassword ? "text" : "password";
    btn.innerHTML = isPassword ? '<i class="fa-solid fa-eye"></i>' : '<i class="fa-solid fa-eye-slash"></i>';
}

function checkAgree() {
    const agree = document.getElementById("agree");

    if (!agree.checked) {
        alert("\uc774\uc6a9\uc57d\uad00\uc5d0 \ub3d9\uc758\ud574\uc8fc\uc138\uc694.");
        return false;
    }

    return true;
}

function validateForm() {
    if (!checkAgree()) return false;
    if (!setEmail()) return false;
    if (!checkAlphanumeric()) return false;

    return true;
}

function checkAlphanumeric() {
    const loginId = document.querySelector('input[name="login_id"]').value.trim();
    const password = document.getElementById("pw1").value.trim();

    const alphanumericRegex = /^[a-zA-Z0-9]+$/;

    if (!alphanumericRegex.test(loginId)) {
        showSnackbar("ID는 영어와 숫자만 입력 가능합니다.");
        return false;
    }

    if (!alphanumericRegex.test(password)) {
        showSnackbar("비밀번호는 영어와 숫자만 입력 가능합니다.");
        return false;
    }

    return true;
}

function showSnackbar(message) {
    const snackbar = document.getElementById("snackbar");
    snackbar.textContent = message;
    snackbar.classList.add("show");

    setTimeout(() => {
        snackbar.classList.remove("show");
    }, 3000);
}
