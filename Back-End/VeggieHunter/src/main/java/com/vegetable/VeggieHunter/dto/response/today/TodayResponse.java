package com.vegetable.veggiehunter.dto.response.today;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.vegetable.veggiehunter.dto.response.recipe.RecipeListResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;

public class TodayResponse {

    @JsonProperty("vegetable") // JSON에서 사용할 필드 이름
    private VegetableListResponse vegetable;

    @JsonProperty("recipe") // JSON에서 사용할 필드 이름
    private RecipeListResponse recipe;

    public TodayResponse(VegetableListResponse vegetableListResponse, RecipeListResponse recipeListResponse) {
        this.vegetable = vegetableListResponse;
        this.recipe = recipeListResponse;
    }
}
