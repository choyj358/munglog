package com.munglog.memory.domain;

import com.munglog.media.domain.MediaFile;
import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(name = "memory_photos", uniqueConstraints = {
        @UniqueConstraint(name = "uk_memory_photos_order", columnNames = {
                "memory_id",
                "sort_order"
        })
}, indexes = {
        @Index(name = "idx_memory_photos_media_file", columnList = "media_file_id")
})
public class MemoryPhoto {

    @EmbeddedId
    private MemoryPhotoId id;

    @MapsId("memoryId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "memory_id", nullable = false, foreignKey = @ForeignKey(name = "fk_memory_photos_memory"))
    private Memory memory;

    @MapsId("mediaFileId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "media_file_id", nullable = false, foreignKey = @ForeignKey(name = "fk_memory_photos_media_file"))
    private MediaFile mediaFile;

    @Column(name = "sort_order", nullable = false)
    private byte sortOrder;

    protected MemoryPhoto() {
    }

    public MemoryPhoto(
            Memory memory,
            MediaFile mediaFile,
            int sortOrder) {
        validateSortOrder(sortOrder);

        this.id = new MemoryPhotoId(
                memory.getId(),
                mediaFile.getId());
        this.memory = memory;
        this.mediaFile = mediaFile;
        this.sortOrder = (byte) sortOrder;
    }

    private void validateSortOrder(int sortOrder) {
        if (sortOrder < 1 || sortOrder > 10) {
            throw new IllegalArgumentException(
                    "사진 순서는 1부터 10 사이여야 합니다.");
        }
    }

    public MemoryPhotoId getId() {
        return id;
    }

    public Memory getMemory() {
        return memory;
    }

    public MediaFile getMediaFile() {
        return mediaFile;
    }

    public int getSortOrder() {
        return sortOrder;
    }
}