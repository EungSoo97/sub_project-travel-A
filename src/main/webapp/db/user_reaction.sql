CREATE TABLE review (
                        review_id NUMBER PRIMARY KEY,
                        plan_id   NUMBER NOT NULL,
                        user_id   NUMBER NOT NULL,
                        content   VARCHAR2(1000) NOT NULL,
                        created_at DATE DEFAULT SYSDATE,

                        CONSTRAINT fk_review_plan
                            FOREIGN KEY (plan_id)
                                REFERENCES travel_plan(plan_id)
                                    ON DELETE CASCADE,

                        CONSTRAINT fk_review_user
                            FOREIGN KEY (user_id)
                                REFERENCES user_info(u_user_id)
                                    ON DELETE CASCADE
);

CREATE SEQUENCE review_seq
    START WITH 1
    INCREMENT BY 1;
select *
from review;

INSERT INTO review (
    review_id, plan_id, user_id, content
) VALUES (
             review_seq.NEXTVAL, 140, 1, '이 여행 진짜 좋았어요'
         );
select *from review;

SELECT r.review_id,
       r.content,
       r.created_at,
       u.u_name
FROM review r
         JOIN user_info u
              ON r.user_id = u.u_user_id
WHERE r.plan_id = 1
ORDER BY r.created_at DESC;


CREATE SEQUENCE plan_like_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE plan_like (
                           like_id NUMBER PRIMARY KEY,
                           plan_id NUMBER NOT NULL,
                           user_id NUMBER NOT NULL,
                           created_at DATE DEFAULT SYSDATE,

                           CONSTRAINT fk_like_plan
                               FOREIGN KEY (plan_id)
                                   REFERENCES travel_plan(plan_id)
                                       ON DELETE CASCADE,

                           CONSTRAINT fk_like_user
                               FOREIGN KEY (user_id)
                                   REFERENCES user_info(u_user_id)
                                       ON DELETE CASCADE,

                           CONSTRAINT unique_like
                               UNIQUE (plan_id, user_id)
);

select * from plan_like;


SELECT tp.plan_id,
       tp.destination,
       tp.title,
       tp.start_date,
       tp.end_date,
       tp.days,
       tp.travelers,
       tp.travel_style,
       tp.total_estimated_cost,
       tp.currency,
       pl.created_at AS liked_at
FROM travel_plan tp
         JOIN plan_like pl ON tp.plan_id = pl.plan_id
WHERE pl.user_id = 1
ORDER BY pl.created_at DESC;

SELECT tp.plan_id, tp.title, tp.destination
FROM travel_plan tp
         JOIN plan_like pl ON tp.plan_id = pl.plan_id
WHERE pl.user_id = 1;  -- 본인 userId로 변경


SELECT DBTIMEZONE, SESSIONTIMEZONE FROM DUAL;
--  세션 기준으로 서울 시간 적용 (안전)
ALTER SESSION SET TIME_ZONE = 'Asia/Seoul';

--  3. DB 전체 타임존 변경 (주의 필요 )
-- ALTER DATABASE SET TIME_ZONE = 'Asia/Seoul';
CREATE SEQUENCE plan_star_seq
    START WITH 1
    INCREMENT BY 1;

CREATE TABLE plan_star (
                           star_id NUMBER PRIMARY KEY,
                           plan_id NUMBER NOT NULL,
                           user_id NUMBER NOT NULL,
                           created_at DATE DEFAULT SYSDATE,

                           CONSTRAINT fk_star_plan
                               FOREIGN KEY (plan_id)
                                   REFERENCES travel_plan(plan_id)
                                       ON DELETE CASCADE,

                           CONSTRAINT fk_star_user
                               FOREIGN KEY (user_id)
                                   REFERENCES user_info(u_user_id)
                                       ON DELETE CASCADE,

                           CONSTRAINT uk_plan_star
                               UNIQUE (plan_id, user_id)
);

select *from plan_star;

------------------테스트용
-- 받은 좋아요 수
SELECT COUNT(*) AS total_likes
FROM plan_like pl
    JOIN travel_plan tp ON pl.plan_id = tp.plan_id
WHERE tp.user_id =? ;


SELECT plan_id, user_id, destination, title, start_date, end_date,
                days, travelers, travel_style, total_estimated_cost, currency, overview,
                success, message, response_json, created_at, updated_at
                FROM travel_plan
                WHERE user_id = 1
                ORDER BY created_at DESC;


SELECT tp.plan_id, tp.user_id, tp.destination, tp.title,
    tp.start_date, tp.end_date, tp.days, tp.travelers,
                tp.travel_style, tp.total_estimated_cost, tp.currency, tp.overview
            FROM travel_plan tp
                JOIN plan_like pl ON tp.plan_id = pl.plan_id
                WHERE pl.user_id = 1
                ORDER BY pl.created_at DESC;

SELECT *
FROM travel_plan
WHERE plan_id IN (
    SELECT plan_id FROM plan_like WHERE user_id = 1
);