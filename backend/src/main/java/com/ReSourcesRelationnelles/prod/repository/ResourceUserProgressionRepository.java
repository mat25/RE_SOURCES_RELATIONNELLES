package com.ReSourcesRelationnelles.prod.repository;

import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.entity.Resource;
import com.ReSourcesRelationnelles.prod.entity.ResourceUserProgression;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ResourceUserProgressionRepository extends JpaRepository<ResourceUserProgression, Long> {
    Optional<ResourceUserProgression> findByUserAndResource(User user, Resource resource);
    List<ResourceUserProgression> findAllByUser(User user);
    List<ResourceUserProgression> findAllByUserAndFavoriteTrue(User user);
    List<ResourceUserProgression> findAllByUserAndExploitedTrue(User user);
    List<ResourceUserProgression> findAllByUserAndSetAsideTrue(User user);
}