package com.vegetable.veggiehunter.dto.request.recipe;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class RecipeStepsRequest {
    private Long step;
    private String content;
}
