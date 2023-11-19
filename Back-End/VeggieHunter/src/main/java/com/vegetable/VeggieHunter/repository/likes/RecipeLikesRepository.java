package com.vegetable.veggiehunter.repository.likes;

import com.vegetable.veggiehunter.domain.*;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RecipeLikesRepository extends JpaRepository<RecipeLikes, Long> {
    List<RecipeLikes> findAllByUser(User user);

    RecipeLikes findByUserAndRecipe(User users, Recipe recipe);

}
