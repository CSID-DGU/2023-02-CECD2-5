package com.vegetable.veggiehunter.dto.request.recipe;

import com.vegetable.veggiehunter.domain.Recipe;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;


@AllArgsConstructor
@NoArgsConstructor
@Getter
public class RecipeRequest {
    private String title;
    private String writer;
    private Long vegetableId;
}
