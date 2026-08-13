package com.munglog.pet.domain;

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

import java.time.LocalDateTime;

@Entity
@Table(name = "pets", indexes = {
        @Index(name = "idx_pets_user_deleted_at", columnList = "user_id, deleted_at")
})
public class Pet extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false, foreignKey = @ForeignKey(name = "fk_pets_user"))
    private User user;

    @Column(nullable = false, length = 20)
    private String name;

    @Column(name = "profile_image_url", length = 2048)
    private String profileImageUrl;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    protected Pet() {
    }

    public Pet(
            User user,
            String name,
            String profileImageUrl) {
        this.user = user;
        this.name = name;
        this.profileImageUrl = profileImageUrl;
    }

    public void changeName(String name) {
        this.name = name;
    }

    public void changeProfileImage(String profileImageUrl) {
        this.profileImageUrl = profileImageUrl;
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

    public String getName() {
        return name;
    }

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public LocalDateTime getDeletedAt() {
        return deletedAt;
    }
}