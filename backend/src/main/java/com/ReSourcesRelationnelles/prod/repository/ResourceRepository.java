package com.ReSourcesRelationnelles.prod.repository;

import com.ReSourcesRelationnelles.prod.entity.Resource;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ResourceRepository extends JpaRepository<Resource, Long> {
}