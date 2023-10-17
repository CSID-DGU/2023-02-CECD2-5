package com.vegetable.veggiehunter.dto.response;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ResponseService {
    //ResponseService
    public CommonResponse.GeneralResponse getGeneralResponse(int code, String msg) {
        return new CommonResponse.GeneralResponse(true, code, msg);
    }

    public <T> CommonResponse.SingleResponse<T> getSingleResponse(int code, T data) {
        return new CommonResponse.SingleResponse<>(true, code, data);
    }

    public <T> CommonResponse.ListResponse<T> getListResponse(int code, List<T> data) {
        return new CommonResponse.ListResponse<>(true, code, data);
    }

}