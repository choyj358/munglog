package com.munglog.memory.infrastructure;

import com.munglog.memory.domain.MemoryPhoto;
import com.munglog.memory.domain.MemoryPhotoId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemoryPhotoRepository
        extends JpaRepository<MemoryPhoto, MemoryPhotoId> {
}