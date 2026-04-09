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