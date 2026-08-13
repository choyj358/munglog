package com.munglog.pet.application;

import com.munglog.pet.domain.Pet;
import com.munglog.pet.infrastructure.PetRepository;
import com.munglog.pet.presentation.dto.PetCreateRequest;
import com.munglog.pet.presentation.dto.PetResponse;
import com.munglog.pet.presentation.dto.PetUpdateRequest;
import com.munglog.user.domain.User;
import com.munglog.user.infrastructure.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

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

    public List<PetResponse> findAll(Long userId) {
        userRepository.findByIdAndDeletedAtIsNull(userId)
                .orElseThrow(
                        () -> new EntityNotFoundException(
                                "사용자를 찾을 수 없습니다."));

        return petRepository
                .findAllByUser_IdAndDeletedAtIsNullOrderByCreatedAtDesc(userId)
                .stream()
                .map(PetResponse::from)
                .toList();
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

    @Transactional
    public PetResponse update(
            Long userId,
            Long petId,
            PetUpdateRequest request) {
        Pet pet = petRepository
                .findByIdAndUser_IdAndDeletedAtIsNull(
                        petId,
                        userId)
                .orElseThrow(
                        () -> new EntityNotFoundException(
                                "반려견을 찾을 수 없습니다."));

        String name = request.name().trim();

        pet.changeName(name);

        return PetResponse.from(pet);
    }

    @Transactional
    public void delete(
            Long userId,
            Long petId) {
        Pet pet = petRepository
                .findByIdAndUser_IdAndDeletedAtIsNull(
                        petId,
                        userId)
                .orElseThrow(
                        () -> new EntityNotFoundException(
                                "반려견을 찾을 수 없습니다."));

        pet.delete();
    }

    @Transactional
    public PetResponse restore(
            Long userId,
            Long petId) {
        Pet pet = petRepository
                .findByIdAndUser_IdAndDeletedAtIsNotNull(
                        petId,
                        userId)
                .orElseThrow(
                        () -> new EntityNotFoundException(
                                "삭제된 반려견을 찾을 수 없습니다."));

        pet.restore();

        return PetResponse.from(pet);
    }
}
