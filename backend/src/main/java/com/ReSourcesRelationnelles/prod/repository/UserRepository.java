package com.ReSourcesRelationnelles.prod.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ReSourcesRelationnelles.prod.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    boolean existsByEmailAndDeletedFalse(String email);

    User findByUsernameAndDeletedFalse(String username);
    boolean existsByUsernameAndDeletedFalse(String username);

    Optional<User> findByIdAndDeletedFalse(Long id);

    List<User> findAllByDeletedFalse();
}