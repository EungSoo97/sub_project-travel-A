package com.es.ta.ai;

import java.util.Locale;

/**
 * FastAPI {@code TravelSuccessResponse.primaryAccommodationTier} 및 {@code HotelOption.inventoryTier}
 * 에 쓰이는 시맨틱 출처. 판매 가능 여부는 응답의 {@code hasSellableHotel}로 별도 판정한다.
 *
 * <p>레거시 값 {@code PRODUCT}, {@code ANCHOR_ONLY}는 더 이상 내려오지 않는다.
 */
public enum PrimaryAccommodationTier {
    REAL_PLACE_LODGING,
    CURATED_LODGING,
    REFERENCE_STAY;

    /**
     * API 문자열을 enum으로 파싱. 알 수 없거나 빈 값이면 {@code null}.
     */
    public static PrimaryAccommodationTier fromApiValue(String raw) {
        if (raw == null) {
            return null;
        }
        String s = raw.trim();
        if (s.isEmpty()) {
            return null;
        }
        try {
            return PrimaryAccommodationTier.valueOf(s.toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }
}
