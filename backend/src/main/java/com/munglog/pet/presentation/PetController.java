package com.munglog.pet.presentation;

import com.munglog.pet.application.PetService;
import com.munglog.pet.presentation.dto.PetCreateRequest;
import com.munglog.pet.presentation.dto.PetResponse;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users/{userId}/pets")
public class PetController {

    private final PetService petService;

    public PetController(PetService petService) {
        this.petService = petService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public PetResponse create(
            @PathVariable Long userId,
            @Valid @RequestBody PetCreateRequest request) {
        return petService.create(
                userId,
                request);
    }
}