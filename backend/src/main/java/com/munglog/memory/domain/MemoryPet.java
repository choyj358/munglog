package com.munglog.memory.domain;

import com.munglog.pet.domain.Pet;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;

@Entity
@Table(name = "memory_pets")
public class MemoryPet {

    @EmbeddedId
    private MemoryPetId id;

    @MapsId("memoryId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "memory_id", nullable = false, foreignKey = @ForeignKey(name = "fk_memory_pets_memory"))
    private Memory memory;

    @MapsId("petId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "pet_id", nullable = false, foreignKey = @ForeignKey(name = "fk_memory_pets_pet"))
    private Pet pet;

    protected MemoryPet() {
    }

    public MemoryPet(
            Memory memory,
            Pet pet) {
        this.id = new MemoryPetId(
                memory.getId(),
                pet.getId());
        this.memory = memory;
        this.pet = pet;
    }

    public MemoryPetId getId() {
        return id;
    }

    public Memory getMemory() {
        return memory;
    }

    public Pet getPet() {
        return pet;
    }
}