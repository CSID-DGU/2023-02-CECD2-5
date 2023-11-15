package com.vegetable.veggiehunter.repository.recipe;

import com.vegetable.veggiehunter.domain.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RecipeRepository extends JpaRepository<Recipe, Long>, RecipeRepositoryCustom {
    Optional<Recipe> findById(Long recipeId);
}
