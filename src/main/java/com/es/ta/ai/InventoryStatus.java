package com.es.ta.ai;

import java.util.Locale;

/**
 * FastAPI {@code TravelSuccessResponse.inventoryStatus} — 항공·숙소 재고 축 요약.
 *
 * <p>{@link #MIXED_INVENTORY}: 한 축만 전부 REFERENCE이고 다른 축은 실재고
 * (예: 항공 reference + 숙소 REAL_PLACES_API).
 *
 * <p>Python {@code validation_service.ValidationService._inventory_status} 와 동일한 문자열.
 */
public enum InventoryStatus {
    COMPLETE,
    REFERENCE_ONLY,
    MIXED_INVENTORY,
    MISSING_BOTH,
    MISSING_FLIGHTS,
    MISSING_HOTELS,
    PARTIAL;

    /**
     * API 문자열을 enum으로 파싱. 알 수 없거나 빈 값이면 {@code null}.
     */
    public static InventoryStatus fromApiValue(String raw) {
        if (raw == null) {
            return null;
        }
        String s = raw.trim();
        if (s.isEmpty()) {
            return null;
        }
        try {
            return InventoryStatus.valueOf(s.toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException ex) {
            return null;
        }
    }
}
