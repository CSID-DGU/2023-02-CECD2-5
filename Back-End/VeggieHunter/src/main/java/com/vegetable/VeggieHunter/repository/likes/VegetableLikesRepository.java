package com.vegetable.veggiehunter.repository.likes;

import com.vegetable.veggiehunter.domain.User;
import com.vegetable.veggiehunter.domain.Vegetable;
import com.vegetable.veggiehunter.domain.VegetableLikes;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VegetableLikesRepository extends JpaRepository<VegetableLikes, Long> {
    List<VegetableLikes> findAllByUser(User user);


    VegetableLikes findByUserAndVegetable(User users, Vegetable vegetable);
}
