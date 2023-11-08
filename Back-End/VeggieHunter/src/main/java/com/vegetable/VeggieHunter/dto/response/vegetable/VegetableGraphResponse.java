package com.vegetable.veggiehunter.dto.response.vegetable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class VegetableGraphResponse {
    private String unit;
    private LocalDate date;
    private Double price;
}
