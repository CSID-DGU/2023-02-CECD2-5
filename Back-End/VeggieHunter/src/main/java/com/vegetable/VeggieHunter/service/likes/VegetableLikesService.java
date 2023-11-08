package com.vegetable.veggiehunter.service.likes;

import com.amazonaws.services.kms.model.NotFoundException;
import com.vegetable.veggiehunter.domain.User;
import com.vegetable.veggiehunter.domain.Vegetable;
import com.vegetable.veggiehunter.domain.VegetableLikes;
import com.vegetable.veggiehunter.dto.response.CommonResponse;
import com.vegetable.veggiehunter.dto.response.ResponseService;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableListResponse;
import com.vegetable.veggiehunter.dto.response.vegetable.VegetableResponse;
import com.vegetable.veggiehunter.repository.likes.VegetableLikesRepository;
import com.vegetable.veggiehunter.repository.user.UserRepository;
import com.vegetable.veggiehunter.repository.vegetable.VegetableRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VegetableLikesService {
    private final UserRepository userRepository;
    private final VegetableLikesRepository vegetableLikesRepository;
    private final VegetableRepository vegetableRepository;
    private final ResponseService responseService;

    public CommonResponse getLikesByUserId(String userId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(()->new NotFoundException("could not found user"));

        List<VegetableLikes> vegetableLikesList = vegetableLikesRepository.findAllByUser(user);
        List<Long> vegetableIdList = new ArrayList<>();

        for (VegetableLikes vegetableLikes : vegetableLikesList) {
            vegetableIdList.add(vegetableLikes.getVegetable().getId());
        }

        List<VegetableListResponse> vegetableListResponseList = vegetableRepository.getVegetableList(vegetableIdList);

        return responseService.getListResponse(HttpStatus.OK.value(), vegetableListResponseList);
    }

    public CommonResponse addLikesToVegetable(String userId, Long vegetableId) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(()->new NotFoundException("could not found user"));

        Vegetable vegetable = vegetableRepository.findById(vegetableId)
                .orElseThrow(()->new NotFoundException("could not found vegetable"));

        VegetableLikes vegetableLikes = VegetableLikes.builder()
                .vegetable(vegetable)
                .user(user)
                .build();
        vegetableLikesRepository.save(vegetableLikes);

        return responseService.getGeneralResponse(HttpStatus.OK.value(), "좋아요 하였습니다.");
    }

    public CommonResponse removeLikesFromVegetable(String userId, Long vegetableId) {

        try {
            Vegetable vegetable = vegetableRepository.findById(vegetableId)
                    .orElseThrow(()->new NotFoundException("could not found vegetable"));
            User user = userRepository.findByUserId(userId)
                    .orElseThrow(()->new NotFoundException("could not found user"));




            VegetableLikes deleteLikes = vegetableLikesRepository.findByUserAndVegetable(user, vegetable);
            if (deleteLikes != null) {
                vegetableLikesRepository.delete(deleteLikes);
                return responseService.getGeneralResponse(HttpStatus.OK.value(), "좋아요가 삭제 되었습니다.");
            } else {
                return responseService.getGeneralResponse(HttpStatus.NOT_FOUND.value(), "좋아요를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            return responseService.getGeneralResponse(HttpStatus.BAD_REQUEST.value(),"잘못된 요청입니다.");
        }
    }

    public CommonResponse getIsLikesByUserIdAndVegetableId(String userId, Long vegetableId) {
        boolean isLikes = false;
        Vegetable vegetable = vegetableRepository.findById(vegetableId)
                .orElseThrow(()->new NotFoundException("could not found vegetable"));
        User user = userRepository.findByUserId(userId)
                .orElseThrow(()->new NotFoundException("could not found user"));


        VegetableLikes vegetableLikes = vegetableLikesRepository.findByUserAndVegetable(user, vegetable);
        if (vegetableLikes != null) {
            isLikes = true;
        }
        return responseService.getSingleResponse(HttpStatus.OK.value(), isLikes);
    }
}
