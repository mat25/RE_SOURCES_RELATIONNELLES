package com.ReSourcesRelationnelles.prod.repository;

import com.ReSourcesRelationnelles.prod.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    List<Category> findByActiveTrue();
}