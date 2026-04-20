const select = document.getElementById("emailDomain");
const custom = document.getElementById("customDomain");
const customSelect = document.getElementById("emailDomainSelect");
const selectTrigger = customSelect.querySelector(".select-trigger");
const optionsList = customSelect.querySelector(".options");
const birthDateInput = document.getElementById("birthDate");
const birthDateTrigger = document.getElementById("birthDateTrigger");
const birthDateDisplay = document.getElementById("birthDateDisplay");
const birthDateModalBackdrop = document.getElementById("birthDateModalBackdrop");
const birthYearSelect = document.getElementById("birthYearSelect");
const birthMonthSelect = document.getElementById("birthMonthSelect");
const birthDaySelect = document.getElementById("birthDaySelect");
const birthDateCancelBtn = document.getElementById("birthDateCancelBtn");
const birthDateConfirmBtn = document.getElementById("birthDateConfirmBtn");

// 커스텀 드롭다운 토글
selectTrigger.addEventListener("click", function() {
    customSelect.classList.toggle("active");
});

// 옵션 선택
optionsList.addEventListener("click", function(e) {
    if (e.target.tagName === "LI") {
        const value = e.target.getAttribute("data-value");
        const text = e.target.textContent;

        // 선택된 옵션 하이라이트 업데이트
        optionsList.querySelectorAll("li").forEach(li => li.classList.remove("selected"));
        e.target.classList.add("selected");

        // 트리거 텍스트 업데이트
        selectTrigger.textContent = text;
        selectTrigger.setAttribute("data-value", value);

        // 히든 인풋 값 업데이트
        select.value = value;

        // 드롭다운 닫기
        customSelect.classList.remove("active");

        // 직접 입력 처리
        if (value === "direct") {
            custom.style.display = "inline";
            custom.value = "@";
            custom.focus();
        } else {
            custom.style.display = "none";
        }
    }
});

// 외부 클릭 시 드롭다운 닫기
document.addEventListener("click", function(e) {
    if (!customSelect.contains(e.target)) {
        customSelect.classList.remove("active");
    }
});

if (
    birthDateInput &&
    birthDateTrigger &&
    birthDateDisplay &&
    birthDateModalBackdrop &&
    birthYearSelect &&
    birthMonthSelect &&
    birthDaySelect &&
    birthDateCancelBtn &&
    birthDateConfirmBtn
) {
    const today = new Date();
    const currentYear = today.getFullYear();
    let previousBodyOverflow = "";

    function padBirthValue(value) {
        return String(value).padStart(2, "0");
    }

    function formatBirthDate(value) {
        if (!value) {
            return "";
        }

        const parts = value.split("-");
        if (parts.length !== 3) {
            return value;
        }

        return parts[0] + "." + parts[1] + "." + parts[2];
    }

    function setBirthDisplay(value) {
        birthDateDisplay.textContent = formatBirthDate(value || "2010-01-01");
    }

    function populateBirthYears() {
        const fragment = document.createDocumentFragment();
        for (let year = currentYear; year >= 1900; year -= 1) {
            const option = document.createElement("option");
            option.value = String(year);
            option.textContent = year + "년";
            fragment.appendChild(option);
        }
        birthYearSelect.innerHTML = "";
        birthYearSelect.appendChild(fragment);
    }

    function populateBirthMonths() {
        const fragment = document.createDocumentFragment();
        for (let month = 1; month <= 12; month += 1) {
            const option = document.createElement("option");
            option.value = String(month);
            option.textContent = month + "월";
            fragment.appendChild(option);
        }
        birthMonthSelect.innerHTML = "";
        birthMonthSelect.appendChild(fragment);
    }

    function populateBirthDays(year, month, selectedDay) {
        const maxDay = new Date(year, month, 0).getDate();
        const fragment = document.createDocumentFragment();
        for (let day = 1; day <= maxDay; day += 1) {
            const option = document.createElement("option");
            option.value = String(day);
            option.textContent = day + "일";
            fragment.appendChild(option);
        }
        birthDaySelect.innerHTML = "";
        birthDaySelect.appendChild(fragment);
        birthDaySelect.value = String(Math.min(selectedDay, maxDay));
    }

    function syncBirthPickerFromValue() {
        const value = birthDateInput.value || "2010-01-01";
        const parts = value.split("-");
        const year = Number(parts[0]) || 2010;
        const month = Number(parts[1]) || 1;
        const day = Number(parts[2]) || 1;

        birthYearSelect.value = String(year);
        birthMonthSelect.value = String(month);
        populateBirthDays(year, month, day);
    }

    function openBirthModal() {
        syncBirthPickerFromValue();
        previousBodyOverflow = document.body.style.overflow;
        document.body.style.overflow = "hidden";
        birthDateModalBackdrop.classList.add("is-open");
        birthDateModalBackdrop.setAttribute("aria-hidden", "false");
    }

    function closeBirthModal() {
        birthDateModalBackdrop.classList.remove("is-open");
        birthDateModalBackdrop.setAttribute("aria-hidden", "true");
        document.body.style.overflow = previousBodyOverflow;
    }

    function applyBirthDate() {
        const year = Number(birthYearSelect.value);
        const month = Number(birthMonthSelect.value);
        const day = Number(birthDaySelect.value);

        if (!year || !month || !day) {
            showSnackbar("생년월일을 모두 선택해주세요.");
            return;
        }

        const nextValue = year + "-" + padBirthValue(month) + "-" + padBirthValue(day);
        birthDateInput.value = nextValue;
        setBirthDisplay(nextValue);
        closeBirthModal();
    }

    populateBirthYears();
    populateBirthMonths();
    setBirthDisplay(birthDateInput.value);

    birthDateTrigger.addEventListener("click", openBirthModal);
    birthDateCancelBtn.addEventListener("click", closeBirthModal);
    birthDateConfirmBtn.addEventListener("click", applyBirthDate);
    birthDateModalBackdrop.addEventListener("click", function (event) {
        if (event.target === birthDateModalBackdrop) {
            closeBirthModal();
        }
    });

    birthYearSelect.addEventListener("change", function () {
        populateBirthDays(Number(birthYearSelect.value), Number(birthMonthSelect.value), Number(birthDaySelect.value) || 1);
    });

    birthMonthSelect.addEventListener("change", function () {
        populateBirthDays(Number(birthYearSelect.value), Number(birthMonthSelect.value), Number(birthDaySelect.value) || 1);
    });

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape" && birthDateModalBackdrop.classList.contains("is-open")) {
            closeBirthModal();
        }
    });
}

// 기존 select change 이벤트 유지 (하위 호환성)
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
        if (!customDomain || customDomain === "@") {
            alert("\ub3c4\uba54\uc778\uc744 \uc785\ub825\ud574\uc8fc\uc138\uc694.");
            return false;
        }
        domain = customDomain;
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

    emailInput.value = id + domain;
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
        showInlineError("id-error", "ID는 영어와 숫자만 입력 가능합니다.");
    } else {
        hideInlineError("id-error");
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
    const passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+$/;

    if (password && !passwordRegex.test(password)) {
        showSnackbar("비밀번호는 영어, 숫자, 특수문자만 입력 가능합니다.");
        showInlineError("password-error", "비밀번호는 영어, 숫자, 특수문자만 입력 가능합니다.");
    } else {
        hideInlineError("password-error");
    }

    updatePasswordStrength(password);
}

function showStrengthBar() {
    const strengthDiv = document.getElementById("password-strength");
    strengthDiv.classList.add("show");
}

function hideStrengthBar() {
    const strengthDiv = document.getElementById("password-strength");
    const password = document.getElementById("pw1").value.trim();
    if (!password) {
        strengthDiv.classList.remove("show");
    }
}

function updatePasswordStrength(password) {
    const strengthBar = document.getElementById("strength-bar");
    const strengthText = document.getElementById("strength-text");

    if (!password) {
        strengthBar.style.width = "0%";
        strengthBar.className = "strength-bar";
        strengthText.textContent = "";
        return;
    }

    let score = 0;

    // 길이 점수
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // 문자 조합 점수
    if (/[a-z]/.test(password)) score++;
    if (/[A-Z]/.test(password)) score++;
    if (/[0-9]/.test(password)) score++;
    if (/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) score++;

    // 강도 설정
    let strength = "";
    let color = "";
    let width = "";
    let strengthClass = "";

    if (score <= 2) {
        strength = "약함";
        color = "#dc2626";
        width = "33%";
        strengthClass = "weak";
    } else if (score <= 4) {
        strength = "보통";
        color = "#f59e0b";
        width = "66%";
        strengthClass = "medium";
    } else {
        strength = "강함";
        color = "#16a34a";
        width = "100%";
        strengthClass = "strong";
    }

    strengthBar.style.width = width;
    strengthBar.className = "strength-bar " + strengthClass;
    strengthText.textContent = strength;
    strengthText.style.color = color;
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
    if (!checkGender()) return false;

    return true;
}

function checkGender() {
    const gender = document.querySelector('input[name="gender"]:checked');
    if (!gender) {
        showSnackbar("성별을 선택해주세요.");
        return false;
    }
    return true;
}

function checkAlphanumeric() {
    const loginId = document.querySelector('input[name="login_id"]').value.trim();
    const password = document.getElementById("pw1").value.trim();

    const alphanumericRegex = /^[a-zA-Z0-9]+$/;
    const passwordRegex = /^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+$/;

    if (!alphanumericRegex.test(loginId)) {
        showSnackbar("ID는 영어와 숫자만 입력 가능합니다.");
        return false;
    }

    if (!passwordRegex.test(password)) {
        showSnackbar("비밀번호는 영어, 숫자, 특수문자만 입력 가능합니다.");
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

function showInlineError(elementId, message) {
    const errorElement = document.getElementById(elementId);
    if (errorElement) {
        errorElement.textContent = message;
        errorElement.classList.add("show");
    }
}

function hideInlineError(elementId) {
    const errorElement = document.getElementById(elementId);
    if (errorElement) {
        errorElement.textContent = "";
        errorElement.classList.remove("show");
    }
}
