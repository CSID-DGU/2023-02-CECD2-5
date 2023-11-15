package com.vegetable.veggiehunter.dto.response.recipe;

import com.vegetable.veggiehunter.domain.RecipeSteps;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class RecipeStepsResponse {

    private Long step;

    private String content;
    public RecipeStepsResponse(RecipeSteps recipeSteps) {
        this.step = recipeSteps.getStep();
        this.content = recipeSteps.getContent();
    }
}
