package com.munglog.media.infrastructure;

import com.munglog.media.domain.MediaFile;
import com.munglog.media.domain.UploadStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MediaFileRepository
        extends JpaRepository<MediaFile, Long> {

    List<MediaFile> findAllByIdInAndUser_IdAndUploadStatusAndDeletedAtIsNull(
            List<Long> mediaFileIds,
            Long userId,
            UploadStatus uploadStatus);
}