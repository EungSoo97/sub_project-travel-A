
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Live</title>
    <link rel="stylesheet" href="/css/live.css">
</head>
<body>


<div class="live-header">
    <h1>실시간 여행</h1>
    <p>지금 이 순간의 여행을 실시간으로 관리하세요</p>
</div>

<div class="realtime-box card-box">

    <div class="time-box">
        <div class="time-top">
            <span class="time-label">🕒 현재 시각</span>
            <span class="time-display" id="currentTime">오후 05:32</span>
        </div>
        <div class="time-bottom">
            <span class="date-display" id="currentDate">2026년 4월 2일 목요일</span>
        </div>
    </div>

    <div class="activity-card">
        <div class="activity-header">
            <div class="status-badge"><span class="dot"></span> 진행 중</div>
            <div class="time-remaining">남은 시간 <strong>5분</strong></div>
        </div>

        <h3 class="activity-title">도쿄 스카이트리</h3>
        <p class="activity-address">📍 東京都墨田区押上1丁目1-2</p>

        <div class="info-grid">
            <div class="info-item">
                <span class="info-label">시작</span>
                <span class="info-value">15:00</span>
            </div>
            <div class="info-item">
                <span class="info-label">종료</span>
                <span class="info-value">17:00</span>
            </div>
            <div class="info-item">
                <span class="info-label">혼잡도</span>
                <span class="info-value status-good">여유</span>
            </div>
        </div>

        <div class="congestion-banner">
            <div class="banner-icon">👥</div>
            <div class="banner-text">
                <strong>실시간 혼잡도</strong>
                <p>지금 방문하기 좋은 시간이에요!</p>
            </div>
        </div>
    </div>
    <div class="next-schedule-box card-box">
        <div class="section-title">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
            다음 일정
        </div>

        <div class="schedule-content">
            <div class="schedule-info">
                <h3>아사쿠사 센소지</h3>
                <p>17:30 예정 &nbsp;&middot;&nbsp; 2.3km &nbsp;&middot;&nbsp; 15분</p>
            </div>
            <button class="btn-dark">경로 보기</button>
        </div>
    </div>

    <div class="nearby-booking-box card-box">
        <div class="section-header">
            <div class="section-title">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path><circle cx="12" cy="13" r="4"></circle></svg>
                주변 인생샷 스폿
            </div>
            <span class="subtitle">도보 10분 이내</span>
        </div>

        <div class="booking-list">
            <div class="booking-item">
                <div class="place-info">
                    <div class="place-title-row">
                        <h4>스미다 공원</h4>
                        <span class="badge badge-gray">포토존</span>
                    </div>
                    <p>300m &nbsp;🌸 벚꽃 핫플 &nbsp; 스카이트리 뷰</p>
                </div>
                <button class="btn-outline">위치 보기</button>
            </div>

            <div class="booking-item">
                <div class="place-info">
                    <div class="place-title-row">
                        <h4>도쿄 미즈마치</h4>
                        <span class="badge badge-gray">산책로</span>
                    </div>
                    <p>600m &nbsp;☕ 감성 카페 &nbsp; 강변 테라스</p>
                </div>
                <button class="btn-outline">위치 보기</button>
            </div>

            <div class="booking-item">
                <div class="place-info">
                    <div class="place-title-row">
                        <h4>짓켄가와 수변공원</h4>
                        <span class="badge badge-gray">숨은 명소</span>
                    </div>
                    <p>850m &nbsp;🤫 현지인 추천 &nbsp; 야경 맛집</p>
                </div>
                <button class="btn-outline">위치 보기</button>
            </div>
        </div>
    </div>
    <div class="weather-box card-box">
        <div class="section-title">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z"></path></svg>
            실시간 날씨
        </div>
        <div id="weatherArea">날씨 불러오는 중...</div>
    </div>

    <div class="traffic-box card-box">
        <div class="section-title">
            교통 상황
        </div>

        <div class="info-list">
            <div class="info-row">
                <span class="info-name">긴자선</span>
                <span class="status-text good">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    정상 운행
                </span>
            </div>
            <div class="info-row">
                <span class="info-name">마루노우치선</span>
                <span class="status-text warning">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                    5분 지연
                </span>
            </div>
            <div class="info-row">
                <span class="info-name">JR 야마노테선</span>
                <span class="status-text good">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    정상 운행
                </span>
            </div>
        </div>
    </div>

    <div class="emergency-box card-box">
        <div class="section-title">
            긴급 연락처
        </div>

        <div class="info-list">
            <div class="info-row">
                <span class="info-name text-gray">긴급 전화</span>
                <span class="info-value">110</span>
            </div>
            <div class="info-row">
                <span class="info-name text-gray">소방/구급</span>
                <span class="info-value">119</span>
            </div>
            <div class="info-row">
                <span class="info-name text-gray">관광 안내</span>
                <span class="info-value">050-3816-2787</span>
            </div>
        </div>
    </div>
</div>
<script src="/js/livePage.js"></script>
</body>
</html>