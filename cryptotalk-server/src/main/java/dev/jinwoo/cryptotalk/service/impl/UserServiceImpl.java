package dev.jinwoo.cryptotalk.service.impl;

import dev.jinwoo.cryptotalk.model.User;
import dev.jinwoo.cryptotalk.repository.UserRepository;
import dev.jinwoo.cryptotalk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public User createUser(String publicKey, String name) throws Exception {
        User user = new User();
        user.setName(name);
        user.setPublicKey(publicKey);
        return userRepository.save(user);
    }

    @Override
    public User getUser(String publicKey) throws Exception {
        return userRepository.findById(publicKey).orElseThrow();
    }
}
