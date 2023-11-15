package com.vegetable.veggiehunter.repository.recipe;

import com.vegetable.veggiehunter.domain.RecipeSteps;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RecipeStepsRepository extends JpaRepository<RecipeSteps, Long> {
    List<RecipeSteps> findByRecipeId(Long recipeId);
}
