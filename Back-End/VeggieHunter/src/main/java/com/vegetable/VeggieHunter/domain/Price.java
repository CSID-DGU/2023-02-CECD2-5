package com.vegetable.veggiehunter.domain;

import jakarta.persistence.*;
import lombok.Getter;

@Entity
@Getter
public class Price extends BaseTime {
    @Id
    @GeneratedValue
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vegetable_name")
    private Vegetable vegetable;

    private Double price;

    private String unit;

}
