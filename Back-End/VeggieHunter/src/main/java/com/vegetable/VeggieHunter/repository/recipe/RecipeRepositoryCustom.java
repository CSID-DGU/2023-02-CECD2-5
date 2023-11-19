package com.vegetable.veggiehunter.repository.recipe;

import com.vegetable.veggiehunter.dto.response.likes.RecipeLikesListResponse;
import com.vegetable.veggiehunter.dto.response.recipe.RecipeListResponse;

import java.util.List;

public interface RecipeRepositoryCustom {
    List<RecipeListResponse> getRecipeList(Long vegetableId);
    List<RecipeLikesListResponse> getRecipeLikesList(List<Long> recipeIdList);
}
