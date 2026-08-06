package com.munglog.pet.application;

import com.munglog.pet.domain.Pet;
import com.munglog.pet.infrastructure.PetRepository;
import com.munglog.pet.presentation.dto.PetCreateRequest;
import com.munglog.pet.presentation.dto.PetResponse;
import com.munglog.user.domain.User;
import com.munglog.user.infrastructure.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class PetService {

    private final UserRepository userRepository;
    private final PetRepository petRepository;

    public PetService(
            UserRepository userRepository,
            PetRepository petRepository) {
        this.userRepository = userRepository;
        this.petRepository = petRepository;
    }

    @Transactional
    public PetResponse create(
            Long userId,
            PetCreateRequest request) {
        User user = userRepository
                .findByIdAndDeletedAtIsNull(userId)
                .orElseThrow(
                        () -> new EntityNotFoundException(
                                "사용자를 찾을 수 없습니다."));

        String name = request.name().trim();

        Pet pet = new Pet(
                user,
                name,
                null);

        Pet savedPet = petRepository.save(pet);

        return PetResponse.from(savedPet);
    }
}