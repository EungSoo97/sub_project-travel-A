function updateClock() {
    const now = new Date();

    const year = now.getFullYear();
    const month = now.getMonth() + 1;
    const date = now.getDate();
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    const dayName = days[now.getDay()];

    // 💡 JSP와 충돌하지 않도록 문자열 더하기(+) 방식으로 변경!
    document.getElementById('currentDate').innerText =
        year + '년 ' + month + '월 ' + date + '일 ' + dayName + '요일';

    let hours = now.getHours();
    let minutes = now.getMinutes();
    const ampm = hours >= 12 ? '오후' : '오전';

    hours = hours % 12;
    hours = hours ? hours : 12;
    minutes = minutes < 10 ? '0' + minutes : minutes;

    const hoursStr = hours < 10 ? '0' + hours : hours;

    // 💡 여기도 문자열 더하기(+) 방식으로 변경!
    document.getElementById('currentTime').innerText =
        ampm + ' ' + hoursStr + ':' + minutes;
}

updateClock();
setInterval(updateClock, 1000);


function loadWeather() {
    const destination = "도쿄";

    fetch("/weather?destination=" + encodeURIComponent(destination))
        .then(res => res.json())
        .then(data => {
            if (data.error) {
                document.getElementById("weatherArea").innerHTML =
                    "<p>${data.error}</p>";
                return;
            }

            document.getElementById("weatherArea").innerHTML =

                `<div class='weather-main'>
                    <h2>${data.temp}°C</h2>
                    <p>${data.description}</p>
                </div>

                <div class='weather-details'>
                    <div class='detail-item'>
                        <span class='detail-label'>습도</span>
                        <span class='detail-value'>${data.humidity}%</span>
                    </div>
                    <div class='detail-item'>
                        <span class='detail-label'>풍속</span>
                        <span class='detail-value'>${data.windSpeed}m/s</span>
                    </div>
                </div>`;
        })
        .catch(err => {
            console.error(err);
            document.getElementById("weatherArea").innerHTML =
                "<p>날씨 로딩 실패</p>";
        });
}

loadWeather();

setInterval(() => {
    if (!document.hidden) {
        loadWeather();
    }
}, 300000);