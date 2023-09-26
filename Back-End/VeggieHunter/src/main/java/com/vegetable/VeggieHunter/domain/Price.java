package com.vegetable.VeggieHunter.domain;

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

    private String item_name;

    private Double price;

    private String unit;
}
