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

    return true;
}
