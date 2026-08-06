package com.munglog.pet.presentation.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record PetCreateRequest(

        @NotBlank(message = "반려견 이름을 입력해주세요.") @Size(max = 20, message = "반려견 이름은 20자 이하로 입력해주세요.") String name

) {
}