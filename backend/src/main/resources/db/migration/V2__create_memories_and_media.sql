CREATE TABLE memories (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    recorded_date DATE NOT NULL,
    memo VARCHAR(500) NULL,
    place_name VARCHAR(255) NULL,
    latitude DECIMAL(10, 7) NULL,
    longitude DECIMAL(10, 7) NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
        ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at DATETIME(6) NULL,

    CONSTRAINT pk_memories PRIMARY KEY (id),

    CONSTRAINT fk_memories_user
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,

    CONSTRAINT ck_memories_location_pair
        CHECK (
            (latitude IS NULL AND longitude IS NULL)
            OR
            (latitude IS NOT NULL AND longitude IS NOT NULL)
        ),

    INDEX idx_memories_user_recorded_date (
        user_id,
        recorded_date DESC,
        id DESC
    ),

    INDEX idx_memories_user_deleted_at (
        user_id,
        deleted_at
    )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE memory_pets (
    memory_id BIGINT NOT NULL,
    pet_id BIGINT NOT NULL,

    CONSTRAINT pk_memory_pets
        PRIMARY KEY (memory_id, pet_id),

    CONSTRAINT fk_memory_pets_memory
        FOREIGN KEY (memory_id)
        REFERENCES memories (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_memory_pets_pet
        FOREIGN KEY (pet_id)
        REFERENCES pets (id)
        ON DELETE RESTRICT,

    INDEX idx_memory_pets_pet (
        pet_id,
        memory_id
    )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE media_files (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    storage_key VARCHAR(512) NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    content_type VARCHAR(100) NOT NULL,
    size_bytes BIGINT NOT NULL,
    upload_status VARCHAR(20) NOT NULL,
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    deleted_at DATETIME(6) NULL,

    CONSTRAINT pk_media_files PRIMARY KEY (id),

    CONSTRAINT uk_media_files_storage_key
        UNIQUE (storage_key),

    CONSTRAINT fk_media_files_user
        FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE RESTRICT,

    CONSTRAINT ck_media_files_size
        CHECK (size_bytes > 0),

    CONSTRAINT ck_media_files_upload_status
        CHECK (
            upload_status IN (
                'PENDING',
                'COMPLETED',
                'FAILED'
            )
        ),

    INDEX idx_media_files_user_status (
        user_id,
        upload_status
    )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE memory_photos (
    memory_id BIGINT NOT NULL,
    media_file_id BIGINT NOT NULL,
    sort_order TINYINT UNSIGNED NOT NULL,

    CONSTRAINT pk_memory_photos
        PRIMARY KEY (memory_id, media_file_id),

    CONSTRAINT uk_memory_photos_order
        UNIQUE (memory_id, sort_order),

    CONSTRAINT fk_memory_photos_memory
        FOREIGN KEY (memory_id)
        REFERENCES memories (id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_memory_photos_media_file
        FOREIGN KEY (media_file_id)
        REFERENCES media_files (id)
        ON DELETE RESTRICT,

    CONSTRAINT ck_memory_photos_sort_order
        CHECK (sort_order BETWEEN 1 AND 10),

    INDEX idx_memory_photos_media_file (
        media_file_id
    )
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;