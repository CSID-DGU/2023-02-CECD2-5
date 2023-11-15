package com.vegetable.veggiehunter.controller.recipe;

import com.vegetable.veggiehunter.domain.RecipeSteps;
import com.vegetable.veggiehunter.dto.request.recipe.IngredientRequest;
import com.vegetable.veggiehunter.dto.request.recipe.RecipeRequest;
import com.vegetable.veggiehunter.dto.request.recipe.RecipeStepsRequest;
import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.recipe.*;
import com.vegetable.veggiehunter.service.recipe.RecipeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/recipe")
public class RecipeController {
    private final RecipeService recipeService;

    @GetMapping
    public ResponseEntity<CommonResponse.ListResponse<RecipeVegetableListResponse>> getVegetableList() {
        return ResponseEntity.ok().body(recipeService.getVegetableList());
    }

    @GetMapping("/{vegetableId}")
    public ResponseEntity<CommonResponse.ListResponse<RecipeListResponse>> getRecipeList(@PathVariable Long vegetableId) {
        return ResponseEntity.ok().body(recipeService.getRecipeList(vegetableId));
    }

    @GetMapping("/detail/{recipeId}")
    public ResponseEntity<CommonResponse.SingleResponse<RecipeDetailResponse>> getRecipeDetail(@PathVariable Long recipeId) {
        return ResponseEntity.ok().body(recipeService.getRecipeDetail(recipeId));
    }

    @GetMapping("/steps/{recipeId}")
    public ResponseEntity<CommonResponse.ListResponse<RecipeStepsResponse>> getRecipeSteps(@PathVariable Long recipeId) {
        return ResponseEntity.ok().body(recipeService.getRecipeSteps(recipeId));
    }

    @GetMapping("/ingredient/{recipeId}")
    public ResponseEntity<CommonResponse.ListResponse<IngredientResponse>> getIngredient(@PathVariable Long recipeId) {
        return ResponseEntity.ok().body(recipeService.getIngredient(recipeId));
    }

    @PostMapping(value = "", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<CommonResponse> createRecipe(@RequestPart(value = "recipeRequest")  RecipeRequest recipeRequest,
                                                       @RequestPart(value = "recipeStepsRequestList")  List<RecipeStepsRequest> recipeStepsRequestList,
                                                       @RequestPart(value = "ingredientRequestList")  List<IngredientRequest> ingredientRequestList,
                                                       @RequestPart(required = true) List<MultipartFile> files) {
        return ResponseEntity.ok().body(recipeService.createRecipe(recipeRequest, recipeStepsRequestList, ingredientRequestList, files));
    }


}
