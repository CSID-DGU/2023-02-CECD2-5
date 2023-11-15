package com.vegetable.veggiehunter.service.S3;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;

@Service
@RequiredArgsConstructor
public class S3Service {

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public String upload(MultipartFile multipartFile) {
        String imageUrl = "";
        String originalFilename = multipartFile.getOriginalFilename();
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(multipartFile.getSize());
        metadata.setContentType(multipartFile.getContentType());

        try (InputStream inputStream = multipartFile.getInputStream()) {
            amazonS3.putObject(new PutObjectRequest(bucket , originalFilename, inputStream, metadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead));
            imageUrl = amazonS3.getUrl(bucket, originalFilename).toString();
        } catch (IOException e) {
            throw new IllegalArgumentException("IMAGE_UPLOAD_ERROR");
        }

        return imageUrl;
    }

    public void deleteFile(String fileName) {
        String objectKey = parseObjectKeyFromUrl(fileName);

        // 삭제
        DeleteObjectRequest deleteObjectRequest = new DeleteObjectRequest(bucket , objectKey);
        amazonS3.deleteObject(deleteObjectRequest);
    }

    private String parseObjectKeyFromUrl(String objectUrl) {
        return objectUrl.substring(objectUrl.lastIndexOf('/') + 1);
    }


}
