package com.vegetable.veggiehunter.service.home;

import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.ResponseService;
import com.vegetable.veggiehunter.dto.response.recipe.RecipeListResponse;
import com.vegetable.veggiehunter.dto.response.today.TodayResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;
import com.vegetable.veggiehunter.repository.recipe.RecipeRepository;
import com.vegetable.veggiehunter.repository.vegetable.VegetableRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class HomeService {
    private final VegetableRepository vegetableRepository;
    private final RecipeRepository recipeRepository;
    private final ResponseService responseService;

    public CommonResponse.SingleResponse<TodayResponse> getToday() {
        VegetableListResponse vegetable = vegetableRepository.getTodayVegetable();
        RecipeListResponse recipe = recipeRepository.getRecipeRandom(vegetable.getId());
        TodayResponse todayResponse = new TodayResponse(vegetable, recipe);

        return responseService.getSingleResponse(HttpStatus.OK.value(), todayResponse);
    }
}
