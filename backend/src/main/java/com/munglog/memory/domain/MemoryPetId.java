package com.munglog.memory.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class MemoryPetId implements Serializable {

    @Column(name = "memory_id")
    private Long memoryId;

    @Column(name = "pet_id")
    private Long petId;

    protected MemoryPetId() {
    }

    public MemoryPetId(
            Long memoryId,
            Long petId) {
        this.memoryId = memoryId;
        this.petId = petId;
    }

    public Long getMemoryId() {
        return memoryId;
    }

    public Long getPetId() {
        return petId;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) {
            return true;
        }

        if (!(object instanceof MemoryPetId that)) {
            return false;
        }

        return Objects.equals(memoryId, that.memoryId)
                && Objects.equals(petId, that.petId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(memoryId, petId);
    }
}