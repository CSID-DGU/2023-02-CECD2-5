package com.vegetable.veggiehunter.repository.recipe;

import com.vegetable.veggiehunter.dto.response.recipe.RecipeListResponse;

import java.util.List;

public interface RecipeRepositoryCustom {
    List<RecipeListResponse> getRecipeList(Long vegetableId);
}
