$(function () {
    $("#check-btn").click(function () {
        const loginId = $("input[name='login_id']").val().trim();

        if (loginId === "") {
            $(".result").text("ID를 입력해주세요.").css("color", "orange");
            return;
        }

        $.ajax({
            url: 'idcheck',
            data: { login_id: loginId }
        }).done(function (resData) {
            if (resData === 0) {
                $(".result").text("사용 가능한 ID입니다.").css("color", "green");
            } else {
                $(".result").text("이미 사용 중인 ID입니다.").css("color", "red");
            }
        }).fail(function () {
            $(".result").text("서버 오류가 발생했습니다.").css("color", "red");
        });
    });
});