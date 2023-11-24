package com.vegetable.veggiehunter.repository.recipe;

import com.querydsl.core.types.Projections;
import com.querydsl.core.types.SubQueryExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.vegetable.veggiehunter.dto.response.likes.RecipeLikesListResponse;
import com.vegetable.veggiehunter.dto.response.recipe.RecipeHighLikesListResponse;
import com.vegetable.veggiehunter.dto.response.recipe.RecipeListResponse;

import javax.persistence.EntityManager;
import java.util.List;

import static com.vegetable.veggiehunter.domain.QRecipe.recipe;
import static com.vegetable.veggiehunter.domain.QPhoto.photo;
import static com.vegetable.veggiehunter.domain.QRecipeLikes.recipeLikes;

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
                .leftJoin(photo)
                .on(recipe.id.eq(photo.recipe.id)
                        .and(photo.id.eq(
                                JPAExpressions
                                        .select(photo.id.min())
                                        .from(photo)
                                        .where(photo.recipe.id.eq(recipe.id))
                        ))
                )
                .fetch();
    }

    @Override
    public List<RecipeLikesListResponse> getRecipeLikesList(List<Long> recipeIdList) {
        Boolean isLikes = true;

        return queryFactory
                .select(
                        Projections.constructor(
                                RecipeLikesListResponse.class,
                                recipe.id,
                                recipe.title,
                                photo.savedFile,
                                Expressions.constant(isLikes)
                        )
                )
                .from(recipe)
                .where(recipe.id.in(recipeIdList))
                .leftJoin(photo).on(recipe.id.eq(photo.recipe.id)
                        .and(photo.id.eq(
                                JPAExpressions
                                        .select(photo.id.min())
                                        .from(photo)
                                        .where(photo.recipe.id.eq(recipe.id))
                        ))
                )
                .fetch();

    }

    @Override
    public List<RecipeHighLikesListResponse> getRecipeHighLikesList() {
        return queryFactory
                .select(
                        Projections.constructor(
                                RecipeHighLikesListResponse.class,
                                recipeLikes.recipe.id,
                                recipeLikes.recipe.title,
                                photo.savedFile,
                                recipeLikes.recipeLikes.count()
                        )
                )
                .from(recipeLikes)
                .leftJoin(photo)
                .on(recipeLikes.recipe.id.eq(photo.recipe.id)
                        .and(photo.id.eq(
                                JPAExpressions
                                        .select(photo.id.max())
                                        .from(photo)
                                        .where(photo.recipe.id.eq(recipeLikes.recipe.id))
                        ))
                )
                .groupBy(recipeLikes.recipe.id, recipeLikes.recipe.title, photo.savedFile)
                .orderBy(recipeLikes.recipeLikes.count().desc())
                .limit(5)
                .fetch();
    }

    @Override
    public RecipeListResponse getRecipeRandom(Long vegetableId) {
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
                .leftJoin(photo)
                .on(recipe.id.eq(photo.recipe.id)
                        .and(photo.id.eq(
                                JPAExpressions
                                        .select(photo.id.max())
                                        .from(photo)
                                        .where(photo.recipe.id.eq(recipe.id))
                        ))
                )
                .orderBy(Expressions.numberTemplate(Double.class, "function('rand')").asc())
                .fetchFirst();
    }
}
