package com.munglog.memory.presentation;

import com.munglog.memory.application.MemoryService;
import com.munglog.memory.presentation.dto.MemoryCreateRequest;
import com.munglog.memory.presentation.dto.MemoryResponse;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users/{userId}/memories")
public class MemoryController {

    private final MemoryService memoryService;

    public MemoryController(
            MemoryService memoryService) {
        this.memoryService = memoryService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public MemoryResponse create(
            @PathVariable Long userId,
            @Valid @RequestBody MemoryCreateRequest request) {
        return memoryService.create(
                userId,
                request);
    }
}