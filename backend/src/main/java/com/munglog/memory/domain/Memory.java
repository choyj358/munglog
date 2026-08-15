package com.munglog.memory.domain;

import com.munglog.common.domain.BaseTimeEntity;
import com.munglog.user.domain.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "memories", indexes = {
        @Index(name = "idx_memories_user_recorded_date", columnList = "user_id, recorded_date, id"),
        @Index(name = "idx_memories_user_deleted_at", columnList = "user_id, deleted_at")
})
public class Memory extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false, foreignKey = @ForeignKey(name = "fk_memories_user"))
    private User user;

    @Column(name = "recorded_date", nullable = false)
    private LocalDate recordedDate;

    @Column(length = 500)
    private String memo;

    @Column(name = "place_name", length = 255)
    private String placeName;

    @Column(precision = 10, scale = 7)
    private BigDecimal latitude;

    @Column(precision = 10, scale = 7)
    private BigDecimal longitude;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    protected Memory() {
    }

    public Memory(
            User user,
            LocalDate recordedDate,
            String memo,
            String placeName,
            BigDecimal latitude,
            BigDecimal longitude) {
        this.user = user;
        this.recordedDate = recordedDate;
        this.memo = memo;
        this.placeName = placeName;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public void delete() {
        deletedAt = LocalDateTime.now();
    }

    public void restore() {
        deletedAt = null;
    }

    public Long getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public LocalDate getRecordedDate() {
        return recordedDate;
    }

    public String getMemo() {
        return memo;
    }

    public String getPlaceName() {
        return placeName;
    }

    public BigDecimal getLatitude() {
        return latitude;
    }

    public BigDecimal getLongitude() {
        return longitude;
    }

    public LocalDateTime getDeletedAt() {
        return deletedAt;
    }
}