package com.vegetable.veggiehunter.domain;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
public class Price extends BaseTime {
    @Id
    @GeneratedValue
    private Long id;

    private String name;

    private Double price;

    private String unit;

}
