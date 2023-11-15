package com.vegetable.veggiehunter.service.recipe;

import com.amazonaws.services.kms.model.NotFoundException;
import com.vegetable.veggiehunter.domain.*;
import com.vegetable.veggiehunter.dto.request.recipe.IngredientRequest;
import com.vegetable.veggiehunter.dto.request.recipe.RecipeRequest;
import com.vegetable.veggiehunter.dto.request.recipe.RecipeStepsRequest;
import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.ResponseService;
import com.vegetable.veggiehunter.dto.response.recipe.*;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;
import com.vegetable.veggiehunter.repository.photo.PhotoRepository;
import com.vegetable.veggiehunter.repository.recipe.IngredientRepository;
import com.vegetable.veggiehunter.repository.recipe.RecipeRepository;
import com.vegetable.veggiehunter.repository.recipe.RecipeStepsRepository;
import com.vegetable.veggiehunter.repository.vegetable.VegetableRepository;
import com.vegetable.veggiehunter.service.S3.S3Service;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class RecipeService {
    private final S3Service s3Service;
    private final ResponseService responseService;
    private final PhotoRepository photoRepository;
    private final RecipeRepository recipeRepository;
    private final RecipeStepsRepository recipeStepsRepository;
    private final IngredientRepository ingredientRepository;
    private final VegetableRepository vegetableRepository;

    @Transactional
    public CommonResponse.GeneralResponse createRecipe(RecipeRequest recipeRequest,
                                                                      List<RecipeStepsRequest> recipeStepsRequestList,
                                                                      List<IngredientRequest> ingredientRequestList,
                                                                      List<MultipartFile> multipartFileList) {
        Vegetable vegetable = vegetableRepository.findById(recipeRequest.getVegetableId()).orElseThrow(
                () -> new NotFoundException("vegetable not found"));

        Recipe recipe = Recipe.builder()
                .title(recipeRequest.getTitle())
                .writer(recipeRequest.getWriter())
                .vegetable(vegetable)
                .createdDate(LocalDate.now())
                .build();
        recipeRepository.save(recipe);

        List<Photo> photoList = new ArrayList<>();
        for (MultipartFile multipartFile : multipartFileList) {
            Photo photo=Photo.builder()
                    .originFile(multipartFile.getOriginalFilename())
                    .fileSize(multipartFile.getSize())
                    .savedFile(s3Service.upload(multipartFile))
                    .recipe(recipe)
                    .build();
            photoList.add(photo);
        }
        photoRepository.saveAll(photoList);

        List<RecipeSteps> recipeStepsList = new ArrayList<>();
        for (RecipeStepsRequest recipeStepsRequest : recipeStepsRequestList) {
            RecipeSteps recipeSteps = RecipeSteps.builder()
                    .step(recipeStepsRequest.getStep())
                    .content(recipeStepsRequest.getContent())
                    .recipe(recipe)
                    .build();
            recipeStepsList.add(recipeSteps);
        }
        recipeStepsRepository.saveAll(recipeStepsList);

        List<Ingredient> ingredientList = new ArrayList<>();
        for (IngredientRequest ingredientRequest : ingredientRequestList) {
            Ingredient ingredient = Ingredient.builder()
                    .name(ingredientRequest.getName())
                    .amount(ingredientRequest.getAmount())
                    .recipe(recipe)
                    .build();
            ingredientList.add(ingredient);
        }
        ingredientRepository.saveAll(ingredientList);

        return responseService.getGeneralResponse(HttpStatus.OK.value(), "레시피를 등록하였습니다.");
    }

    public CommonResponse.ListResponse<RecipeVegetableListResponse> getVegetableList() {
        List<RecipeVegetableListResponse> result = vegetableRepository.getRecipeVegetableList();
        return responseService.getListResponse(HttpStatus.OK.value(), result);
    }

    public CommonResponse.ListResponse<RecipeListResponse> getRecipeList(Long vegetableId) {
        List<RecipeListResponse> result = recipeRepository.getRecipeList(vegetableId);
        return responseService.getListResponse(HttpStatus.OK.value(), result);
    }

    public CommonResponse.SingleResponse<RecipeDetailResponse> getRecipeDetail(Long recipeId) {
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(()->new NotFoundException("Could not found recipe"));
        List<Photo> photoList = photoRepository.findAllByRecipeId(recipeId);
        RecipeDetailResponse response = new RecipeDetailResponse(recipe, photoList);

        return responseService.getSingleResponse(HttpStatus.OK.value(), response);
    }

    public CommonResponse.ListResponse<RecipeStepsResponse> getRecipeSteps(Long recipeId) {
        List<RecipeSteps> recipeSteps = recipeStepsRepository.findByRecipeId(recipeId);
        List<RecipeStepsResponse> response = recipeSteps.stream()
                .map(r -> new RecipeStepsResponse(r))
                .collect(Collectors.toList());

        return responseService.getListResponse(HttpStatus.OK.value(), response);
    }

    public CommonResponse.ListResponse<IngredientResponse> getIngredient(Long recipeId) {
        List<Ingredient> ingredient = ingredientRepository.findByRecipeId(recipeId);
        List<IngredientResponse> response = ingredient.stream()
                .map(i -> new IngredientResponse(i))
                .collect(Collectors.toList());

        return responseService.getListResponse(HttpStatus.OK.value(), response);
    }
}
