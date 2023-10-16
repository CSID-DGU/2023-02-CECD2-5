package com.vegetable.veggiehunter.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;
    private String nickname;

    private String email;

    private String socialId;

    private String refreshToken;

    @Enumerated(EnumType.STRING)
    private Role role;

    public void updateRefreshToken(String updateRefreshToken) {
        this.refreshToken = updateRefreshToken;
    }

    //Sign up
    public void signUp(String nickname) {
        this.nickname = nickname;
    }

    public void logout() {
        this.refreshToken = null;
    }
}
