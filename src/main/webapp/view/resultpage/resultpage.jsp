
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Resultpage</title>
    <link rel="stylesheet" href="result-page.css">
</head>
<body>
<div class="result-page">

    <div class="container-result">

        <div class="header">
            <div ><a href="hello-servlet">← 검색으로 돌아가기</a></div>

            <div class="title-area">
                <h1> AI 맞춤 여행 일정</h1>
                <p class="sub">${result.summary.destination} · 6일 여행</p>


<%--            EL 문으로 잡아줄예정--%>
            </div>


            <div class="actions">
                <form action="result-page" method="post">
                <button >✏️</button>
                </form>
                <button>♡</button>
                <button>🔗</button>
<%--                공유 버튼은 url 복사만 --%>
                <button class="download">⬇ 다운로드</button>
                <button class="download">개시하기</button>
            </div>
        </div>

        <!-- 여행 정보 카드 -->
        <div class="info-cards">
            <div class="card">
                <p class="label">📅 여행 기간</p>
                <p class="value">4월 2일 ~ 4월 7일</p>
                <%--            EL 문으로 잡아줄예정--%>
            </div>

            <div class="card">
                <p class="label">👥 여행 인원</p>
                <p class="value">2명</p>
                <%--            EL 문으로 잡아줄예정--%>
            </div>

            <div class="card">
                <p class="label">✨ 여행 스타일</p>
                <p class="value">액티브</p>
                <%--            EL 문으로 잡아줄예정--%>
            </div>
        </div>

        <!-- 지도 영역 -->
        <div class="map-section">
            <div class="map-header">
                <span>🧭 여행 동선 지도</span>
                <div class="legend">
                    <span class="dot blue"></span> 관광지
                    <span class="dot orange"></span> 식당
                    <span class="dot purple"></span> 숙소
                </div>
            </div>

            <div class="map-area">
                <!-- 지도 들어갈 자리 -->
            </div>
        </div>

        <!-- 일정 리스트 -->
        <div class="schedule">

            <div class="day">
                <h3>1일차 <span>(5개 장소)</span></h3>
                <p class="route">
                    ● 아사쿠사 센소지 → ● 점심 - 텐동 → ● 도쿄 스카이트리 → ● 저녁 - 이자카야 → ● 아메요코 거리 야시장
                </p>
            </div>

            <div class="day">
                <h3>2일차 <span>(8개 장소)</span></h3>
                <p class="route">
                    ● 메이지 신궁 → ● 하라주쿠 거리 → ● 점심 - 라멘 → ● 시부야 스크램블 교차로 → ● 시부야 스카이 → ● 저녁 - 야키니쿠 → ● 신주쿠 골든가이
                </p>
            </div>

            <div class="day">
                <h3>3일차 <span>(4개 장소)</span></h3>
                <p class="route">
                    ● 후지산 → ● 점심 - 호토우동 → ● 가와구치호 → ● 저녁 - 회전초밥
                </p>
            </div>

        </div>
        <div class="detail-container">

            <!-- 상단 -->
            <div class="detail-header">
                <h2>상세 일정</h2>
                <div class="total-cost">총 예상 비용: ¥82,800</div>
            </div>

            <!-- 하루 -->
            <div class="day-card">

                <!-- day header -->
                <div class="day-header">
                    <div class="day-left">
                        <div class="day-badge">D1</div>
                        <div>
                            <div class="day-title">1일차</div>
                            <div class="day-date">4월 2일 (목)</div>
                        </div>
                    </div>

                    <div class="day-right">
                        <span class="transport">🚆 지하철/도보</span>
                        <span class="distance">총 거리: 12.5km</span>
                    </div>
                </div>

                <!-- 오전 -->
                <div class="time-section">
                    <h4>오전</h4>

                    <div class="item">
                        <div class="icon move">▲</div>
                        <div class="content">
                            <div class="top">
                                <span class="time">09:00</span>
                                <span class="title">공항에서 숙소로 이동</span>
                            </div>
                            <div class="desc">나리타공항 → 도쿄역 (NEX 특급열차)</div>
                        </div>
                        <div class="meta">
                            <span>1시간</span>
                            <span>¥3,070</span>
                        </div>
                    </div>

                    <div class="item">
                        <div class="icon spot">📍</div>
                        <div class="content">
                            <div class="top">
                                <span class="time">11:00</span>
                                <span class="title">아사쿠사 센소지</span>
                            </div>
                            <div class="desc">도쿄에서 가장 오래된 사찰</div>
                        </div>
                        <div class="meta">
                            <span>2시간</span>
                            <span>무료</span>
                        </div>
                    </div>

                </div>

                <!-- 오후 -->
                <div class="time-section">
                    <h4>오후</h4>

                    <div class="item">
                        <div class="icon food">🍽</div>
                        <div class="content">
                            <div class="top">
                                <span class="time">13:00</span>
                                <span class="title">점심 - 텐동</span>
                            </div>
                            <div class="desc">아사쿠사 맛집</div>
                        </div>
                        <div class="meta">¥1,200</div>
                    </div>

                    <div class="item">
                        <div class="icon spot">📍</div>
                        <div class="content">
                            <div class="top">
                                <span class="time">15:00</span>
                                <span class="title">도쿄 스카이트리</span>
                            </div>
                            <div class="desc">634m 전망대</div>
                        </div>
                        <div class="meta">
                            <span>2시간</span>
                            <span>¥2,700</span>
                        </div>
                    </div>

                </div>

                <!-- 저녁 -->
                <div class="time-section">
                    <h4>저녁</h4>

                    <div class="item">
                        <div class="icon food">🍽</div>
                        <div class="content">
                            <div class="top">
                                <span class="time">18:00</span>
                                <span class="title">저녁 - 이자카야</span>
                            </div>
                            <div class="desc">현지 술집</div>
                        </div>
                        <div class="meta">¥3,500</div>
                    </div>

                    <div class="item">
                        <div class="icon spot">📍</div>
                        <div class="content">
                            <div class="top">
                                <span class="time">20:30</span>
                                <span class="title">아메요코 거리 야시장</span>
                            </div>
                            <div class="desc">야시장 구경</div>
                        </div>
                        <div class="meta">1.5시간</div>
                    </div>

                </div>

                <!-- 하단 요약 -->
                <div class="day-footer">
                    <span>총 3개 관광지 · 2회 식사</span>
                    <span>예상 비용: ¥8,500</span>
                </div>

            </div>

        </div>

        <div class="recommend-section">

            <h2>추천 항공/숙박</h2>

            <div class="recommend-grid">

                <!-- 항공 -->
                <div class="recommend-card">
                    <h3>✈️ 항공권 최저가</h3>

                    <div class="recommend-item">
                        <div class="left">
                            <div class="title">대한항공 KE706</div>
                            <div class="desc">인천 → 나리타 (직항)</div>
                        </div>
                        <div class="right">
                            <div class="price">₩385,000</div>
                            <div class="sub">왕복 1인</div>
                        </div>
                    </div>

                    <div class="recommend-item">
                        <div class="left">
                            <div class="title">아시아나 OZ102</div>
                            <div class="desc">인천 → 나리타 (직항)</div>
                        </div>
                        <div class="right">
                            <div class="price">₩395,000</div>
                            <div class="sub">왕복 1인</div>
                        </div>
                    </div>
                </div>

                <!-- 숙박 -->
                <div class="recommend-card">
                    <h3>🏨 숙박 추천</h3>

                    <div class="recommend-item">
                        <div class="left">
                            <div class="title">도쿄 베이 힐튼</div>
                            <div class="desc">⭐ 4.5 · 신주쿠역 5분</div>
                        </div>
                        <div class="right">
                            <div class="price">₩185,000</div>
                            <div class="sub">1박</div>
                        </div>
                    </div>

                    <div class="recommend-item">
                        <div class="left">
                            <div class="title">센츄리 서던 타워</div>
                            <div class="desc">⭐ 4.3 · 시부야역 10분</div>
                        </div>
                        <div class="right">
                            <div class="price">₩165,000</div>
                            <div class="sub">1박</div>
                        </div>
                    </div>

                </div>

            </div>

        </div>





    </div>
</div>
    </body>
    </html>


