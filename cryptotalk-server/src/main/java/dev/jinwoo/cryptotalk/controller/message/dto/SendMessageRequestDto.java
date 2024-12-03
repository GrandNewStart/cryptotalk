package dev.jinwoo.cryptotalk.controller.message.dto;

import lombok.Data;

@Data
public class SendMessageRequestDto {
    String from, to, data, signature;
}
