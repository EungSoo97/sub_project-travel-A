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


drop table travel_plan;
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
