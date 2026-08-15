package com.munglog.memory.application;

import com.munglog.media.domain.MediaFile;
import com.munglog.media.domain.UploadStatus;
import com.munglog.media.infrastructure.MediaFileRepository;
import com.munglog.memory.domain.Memory;
import com.munglog.memory.domain.MemoryPet;
import com.munglog.memory.domain.MemoryPhoto;
import com.munglog.memory.infrastructure.MemoryPetRepository;
import com.munglog.memory.infrastructure.MemoryPhotoRepository;
import com.munglog.memory.infrastructure.MemoryRepository;
import com.munglog.memory.presentation.dto.MemoryCreateRequest;
import com.munglog.memory.presentation.dto.MemoryResponse;
import com.munglog.pet.domain.Pet;
import com.munglog.pet.infrastructure.PetRepository;
import com.munglog.user.domain.User;
import com.munglog.user.infrastructure.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class MemoryService {

    private final UserRepository userRepository;
    private final PetRepository petRepository;
    private final MediaFileRepository mediaFileRepository;
    private final MemoryRepository memoryRepository;
    private final MemoryPetRepository memoryPetRepository;
    private final MemoryPhotoRepository memoryPhotoRepository;

    public MemoryService(
            UserRepository userRepository,
            PetRepository petRepository,
            MediaFileRepository mediaFileRepository,
            MemoryRepository memoryRepository,
            MemoryPetRepository memoryPetRepository,
            MemoryPhotoRepository memoryPhotoRepository) {
        this.userRepository = userRepository;
        this.petRepository = petRepository;
        this.mediaFileRepository = mediaFileRepository;
        this.memoryRepository = memoryRepository;
        this.memoryPetRepository = memoryPetRepository;
        this.memoryPhotoRepository = memoryPhotoRepository;
    }

    @Transactional
    public MemoryResponse create(
            Long userId,
            MemoryCreateRequest request) {
        validateLocation(request);
        validateDuplicateMediaFiles(request.mediaFileIds());

        User user = userRepository
                .findByIdAndDeletedAtIsNull(userId)
                .orElseThrow(() -> new EntityNotFoundException(
                        "사용자를 찾을 수 없습니다."));

        List<Pet> pets = petRepository
                .findAllByIdInAndUser_IdAndDeletedAtIsNull(
                        request.petIds(),
                        userId);

        if (pets.size() != request.petIds().size()) {
            throw new EntityNotFoundException(
                    "선택한 반려견을 찾을 수 없습니다.");
        }

        List<MediaFile> mediaFiles = mediaFileRepository
                .findAllByIdInAndUser_IdAndUploadStatusAndDeletedAtIsNull(
                        request.mediaFileIds(),
                        userId,
                        UploadStatus.COMPLETED);

        if (mediaFiles.size() != request.mediaFileIds().size()) {
            throw new EntityNotFoundException(
                    "사용할 수 있는 사진을 찾을 수 없습니다.");
        }

        Memory memory = memoryRepository.save(
                new Memory(
                        user,
                        request.recordedDate(),
                        normalizeText(request.memo()),
                        normalizeText(request.placeName()),
                        request.latitude(),
                        request.longitude()));

        List<MemoryPet> memoryPets = pets.stream()
                .map(pet -> new MemoryPet(memory, pet))
                .toList();

        memoryPetRepository.saveAll(memoryPets);

        Map<Long, MediaFile> mediaFileMap = new HashMap<>();

        for (MediaFile mediaFile : mediaFiles) {
            mediaFileMap.put(
                    mediaFile.getId(),
                    mediaFile);
        }

        List<MemoryPhoto> memoryPhotos = new ArrayList<>();

        for (int index = 0; index < request.mediaFileIds().size(); index++) {

            Long mediaFileId = request.mediaFileIds().get(index);
            MediaFile mediaFile = mediaFileMap.get(mediaFileId);

            memoryPhotos.add(
                    new MemoryPhoto(
                            memory,
                            mediaFile,
                            index + 1));
        }

        memoryPhotoRepository.saveAll(memoryPhotos);

        return MemoryResponse.from(
                memory,
                pets.stream()
                        .map(Pet::getId)
                        .toList(),
                request.mediaFileIds());
    }

    private void validateLocation(
            MemoryCreateRequest request) {
        boolean hasLatitude = request.latitude() != null;
        boolean hasLongitude = request.longitude() != null;

        if (hasLatitude != hasLongitude) {
            throw new IllegalArgumentException(
                    "위도와 경도는 함께 입력해야 합니다.");
        }
    }

    private void validateDuplicateMediaFiles(
            List<Long> mediaFileIds) {
        long distinctCount = mediaFileIds.stream()
                .distinct()
                .count();

        if (distinctCount != mediaFileIds.size()) {
            throw new IllegalArgumentException(
                    "같은 사진을 중복 선택할 수 없습니다.");
        }
    }

    private String normalizeText(String text) {
        if (text == null) {
            return null;
        }

        String trimmedText = text.trim();

        if (trimmedText.isEmpty()) {
            return null;
        }

        return trimmedText;
    }
}