package com.ReSourcesRelationnelles.prod.repository;

import com.ReSourcesRelationnelles.prod.entity.Resource;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ResourceRepository extends JpaRepository<Resource, Long> {

    List<Resource> findByActiveTrue();
}