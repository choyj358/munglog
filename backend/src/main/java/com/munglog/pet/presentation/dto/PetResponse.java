package com.munglog.pet.presentation.dto;

import com.munglog.pet.domain.Pet;

import java.time.LocalDateTime;

public record PetResponse(
        Long id,
        String name,
        String profileImageUrl,
        LocalDateTime createdAt) {

    public static PetResponse from(Pet pet) {
        return new PetResponse(
                pet.getId(),
                pet.getName(),
                pet.getProfileImageUrl(),
                pet.getCreatedAt());
    }
}