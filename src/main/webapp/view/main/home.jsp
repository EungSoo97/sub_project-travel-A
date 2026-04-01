<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Travel-A(AI) | AI 여행 플래너</title>
</head>
<body>
<main>
    <section class="hero section">
        <div class="container hero__inner">
            <span class="hero__badge">AI Travel Planner</span>
            <h1 class="hero__title">AI가 만드는 완벽한 여행</h1>
            <p class="hero__desc">당신의 취향과 예산에 맞춘 맞춤형 여행 일정을 몇 초 만에 완성하세요.</p>
        </div>
    </section>

    <section class="search section search-section">
        <div class="container">
            <form class="search-card" action="${pageContext.request.contextPath}/planner/result" method="get">
                <div class="search-card__header">
                    <h2>여행 조건 입력</h2>
                    <p>JSP에서는 form submit 기반으로 서버에 조건을 넘기고, 이후 결과 페이지에서 itinerary를 렌더링하면 됩니다.</p>
                </div>

                <div class="form-grid">
                    <div class="form-field form-field--wide">
                        <label for="destination">여행지</label>
                        <input id="destination" name="destination" type="text" placeholder="예: 일본, 시코쿠, 규슈" required>
                    </div>

                    <div class="form-field">
                        <label for="startDate">출발일</label>
                        <input id="startDate" name="startDate" type="date" required>
                    </div>

                    <div class="form-field">
                        <label for="endDate">도착일</label>
                        <input id="endDate" name="endDate" type="date" required>
                    </div>
                </div>

                <div class="search-card__row">
                    <div class="traveler-box">
                        <span class="traveler-box__label">여행 인원</span>
                        <div class="counter">
                            <button type="button" class="counter__btn" data-counter-minus>-</button>
                            <input type="number" id="travelers" name="travelers" value="2" min="1" max="20" readonly>
                            <button type="button" class="counter__btn" data-counter-plus>+</button>
                        </div>
                    </div>
                </div>

                <div class="chip-group-wrap">
                    <h3>여행 스타일</h3>
                    <div class="chip-group">
                        <label class="chip"><input type="checkbox" name="travelStyle" value="식도락"><span>식도락</span></label>
                        <label class="chip"><input type="checkbox" name="travelStyle" value="액티브"><span>액티브</span></label>
                        <label class="chip"><input type="checkbox" name="travelStyle" value="문화"><span>문화</span></label>
                        <label class="chip"><input type="checkbox" name="travelStyle" value="쇼핑"><span>쇼핑</span></label>
                        <label class="chip"><input type="checkbox" name="travelStyle" value="자연"><span>자연</span></label>
                    </div>
                </div>

                <div class="chip-group-wrap">
                    <h3>분위기</h3>
                    <div class="chip-group">
                        <label class="chip"><input type="checkbox" name="mood" value="힐링"><span>힐링</span></label>
                        <label class="chip"><input type="checkbox" name="mood" value="도심"><span>도심</span></label>
                        <label class="chip"><input type="checkbox" name="mood" value="로맨틱"><span>로맨틱</span></label>
                        <label class="chip"><input type="checkbox" name="mood" value="가족"><span>가족</span></label>
                        <label class="chip"><input type="checkbox" name="mood" value="모험"><span>모험</span></label>
                    </div>
                </div>

                <button type="submit" class="btn btn--primary btn--block">AI 여행 일정 만들기</button>
            </form>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div class="image-search-card">
                <div class="section-head section-head--center">
                    <h2>이미지로 여행지 찾기</h2>
                    <p>React의 업로드 컴포넌트를 JSP/HTML 구조로 단순화했습니다. 실제 AI 분석은 추후 API 호출로 연결하면 됩니다.</p>
                </div>

                <div class="upload-box" id="uploadBox">
                    <input type="file" id="imageFile" accept="image/*" hidden>
                    <button type="button" class="upload-box__button" id="uploadTrigger">이미지 업로드</button>
                    <p class="upload-box__text">클릭하거나 파일을 드래그하여 업로드하세요</p>
                    <div class="upload-preview" id="uploadPreview"></div>
                </div>
            </div>
        </div>
    </section>

    <section class="features section section--soft">
        <div class="container">
            <div class="feature-grid">
                <article class="feature-card">
                    <div class="feature-card__icon">⚡</div>
                    <h3>초정밀 AI 분석</h3>
                    <p>취향과 예산을 고려한 일정 추천</p>
                </article>
                <article class="feature-card">
                    <div class="feature-card__icon">📈</div>
                    <h3>실시간 최저가</h3>
                    <p>항공편과 숙박을 한눈에 비교</p>
                </article>
                <article class="feature-card">
                    <div class="feature-card__icon">📷</div>
                    <h3>이미지 검색</h3>
                    <p>사진 기반 여행지 추천 확장 가능</p>
                </article>
                <article class="feature-card">
                    <div class="feature-card__icon">🛡️</div>
                    <h3>안전한 예약</h3>
                    <p>검증된 파트너 연동 구조에 적합</p>
                </article>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div class="section-head">
                <h2>인기 여행지</h2>
                <p>현재는 정적 카드로 구성했고, 나중에는 JSTL의 c:forEach로 서버 데이터만 바꿔서 렌더링할 수 있습니다.</p>
            </div>

            <div class="destination-grid">
                <article class="destination-card">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1200&q=80" alt="교토">
                        <div class="destination-card__overlay">
                            <strong>교토</strong>
                            <span>일본</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>벚꽃과 전통 문화의 도시</p></div>
                </article>

                <article class="destination-card">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80" alt="도쿄">
                        <div class="destination-card__overlay">
                            <strong>도쿄</strong>
                            <span>일본</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>현대와 전통이 공존하는 도시</p></div>
                </article>

                <article class="destination-card">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1590559899731-a382839e5549?auto=format&fit=crop&w=1200&q=80" alt="오사카">
                        <div class="destination-card__overlay">
                            <strong>오사카</strong>
                            <span>일본</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>맛과 활기가 살아있는 도시</p></div>
                </article>

                <article class="destination-card">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80" alt="자연 여행">
                        <div class="destination-card__overlay">
                            <strong>자연 여행</strong>
                            <span>테마</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>휴식과 힐링 중심 코스</p></div>
                </article>

                <article class="destination-card">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1468413253725-0d5181091126?auto=format&fit=crop&w=1200&q=80" alt="해안 드라이브">
                        <div class="destination-card__overlay">
                            <strong>해안 드라이브</strong>
                            <span>테마</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>바다와 함께하는 여행 코스</p></div>
                </article>

                <article class="destination-card">
                    <div class="destination-card__image">
                        <img src="https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1200&q=80" alt="역사 투어">
                        <div class="destination-card__overlay">
                            <strong>역사 투어</strong>
                            <span>테마</span>
                        </div>
                    </div>
                    <div class="destination-card__body"><p>성곽과 유적 중심의 여행</p></div>
                </article>
            </div>
        </div>
    </section>

    <section class="cta section">
        <div class="container cta__inner">
            <h2>지금 바로 떠날 준비되셨나요?</h2>
            <p>AI가 추천하는 최적 동선과 가격 비교를 한 번에 확인해보세요.</p>
            <a href="${pageContext.request.contextPath}/explore" class="btn btn--light">즉흥 여행 상품 보기</a>
        </div>
    </section>
</main>


</body>
</html>
