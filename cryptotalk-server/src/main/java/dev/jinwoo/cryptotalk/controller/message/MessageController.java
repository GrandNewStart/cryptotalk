package dev.jinwoo.cryptotalk.controller.message;

import dev.jinwoo.cryptotalk.controller.message.dto.*;
import dev.jinwoo.cryptotalk.model.Message;
import dev.jinwoo.cryptotalk.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("message")
public class MessageController {

    @Autowired
    private MessageService messageService;

    @PostMapping("/send")
    public ResponseEntity<SendMessageResponseDto> sendMessage(@RequestBody SendMessageRequestDto request) {
        SendMessageResponseDto response = new SendMessageResponseDto();
        HttpStatus status;
        try {
            Message message = messageService.createMessage(
                    request.getFrom(),
                    request.getTo(),
                    request.getData(),
                    request.getSignature()
            );
            MessageDto body = new MessageDto();
            body.setId(message.getId());
            body.setFrom(message.getFrom());
            body.setTo(message.getTo());
            body.setData(message.getData());
            body.setDate(message.getDate().toString());
            response.setBody(body);
            response.setMessage("메시지 전송에 성공했습니다.");
            status = HttpStatus.CREATED;
        } catch (Exception e) {
            e.printStackTrace();
            response.setMessage("메시지 전송에 실패했습니다.");
            status = HttpStatus.INTERNAL_SERVER_ERROR;
        }
        return new ResponseEntity<>(response, status);
    }

    @PostMapping("/get")
    public ResponseEntity<GetMessageResponseDto> getMessage(@RequestBody GetMessageRequestDto request) {
        GetMessageResponseDto response = new GetMessageResponseDto();
        HttpStatus status;
        try {
            List<MessageDto> data = messageService.getMessages(request.getFrom(), request.getTo())
                    .stream().map(e -> {
                        MessageDto dto = new MessageDto();
                        dto.setId(e.getId());
                        dto.setFrom(e.getFrom());
                        dto.setTo(e.getTo());
                        dto.setData(e.getData());
                        dto.setDate(e.getDate().toString());
                        return dto;
                    }).toList();
            response.setMessage("메시지 조회에 성공했습니다.");
            response.setData(data);
            status = HttpStatus.OK;
        } catch (Exception e) {
            e.printStackTrace();
            response.setMessage("메시지 조회에 실패했습니다.");
            response.setData(List.of());
            status = HttpStatus.INTERNAL_SERVER_ERROR;
        }
        return new ResponseEntity<>(response, status);
    }

}