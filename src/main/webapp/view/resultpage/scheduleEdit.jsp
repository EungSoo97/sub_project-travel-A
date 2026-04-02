<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>일정 편집하기</title>

    <link rel="stylesheet" href="../../css/edit-schedule.css">
    <script src="js/scheduleEdit.js"></script>
</head>
<body>

<div class="container">

    <!-- ── 헤더 ── -->
    <div class="edit-header">
        <div class="edit-header__left">
            <h1>일정 편집하기</h1>
            <p>드래그 앤 드롭으로 일정을 자유롭게 수정하세요</p>
        </div>
        <div class="edit-header__actions">
            <button class="btn-recalc">
                <span class="btn-icon">↺</span> 경로 재계산
            </button>
            <button class="btn-save">
                <span class="btn-icon">💾</span> 저장
            </button>
        </div>
    </div>

    <!-- ── Day 블록 (반복 구조) ── -->
    <div class="day-block">

        <!-- Day 헤더 -->
        <div class="day-block__header">
            <span class="day-block__title">Day 1</span>
            <button class="btn-add-activity">
                <span>+</span> 활동 추가
            </button>
        </div>

        <!-- 일정 아이템 목록 (드래그 영역) -->
        <div class="activity-list" id="day1-list">

            <!-- 아이템: 이동 -->
            <div class="activity-item activity-item--move" draggable="true">
                <div class="activity-item__drag">⋮⋮</div>
                <div class="activity-item__icon">🚆</div>
                <div class="activity-item__body">
                    <div class="activity-item__top">
                        <span class="activity-item__time">09:00</span>
                        <span class="activity-item__title">공항에서 숙소로 이동</span>
                    </div>
                    <div class="activity-item__desc">나리타공항 → 도쿄역 (NEX 특급열차)</div>
                    <div class="activity-item__meta">
                        <span class="meta-tag meta-tag--time">⏱ 1시간</span>
                        <span class="meta-tag meta-tag--cost">$ ¥3,070</span>
                    </div>
                </div>
                <button class="activity-item__delete" title="삭제">🗑</button>
            </div>

            <!-- 아이템: 관광지 -->
            <div class="activity-item activity-item--spot" draggable="true">
                <div class="activity-item__drag">⋮⋮</div>
                <div class="activity-item__icon">🏛</div>
                <div class="activity-item__body">
                    <div class="activity-item__top">
                        <span class="activity-item__time">11:00</span>
                        <span class="activity-item__title">아사쿠사 센소지</span>
                    </div>
                    <div class="activity-item__desc">도쿄에서 가장 오래된 사찰, 전통 기념품 쇼핑</div>
                    <div class="activity-item__meta">
                        <span class="meta-tag meta-tag--location">📍 도쿄 다이토구</span>
                        <span class="meta-tag meta-tag--time">⏱ 2시간</span>
                        <span class="meta-tag meta-tag--cost">$ 무료</span>
                    </div>
                </div>
                <button class="activity-item__delete" title="삭제">🗑</button>
            </div>

            <!-- 아이템: 식사 -->
            <div class="activity-item activity-item--food" draggable="true">
                <div class="activity-item__drag">⋮⋮</div>
                <div class="activity-item__icon">🍽</div>
                <div class="activity-item__body">
                    <div class="activity-item__top">
                        <span class="activity-item__time">13:00</span>
                        <span class="activity-item__title">점심 - 텐동 (텐푸라 덮밥)</span>
                    </div>
                    <div class="activity-item__desc">다이코쿠야 본점에서 에비텐동 맛보기</div>
                    <div class="activity-item__meta">
                        <span class="meta-tag meta-tag--location">📍 아사쿠사</span>
                        <span class="meta-tag meta-tag--cost">$ ¥1,200</span>
                    </div>
                </div>
                <button class="activity-item__delete" title="삭제">🗑</button>
            </div>

            <!-- 아이템: 관광지 -->
            <div class="activity-item activity-item--spot" draggable="true">
                <div class="activity-item__drag">⋮⋮</div>
                <div class="activity-item__icon">🏛</div>
                <div class="activity-item__body">
                    <div class="activity-item__top">
                        <span class="activity-item__time">15:00</span>
                        <span class="activity-item__title">도쿄 스카이트리</span>
                    </div>
                    <div class="activity-item__desc">634m 높이의 전망대에서 도쿄 전경 감상</div>
                    <div class="activity-item__meta">
                        <span class="meta-tag meta-tag--location">📍 스미다구</span>
                        <span class="meta-tag meta-tag--time">⏱ 2시간</span>
                        <span class="meta-tag meta-tag--cost">$ ¥2,700</span>
                    </div>
                </div>
                <button class="activity-item__delete" title="삭제">🗑</button>
            </div>

            <!-- 아이템: 식사 -->
            <div class="activity-item activity-item--food" draggable="true">
                <div class="activity-item__drag">⋮⋮</div>
                <div class="activity-item__icon">🍽</div>
                <div class="activity-item__body">
                    <div class="activity-item__top">
                        <span class="activity-item__time">18:00</span>
                        <span class="activity-item__title">저녁 - 이자카야</span>
                    </div>
                    <div class="activity-item__desc">현지인들이 즐기는 이자카야에서 사케와 안주</div>
                    <div class="activity-item__meta">
                        <span class="meta-tag meta-tag--location">📍 아사쿠사</span>
                        <span class="meta-tag meta-tag--cost">$ ¥3,500</span>
                    </div>
                </div>
                <button class="activity-item__delete" title="삭제">🗑</button>
            </div>

        </div>
        <!-- /activity-list -->

    </div>
    <!-- /day-block -->

    <!-- Day 2, 3... 동일한 .day-block 구조로 반복 -->
    <%-- EL 문 / JSTL c:forEach로 반복 예정 --%>

</div>
<!-- /container -->

<script src="edit-schedule.js"></script>
</body>
</html>
