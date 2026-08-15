package com.munglog.memory.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class MemoryPhotoId implements Serializable {

    @Column(name = "memory_id")
    private Long memoryId;

    @Column(name = "media_file_id")
    private Long mediaFileId;

    protected MemoryPhotoId() {
    }

    public MemoryPhotoId(
            Long memoryId,
            Long mediaFileId) {
        this.memoryId = memoryId;
        this.mediaFileId = mediaFileId;
    }

    public Long getMemoryId() {
        return memoryId;
    }

    public Long getMediaFileId() {
        return mediaFileId;
    }

    @Override
    public boolean equals(Object object) {
        if (this == object) {
            return true;
        }

        if (!(object instanceof MemoryPhotoId that)) {
            return false;
        }

        return Objects.equals(memoryId, that.memoryId)
                && Objects.equals(mediaFileId, that.mediaFileId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(memoryId, mediaFileId);
    }
}