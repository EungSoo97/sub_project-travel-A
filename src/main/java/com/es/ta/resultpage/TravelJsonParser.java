package com.es.ta.resultpage;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

public class TravelJsonParser {

    private static final ObjectMapper mapper = new ObjectMapper()
            .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

    public static TravelResultVDTO parse(String json) {
        if (json == null || json.trim().isEmpty()) {
            return null;
        }

        try {
            return mapper.readValue(json, TravelResultVDTO.class);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
