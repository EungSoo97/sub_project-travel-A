CREATE TABLE user_info (
                        u_user_id NUMBER PRIMARY KEY,
                        u_login_id VARCHAR2(50) NOT NULL UNIQUE,
                        u_password VARCHAR2(255) NOT NULL,
                        u_name VARCHAR2(50) NOT NULL,
                        u_gender CHAR(1),
                        u_birth_date DATE NOT NULL,
                        u_email VARCHAR2(100) NOT NULL UNIQUE
);

-- AUTO_INCREMENT 대체 (시퀀스 생성)
CREATE SEQUENCE user_info_seq
    START WITH 1
    INCREMENT BY 1;

-- INSERT 시 사용 예시
INSERT INTO user_info (
    u_user_id, u_login_id, u_password, u_name, u_gender, u_birth_date, u_email
) VALUES (
             user_info_seq.NEXTVAL, 'test123', 'hash값', '홍길동', 'M', DATE '1990-01-01', 'test@test.com'
         );

-- COMMENT 추가 (Oracle 방식)
COMMENT ON COLUMN user_info.u_gender IS 'M/F';

select * from user_info;

ALTER TABLE user_info ADD u_profile_img VARCHAR2(300);
UPDATE user_info
SET u_profile_img = 'img/profile/default.png'
WHERE u_profile_img IS NULL;

