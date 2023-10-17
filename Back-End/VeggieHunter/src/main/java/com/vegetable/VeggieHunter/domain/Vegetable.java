package com.vegetable.veggiehunter.domain;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Vegetable {
    @Id @GeneratedValue
    private Long id;

    private String name;

    private String image;

    @Lob
    private String storageMethod;

}
