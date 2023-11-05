package com.vegetable.veggiehunter.dto.response.vegetable;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class VegetableListResponse {
    private String name;
    private String image;
    private String unit;
    private Double price;
    private Double rate;


}

