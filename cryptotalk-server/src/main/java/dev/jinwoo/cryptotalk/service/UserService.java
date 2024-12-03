package dev.jinwoo.cryptotalk.service;

import dev.jinwoo.cryptotalk.model.User;

public interface UserService {
    User createUser(String publicKey, String name) throws Exception;
    User getUser(String publicKey) throws Exception;
}
