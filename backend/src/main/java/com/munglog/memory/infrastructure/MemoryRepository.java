package com.munglog.memory.infrastructure;

import com.munglog.memory.domain.Memory;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemoryRepository
        extends JpaRepository<Memory, Long> {
}