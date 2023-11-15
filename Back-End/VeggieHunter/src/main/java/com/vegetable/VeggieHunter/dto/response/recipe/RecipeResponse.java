package com.vegetable.veggiehunter.dto.response.recipe;

import com.vegetable.veggiehunter.domain.*;
import lombok.Builder;
import lombok.Getter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class RecipeResponse {
    private String title;

    private String writer;

    private Vegetable vegetable;

    private List<Ingredient> ingredientList;

    private List<RecipeSteps> recipeStepsList;

    private List<String> photoList;

    public RecipeResponse(Recipe recipe) {
        this.title = recipe.getTitle();
        this.writer = recipe.getWriter();
        this.vegetable = recipe.getVegetable();
        this.ingredientList = recipe.getIngredientList();
        this.recipeStepsList = recipe.getRecipeStepsList();
        this.photoList = recipe.getPhotoList()
                .stream()
                .map(photo -> photo.getSavedFile())
                .filter(fileUrl -> fileUrl != null)
                .collect(Collectors.toList());
    }
}
