package com.munglog.media.domain;

import com.munglog.common.domain.BaseTimeEntity;
import com.munglog.user.domain.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

import java.time.LocalDateTime;

@Entity
@Table(name = "media_files", uniqueConstraints = {
        @UniqueConstraint(name = "uk_media_files_storage_key", columnNames = "storage_key")
}, indexes = {
        @Index(name = "idx_media_files_user_status", columnList = "user_id, upload_status")
})
public class MediaFile extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false, foreignKey = @ForeignKey(name = "fk_media_files_user"))
    private User user;

    @Column(name = "storage_key", nullable = false, length = 512)
    private String storageKey;

    @Column(name = "original_filename", nullable = false, length = 255)
    private String originalFilename;

    @Column(name = "content_type", nullable = false, length = 100)
    private String contentType;

    @Column(name = "size_bytes", nullable = false)
    private long sizeBytes;

    @Enumerated(EnumType.STRING)
    @Column(name = "upload_status", nullable = false, length = 20)
    private UploadStatus uploadStatus;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    protected MediaFile() {
    }

    public MediaFile(
            User user,
            String storageKey,
            String originalFilename,
            String contentType,
            long sizeBytes) {
        this.user = user;
        this.storageKey = storageKey;
        this.originalFilename = originalFilename;
        this.contentType = contentType;
        this.sizeBytes = sizeBytes;
        this.uploadStatus = UploadStatus.PENDING;
    }

    public void completeUpload() {
        uploadStatus = UploadStatus.COMPLETED;
    }

    public void failUpload() {
        uploadStatus = UploadStatus.FAILED;
    }

    public void delete() {
        deletedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public String getStorageKey() {
        return storageKey;
    }

    public String getOriginalFilename() {
        return originalFilename;
    }

    public String getContentType() {
        return contentType;
    }

    public long getSizeBytes() {
        return sizeBytes;
    }

    public UploadStatus getUploadStatus() {
        return uploadStatus;
    }

    public LocalDateTime getDeletedAt() {
        return deletedAt;
    }
}