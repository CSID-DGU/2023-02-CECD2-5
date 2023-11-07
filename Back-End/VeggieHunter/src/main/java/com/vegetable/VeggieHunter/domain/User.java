package com.vegetable.veggiehunter.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String userId;

    private String userName;

    @Builder
    public User(String userId, String userName) {
        this.userId = userId;
        this.userName = userName;
    }

}
