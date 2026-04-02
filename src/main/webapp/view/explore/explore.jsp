<%--
  Created by IntelliJ IDEA.
  User: soldesk
  Date: 2026-04-02
  Time: 오후 12:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Explore</title>
      <link rel="stylesheet" href="/css/explore.css">

</head>
<body>
<div class="explore-header">
    <h1>여행 플랜 탐색</h1>
    <p>다른 여행자들의 멋진 여행 계획을 둘러보고 영감을 받아보세요</p>
</div>

<div class="search-box">
    <input type="text" placeholder="여행지, 키워드, 작성자 검색..." />
</div>

<div class="filter-box card-box">
    <h3>🔎 필터</h3>
    <div class="filter-item active">🌍 전체</div>
    <div class="filter-item">🍽 미식</div>
    <div class="filter-item">🧘 힐링</div>
    <div class="filter-item">🏃 액티브</div>
    <div class="filter-item">🏛 문화</div>
    <div class="filter-item">🛍 쇼핑</div>
</div>

<div class="trending-box card-box">
    <h3>🔥 트렌딩 목적지</h3>

    <div class="trend-item">
        <span class="rank">1</span>
        <div class="trend-info">
            <h4>도쿄</h4>
            <p>1234개 플랜</p>
        </div>
        <span class="trend-rate up">+12%</span>
    </div>

    <div class="trend-item">
        <span class="rank">2</span>
        <div class="trend-info">
            <h4>교토</h4>
            <p>987개 플랜</p>
        </div>
        <span class="trend-rate up">+18%</span>
    </div>

    <div class="trend-item">
        <span class="rank">3</span>
        <div class="trend-info">
            <h4>오사카</h4>
            <p>856개 플랜</p>
        </div>
        <span class="trend-rate up">+9%</span>
    </div>

    <div class="trend-item">
        <span class="rank">4</span>
        <div class="trend-info">
            <h4>제주도</h4>
            <p>743개 플랜</p>
        </div>
        <span class="trend-rate up">+25%</span>
    </div>

    <div class="trend-item">
        <span class="rank">5</span>
        <div class="trend-info">
            <h4>부산</h4>
            <p>621개 플랜</p>
        </div>
        <span class="trend-rate">-</span>
    </div>
</div>


<div class="popular-box card-box">
        <div class="card-header">
            <h2>인기 여행 플랜</h2>
            <select>
                <option>인기순</option>
                <option>최신순</option>
                <option>좋아요순</option>
                <option>후기순</option>

            </select>
        </div>

        <div class="card-list">

            <!-- 카드 1 -->
            <div class="card">
                <div class="card-img">
                    <img src="tokyo.jpg">
                    <span class="price">₩850,000</span>
                </div>E

                <div class="card-body">
                    <div class="user">👤 김민준</div>
                    <h3>도쿄 야경 투어 3일</h3>

                    <div class="info">
                        <span>📅 3일</span>
                        <span>⭐ 4.9</span>
                    </div>

                    <div class="tags">
                        <span>#도심</span>
                        <span>#야경</span>
                        <span>#쇼핑</span>
                    </div>

                    <div class="card-footer">
                        <span>♡ 2847</span>
                        <span>💬 342</span>
                        <span>🔗</span>
                    </div>
                </div>
            </div>

            <!-- 카드 계속 복붙 -->
            <!-- 카드 2 -->
            <div class="card">
                <div class="card-img">
                    <img src="kyoto.jpg">
                    <span class="price">₩820,000</span>
                </div>

                <div class="card-body">
                    <div class="user">👤 이서준</div>
                    <h3>교토 전통 사찰 순례</h3>

                    <div class="info">
                        <span>📅 4일</span>
                        <span>⭐ 5.0</span>
                    </div>

                    <div class="tags">
                        <span>#문화</span>
                        <span>#힐링</span>
                        <span>#사진</span>
                    </div>

                    <div class="card-footer">
                        <span>♡ 3521</span>
                        <span>💬 418</span>
                        <span>🔗</span>
                    </div>
                </div>
            </div>

            <!-- 카드 3 -->
            <div class="card">
                <div class="card-img">
                    <img src="osaka.jpg">
                    <span class="price">₩780,000</span>
                </div>

                <div class="card-body">
                    <div class="user">👤 박지훈</div>
                    <h3>오사카 미식 탐방</h3>

                    <div class="info">
                        <span>📅 3일</span>
                        <span>⭐ 4.8</span>
                    </div>

                    <div class="tags">
                        <span>#맛집투어</span>
                        <span>#야시장</span>
                        <span>#먹방</span>
                    </div>

                    <div class="card-footer">
                        <span>♡ 4235</span>
                        <span>💬 567</span>
                        <span>🔗</span>
                    </div>
                </div>
            </div>

            <!-- 카드 4 -->
            <div class="card">
                <div class="card-img">
                    <img src="jeju.jpg">
                    <span class="price">₩650,000</span>
                </div>

                <div class="card-body">
                    <div class="user">👤 최유진</div>
                    <h3>제주도 자연 힐링 여행</h3>

                    <div class="info">
                        <span>📅 4일</span>
                        <span>⭐ 4.7</span>
                    </div>

                    <div class="tags">
                        <span>#자연</span>
                        <span>#휴식</span>
                        <span>#드라이브</span>
                    </div>

                    <div class="card-footer">
                        <span>♡ 1983</span>
                        <span>💬 234</span>
                        <span>🔗</span>
                    </div>
                </div>
            </div>

            <!-- 카드 계속 추가하면 자동으로 2열 정렬됨 -->
        </div>
</div>

 <div class="more-btn-container">
    <button class="more-btn">더 많은 플랜 보기</button>
</div>

</body>





</html>
