package com.munglog.pet.application;

import com.munglog.pet.domain.Pet;
import com.munglog.pet.infrastructure.PetRepository;
import com.munglog.pet.presentation.dto.PetCreateRequest;
import com.munglog.pet.presentation.dto.PetResponse;
import com.munglog.pet.presentation.dto.PetUpdateRequest;
import com.munglog.user.domain.User;
import com.munglog.user.infrastructure.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;

@ExtendWith(MockitoExtension.class)
class PetServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PetRepository petRepository;

    @InjectMocks
    private PetService petService;

    @Test
    void 반려견을_등록한다() {
        User user = new User(
                "dev@munglog.local",
                null);

        PetCreateRequest request = new PetCreateRequest("  푸딩  ");

        given(
                userRepository.findByIdAndDeletedAtIsNull(1L)).willReturn(Optional.of(user));

        given(
                petRepository.save(any(Pet.class))).willAnswer(invocation -> invocation.getArgument(0));

        PetResponse response = petService.create(
                1L,
                request);

        ArgumentCaptor<Pet> petCaptor = ArgumentCaptor.forClass(Pet.class);

        verify(petRepository).save(petCaptor.capture());

        Pet savedPet = petCaptor.getValue();

        assertThat(savedPet.getUser()).isSameAs(user);
        assertThat(savedPet.getName()).isEqualTo("푸딩");
        assertThat(response.name()).isEqualTo("푸딩");
    }

    @Test
    void 사용자가_없으면_반려견을_저장하지_않는다() {
        PetCreateRequest request = new PetCreateRequest("푸딩");

        given(
                userRepository.findByIdAndDeletedAtIsNull(
                        999999L))
                .willReturn(Optional.empty());

        assertThatThrownBy(
                () -> petService.create(
                        999999L,
                        request))
                .isInstanceOf(EntityNotFoundException.class)
                .hasMessage("사용자를 찾을 수 없습니다.");

        verifyNoInteractions(petRepository);
    }

    @Test
    void 반려견_목록을_최신순으로_조회한다() {
        User user = new User(
                "dev@munglog.local",
                null);

        Pet mayo = new Pet(
                user,
                "마요",
                null);

        Pet leo = new Pet(
                user,
                "레오",
                null);

        given(
                userRepository.findByIdAndDeletedAtIsNull(1L))
                .willReturn(Optional.of(user));

        given(
                petRepository
                        .findAllByUser_IdAndDeletedAtIsNullOrderByCreatedAtDesc(1L))
                .willReturn(List.of(mayo, leo));

        List<PetResponse> responses = petService.findAll(1L);

        assertThat(responses)
                .extracting(PetResponse::name)
                .containsExactly(
                        "마요",
                        "레오");
    }

    @Test
    void 반려견_이름을_수정한다() {
        User user = new User(
                "dev@munglog.local",
                null);

        Pet pet = new Pet(
                user,
                "푸딩",
                null);

        PetUpdateRequest request = new PetUpdateRequest("  레오  ");

        given(
                petRepository
                        .findByIdAndUser_IdAndDeletedAtIsNull(
                                3L,
                                1L))
                .willReturn(Optional.of(pet));

        PetResponse response = petService.update(
                1L,
                3L,
                request);

        assertThat(pet.getName()).isEqualTo("레오");
        assertThat(response.name()).isEqualTo("레오");
    }

    @Test
    void 다른_사용자의_반려견은_수정할_수_없다() {
        PetUpdateRequest request = new PetUpdateRequest("레오");

        given(
                petRepository
                        .findByIdAndUser_IdAndDeletedAtIsNull(
                                3L,
                                999L))
                .willReturn(Optional.empty());

        assertThatThrownBy(
                () -> petService.update(
                        999L,
                        3L,
                        request))
                .isInstanceOf(EntityNotFoundException.class)
                .hasMessage("반려견을 찾을 수 없습니다.");
    }

    @Test
    void 반려견을_소프트_삭제한다() {
        User user = new User(
                "dev@munglog.local",
                null);

        Pet pet = new Pet(
                user,
                "레오",
                null);

        given(
                petRepository
                        .findByIdAndUser_IdAndDeletedAtIsNull(
                                1L,
                                1L))
                .willReturn(Optional.of(pet));

        petService.delete(
                1L,
                1L);

        assertThat(pet.getDeletedAt()).isNotNull();
    }

    @Test
    void 다른_사용자의_반려견은_삭제할_수_없다() {
        given(
                petRepository
                        .findByIdAndUser_IdAndDeletedAtIsNull(
                                1L,
                                999L))
                .willReturn(Optional.empty());

        assertThatThrownBy(
                () -> petService.delete(
                        999L,
                        1L))
                .isInstanceOf(EntityNotFoundException.class)
                .hasMessage("반려견을 찾을 수 없습니다.");
    }
}
