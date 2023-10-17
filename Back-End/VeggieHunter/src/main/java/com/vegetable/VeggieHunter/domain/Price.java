package com.vegetable.veggiehunter.domain;

import com.vegetable.veggiehunter.domain.BaseTime;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
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
