CREATE TABLE travel_plan (
                             plan_id NUMBER PRIMARY KEY,
                             user_id NUMBER,

    -- Summary 기준 요약 컬럼
                             destination VARCHAR2(100) NOT NULL,
                             title VARCHAR2(200),
                             start_date DATE,
                             end_date DATE,
                             days NUMBER,
                             travelers NUMBER,
                             travel_style VARCHAR2(50),
                             total_estimated_cost NUMBER DEFAULT 0,
                             currency VARCHAR2(10) DEFAULT 'KRW',
                             overview CLOB,

    -- 최상위 응답 상태
                             success NUMBER(1) DEFAULT 1,
                             message VARCHAR2(500),

    -- 전체 원본 JSON
                             response_json CLOB NOT NULL,

                             created_at DATE DEFAULT SYSDATE,
                             updated_at DATE DEFAULT SYSDATE
);

-- AUTO_INCREMENT 대체 (시퀀스)
CREATE SEQUENCE travel_plan_seq
    START WITH 1
    INCREMENT BY 1;

INSERT INTO travel_plan (
    plan_id, destination, response_json
) VALUES (
             travel_plan_seq.NEXTVAL, 'Seoul', '{}'
         );

select * from travel_plan;

SELECT plan_id FROM travel_plan;
