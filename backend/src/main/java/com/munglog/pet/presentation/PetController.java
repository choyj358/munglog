package com.munglog.pet.presentation;

import com.munglog.pet.application.PetService;
import com.munglog.pet.presentation.dto.PetCreateRequest;
import com.munglog.pet.presentation.dto.PetResponse;
import com.munglog.pet.presentation.dto.PetUpdateRequest;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users/{userId}/pets")
public class PetController {

    private final PetService petService;

    public PetController(PetService petService) {
        this.petService = petService;
    }

    @GetMapping
    public List<PetResponse> findAll(
            @PathVariable Long userId) {
        return petService.findAll(userId);
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

    @PatchMapping("/{petId}")
    public PetResponse update(
            @PathVariable Long userId,
            @PathVariable Long petId,
            @Valid @RequestBody PetUpdateRequest request) {
        return petService.update(
                userId,
                petId,
                request);
    }

    @DeleteMapping("/{petId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(
            @PathVariable Long userId,
            @PathVariable Long petId) {
        petService.delete(
                userId,
                petId);
    }

    @PostMapping("/{petId}/restore")
    public PetResponse restore(
            @PathVariable Long userId,
            @PathVariable Long petId) {
        return petService.restore(
                userId,
                petId);
    }
}
