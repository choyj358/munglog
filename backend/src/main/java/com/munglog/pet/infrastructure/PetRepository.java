package com.munglog.pet.infrastructure;

import com.munglog.pet.domain.Pet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface PetRepository
                extends JpaRepository<Pet, Long> {

        List<Pet> findAllByUser_IdAndDeletedAtIsNullOrderByCreatedAtDesc(
                        Long userId);

        Optional<Pet> findByIdAndUser_IdAndDeletedAtIsNull(
                        Long petId,
                        Long userId);

        Optional<Pet> findByIdAndUser_IdAndDeletedAtIsNotNull(
                        Long petId,
                        Long userId);

        List<Pet> findAllByIdInAndUser_IdAndDeletedAtIsNull(
                        Set<Long> petIds,
                        Long userId);
}
