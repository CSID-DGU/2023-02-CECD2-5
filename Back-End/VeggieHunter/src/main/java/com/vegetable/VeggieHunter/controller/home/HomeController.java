package com.vegetable.veggiehunter.controller.home;

import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.recipe.RecipeHighLikesListResponse;
import com.vegetable.veggiehunter.dto.response.today.TodayResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableHighLikesListResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;
import com.vegetable.veggiehunter.service.home.HomeService;
import com.vegetable.veggiehunter.service.recipe.RecipeService;
import com.vegetable.veggiehunter.service.vegetable.VegetableService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/home")
public class HomeController {
    private final HomeService homeService;
    private final VegetableService vegetableService;
    private final RecipeService recipeService;

    @GetMapping("/today")
    public ResponseEntity<CommonResponse.SingleResponse<TodayResponse>> getToday() {
        return ResponseEntity.ok().body(homeService.getToday());
    }
    @GetMapping("/vegetable")
    public ResponseEntity<CommonResponse.ListResponse<VegetableHighLikesListResponse>> getVegetableHighLikesList() {
        return ResponseEntity.ok().body(vegetableService.getVegetableHighLikesList());
    }

    @GetMapping("/recipe")
    public ResponseEntity<CommonResponse.ListResponse<RecipeHighLikesListResponse>> getRecipeHighLikesList() {
        return ResponseEntity.ok().body(recipeService.getRecipeHighLikesList());
    }
}
