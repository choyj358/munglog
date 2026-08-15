package com.munglog.common.exception;

import jakarta.persistence.EntityNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.LinkedHashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

        private static final Logger log = LoggerFactory.getLogger(
                        GlobalExceptionHandler.class);

        @ExceptionHandler(MethodArgumentNotValidException.class)
        public ResponseEntity<ApiErrorResponse> handleValidation(
                        MethodArgumentNotValidException exception) {
                Map<String, String> fieldErrors = new LinkedHashMap<>();

                exception.getBindingResult()
                                .getFieldErrors()
                                .forEach(error -> {
                                        String message = error.getDefaultMessage();

                                        if (message == null) {
                                                message = "올바른 값을 입력해주세요.";
                                        }

                                        fieldErrors.putIfAbsent(
                                                        error.getField(),
                                                        message);
                                });

                ApiErrorResponse response = ApiErrorResponse.withFieldErrors(
                                HttpStatus.BAD_REQUEST.value(),
                                "INVALID_INPUT",
                                "입력값을 확인해주세요.",
                                fieldErrors);

                return ResponseEntity
                                .status(HttpStatus.BAD_REQUEST)
                                .body(response);
        }

        @ExceptionHandler(EntityNotFoundException.class)
        public ResponseEntity<ApiErrorResponse> handleNotFound(
                        EntityNotFoundException exception) {
                ApiErrorResponse response = ApiErrorResponse.of(
                                HttpStatus.NOT_FOUND.value(),
                                "RESOURCE_NOT_FOUND",
                                exception.getMessage());

                return ResponseEntity
                                .status(HttpStatus.NOT_FOUND)
                                .body(response);
        }

        @ExceptionHandler(HttpMessageNotReadableException.class)
        public ResponseEntity<ApiErrorResponse> handleUnreadableMessage(
                        HttpMessageNotReadableException exception) {
                ApiErrorResponse response = ApiErrorResponse.of(
                                HttpStatus.BAD_REQUEST.value(),
                                "INVALID_JSON",
                                "요청 내용을 읽을 수 없습니다.");

                return ResponseEntity
                                .status(HttpStatus.BAD_REQUEST)
                                .body(response);
        }

        @ExceptionHandler(IllegalArgumentException.class)
        public ResponseEntity<ApiErrorResponse> handleIllegalArgument(
                        IllegalArgumentException exception) {
                ApiErrorResponse response = ApiErrorResponse.of(
                                HttpStatus.BAD_REQUEST.value(),
                                "INVALID_INPUT",
                                exception.getMessage());

                return ResponseEntity
                                .status(HttpStatus.BAD_REQUEST)
                                .body(response);
        }

        @ExceptionHandler(Exception.class)
        public ResponseEntity<ApiErrorResponse> handleUnexpected(
                        Exception exception) {
                log.error(
                                "처리되지 않은 서버 오류가 발생했습니다.",
                                exception);

                ApiErrorResponse response = ApiErrorResponse.of(
                                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                                "INTERNAL_SERVER_ERROR",
                                "서버 오류가 발생했습니다.");

                return ResponseEntity
                                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                                .body(response);
        }
}