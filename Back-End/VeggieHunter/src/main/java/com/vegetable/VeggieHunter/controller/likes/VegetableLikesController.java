package com.vegetable.VeggieHunter.controller.likes;

import com.vegetable.VeggieHunter.dto.response.CommonResponse;
import com.vegetable.VeggieHunter.service.like.VegetableLikesService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/vegetableLikes")
@RequiredArgsConstructor
public class VegetableLikesController {
    private final VegetableLikesService vegetableLikesService;

    @PostMapping("/{vegetableId}")
    public ResponseEntity<CommonResponse> addLikesToVegetable(@PathVariable Long vegetableId){
        return ResponseEntity.ok().body(vegetableLikesService.addLikesToVegetable(vegetableId));
    }

    @DeleteMapping("/{vegetableId}")
    public ResponseEntity<CommonResponse> removeLikesToVegetable(@PathVariable Long vegetableId){
        return ResponseEntity.ok().body(vegetableLikesService.removeLikesFromVegetable(vegetableId));
    }
}
