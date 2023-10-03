package com.vegetable.VeggieHunter.dto.response.vegetable;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
public class VegetableListResponse {
    private String name;
    private String image;
    private Double price;
    private Double rate;
}
