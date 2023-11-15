package com.vegetable.veggiehunter.dto.response.recipe;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class RecipeVegetableListResponse {
    private Long id;
    private String name;
    private String image;

}
