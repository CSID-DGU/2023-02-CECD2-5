package com.vegetable.VeggieHunter.repository.likes;

import com.vegetable.VeggieHunter.domain.VegetableLikes;
import com.vegetable.VeggieHunter.domain.User;
import com.vegetable.VeggieHunter.domain.Vegetable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VegetableLikesRepository extends JpaRepository<VegetableLikes, Long> {
    List<VegetableLikes> findAllByUserId(Long userId);
    VegetableLikes findByUserAndVegetable(User user, Vegetable vegetable);
}
