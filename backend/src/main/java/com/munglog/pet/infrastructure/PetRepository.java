package com.munglog.pet.infrastructure;

import com.munglog.pet.domain.Pet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PetRepository
        extends JpaRepository<Pet, Long> {

    List<Pet> findAllByUser_IdAndDeletedAtIsNullOrderByCreatedAtDesc(
            Long userId);

    Optional<Pet> findByIdAndUser_IdAndDeletedAtIsNull(
            Long petId,
            Long userId);
}