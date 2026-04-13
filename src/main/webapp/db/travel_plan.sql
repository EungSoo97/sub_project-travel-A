-- =============================================================================
-- Oracle: travel_plan 테이블 (FastAPI 요약 + 스타일/테마/전략 저장용 확장)
-- 실행 전 백업 권장. 기존 테이블이 있으면 §2 ALTER 만 실행.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- §1) 신규 구축용 (테이블이 없을 때만)
-- -----------------------------------------------------------------------------
CREATE TABLE travel_plan (
                             plan_id           NUMBER         PRIMARY KEY,
                             user_id           NUMBER,

    -- Summary
                             destination       VARCHAR2(100)  NOT NULL,
                             title             VARCHAR2(200),
                             start_date        DATE,
                             end_date          DATE,
                             days              NUMBER,
                             travelers         NUMBER,
    -- 단일 표시 라벨(엔진 travelStyle). 레거시 호환.
                             travel_style      VARCHAR2(200),
    -- 요청 styles[] — 콤마 구분 문자열 또는 JSON 배열 문자열
                             request_styles    VARCHAR2(4000),
    -- 요청 themes[]
                             request_themes    VARCHAR2(4000),
    -- summary.travelStrategy JSON
                             travel_strategy_json CLOB,
    -- summary.costBreakdown JSON
                             cost_breakdown_json CLOB,

                             total_estimated_cost NUMBER DEFAULT 0,
                             currency          VARCHAR2(10)   DEFAULT 'KRW',
                             overview          CLOB,

                             success           NUMBER(1)      DEFAULT 1,
                             message             VARCHAR2(500),
                             partial             NUMBER(1)      DEFAULT 0,
                             quality_score       NUMBER,

                             response_json     CLOB           NOT NULL,

                             created_at        DATE           DEFAULT SYSDATE,
                             updated_at        DATE           DEFAULT SYSDATE
);


select * from travel_plan;

-- -----------------------------------------------------------------------------
-- §2) 기존 travel_plan 이 이미 있을 때 — 아래 한 줄씩 실행 (ORA-01430 이미 존재 → 스킵)
-- -----------------------------------------------------------------------------
-- ALTER TABLE travel_plan ADD (request_styles VARCHAR2(4000));
-- ALTER TABLE travel_plan ADD (request_themes VARCHAR2(4000));
-- ALTER TABLE travel_plan ADD (travel_strategy_json CLOB);
-- ALTER TABLE travel_plan ADD (cost_breakdown_json CLOB);
-- ALTER TABLE travel_plan ADD (partial NUMBER(1) DEFAULT 0);
-- ALTER TABLE travel_plan ADD (quality_score NUMBER);
-- ALTER TABLE travel_plan MODIFY (travel_style VARCHAR2(200));

-- -----------------------------------------------------------------------------
-- §3) 샘플 (테스트용)
-- -----------------------------------------------------------------------------
-- INSERT INTO travel_plan (plan_id, destination, response_json)
-- VALUES (travel_plan_seq.NEXTVAL, 'Seoul', '{}');
-- COMMIT;

-- 전체 삭제가 필요하면 (운영에서는 사용 금지):
-- TRUNCATE TABLE travel_plan;
-- 또는
-- DELETE FROM travel_plan;

INSERT INTO travel_plan (
    plan_id,
    user_id,
    destination,
    title,
    start_date,
    end_date,
    days,
    travelers,
    travel_style,
    total_estimated_cost,
    currency,
    overview,
    response_json
) VALUES (
             travel_plan_seq.NEXTVAL,
             29,
             'Tokyo',
             '도쿄 벚꽃 여행',
             TO_DATE('2026-04-20', 'YYYY-MM-DD'),
             TO_DATE('2026-04-23', 'YYYY-MM-DD'),
             4,
             2,
             '힐링',
             1200000,
             'KRW',
             '벚꽃 명소와 카페를 중심으로 즐기는 여행',
             '{}'
         );
INSERT INTO travel_plan (
    plan_id,
    user_id,
    destination,
    title,
    start_date,
    end_date,
    days,
    travelers,
    response_json
) VALUES (
             travel_plan_seq.NEXTVAL,
             22,
             'Seoul',
             '서울 주말 여행',
             TO_DATE('2026-03-20', 'YYYY-MM-DD'),
             TO_DATE('2026-03-22', 'YYYY-MM-DD'),
             3,
             1,
             '{}'
         );
select * from travel_plan;

-- delete
-- from TRAVEL_PLAN;

UPDATE travel_plan
SET
    title = '도쿄 테스트 여행',
    destination = 'Tokyo',
    days = 3,
    travelers = 2,
    travel_style = '맛집',
    total_estimated_cost = 1200000,
    currency = 'KRW',
    overview = '테스트용 여행 일정입니다.',
    response_json = '{
      "planId": 1,
      "success": true,
      "message": "테스트 데이터",
      "summary": {
        "destination": "Tokyo",
        "title": "도쿄 테스트 여행",
        "startDate": "2026-04-20",
        "endDate": "2026-04-22",
        "days": 3,
        "travelers": 2,
        "travelStyle": "맛집",
        "totalEstimatedCost": 1200000,
        "currency": "KRW",
        "overview": "도쿄 주요 관광지와 맛집을 즐기는 3일 여행"
      },
      "itinerary": [
        {
          "day": 1,
          "date": "2026-04-20",
          "dayLabel": "1일차",
          "estimatedCost": 300000,
          "activities": [
            {
              "id": "a1",
              "time": "09:00",
              "name": "나리타 공항 도착",
              "description": "공항 도착 후 도쿄 시내로 이동",
              "type": "TRANSPORT",
              "category": "이동",
              "lat": 35.7719,
              "lng": 140.3929,
              "cost": 50000
            },
            {
              "id": "a2",
              "time": "13:00",
              "name": "아사쿠사 관광",
              "description": "센소지와 주변 상점가 구경",
              "type": "SPOT",
              "category": "관광",
              "lat": 35.7148,
              "lng": 139.7967,
              "cost": 0
            }
          ]
        },
        {
          "day": 2,
          "date": "2026-04-21",
          "dayLabel": "2일차",
          "estimatedCost": 450000,
          "activities": [
            {
              "id": "b1",
              "time": "10:00",
              "name": "시부야 스카이",
              "description": "전망대 방문",
              "type": "SPOT",
              "category": "관광",
              "lat": 35.6580,
              "lng": 139.7016,
              "cost": 25000
            },
            {
              "id": "b2",
              "time": "18:00",
              "name": "스시 디너",
              "description": "현지 스시 맛집 방문",
              "type": "DINING",
              "category": "식사",
              "lat": 35.6717,
              "lng": 139.7650,
              "cost": 120000
            }
          ]
        },
        {
          "day": 3,
          "date": "2026-04-22",
          "dayLabel": "3일차",
          "estimatedCost": 200000,
          "activities": [
            {
              "id": "c1",
              "time": "11:00",
              "name": "우에노 공원 산책",
              "description": "출국 전 마지막 일정",
              "type": "SPOT",
              "category": "관광",
              "lat": 35.7156,
              "lng": 139.7745,
              "cost": 0
            }
          ]
        }
      ],
      "flights": [
        {
          "id": "f1",
          "airline": "Korean Air",
          "tripType": "왕복",
          "price": 450000,
          "departureAirport": "ICN",
          "arrivalAirport": "NRT"
        }
      ],
      "hotels": [
        {
          "id": "h1",
          "name": "Shinjuku Hotel",
          "pricePerNight": 180000,
          "rating": 4.3,
          "address": "Shinjuku, Tokyo",
          "lat": 35.6938,
          "lng": 139.7034
        }
      ]
    }'
WHERE plan_id = 1;

select plan_id, user_id, title, destination
from travel_plan
order by plan_id desc;

select *from travel_plan;

ALTER TABLE travel_plan
    ADD CONSTRAINT fk_travel_plan_user
        FOREIGN KEY (user_id)
            REFERENCES user_info(u_user_id);

UPDATE travel_plan
SET user_id = 1
WHERE user_id IN (29, 22);

SELECT u_user_id, u_login_id, u_name
FROM user_info;

SELECT plan_id, user_id, title, destination
FROM travel_plan
ORDER BY plan_id DESC;

UPDATE travel_plan
SET user_id = 1
WHERE user_id IS NULL;

ALTER TABLE travel_plan
    MODIFY user_id NULL;


SELECT tp. *, COUNT(pl.plan_id) AS like_cnt
FROM travel_plan tp
         LEFT JOIN plan_like pl ON tp.plan_id = pl.plan_id
GROUP BY tp.plan_id, tp.user_id, tp.destination, tp.title,
         tp.start_date, tp.end_date, tp.days, tp.travelers,
         tp.travel_style, tp.total_estimated_cost, tp.currency, tp.overview;

SELECT tp.*,
       (SELECT COUNT(*)
        FROM plan_like pl
        WHERE pl.plan_id = tp.plan_id) AS like_cnt
FROM travel_plan tp
ORDER BY tp.plan_id DESC;

SELECT tp.*, NVL(pl.like_cnt, 0) AS like_cnt
FROM travel_plan tp
         LEFT JOIN (
    SELECT plan_id, COUNT(*) AS like_cnt
    FROM plan_like
    GROUP BY plan_id
) pl ON tp.plan_id = pl.plan_id;

SELECT travel_style, COUNT(*) AS cnt
FROM travel_plan
WHERE user_id = ?
  AND travel_style IS NOT NULL
GROUP BY travel_style
ORDER BY cnt DESC;
) pl ON tp.plan_id = pl.plan_id

/*탐색페이지 검색용*/
SELECT plan_id, destination, title, travel_style, request_styles, request_themes, created_at
FROM travel_plan
ORDER BY created_at DESC;
커스,