package com.munglog.memory.presentation.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;

public record MemoryCreateRequest(

        @NotNull(message = "기록 날짜를 선택해주세요.") @PastOrPresent(message = "미래 날짜에는 기록할 수 없습니다.") LocalDate recordedDate,

        @Size(max = 500, message = "메모는 500자 이하로 입력해주세요.") String memo,

        @Size(max = 255, message = "장소 이름은 255자 이하로 입력해주세요.") String placeName,

        @DecimalMin(value = "-90.0", message = "위도는 -90 이상이어야 합니다.") @DecimalMax(value = "90.0", message = "위도는 90 이하여야 합니다.") BigDecimal latitude,

        @DecimalMin(value = "-180.0", message = "경도는 -180 이상이어야 합니다.") @DecimalMax(value = "180.0", message = "경도는 180 이하여야 합니다.") BigDecimal longitude,

        @NotEmpty(message = "함께한 반려견을 한 마리 이상 선택해주세요.") Set<@Positive(message = "올바른 반려견 번호를 입력해주세요.") Long> petIds,

        @NotEmpty(message = "사진을 한 장 이상 선택해주세요.") @Size(max = 10, message = "사진은 최대 10장까지 선택할 수 있습니다.") List<@Positive(message = "올바른 사진 번호를 입력해주세요.") Long> mediaFileIds

) {
}