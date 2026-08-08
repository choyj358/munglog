package com.munglog.pet.presentation;

import com.munglog.pet.application.PetService;
import com.munglog.pet.presentation.dto.PetCreateRequest;
import com.munglog.pet.presentation.dto.PetResponse;
import jakarta.persistence.EntityNotFoundException;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(PetController.class)
class PetControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private PetService petService;

    @Test
    void 반려견을_등록하면_201과_등록된_정보를_반환한다()
            throws Exception {

        PetResponse response = new PetResponse(
                1L,
                "푸딩",
                null,
                LocalDateTime.of(
                        2026,
                        8,
                        6,
                        20,
                        16));

        given(
                petService.create(
                        eq(1L),
                        any(PetCreateRequest.class)))
                .willReturn(response);

        mockMvc.perform(
                post("/api/users/1/pets")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "name": "푸딩"
                                }
                                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").value("푸딩"))
                .andExpect(jsonPath("$.profileImageUrl").isEmpty());
    }

    @Test
    void 이름이_공백이면_400과_필드_오류를_반환한다()
            throws Exception {

        mockMvc.perform(
                post("/api/users/1/pets")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "name": "   "
                                }
                                """))
                .andExpect(status().isBadRequest())
                .andExpect(
                        jsonPath("$.code")
                                .value("INVALID_INPUT"))
                .andExpect(
                        jsonPath("$.fieldErrors.name")
                                .value("반려견 이름을 입력해주세요."));

        verifyNoInteractions(petService);
    }

    @Test
    void 사용자가_없으면_404를_반환한다()
            throws Exception {

        given(
                petService.create(
                        eq(999999L),
                        any(PetCreateRequest.class)))
                .willThrow(
                        new EntityNotFoundException(
                                "사용자를 찾을 수 없습니다."));

        mockMvc.perform(
                post("/api/users/999999/pets")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "name": "test"
                                }
                                """))
                .andExpect(status().isNotFound())
                .andExpect(
                        jsonPath("$.code")
                                .value("RESOURCE_NOT_FOUND"))
                .andExpect(
                        jsonPath("$.message")
                                .value("사용자를 찾을 수 없습니다."));
    }

    @Test
    void 반려견_목록을_조회하면_200과_목록을_반환한다()
            throws Exception {

        List<PetResponse> responses = List.of(
                new PetResponse(
                        2L,
                        "마요",
                        null,
                        LocalDateTime.of(
                                2026,
                                8,
                                8,
                                10,
                                30)),
                new PetResponse(
                        1L,
                        "레오",
                        null,
                        LocalDateTime.of(
                                2026,
                                8,
                                7,
                                10,
                                30)));

        given(petService.findAll(1L))
                .willReturn(responses);

        mockMvc.perform(
                get("/api/users/1/pets"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].id").value(2))
                .andExpect(jsonPath("$[0].name").value("마요"))
                .andExpect(jsonPath("$[1].id").value(1))
                .andExpect(jsonPath("$[1].name").value("레오"));
    }
}
