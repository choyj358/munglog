package com.munglog.memory.application;

import com.munglog.media.domain.MediaFile;
import com.munglog.media.domain.UploadStatus;
import com.munglog.media.infrastructure.MediaFileRepository;
import com.munglog.memory.domain.Memory;
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
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;

@ExtendWith(MockitoExtension.class)
class MemoryServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PetRepository petRepository;

    @Mock
    private MediaFileRepository mediaFileRepository;

    @Mock
    private MemoryRepository memoryRepository;

    @Mock
    private MemoryPetRepository memoryPetRepository;

    @Mock
    private MemoryPhotoRepository memoryPhotoRepository;

    @InjectMocks
    private MemoryService memoryService;

    @Test
    void createsMemoryWithSelectedPetsAndPhotos() {
        User user = createUser(1L);

        Pet leo = createPet(
                1L,
                user,
                "레오");

        Pet mayo = createPet(
                2L,
                user,
                "마요");

        MediaFile firstPhoto = createCompletedMediaFile(
                10L,
                user,
                "first.jpg");

        MediaFile secondPhoto = createCompletedMediaFile(
                11L,
                user,
                "second.jpg");

        MemoryCreateRequest request = new MemoryCreateRequest(
                LocalDate.now(),
                "  오늘도 즐거운 하루  ",
                "  우리 동네 공원  ",
                null,
                null,
                Set.of(1L, 2L),
                List.of(11L, 10L));

        given(
                userRepository.findByIdAndDeletedAtIsNull(1L))
                .willReturn(Optional.of(user));

        given(
                petRepository.findAllByIdInAndUser_IdAndDeletedAtIsNull(
                        request.petIds(),
                        1L))
                .willReturn(List.of(leo, mayo));

        given(
                mediaFileRepository
                        .findAllByIdInAndUser_IdAndUploadStatusAndDeletedAtIsNull(
                                request.mediaFileIds(),
                                1L,
                                UploadStatus.COMPLETED))
                .willReturn(List.of(firstPhoto, secondPhoto));

        given(
                memoryRepository.save(any(Memory.class)))
                .willAnswer(invocation -> {
                    Memory memory = invocation.getArgument(0);

                    ReflectionTestUtils.setField(
                            memory,
                            "id",
                            100L);

                    return memory;
                });

        MemoryResponse response = memoryService.create(
                1L,
                request);

        ArgumentCaptor<Memory> memoryCaptor = ArgumentCaptor.forClass(Memory.class);

        verify(memoryRepository).save(memoryCaptor.capture());

        Memory savedMemory = memoryCaptor.getValue();

        assertThat(savedMemory.getUser()).isSameAs(user);
        assertThat(savedMemory.getRecordedDate())
                .isEqualTo(request.recordedDate());
        assertThat(savedMemory.getMemo())
                .isEqualTo("오늘도 즐거운 하루");
        assertThat(savedMemory.getPlaceName())
                .isEqualTo("우리 동네 공원");

        verify(memoryPetRepository).saveAll(any());

        @SuppressWarnings("unchecked")
        ArgumentCaptor<List<MemoryPhoto>> photoCaptor = ArgumentCaptor.forClass(List.class);

        verify(memoryPhotoRepository).saveAll(
                photoCaptor.capture());

        List<MemoryPhoto> savedPhotos = photoCaptor.getValue();

        assertThat(savedPhotos).hasSize(2);

        assertThat(savedPhotos.get(0).getMediaFile().getId())
                .isEqualTo(11L);
        assertThat(savedPhotos.get(0).getSortOrder())
                .isEqualTo(1);

        assertThat(savedPhotos.get(1).getMediaFile().getId())
                .isEqualTo(10L);
        assertThat(savedPhotos.get(1).getSortOrder())
                .isEqualTo(2);

        assertThat(response.id()).isEqualTo(100L);
        assertThat(response.petIds())
                .containsExactlyInAnyOrder(1L, 2L);
        assertThat(response.mediaFileIds())
                .containsExactly(11L, 10L);
    }

    @Test
    void rejectsMemoryWhenSelectedPetDoesNotExist() {
        User user = createUser(1L);

        MemoryCreateRequest request = new MemoryCreateRequest(
                LocalDate.now(),
                null,
                null,
                null,
                null,
                Set.of(999L),
                List.of(10L));

        given(
                userRepository.findByIdAndDeletedAtIsNull(1L))
                .willReturn(Optional.of(user));

        given(
                petRepository.findAllByIdInAndUser_IdAndDeletedAtIsNull(
                        request.petIds(),
                        1L))
                .willReturn(List.of());

        assertThatThrownBy(
                () -> memoryService.create(
                        1L,
                        request))
                .isInstanceOf(EntityNotFoundException.class);

        verify(
                memoryRepository,
                never())
                .save(any(Memory.class));

        verifyNoInteractions(
                mediaFileRepository,
                memoryPetRepository,
                memoryPhotoRepository);
    }

    @Test
    void rejectsDuplicateMediaFiles() {
        MemoryCreateRequest request = new MemoryCreateRequest(
                LocalDate.now(),
                null,
                null,
                null,
                null,
                Set.of(1L),
                List.of(10L, 10L));

        assertThatThrownBy(
                () -> memoryService.create(
                        1L,
                        request))
                .isInstanceOf(IllegalArgumentException.class);

        verifyNoInteractions(
                userRepository,
                petRepository,
                mediaFileRepository,
                memoryRepository,
                memoryPetRepository,
                memoryPhotoRepository);
    }

    @Test
    void rejectsLocationWhenOnlyLatitudeIsProvided() {
        MemoryCreateRequest request = new MemoryCreateRequest(
                LocalDate.now(),
                null,
                null,
                java.math.BigDecimal.valueOf(37.5),
                null,
                Set.of(1L),
                List.of(10L));

        assertThatThrownBy(
                () -> memoryService.create(
                        1L,
                        request))
                .isInstanceOf(IllegalArgumentException.class);

        verifyNoInteractions(
                userRepository,
                petRepository,
                mediaFileRepository,
                memoryRepository,
                memoryPetRepository,
                memoryPhotoRepository);
    }

    private User createUser(Long id) {
        User user = new User(
                "dev@munglog.local",
                null);

        ReflectionTestUtils.setField(
                user,
                "id",
                id);

        return user;
    }

    private Pet createPet(
            Long id,
            User user,
            String name) {
        Pet pet = new Pet(
                user,
                name,
                null);

        ReflectionTestUtils.setField(
                pet,
                "id",
                id);

        return pet;
    }

    private MediaFile createCompletedMediaFile(
            Long id,
            User user,
            String filename) {
        MediaFile mediaFile = new MediaFile(
                user,
                "memories/" + filename,
                filename,
                "image/jpeg",
                1024L);

        ReflectionTestUtils.setField(
                mediaFile,
                "id",
                id);

        mediaFile.completeUpload();

        return mediaFile;
    }
}