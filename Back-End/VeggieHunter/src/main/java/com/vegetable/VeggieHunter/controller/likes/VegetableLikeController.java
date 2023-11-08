package com.vegetable.veggiehunter.controller.likes;

import com.vegetable.veggiehunter.domain.User;
import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.service.likes.VegetableLikesService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/vegetableLikes")
public class VegetableLikeController {
    private final VegetableLikesService vegetableLikesService;

    @GetMapping
    public ResponseEntity<CommonResponse> getLikesByUserId(@RequestBody User user) {
        System.out.println(user.getUserId());
        System.out.println(user.getUserName());
        return ResponseEntity.ok().body(vegetableLikesService.getLikesByUserId(user.getUserId()));
    }

    @GetMapping("/{vegetableId}")
    public ResponseEntity<CommonResponse> getIsLikesByUserIdAndVegetableId(@RequestBody User user, @PathVariable Long vegetableId) {
        System.out.println(user.getUserId());
        System.out.println(user.getUserName());
        return ResponseEntity.ok().body(vegetableLikesService.getIsLikesByUserIdAndVegetableId(user.getUserId(), vegetableId));
    }

    @PostMapping("/{vegetableId}")
    public ResponseEntity<CommonResponse> addLikesToVegetable(@RequestBody User user, @PathVariable Long vegetableId){
        System.out.println(user.getUserId());
        System.out.println(user.getUserName());
        return ResponseEntity.ok().body(vegetableLikesService.addLikesToVegetable(user.getUserId(), vegetableId));
    }

    @DeleteMapping("/{vegetableId}")
    public ResponseEntity<CommonResponse> removeLikesFromVegetable(@RequestBody User user, @PathVariable Long vegetableId){
        System.out.println(user.getUserId());
        System.out.println(user.getUserName());
        return ResponseEntity.ok().body(vegetableLikesService.removeLikesFromVegetable(user.getUserId(), vegetableId));
    }
}
