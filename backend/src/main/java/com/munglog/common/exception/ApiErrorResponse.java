package com.munglog.common.exception;

import java.time.LocalDateTime;
import java.util.Map;

public record ApiErrorResponse(
        LocalDateTime timestamp,
        int status,
        String code,
        String message,
        Map<String, String> fieldErrors) {

    public static ApiErrorResponse of(
            int status,
            String code,
            String message) {
        return new ApiErrorResponse(
                LocalDateTime.now(),
                status,
                code,
                message,
                Map.of());
    }

    public static ApiErrorResponse withFieldErrors(
            int status,
            String code,
            String message,
            Map<String, String> fieldErrors) {
        return new ApiErrorResponse(
                LocalDateTime.now(),
                status,
                code,
                message,
                fieldErrors);
    }
}