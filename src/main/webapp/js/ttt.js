{
    "success"
:
    true, "message"
:
    "Reference inventory was used to generate a guided itinerary.", "summary"
:
    {
        "destination"
    :
        "도쿄", "title"
    :
        "도쿄 guided reference itinerary", "startDate"
    :
        "2026-04-21", "endDate"
    :
        "2026-04-23", "days"
    :
        3, "travelers"
    :
        1, "travelStyle"
    :
        "쇼핑", "requestStyles"
    :
        ["쇼핑"], "requestThemes"
    :
        ["모험"], "travelStrategy"
    :
        {
            "primarySubject"
        :
            "shopping", "mood"
        :
            "adventure", "customTags"
        :
            [], "coreCategories"
        :
            ["SHOP", "MALL", "MARKET"], "secondaryCategories"
        :
            ["CAFE", "VIEWPOINT"], "subjectBias"
        :
            {
                "shopping"
            :
                "HIGH", "dining"
            :
                "MEDIUM", "culture"
            :
                "LOW"
            }
        ,
            "areaPreference"
        :
            "LOCAL_BACKSTREET", "tempo"
        :
            "FAST", "nightFocus"
        :
            "MEDIUM", "walkBias"
        :
            "HIGH", "shoppingBias"
        :
            "HIGH", "diningBias"
        :
            "MEDIUM", "cultureBias"
        :
            "LOW", "natureBias"
        :
            "MEDIUM", "poiQueryBoosters"
        :
            [], "budgetPerTravelerMinKrw"
        :
            0, "budgetPerTravelerMaxKrw"
        :
            5000000, "totalBudgetMinKrw"
        :
            0, "totalBudgetMaxKrw"
        :
            5000000, "travelers"
        :
            1
        }
    ,
        "totalEstimatedCost"
    :
        1290000, "currency"
    :
        "KRW", "overview"
    :
        "A guided itinerary was generated using reference flight or hotel inventory.", "costBreakdown"
    :
        {
            "activities"
        :
            350000, "flights"
        :
            700000, "hotels"
        :
            240000, "nights"
        :
            2, "total"
        :
            1290000
        }
    }
,
    "itinerary"
:
    [{
        "day": 1,
        "date": "2026-04-21",
        "dayLabel": "Day 1",
        "transportation": "대중교통",
        "totalDistanceKm": 35.71,
        "totalTravelTimeMinutes": 70,
        "estimatedCost": 125000,
        "currency": "KRW",
        "summary": "도착 후 도심 상권과 전망 포인트 적응 (shopping/adventure)",
        "metricSource": "google_directions",
        "metricIsEstimated": false,
        "routePoints": [{
            "order": 1,
            "name": "Haneda Airport",
            "type": "point",
            "lat": 35.5494,
            "lng": 139.7798,
            "day": 1
        }, {
            "order": 2,
            "name": "도쿄 Reference Stay",
            "type": "point",
            "lat": 35.6764225,
            "lng": 139.650027,
            "day": 1
        }, {
            "order": 3,
            "name": "Keio Department Store Shinjuku",
            "type": "point",
            "lat": 35.6901289,
            "lng": 139.6991869,
            "day": 1
        }, {
            "order": 4,
            "name": "NachuRa Gluten Free Cafe",
            "type": "point",
            "lat": 35.66637720000001,
            "lng": 139.6919251,
            "day": 1
        }, {"order": 5, "name": "Shibuya Sky", "type": "point", "lat": 35.6586719, "lng": 139.7019848, "day": 1}],
        "activities": [{
            "id": "ACT-dabdc4",
            "time": "10:00",
            "endTime": "11:30",
            "durationMinutes": 90,
            "category": "transport",
            "categoryCode": "TRANSPORT",
            "type": "이동",
            "activityType": "MOVE",
            "entityType": "TRANSPORT",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "Haneda Airport",
            "description": "Airport arrival and transfer into the city.",
            "location": "Haneda Airport",
            "address": "Hanedakuko, Ota City, Tokyo 144-0041, Japan",
            "lat": 35.5494,
            "lng": 139.7798,
            "cost": 5000,
            "currency": "KRW",
            "rating": 4.3,
            "googlePlaceId": "ChIJ45IxpAtkGGAR3_hG0anDMg0",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJ45IxpAtkGGAR3_hG0anDMg0",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 80,
            "transport": null
        }, {
            "id": "ACT-c6adb8",
            "time": "11:50",
            "endTime": "13:20",
            "durationMinutes": 90,
            "category": "accommodation",
            "categoryCode": "ACCOMMODATION",
            "type": "Accommodation",
            "activityType": "STAY",
            "entityType": "HOTEL",
            "slotType": "PLACE_BASED",
            "qualityTier": "LOW",
            "name": "도쿄 Reference Stay",
            "description": "Hotel and luggage drop before exploring nearby areas",
            "location": "도쿄 transit-access area",
            "address": "도쿄 transit-access area",
            "lat": 35.6764225,
            "lng": 139.650027,
            "cost": 10000,
            "currency": "KRW",
            "rating": null,
            "googlePlaceId": null,
            "googleMapsUrl": null,
            "popularityTag": null,
            "enrichmentStatus": "PENDING",
            "qualityScore": 30,
            "transport": null
        }, {
            "id": "ACT-e9c4b8",
            "time": "13:40",
            "endTime": "14:40",
            "durationMinutes": 60,
            "category": "shopping",
            "categoryCode": "SHOPPING",
            "type": "쇼핑",
            "activityType": "SHOP",
            "entityType": "STORE",
            "slotType": "PLACE_BASED",
            "qualityTier": "MEDIUM",
            "name": "Keio Department Store Shinjuku",
            "description": "도착 후 무리 없이 둘러보기 좋은 대표 상권입니다.",
            "location": "Keio Department Store Shinjuku",
            "address": "1-chōme-1-4 Nishishinjuku, Shinjuku City, Tokyo 160-8321, Japan",
            "lat": 35.6901289,
            "lng": 139.6991869,
            "cost": 50000,
            "currency": "KRW",
            "rating": 3.8,
            "googlePlaceId": "ChIJ_zhzEkONGGARch8hW-wHRzg",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJ_zhzEkONGGARch8hW-wHRzg",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 70,
            "transport": null
        }, {
            "id": "ACT-bcc5b5",
            "time": "15:00",
            "endTime": "16:00",
            "durationMinutes": 60,
            "category": "dining",
            "categoryCode": "DINING",
            "type": "Dining",
            "activityType": "EAT",
            "entityType": "RESTAURANT",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "NachuRa Gluten Free Cafe",
            "description": "쇼핑 중간에 쉬어가기 좋은 감성 카페 코스입니다.",
            "location": "NachuRa Gluten Free Cafe",
            "address": "Japan, 〒151-0063 Tokyo, Shibuya, Tomigaya, 1-chōme−17−７ 第二山栄ビル １階",
            "lat": 35.66637720000001,
            "lng": 139.6919251,
            "cost": 50000,
            "currency": "KRW",
            "rating": 4.8,
            "googlePlaceId": "ChIJh2ai81GNGGARQyX2os2OAow",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJh2ai81GNGGARQyX2os2OAow",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 85,
            "transport": null
        }, {
            "id": "ACT-8261ab",
            "time": "16:20",
            "endTime": "17:50",
            "durationMinutes": 90,
            "category": "attraction",
            "categoryCode": "ATTRACTION",
            "type": "관광",
            "activityType": "VISIT",
            "entityType": "ATTRACTION",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "Shibuya Sky",
            "description": "첫날 저녁 분위기를 살리기 좋은 도심 전망 코스입니다.",
            "location": "Shibuya Sky",
            "address": "Japan, 〒150-6145 Tokyo, Shibuya, 2-chōme−24−１２ スクランブルスクエア 14階・45階 46階・屋上",
            "lat": 35.6586719,
            "lng": 139.7019848,
            "cost": 10000,
            "currency": "KRW",
            "rating": 4.6,
            "googlePlaceId": "ChIJ4Rr2JWiLGGARcyRSHuZ-9G8",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJ4Rr2JWiLGGARcyRSHuZ-9G8",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 85,
            "transport": null
        }]
    }, {
        "day": 2,
        "date": "2026-04-22",
        "dayLabel": "Day 2",
        "transportation": "대중교통",
        "totalDistanceKm": 13.87,
        "totalTravelTimeMinutes": 43,
        "estimatedCost": 130000,
        "currency": "KRW",
        "summary": "대표 명소와 쇼핑 중심 일정 (shopping/adventure)",
        "metricSource": "google_directions",
        "metricIsEstimated": false,
        "routePoints": [{
            "order": 1,
            "name": "The National Art Center, Tokyo",
            "type": "point",
            "lat": 35.665289,
            "lng": 139.726374,
            "day": 2
        }, {
            "order": 2,
            "name": "Kakureya",
            "type": "point",
            "lat": 35.6900817,
            "lng": 139.6865707,
            "day": 2
        }, {
            "order": 3,
            "name": "Omotesando Hills",
            "type": "point",
            "lat": 35.6672869,
            "lng": 139.7086162,
            "day": 2
        }, {"order": 4, "name": "35 steps bistro", "type": "point", "lat": 35.6597737, "lng": 139.6953947, "day": 2}],
        "activities": [{
            "id": "ACT-5256b5",
            "time": "09:30",
            "endTime": "11:00",
            "durationMinutes": 90,
            "category": "attraction",
            "categoryCode": "ATTRACTION",
            "type": "관광",
            "activityType": "VISIT",
            "entityType": "ATTRACTION",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "The National Art Center, Tokyo",
            "description": "오전에는 대표 명소를 먼저 소화합니다.",
            "location": "The National Art Center, Tokyo",
            "address": "7-chōme-22-2 Roppongi, Minato City, Tokyo 106-8558, Japan",
            "lat": 35.665289,
            "lng": 139.726374,
            "cost": 10000,
            "currency": "KRW",
            "rating": 4.4,
            "googlePlaceId": "ChIJP-vO9nuLGGARGJ2q8uryJUA",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJP-vO9nuLGGARGJ2q8uryJUA",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 80,
            "transport": null
        }, {
            "id": "ACT-210f65",
            "time": "11:20",
            "endTime": "12:35",
            "durationMinutes": 75,
            "category": "shopping",
            "categoryCode": "SHOPPING",
            "type": "쇼핑",
            "activityType": "SHOP",
            "entityType": "STORE",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "Kakureya",
            "description": "쇼핑 전 동선이 편한 점심 장소입니다.",
            "location": "Kakureya",
            "address": "Japan, 〒160-0023 Tokyo, Shinjuku City, Nishishinjuku, 4-chōme−12−１３ グランドステータス古谷 1F",
            "lat": 35.6900817,
            "lng": 139.6865707,
            "cost": 50000,
            "currency": "KRW",
            "rating": 4.5,
            "googlePlaceId": "ChIJhQvxGirzGGARpdYyuW4iOp8",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJhQvxGirzGGARpdYyuW4iOp8",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 85,
            "transport": null
        }, {
            "id": "ACT-04b955",
            "time": "12:55",
            "endTime": "13:55",
            "durationMinutes": 60,
            "category": "shopping",
            "categoryCode": "SHOPPING",
            "type": "쇼핑",
            "activityType": "SHOP",
            "entityType": "STORE",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "Omotesando Hills",
            "description": "오후 메인 일정은 쇼핑 중심입니다.",
            "location": "Omotesando Hills",
            "address": "4-chōme-12-10 Jingūmae, Shibuya, Tokyo 150-0001, Japan",
            "lat": 35.6672869,
            "lng": 139.7086162,
            "cost": 50000,
            "currency": "KRW",
            "rating": 4.0,
            "googlePlaceId": "ChIJCx6jgqGMGGARpfB5UIap15k",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJCx6jgqGMGGARpfB5UIap15k",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 80,
            "transport": null
        }, {
            "id": "ACT-807331",
            "time": "14:15",
            "endTime": "15:30",
            "durationMinutes": 75,
            "category": "dining",
            "categoryCode": "DINING",
            "type": "식사",
            "activityType": "EAT",
            "entityType": "RESTAURANT",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "35 steps bistro",
            "description": "사람이 덜 몰리는 비스트로에서 쉬는 일정입니다.",
            "location": "35 steps bistro",
            "address": "Japan, 〒150-0044 Tokyo, Shibuya, Maruyamachō, 1−１ 渋谷シティーホテル B1",
            "lat": 35.6597737,
            "lng": 139.6953947,
            "cost": 20000,
            "currency": "KRW",
            "rating": 4.2,
            "googlePlaceId": "ChIJUZdiMqqMGGARQZ-9YivAyHw",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJUZdiMqqMGGARQZ-9YivAyHw",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 80,
            "transport": null
        }]
    }, {
        "day": 3,
        "date": "2026-04-23",
        "dayLabel": "Day 3",
        "transportation": "대중교통",
        "totalDistanceKm": 33.81,
        "totalTravelTimeMinutes": 63,
        "estimatedCost": 95000,
        "currency": "KRW",
        "summary": "출국 전 가벼운 쇼핑과 식사 (shopping/adventure)",
        "metricSource": "google_directions",
        "metricIsEstimated": false,
        "routePoints": [{
            "order": 1,
            "name": "도쿄 Reference Stay",
            "type": "point",
            "lat": 35.6764225,
            "lng": 139.650027,
            "day": 3
        }, {
            "order": 2,
            "name": "Tokyo Metropolitan Government Building South Observatory",
            "type": "point",
            "lat": 35.6893249,
            "lng": 139.6918129,
            "day": 3
        }, {
            "order": 3,
            "name": "Musashino Mori Diner Shinjuku Central Park",
            "type": "point",
            "lat": 35.6910689,
            "lng": 139.6901922,
            "day": 3
        }, {
            "order": 4,
            "name": "THE SHIBUYA SOUVENIR STORE",
            "type": "point",
            "lat": 35.6609665,
            "lng": 139.7015891,
            "day": 3
        }, {"order": 5, "name": "Haneda Airport", "type": "point", "lat": 35.5494, "lng": 139.7798, "day": 3}],
        "activities": [{
            "id": "ACT-835d79",
            "time": "09:30",
            "endTime": "10:30",
            "durationMinutes": 60,
            "category": "attraction",
            "categoryCode": "ATTRACTION",
            "type": "관광",
            "activityType": "VISIT",
            "entityType": "ATTRACTION",
            "slotType": "PLACE_BASED",
            "qualityTier": "LOW",
            "name": "도쿄 Reference Stay",
            "description": "Check-out and final packing before heading out.",
            "location": "도쿄 transit-access area",
            "address": "도쿄 transit-access area",
            "lat": 35.6764225,
            "lng": 139.650027,
            "cost": 10000,
            "currency": "KRW",
            "rating": null,
            "googlePlaceId": null,
            "googleMapsUrl": null,
            "popularityTag": null,
            "enrichmentStatus": "LOW_REFERENCE_QUALITY",
            "qualityScore": 30,
            "transport": null
        }, {
            "id": "ACT-9c9aa0",
            "time": "10:50",
            "endTime": "12:05",
            "durationMinutes": 75,
            "category": "attraction",
            "categoryCode": "ATTRACTION",
            "type": "관광",
            "activityType": "VISIT",
            "entityType": "ATTRACTION",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "Tokyo Metropolitan Government Building South Observatory",
            "description": "출국 전 가볍게 들르기 좋은 전망 포인트입니다.",
            "location": "Tokyo Metropolitan Government Building South Observatory",
            "address": "Japan, 〒160-8001 Tokyo, Shinjuku City, Nishishinjuku, 2-chōme−8−１ Tochomae Station, 45階",
            "lat": 35.6893249,
            "lng": 139.6918129,
            "cost": 10000,
            "currency": "KRW",
            "rating": 4.7,
            "googlePlaceId": "ChIJ_UlItvCNGGARP1NMx2sFsYg",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJ_UlItvCNGGARP1NMx2sFsYg",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 85,
            "transport": null
        }, {
            "id": "ACT-e22e47",
            "time": "12:25",
            "endTime": "13:25",
            "durationMinutes": 60,
            "category": "dining",
            "categoryCode": "DINING",
            "type": "식사",
            "activityType": "EAT",
            "entityType": "RESTAURANT",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "Musashino Mori Diner Shinjuku Central Park",
            "description": "공항 이동 전 간단한 식사 일정입니다.",
            "location": "Musashino Mori Diner Shinjuku Central Park",
            "address": "Japan, 〒160-0023 Tokyo, Shinjuku City, Nishishinjuku, 2-chōme−11−５ 新宿中央公園内 SHUKNOVA 2階",
            "lat": 35.6910689,
            "lng": 139.6901922,
            "cost": 20000,
            "currency": "KRW",
            "rating": 4.3,
            "googlePlaceId": "ChIJ0zbr5v7zGGAR-PzrYw6YsK4",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJ0zbr5v7zGGAR-PzrYw6YsK4",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 80,
            "transport": null
        }, {
            "id": "ACT-9235d5",
            "time": "13:45",
            "endTime": "14:30",
            "durationMinutes": 45,
            "category": "shopping",
            "categoryCode": "SHOPPING",
            "type": "쇼핑",
            "activityType": "SHOP",
            "entityType": "STORE",
            "slotType": "PLACE_BASED",
            "qualityTier": "MEDIUM",
            "name": "THE SHIBUYA SOUVENIR STORE",
            "description": "마지막 기념품 구매 시간입니다.",
            "location": "THE SHIBUYA SOUVENIR STORE",
            "address": "Japan, 〒150-0001 Tokyo, Shibuya, Jingūmae, 6-chōme−20−１０ 2階 MIYASHITA PARK South",
            "lat": 35.6609665,
            "lng": 139.7015891,
            "cost": 50000,
            "currency": "KRW",
            "rating": 3.8,
            "googlePlaceId": "ChIJa6sBpd-NGGARALHUsN4SOOs",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJa6sBpd-NGGARALHUsN4SOOs",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 70,
            "transport": null
        }, {
            "id": "ACT-ce9948",
            "time": "14:50",
            "endTime": "16:20",
            "durationMinutes": 90,
            "category": "transport",
            "categoryCode": "TRANSPORT",
            "type": "이동",
            "activityType": "MOVE",
            "entityType": "TRANSPORT",
            "slotType": "PLACE_BASED",
            "qualityTier": "HIGH",
            "name": "Haneda Airport",
            "description": "Airport transfer and departure preparation.",
            "location": "Haneda Airport",
            "address": "Hanedakuko, Ota City, Tokyo 144-0041, Japan",
            "lat": 35.5494,
            "lng": 139.7798,
            "cost": 5000,
            "currency": "KRW",
            "rating": 4.3,
            "googlePlaceId": "ChIJ45IxpAtkGGAR3_hG0anDMg0",
            "googleMapsUrl": "https://www.google.com/maps/place/?q=place_id:ChIJ45IxpAtkGGAR3_hG0anDMg0",
            "popularityTag": null,
            "enrichmentStatus": "FOUND",
            "qualityScore": 80,
            "transport": null
        }]
    }], "flights"
:
    [{
        "id": "REF-ICN-HND-OUT",
        "sourceType": "REFERENCE",
        "status": "REFERENCE",
        "airline": "Reference Fare Guide",
        "flightNumber": null,
        "tripType": "도착편",
        "price": 250000,
        "currency": "KRW",
        "pricePerPerson": true,
        "departureAirport": "Incheon International Airport",
        "departureAirportCode": "ICN",
        "arrivalAirport": "Haneda Airport",
        "arrivalAirportCode": "HND",
        "departureTime": "09:00",
        "arrivalTime": "11:00",
        "stops": 0,
        "bookingUrl": null
    }, {
        "id": "REF-HND-ICN-RET",
        "sourceType": "REFERENCE",
        "status": "REFERENCE",
        "airline": "Reference Fare Guide",
        "flightNumber": null,
        "tripType": "귀국편",
        "price": 450000,
        "currency": "KRW",
        "pricePerPerson": true,
        "departureAirport": "Haneda Airport",
        "departureAirportCode": "HND",
        "arrivalAirport": "Incheon International Airport",
        "arrivalAirportCode": "ICN",
        "departureTime": "09:00",
        "arrivalTime": "11:00",
        "stops": 0,
        "bookingUrl": null
    }], "hotels"
:
    [{
        "id": "REF-HTL-도쿄-1",
        "name": "도쿄 Reference Stay",
        "sourceType": "REFERENCE",
        "status": "REFERENCE",
        "pricePerNight": 120000,
        "currency": "KRW",
        "rating": 4.0,
        "reviewCount": null,
        "location": "도쿄 transit-access area",
        "address": "도쿄 transit-access area",
        "lat": 35.6764225,
        "lng": 139.650027,
        "hotelClass": null,
        "imageUrl": null,
        "bookingUrl": null
    }], "errorCode"
:
    null, "retryable"
:
    null, "partial"
:
    true, "processingLog"
:
    ["budget:rule=per_traveler_min_max_to_total_krw:travelers=1:per_max=5000000:total_max_krw=5000000:per_min=0:total_min_krw=0", "perf:geocode_ms=670", "perf:airport_anchor_ms=0", "perf:region_strategy_ms=0", "perf:arrival_flights_ms=10012", "flight_lookup:arrival_count=0:dest=HND", "parallel_context_fetch:cancelled_due_to_missing_arrival_inventory", "fast_path:early_reference_inventory_fallback", "flight_lookup:usable_inventory_missing", "flight_reference_fallback:applied:dest=HND", "hotel_reference_fallback:applied", "fast_path:timeout_budget_guard", "relaxed_mode_applied:reference_inventory_fast_path", "fast_path:reference_inventory_guided_response", "day1: routePoints regenerated from activities (5 -> 5)", "day1: route metrics recalculated via google directions (5 points)", "day2: routePoints regenerated from activities (4 -> 4)", "day2: route metrics recalculated via google directions (4 points)", "day3: routePoints regenerated from activities (5 -> 5)", "day3: route metrics recalculated via google directions (5 points)", "correction_service normalized activity categories (2 activities)", "correction_service marked 1 activities as low reference quality", "correction_service generalized inline flight text in 1 activities for reference-only flights", "day1: correction_service overwrote metrics via google directions (5 points)", "day2: correction_service overwrote metrics via google directions (4 points)", "day3: correction_service overwrote metrics via google directions (5 points)", "warning_detected: role_consistency_day3", "quality_issue:RELAXED_MODE_APPLIED:INFO:4", "final_quality_decision:score=96,threshold=85,policy_path=inventory_incomplete_gate,partial_allowed=True,minimum_viable=True,decision=warning,reason=INCOMPLETE_FLIGHT_OR_HOTEL_INVENTORY", "perf:total_request_ms=22989"], "qualityScore"
:
    96, "validation"
:
    {
        "level"
    :
        "WARNING", "message"
    :
        "SOFT_FAIL: Inventory incomplete; guided package only.", "validationScore"
    :
        96, "isValid"
    :
        true, "riskLevel"
    :
        "MEDIUM", "acceptanceStatus"
    :
        "WARNING", "errors"
    :
        [], "warnings"
    :
        [{
            "ruleId": "RULE-PT-004",
            "severity": "WARNING",
            "message": "Day 3: role consistency issue (Musashino Mori Diner Shinjuku Central Park)."
        }, {
            "ruleId": "RULE-QS-001",
            "severity": "INFO",
            "message": "Relaxed validation mode was applied to recover an otherwise failing result."
        }]
    }
,
    "qualityBreakdown"
:
    {
        "structure"
    :
        26, "density"
    :
        20, "realism"
    :
        20, "variety"
    :
        20, "completeness"
    :
        10, "total"
    :
        96
    }
}