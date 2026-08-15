package com.munglog.memory.infrastructure;

import com.munglog.memory.domain.MemoryPet;
import com.munglog.memory.domain.MemoryPetId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemoryPetRepository
        extends JpaRepository<MemoryPet, MemoryPetId> {
}