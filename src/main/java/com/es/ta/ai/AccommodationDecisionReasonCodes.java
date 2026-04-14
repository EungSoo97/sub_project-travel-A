package com.es.ta.ai;

/**
 * FastAPI {@code TravelSuccessResponse.accommodationDecisionReason} 에 쓰이는 토큰 상수.
 * 서버가 새 값을 추가할 수 있으므로, 미매칭 문자열은 그대로 보존해 처리하면 된다.
 */
public final class AccommodationDecisionReasonCodes {

    private AccommodationDecisionReasonCodes() {}

    public static final String REFERENCE_STAY_UX_ONLY = "reference_stay_ux_only";
    public static final String NO_LODGING_ANCHOR = "no_lodging_anchor";
    public static final String CURATED_LODGING_DISPLAYABLE = "curated_lodging_displayable";
    public static final String CURATED_LODGING_MINIMAL = "curated_lodging_minimal";
    public static final String REAL_PLACE_SELLABLE_AND_DISPLAYABLE = "real_place_sellable_and_displayable";
    public static final String REAL_PLACE_DISPLAYABLE = "real_place_displayable";
    public static final String REAL_PLACE_SELLABLE_ANCHOR = "real_place_sellable_anchor";
    public static final String REAL_PLACE_ANCHOR_MINIMAL = "real_place_anchor_minimal";
    public static final String LODGING_ANCHOR_UNCLASSIFIED = "lodging_anchor_unclassified";
}
