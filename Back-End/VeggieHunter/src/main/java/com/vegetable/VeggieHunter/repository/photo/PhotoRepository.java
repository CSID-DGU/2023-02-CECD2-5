package com.vegetable.veggiehunter.repository.photo;

import com.vegetable.veggiehunter.domain.Photo;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PhotoRepository extends JpaRepository<Photo, Long> {
    List<Photo> findAllByRecipeId(Long recipeId);
}
