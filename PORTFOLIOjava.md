# Travel-A(AI) — AI 기반 여행 플래너 웹 애플리케이션

> AI가 생성하는 맞춤형 여행 일정 계획 서비스  
> Team Project | Java 17 · Oracle DB · FastAPI · Google Maps · OpenWeather · Cloudinary

---

## 목차

1. [프로젝트 개요](#1-프로젝트-개요)
2. [기술 스택](#2-기술-스택)
3. [아키텍처](#3-아키텍처)
4. [주요 기능](#4-주요-기능)
5. [페이지 구성 및 라우팅](#5-페이지-구성-및-라우팅)
6. [데이터베이스 설계](#6-데이터베이스-설계)
7. [외부 API 연동](#7-외부-api-연동)
8. [프론트엔드](#8-프론트엔드)
9. [프로젝트 구조](#9-프로젝트-구조)
10. [주요 의존성](#10-주요-의존성)

---

## 1. 프로젝트 개요

**Travel-A(AI)**는 사용자의 여행 스타일, 테마, 예산, 여행 기간 등을 입력받아 AI가 자동으로 여행 일정을 생성해주는 풀스택 웹 애플리케이션입니다.

생성된 일정에는 항공편, 숙박, 하루하루 상세 일정, 예상 비용 내역이 포함되며, 커뮤니티에 공유하거나 실시간 여행 트래킹 모드로 활용할 수 있습니다.

### 핵심 가치

- **AI 자동화**: FastAPI 기반 ML 서버와 연동하여 완성도 높은 일정 자동 생성
- **커뮤니티**: 다른 사용자의 여행 플랜을 탐색·저장·리뷰
- **라이브 트래킹**: 실시간 날씨 연동 및 현재 여행 일정 추적
- **PDF 내보내기**: 여행 플랜을 PDF로 저장

---

## 2. 기술 스택

| 구분 | 기술 |
|------|------|
| **Language** | Java 17 |
| **Backend Framework** | Jakarta EE Servlets (Apache Tomcat) |
| **Build Tool** | Gradle 8.8 |
| **Database** | Oracle Autonomous Database (Cloud, Wallet 인증) |
| **Connection Pool** | Apache Commons DBCP2 (min:1 / max:20) |
| **ORM / Data Access** | JDBC + DAO 패턴 |
| **JSON** | Jackson (주), Gson (보조) |
| **View** | JSP + JSTL |
| **Frontend** | Vanilla JavaScript, HTML5, CSS3 |
| **Image Hosting** | Cloudinary CDN |
| **PDF Generation** | Flying Saucer (HTML → PDF) |
| **Testing** | JUnit 5 |
| **AI Backend** | FastAPI (Python, 별도 서버) |

---

## 3. 아키텍처

```
[브라우저 / JSP]
       │ HTTP Request
       ▼
[Servlet Controller]  ←→  [Session / Cookie]
       │
       ├── [DAO]  ←→  [Oracle DB (Cloud)]
       │
       ├── [FastApiService]  ──▶  FastAPI 서버 (AI 플래닝)
       │
       ├── [WeatherService]  ──▶  OpenWeather API
       │
       ├── [GooglePlaceImageService]  ──▶  Google Maps API
       │
       └── [CloudinaryUtil]  ──▶  Cloudinary (이미지 CDN)
```

### 설계 패턴

- **MVC** — Servlet(Controller) + JSP(View) + DAO/DTO(Model)
- **DAO 패턴** — 데이터 접근 로직 캡슐화, 비즈니스 로직과 분리
- **DTO 패턴** — 계층 간 데이터 전달 객체 명확히 분리
- **Singleton** — `DBManager_new`, `CloudinaryUtil` 공유 자원 단일 관리

---

## 4. 주요 기능

### 4-1. AI 여행 플래닝

- 목적지, 여행 기간, 예산, 인원, 여행 스타일·테마·커스텀 태그 입력
- FastAPI 서버(POST `/api/v1/travel/plan`)에 요청, 최대 300초 대기
- 응답: 전체 일정, 항공편, 호텔 옵션, 비용 내역, 품질 점수(quality_score)
- 인벤토리 상태: `COMPLETE / PARTIAL / MIXED`
- 패키징 모드: `FULL_PACKAGE / GUIDED_PACKAGE`

### 4-2. 여행 플랜 관리

| 기능 | 설명 |
|------|------|
| 플랜 생성 | AI 엔진으로 자동 생성 |
| 플랜 편집 | 일정 수정 (`scheduleEdit.js`) |
| 커뮤니티 공개 | `posted` 플래그로 공개/비공개 전환 |
| 즐겨찾기 | `plan_star` 테이블 관리 |
| 좋아요 | `plan_like` 테이블, 중복 방지 UNIQUE 제약 |
| 리뷰 | `review` 테이블, 플랜별 작성 |
| PDF 저장 | Flying Saucer로 HTML → PDF 변환 |

### 4-3. 커뮤니티 (Explore)

- 공개된 여행 플랜 탐색 (페이지당 9개)
- 여행 스타일·테마·커스텀 태그 필터링
- 최신순 / 인기순 정렬
- 목적지 자동완성 검색 (`SearchAutocompleteC`)
- Google Place 이미지 썸네일 연동

### 4-4. 라이브 트래킹

- 저장된 플랜 중 하나를 선택해 트래킹 활성화
- OpenWeather API로 목적지 실시간 날씨 조회
- 하루하루 일정 타임라인 표시
- 모바일 최적화 인터페이스 별도 구현
- 사용자당 최대 1개 활성 트래킹 (DB UNIQUE INDEX 보장)
- 헤더에 빨간 점(pulse 애니메이션)으로 트래킹 중 상태 표시
- 트래킹 상태를 `localStorage`로 클라이언트 측도 유지

### 4-5. 마이페이지 (MyPage)

- 내 플랜 목록 + 상태 배지 (작성 중 / 예정됨 / 여행 중 / 완료)
- 좋아요한 플랜 목록
- 작성한 리뷰 히스토리
- 여행 통계 (월별 현황, 스타일 선호도, 인기 목적지)
- 받은 좋아요 수 집계

### 4-6. 인증 (Authentication)

- 세션 기반 로그인/로그아웃
- 회원가입: 이메일, 성별, 생년월일
- 아이디 중복 확인 (AJAX)
- 보호 엔드포인트: 세션 없으면 로그인 페이지로 리다이렉트
- 로그아웃 시 세션 무효화 + `localStorage` 트래킹 상태 초기화

---

## 5. 페이지 구성 및 라우팅

| URL | Controller | 설명 |
|-----|-----------|------|
| `/` | — | 랜딩 페이지, 여행 플랜 생성 폼 |
| `/account` | `AccountC` | 회원가입 |
| `/login` | `LoginC` | 로그인 |
| `/logout` | `LogoutC` | 로그아웃 |
| `/planner/result` | `TravelPlanServlet` | AI 생성 플랜 결과 |
| `/explore` | `ExploreC` | 공개 플랜 탐색 |
| `/live` | `LiveC` | 라이브 트래킹 진입 |
| `/live-select` | `LiveSelectC` | 트래킹할 플랜 선택 |
| `/my-live` | `MyLiveC` | 활성 트래킹 대시보드 |
| `/mypage` | `MypageC` | 사용자 대시보드 |
| `/detailpage` | — | 플랜 상세 |
| `/settings` | `SettingsDAO` | 프로필/계정 설정 |
| `/pdf` | `MakePdfC` | PDF 생성 API |
| `/upload` | `ImageC` | 이미지 업로드 API |
| `/api/search-autocomplete` | `SearchAutocompleteC` | 목적지 자동완성 (JSON) |
| `/api/live-search-suggest` | `LiveSearchSuggestC` | 위치 검색 제안 (JSON) |
| `/api/weather` | `WeatherService` | 날씨 데이터 (JSON) |

---

## 6. 데이터베이스 설계

Oracle Autonomous Database (Cloud) / JDBC + Commons DBCP2

### ERD 개요

```
user_info
  │
  ├──< travel_plan (user_id FK)
  │         │
  │         ├──< plan_like   (plan_id FK, user_id FK)
  │         ├──< plan_star   (plan_id FK, user_id FK)
  │         └──< review      (plan_id FK, user_id FK)
  │
  └── [profile_img, login_id, email, ...]
```

### 주요 테이블

**`user_info`**
```sql
u_user_id     NUMBER PK (SEQUENCE)
u_login_id    VARCHAR2 UNIQUE
u_password    VARCHAR2
u_name        VARCHAR2
u_gender      CHAR(1)   -- M/F
u_birth_date  DATE
u_email       VARCHAR2 UNIQUE
u_profile_img VARCHAR2  DEFAULT 'img/profile/default.png'
```

**`travel_plan`**
```sql
plan_id               NUMBER PK (SEQUENCE)
user_id               NUMBER FK
destination           VARCHAR2
title                 VARCHAR2
start_date, end_date  DATE
days                  NUMBER
travelers             NUMBER
travel_style          VARCHAR2        -- 단일 표시 레이블
request_styles        CLOB (JSON)     -- 사용자 입력 스타일 배열
request_themes        CLOB (JSON)     -- 테마 배열
travel_strategy_json  CLOB (JSON)     -- AI 해석 전략
cost_breakdown_json   CLOB (JSON)     -- 비용 내역
total_estimated_cost  NUMBER
currency              VARCHAR2
overview              CLOB
quality_score         NUMBER
posted                NUMBER(1)       -- 공개 여부
live_tracking         NUMBER(1)       -- 트래킹 활성 여부
response_json         CLOB            -- FastAPI 전체 응답 원본
thumbnail_url         VARCHAR2
created_at, updated_at TIMESTAMP
```

**`review` / `plan_like` / `plan_star`**
```sql
-- 공통 구조
[entity_id]  NUMBER PK (SEQUENCE)
plan_id      NUMBER FK ON DELETE CASCADE
user_id      NUMBER FK ON DELETE CASCADE
created_at   DATE DEFAULT SYSDATE
-- plan_like, plan_star: UNIQUE(plan_id, user_id) 중복 방지
```

### 주요 DB 전략

- Oracle SEQUENCE로 AUTO_INCREMENT 구현
- 복잡한 중첩 데이터는 CLOB에 JSON 저장 (response_json, cost_breakdown_json 등)
- `live_tracking = 1` 조건 UNIQUE 부분 인덱스로 사용자당 1개 활성 트래킹 보장
- CASCADE DELETE로 참조 무결성 유지

---

## 7. 외부 API 연동

### FastAPI (AI 플래닝 엔진)

```
POST http://[AI_SERVER]:8000/api/v1/travel/plan
Content-Type: application/json

{
  "destination": "도쿄",
  "start_date": "2025-08-01",
  "end_date": "2025-08-05",
  "budget": 2000000,
  "travelers": 2,
  "styles": ["힐링", "문화탐방"],
  "themes": ["맛집", "쇼핑"],
  "custom_tags": [...]
}
```

- Connection timeout: 5초 / Read timeout: 300초
- 요청/응답 디버그 JSON을 `java.io.tmpdir/travelA-debug-json/`에 저장
- `FastApiService.java`가 단일 책임으로 HTTP 통신 담당

### Google Maps API

- **Autocomplete**: 목적지 검색 자동완성
- **Place Images**: `GooglePlaceImageService`로 플랜 썸네일 생성
- Key: `application.properties` 관리

### OpenWeather API

- **Endpoint**: `https://api.openweathermap.org/data/2.5/weather`
- 도시명 매핑 처리 (한국어 → 영어, 예: 도쿄 → Tokyo)
- `WeatherService.java`가 온도, 습도, 풍속, 날씨 아이콘 반환
- 응답 언어: 한국어(`lang=kr`)

### Cloudinary

- 이미지 업로드 후 CDN URL 반환
- `CloudinaryUtil` 싱글턴으로 관리
- 사용자 프로필 이미지 및 플랜 썸네일

---

## 8. 프론트엔드

### 구조

- **View Layer**: JSP + JSTL (서버사이드 렌더링)
- **공통 레이아웃**: `index.jsp` — 헤더, 네비게이션, 푸터, 전역 스낵바
- **JavaScript**: 모듈별 분리 (의존성 없는 Vanilla JS)
- **CSS**: 모바일 퍼스트 반응형, CSS 변수 사용

### JavaScript 주요 모듈

| 파일 | 역할 |
|------|------|
| `main.js` | 네비게이션, 헤더 스크롤, 트래킹 상태 표시 |
| `livePage.js` | 트래킹 타임라인, 위치 업데이트 |
| `live-modal.js` | 트래킹 상세 모달 |
| `live-itinerary-mobile.js` | 모바일 최적화 일정 뷰 |
| `scheduleEdit.js` | 일정 편집 (드래그 앤 드롭) |
| `mypageBridge.js` | 마이페이지 탭 상태 관리 |
| `cardModal.js` | 플랜 카드 인터랙션 |
| `account.js` | 회원가입 폼 유효성 검사 |
| `idcheck.js` | 아이디 중복 확인 AJAX |
| `reiviewModal.js` | 리뷰 모달 |

### CSS 전략

- CSS Grid로 전체 레이아웃, Flexbox로 컴포넌트 구성
- CSS Custom Properties (변수)로 색상/간격 일관성 유지
- 애니메이션: pulse(트래킹 표시), fade(모달 등)
- 14개+ CSS 파일 (페이지별 분리)

---

## 9. 프로젝트 구조

```
travelA/
├── src/main/java/com/es/ta/
│   ├── account/          # 회원가입, 아이디 중복 확인, 약관
│   ├── ai/               # AI 플래닝 핵심 (FastApiService, DTO, 저장)
│   ├── common/           # 공통 유틸 (GoogleMapsConfig)
│   ├── community/        # 커뮤니티 허브
│   ├── explore/          # 공개 플랜 탐색, PDF 생성, 이미지 서비스
│   ├── image/            # 이미지 업로드 (Cloudinary)
│   ├── live/             # 라이브 트래킹 (날씨, 타임라인, 검색)
│   ├── login/            # 로그인/로그아웃
│   ├── main/             # DBManager, 헬로서블릿
│   ├── mypage/           # 사용자 대시보드, 통계, 설정
│   ├── resultpage/       # 플랜 결과 표시, JSON 파싱
│   └── userreaction/     # 좋아요, 리뷰, 반응
│
├── src/main/webapp/
│   ├── view/             # JSP 파일 (20개)
│   ├── js/               # JavaScript 모듈
│   ├── css/              # 스타일시트 (14개+)
│   ├── db/               # DDL SQL 스크립트
│   ├── img/              # 정적 이미지
│   └── WEB-INF/
│       └── application.properties  # API 키, DB 설정
│
├── build.gradle
├── settings.gradle
└── PORTFOLIO.md          # 이 파일
```

**규모**: Java 클래스 73개 · JSP 20개 · CSS 14개+ · DB 테이블 5개+

---

## 10. 주요 의존성

```gradle
// Backend
javax.servlet:javax.servlet-api:4.0.1
org.apache.commons:commons-dbcp2:2.10.0
com.oracle.database.jdbc:ojdbc8:21.11.0.0
org.projectlombok:lombok:1.18.32
javax.servlet:jstl:1.2

// JSON
com.fasterxml.jackson.core:jackson-databind:2.17.0
com.google.code.gson:gson:2.10.1

// PDF
com.github.librepdf:openpdf:1.3.30
org.xhtmlrenderer:flying-saucer-core:9.1.22
org.xhtmlrenderer:flying-saucer-pdf:9.1.22

// Image
com.cloudinary:cloudinary-http44:1.39.0

// File Upload
com.servlets:cos:09May2002

// Test
org.junit.jupiter:junit-jupiter-api:5.10.2
```

---

## 팀 정보

| 항목 | 내용 |
|------|------|
| **프로젝트명** | Travel-A(AI) |
| **저장소** | [EungSoo97/sub_project-travel-A](https://github.com/EungSoo97/sub_project-travel-A) |
| **현재 브랜치** | yuni |
| **개발 기간** | 팀 프로젝트 |
| **역할** | 풀스택 (백엔드 Servlet/DAO, 프론트엔드 JSP/JS, Live 트래킹 기능 등) |
