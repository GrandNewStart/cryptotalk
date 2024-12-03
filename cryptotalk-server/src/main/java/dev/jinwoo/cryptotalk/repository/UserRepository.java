package dev.jinwoo.cryptotalk.repository;

import dev.jinwoo.cryptotalk.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, String> { }
