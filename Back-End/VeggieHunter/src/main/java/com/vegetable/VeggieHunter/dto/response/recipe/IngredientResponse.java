package com.vegetable.veggiehunter.dto.response.recipe;

import com.vegetable.veggiehunter.domain.Ingredient;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class IngredientResponse {
    private String name;

    private String amount;
    public IngredientResponse(Ingredient ingredient) {
        this.name = ingredient.getName();
        this.amount = ingredient.getAmount();
    }
}
