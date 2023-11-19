package com.vegetable.veggiehunter.controller.likes;

import com.vegetable.veggiehunter.domain.User;
import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.service.likes.RecipeLikesService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/recipeLikes")
public class RecipeLikesController {
    private final RecipeLikesService recipeLikesService;

    @PostMapping
    public ResponseEntity<CommonResponse> getLikesByUserId(@RequestBody User user) {
        System.out.println(user.getUserId());
        System.out.println(user.getUserName());
        return ResponseEntity.ok().body(recipeLikesService.getLikesByUserId(user.getUserId()));
    }

    @PostMapping("/isLikes/{recipeId}")
    public ResponseEntity<CommonResponse> getIsLikesByUserIdAndRecipeId(@RequestBody User user, @PathVariable Long recipeId) {
        System.out.println(user.getUserId());
        System.out.println(user.getUserName());
        return ResponseEntity.ok().body(recipeLikesService.getIsLikesByUserIdAndRecipeId(user.getUserId(), recipeId));
    }

    @PostMapping("/{recipeId}")
    public ResponseEntity<CommonResponse> addLikesToRecipe(@RequestBody User user, @PathVariable Long recipeId){
        System.out.println(user.getUserId());
        System.out.println(user.getUserName());
        return ResponseEntity.ok().body(recipeLikesService.addLikesToRecipe(user.getUserId(), recipeId));
    }

    @DeleteMapping("/{recipeId}")
    public ResponseEntity<CommonResponse> removeLikesFromRecipe(@RequestBody User user, @PathVariable Long recipeId){
        System.out.println(user.getUserId());
        System.out.println(user.getUserName());
        return ResponseEntity.ok().body(recipeLikesService.removeLikesFromRecipe(user.getUserId(), recipeId));
    }
}
