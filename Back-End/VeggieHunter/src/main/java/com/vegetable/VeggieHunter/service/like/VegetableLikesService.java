package com.vegetable.VeggieHunter.service.like;

import com.amazonaws.services.kms.model.NotFoundException;
import com.vegetable.VeggieHunter.domain.VegetableLikes;
import com.vegetable.VeggieHunter.domain.User;
import com.vegetable.VeggieHunter.domain.Vegetable;
import com.vegetable.VeggieHunter.dto.response.CommonResponse;
import com.vegetable.VeggieHunter.dto.response.ResponseService;
import com.vegetable.VeggieHunter.dto.response.vegetable.VegetableLikesResponse;
import com.vegetable.VeggieHunter.repository.likes.VegetableLikesRepository;
import com.vegetable.VeggieHunter.repository.user.UserRepository;
import com.vegetable.VeggieHunter.repository.vegetable.VegetableRepository;
import com.vegetable.VeggieHunter.util.SecurityUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class VegetableLikesService {
    private final UserRepository userRepository;
    private final VegetableLikesRepository vegetableLikesRepository;
    private final VegetableRepository vegetableRepository;
    private final ResponseService responseService;
    private final SecurityUtil securityUtil;

    public CommonResponse getLikesByUserId() {
        User user = securityUtil.getAuthUserOrThrow();
        List<VegetableLikes> vegetableLikesList = vegetableLikesRepository.findAllByUserId(user.getId());

        List<VegetableLikesResponse> boardResponseList = vegetableLikesList.stream()
                .map(vegetableLikes -> new VegetableLikesResponse(vegetableLikes.getVegetable()))
                .collect(Collectors.toList());

        return responseService.getListResponse(HttpStatus.OK.value(), boardResponseList);
    }

    public CommonResponse addLikesToVegetable(Long vegetableId) {
        User user = securityUtil.getAuthUserOrThrow();
        User chkUser = userRepository.findById(user.getId())
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

    public CommonResponse removeLikesFromVegetable(Long vegetableId) {

        try {
            User user = securityUtil.getAuthUserOrThrow();
            User chkUser = userRepository.findById(user.getId())
                    .orElseThrow(() -> new NotFoundException("could not found user"));

            Vegetable vegetable = vegetableRepository.findById(vegetableId)
                    .orElseThrow(() -> new NotFoundException("could not found board"));


            VegetableLikes deleteVegetableLikes = vegetableLikesRepository.findByUserAndVegetable(user, vegetable);
            if (deleteVegetableLikes != null) {
                vegetableLikesRepository.delete(deleteVegetableLikes);
                return responseService.getGeneralResponse(HttpStatus.OK.value(), "좋아요 게시글이 삭제 되었습니다.");
            } else {
                return responseService.getGeneralResponse(HttpStatus.NOT_FOUND.value(), "좋아요 게시글을 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            return responseService.getGeneralResponse(HttpStatus.BAD_REQUEST.value(),"잘못된 요청입니다.");
        }
    }

}
