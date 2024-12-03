package dev.jinwoo.cryptotalk.service;

import dev.jinwoo.cryptotalk.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MessageService {
    Message createMessage(String from, String to, String data, String signature) throws Exception;
    List<Message> getMessages(String from, String to) throws Exception;
}
