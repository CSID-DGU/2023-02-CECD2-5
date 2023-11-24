package com.vegetable.veggiehunter.repository.vegetable;

import com.vegetable.veggiehunter.domain.Vegetable;
import com.vegetable.veggiehunter.dto.response.likes.VegetableLikesListResponse;
import com.vegetable.veggiehunter.dto.response.recipe.RecipeVegetableListResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableGraphResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableHighLikesListResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;

import java.util.List;

public interface VegetableRepositoryCustom {
    List<VegetableListResponse> getVegetableList();

    List<VegetableListResponse> getVegetableList(List<Long> vegetableIdList);

    List<VegetableLikesListResponse> getVegetableLikesList(List<Long> vegetableIdList);

    List<VegetableGraphResponse> getVegetableGraphList(Long vegetableId);

    List<RecipeVegetableListResponse> getRecipeVegetableList();

    List<VegetableHighLikesListResponse> getVegetableHighLikesList();

    VegetableListResponse getTodayVegetable();
}
