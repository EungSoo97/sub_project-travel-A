<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Mypage</title>
    <link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<section class="profile-section">
    <div class="profile-inner">
        <div class="profile-header">
            <div class="profile-img-wrap">
                <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80" alt="프로필">
            </div>

            <div class="profile-info">
                <div class="name-row">
                    <h2>김여행</h2>
                    <div class="action-icons">
                        <button title="설정" onclick="location.href='${pageContext.request.contextPath}/settings'">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="3"></circle>
                                <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                            </svg>
                        </button>

                        <button title="로그아웃" onclick="location.href='${pageContext.request.contextPath}/logout'">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                <polyline points="16 17 21 12 16 7"></polyline>
                                <line x1="21" y1="12" x2="9" y2="12"></line>
                            </svg>
                        </button>
                    </div>
                </div>
                <p class="email">travel.lover@email.com</p>

                <div class="badges">
                    <span class="badge">🏅 여행 마스터</span>
                    <span class="badge">📍 18개 도시 방문</span>
                </div>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-box">
                <span class="stat-num">12</span>
                <span class="stat-label">총 여행</span>
            </div>
            <div class="stat-box">
                <span class="stat-num">43</span>
                <span class="stat-label">여행 일수</span>
            </div>
            <div class="stat-box">
                <span class="stat-num">5</span>
                <span class="stat-label">방문 국가</span>
            </div>
            <div class="stat-box">
                <span class="stat-num">18</span>
                <span class="stat-label">방문 도시</span>
            </div>
        </div>
    </div>
</section>

<nav class="tabs">
    <button class="tab active" data-target="content-saved">저장된 여행</button>
    <button class="tab" data-target="content-liked">좋아요한 플랜</button>
    <button class="tab" data-target="content-reviews">후기</button>
    <button class="tab" data-target="content-stats">통계</button>
</nav>

<section class="mypage-content">

    <div id="content-saved" class="tab-content active">
        <article class="trip-card">
            <div class="card-img-wrap">
                <img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=600&q=80" alt="도쿄">
                <span class="status-badge blue">예정됨</span>
            </div>
            <div class="card-body">
                <h3>도쿄 3일 여행</h3>
                <div class="trip-details">
                    <p><span>📍</span> 일본 도쿄</p>
                    <p><span>📅</span> 2026.04.15 - 2026.04.17</p>
                    <p><span>👥</span> 2명</p>
                </div>
                <button class="btn-detail">자세히 보기</button>
            </div>
        </article>

        <article class="trip-card">
            <div class="card-img-wrap">
                <img src="https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=600&q=80" alt="교토">
                <span class="status-badge yellow">작성 중</span>
            </div>
            <div class="card-body">
                <h3>교토 힐링 여행</h3>
                <div class="trip-details">
                    <p><span>📍</span> 일본 교토</p>
                    <p><span>📅</span> 2026.05.20 - 2026.05.24</p>
                    <p><span>👥</span> 1명</p>
                </div>
                <button class="btn-detail">자세히 보기</button>
            </div>
        </article>

        <article class="trip-card">
            <div class="card-img-wrap">
                <img src="https://images.unsplash.com/photo-1590559899731-a382839ceab5?auto=format&fit=crop&w=600&q=80" alt="오사카">
                <span class="status-badge green">완료</span>
            </div>
            <div class="card-body">
                <h3>오사카 미식 여행</h3>
                <div class="trip-details">
                    <p><span>📍</span> 일본 오사카</p>
                    <p><span>📅</span> 2026.03.10 - 2026.03.13</p>
                    <p><span>👥</span> 4명</p>
                </div>
                <button class="btn-detail">자세히 보기</button>
            </div>
        </article>
    </div>

    <div id="content-liked" class="tab-content">
        <div class="empty-state">
            <p>❤️ 아직 좋아요를 누른 플랜이 없어요!</p>
        </div>
    </div>

    <div id="content-reviews" class="tab-content">
        <div class="empty-state">
            <p>✍️ 작성한 여행 후기가 없습니다.</p>
        </div>
    </div>

    <div id="content-stats" class="tab-content">
        <div class="empty-state">
            <p>📊 여행 통계 데이터가 준비 중입니다.</p>
        </div>
    </div>

</section>

<script>
    const tabBtns = document.querySelectorAll('.tab');
    const tabContents = document.querySelectorAll('.tab-content');

    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            tabBtns.forEach(t => t.classList.remove('active'));
            tabContents.forEach(c => c.classList.remove('active'));

            btn.classList.add('active');

            const targetId = btn.getAttribute('data-target');
            document.getElementById(targetId).classList.add('active');
        });
    });
</script>
</body>
</html>