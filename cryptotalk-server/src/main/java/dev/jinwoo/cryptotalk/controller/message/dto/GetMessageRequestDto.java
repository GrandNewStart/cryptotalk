package dev.jinwoo.cryptotalk.controller.message.dto;

import lombok.Data;

@Data
public class GetMessageRequestDto {
    String from;
    String to;
}
