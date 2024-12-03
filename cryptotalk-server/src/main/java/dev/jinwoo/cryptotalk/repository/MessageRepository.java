package dev.jinwoo.cryptotalk.repository;

import dev.jinwoo.cryptotalk.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MessageRepository extends JpaRepository<Message, Integer> {
    List<Message> findByFromAndTo(String from, String to);
}
