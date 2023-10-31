package com.vegetable.veggiehunter.domain;

import lombok.Getter;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

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
