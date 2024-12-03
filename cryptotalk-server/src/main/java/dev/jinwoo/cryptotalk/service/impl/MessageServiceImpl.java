package dev.jinwoo.cryptotalk.service.impl;

import dev.jinwoo.cryptotalk.common.CryptoService;
import dev.jinwoo.cryptotalk.common.Utils;
import dev.jinwoo.cryptotalk.model.Message;
import dev.jinwoo.cryptotalk.repository.MessageRepository;
import dev.jinwoo.cryptotalk.repository.UserRepository;
import dev.jinwoo.cryptotalk.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.Date;
import java.util.List;

@Service
public class MessageServiceImpl implements MessageService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CryptoService cryptoService;

    @Autowired
    private MessageRepository messageRepository;

    @Override
    public Message createMessage(String from, String to, String data, String signature) throws Exception {
        boolean isVerified = cryptoService.verify(Utils.hexToBytes(data), Utils.hexToBytes(signature), Utils.hexToBytes(from));
        if (!isVerified) {
            throw new Exception("invalid signature");
        }
        Message message = new Message();
        message.setFrom(from);
        message.setTo(to);
        message.setData(data);
        message.setDate(new Date());
        return messageRepository.save(message);
    }

    @Override
    public List<Message> getMessages(String from, String to) throws Exception {
        if (userRepository.findById(from).isEmpty()) {
            throw new Exception("Sender not found");
        }
        if (userRepository.findById(to).isEmpty()) {
            throw new Exception("Recipient not found");
        }
        List<Message> messages = messageRepository.findByFromAndTo(from, to);
        messages.addAll(messageRepository.findByFromAndTo(to, from));
        messages.sort(Comparator.comparing(Message::getDate));
        return messages;
    }

}
