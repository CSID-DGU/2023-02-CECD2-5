package com.vegetable.VeggieHunter.controller.vegetable;

import com.vegetable.VeggieHunter.dto.response.CommonResponse;
import com.vegetable.VeggieHunter.dto.response.vegetable.VegetableListResponse;
import com.vegetable.VeggieHunter.repository.vegetable.VegetableRepository;
import com.vegetable.VeggieHunter.service.vegetable.VegetableService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/vegetable")
public class VegetableController {
    private final VegetableService vegetableService;
    @GetMapping
    public ResponseEntity<CommonResponse.ListResponse<VegetableListResponse>> getVegetableList() {
        return ResponseEntity.ok().body(vegetableService.getVegetableList());
    }
}
