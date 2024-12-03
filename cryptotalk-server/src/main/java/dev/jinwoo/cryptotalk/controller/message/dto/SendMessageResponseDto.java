package dev.jinwoo.cryptotalk.controller.message.dto;

import lombok.Data;


@Data
public class SendMessageResponseDto {
    String message;
    MessageDto body;
}
