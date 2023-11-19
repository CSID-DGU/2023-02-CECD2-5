package com.vegetable.veggiehunter.service.likes;

import com.amazonaws.services.kms.model.NotFoundException;
import com.vegetable.veggiehunter.domain.*;
import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.ResponseService;
import com.vegetable.veggiehunter.dto.response.likes.RecipeLikesListResponse;
import com.vegetable.veggiehunter.repository.likes.RecipeLikesRepository;
import com.vegetable.veggiehunter.repository.recipe.RecipeRepository;
import com.vegetable.veggiehunter.repository.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class RecipeLikesService {
    private final UserRepository userRepository;
    private final RecipeLikesRepository recipeLikesRepository;
    private final RecipeRepository recipeRepository;
    private final ResponseService responseService;

    public CommonResponse getLikesByUserId(String userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(()->new NotFoundException("could not found user"));

        List<RecipeLikes> recipeLikesList = recipeLikesRepository.findAllByUser(user);
        List<Long> recipeIdList = new ArrayList<>();

        for (RecipeLikes recipeLikes : recipeLikesList) {
            recipeIdList.add(recipeLikes.getRecipe().getId());
        }

        List<RecipeLikesListResponse> recipeLikesListResponseList = recipeRepository.getRecipeLikesList(recipeIdList);

        return responseService.getListResponse(HttpStatus.OK.value(), recipeLikesListResponseList);
    }

    public CommonResponse addLikesToRecipe(String userId, Long RecipeId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(()->new NotFoundException("could not found user"));

        Recipe recipe = recipeRepository.findById(RecipeId)
                .orElseThrow(()->new NotFoundException("could not found recipe"));

        RecipeLikes recipeLikes = RecipeLikes.builder()
                .recipe(recipe)
                .user(user)
                .build();
        recipeLikesRepository.save(recipeLikes);

        return responseService.getGeneralResponse(HttpStatus.OK.value(), "좋아요 하였습니다.");
    }

    public CommonResponse removeLikesFromRecipe(String userId, Long vegetableId) {

        try {
            Recipe recipe = recipeRepository.findById(vegetableId)
                    .orElseThrow(()->new NotFoundException("could not found recipe"));
            User user = userRepository.findByUserId(userId)
                    .orElseThrow(()->new NotFoundException("could not found user"));




            RecipeLikes deleteLikes = recipeLikesRepository.findByUserAndRecipe(user, recipe);
            if (deleteLikes != null) {
                recipeLikesRepository.delete(deleteLikes);
                return responseService.getGeneralResponse(HttpStatus.OK.value(), "좋아요가 삭제 되었습니다.");
            } else {
                return responseService.getGeneralResponse(HttpStatus.NOT_FOUND.value(), "좋아요를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            return responseService.getGeneralResponse(HttpStatus.BAD_REQUEST.value(),"잘못된 요청입니다.");
        }
    }

    public CommonResponse getIsLikesByUserIdAndRecipeId(String userId, Long recipeId) {
        boolean isLikes = false;
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(()->new NotFoundException("could not found recipe"));
        User user = userRepository.findByUserId(userId)
                .orElseThrow(()->new NotFoundException("could not found user"));


        RecipeLikes recipeLikes = recipeLikesRepository.findByUserAndRecipe(user, recipe);
        if (recipeLikes != null) {
            isLikes = true;
        }
        return responseService.getSingleResponse(HttpStatus.OK.value(), isLikes);
    }
}
