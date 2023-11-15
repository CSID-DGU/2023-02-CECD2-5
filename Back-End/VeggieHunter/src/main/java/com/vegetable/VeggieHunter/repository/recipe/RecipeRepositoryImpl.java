package com.vegetable.veggiehunter.repository.recipe;

import com.querydsl.core.types.Projections;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.vegetable.veggiehunter.dto.response.recipe.RecipeListResponse;
import com.vegetable.veggiehunter.dto.response.recipe.RecipeVegetableListResponse;

import javax.persistence.EntityManager;
import java.util.List;

import static com.vegetable.veggiehunter.domain.QRecipe.recipe;
import static com.vegetable.veggiehunter.domain.QPhoto.photo;

public class RecipeRepositoryImpl implements RecipeRepositoryCustom{
    private JPAQueryFactory queryFactory;

    public RecipeRepositoryImpl(EntityManager em) {
        this.queryFactory = new JPAQueryFactory(em);
    }


    @Override
    public List<RecipeListResponse> getRecipeList(Long vegetableId) {
        return queryFactory
                .select(Projections.constructor(
                        RecipeListResponse.class,
                        recipe.id,
                        recipe.title,
                        photo.savedFile,
                        recipe.writer,
                        recipe.createdDate
                ))
                .from(recipe)
                .where(recipe.vegetable.id.eq(vegetableId))
                .leftJoin(photo).on(recipe.id.eq(photo.recipe.id))
                .limit(1)
                .fetch();
    }
}
