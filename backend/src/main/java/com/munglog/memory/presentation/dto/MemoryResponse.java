package com.munglog.memory.presentation.dto;

import com.munglog.memory.domain.Memory;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public record MemoryResponse(
        Long id,
        LocalDate recordedDate,
        String memo,
        String placeName,
        BigDecimal latitude,
        BigDecimal longitude,
        List<Long> petIds,
        List<Long> mediaFileIds,
        LocalDateTime createdAt) {

    public static MemoryResponse from(
            Memory memory,
            List<Long> petIds,
            List<Long> mediaFileIds) {
        return new MemoryResponse(
                memory.getId(),
                memory.getRecordedDate(),
                memory.getMemo(),
                memory.getPlaceName(),
                memory.getLatitude(),
                memory.getLongitude(),
                List.copyOf(petIds),
                List.copyOf(mediaFileIds),
                memory.getCreatedAt());
    }
}