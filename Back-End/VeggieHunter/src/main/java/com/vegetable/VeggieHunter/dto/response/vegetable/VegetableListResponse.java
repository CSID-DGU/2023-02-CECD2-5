package com.vegetable.veggiehunter.dto.response.vegetable;

import com.vegetable.veggiehunter.domain.Vegetable;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class VegetableListResponse {
    private Long id;
    private String name;
    private String image;
    private String unit;
    private Double price;
    private Double rate;


}

