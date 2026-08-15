package com.munglog.memory.presentation;

import com.munglog.memory.application.MemoryService;
import com.munglog.memory.presentation.dto.MemoryCreateRequest;
import com.munglog.memory.presentation.dto.MemoryResponse;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(MemoryController.class)
class MemoryControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private MemoryService memoryService;

    @Test
    void createsMemoryAndReturns201() throws Exception {
        MemoryResponse response = new MemoryResponse(
                100L,
                LocalDate.of(
                        2026,
                        8,
                        1),
                "오늘도 즐거운 하루",
                "우리 동네 공원",
                BigDecimal.valueOf(37.5),
                BigDecimal.valueOf(127.0),
                List.of(1L, 2L),
                List.of(10L, 11L),
                LocalDateTime.of(
                        2026,
                        8,
                        15,
                        14,
                        30));

        given(
                memoryService.create(
                        eq(1L),
                        any(MemoryCreateRequest.class)))
                .willReturn(response);

        mockMvc.perform(
                post("/api/users/1/memories")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "recordedDate": "2026-08-01",
                                  "memo": "오늘도 즐거운 하루",
                                  "placeName": "우리 동네 공원",
                                  "latitude": 37.5,
                                  "longitude": 127.0,
                                  "petIds": [1, 2],
                                  "mediaFileIds": [10, 11]
                                }
                                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(100))
                .andExpect(
                        jsonPath("$.recordedDate")
                                .value("2026-08-01"))
                .andExpect(
                        jsonPath("$.memo")
                                .value("오늘도 즐거운 하루"))
                .andExpect(
                        jsonPath("$.placeName")
                                .value("우리 동네 공원"))
                .andExpect(
                        jsonPath("$.petIds.length()")
                                .value(2))
                .andExpect(
                        jsonPath("$.mediaFileIds[0]")
                                .value(10))
                .andExpect(
                        jsonPath("$.mediaFileIds[1]")
                                .value(11));
    }

    @Test
    void rejectsMemoryWithoutRecordedDate() throws Exception {
        mockMvc.perform(
                post("/api/users/1/memories")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "petIds": [1],
                                  "mediaFileIds": [10]
                                }
                                """))
                .andExpect(status().isBadRequest())
                .andExpect(
                        jsonPath("$.code")
                                .value("INVALID_INPUT"))
                .andExpect(
                        jsonPath("$.fieldErrors.recordedDate")
                                .exists());

        verifyNoInteractions(memoryService);
    }

    @Test
    void rejectsMemoryWithoutPets() throws Exception {
        mockMvc.perform(
                post("/api/users/1/memories")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "recordedDate": "2026-08-01",
                                  "petIds": [],
                                  "mediaFileIds": [10]
                                }
                                """))
                .andExpect(status().isBadRequest())
                .andExpect(
                        jsonPath("$.code")
                                .value("INVALID_INPUT"))
                .andExpect(
                        jsonPath("$.fieldErrors.petIds")
                                .exists());

        verifyNoInteractions(memoryService);
    }

    @Test
    void rejectsMoreThanTenPhotos() throws Exception {
        mockMvc.perform(
                post("/api/users/1/memories")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "recordedDate": "2026-08-01",
                                  "petIds": [1],
                                  "mediaFileIds": [
                                    1, 2, 3, 4, 5, 6,
                                    7, 8, 9, 10, 11
                                  ]
                                }
                                """))
                .andExpect(status().isBadRequest())
                .andExpect(
                        jsonPath("$.code")
                                .value("INVALID_INPUT"))
                .andExpect(
                        jsonPath("$.fieldErrors.mediaFileIds")
                                .exists());

        verifyNoInteractions(memoryService);
    }
}