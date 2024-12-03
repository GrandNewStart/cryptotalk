package dev.jinwoo.cryptotalk.controller.message.dto;

import lombok.Data;

import java.util.List;

@Data
public class GetMessageResponseDto {
    String message;
    List<MessageDto> data;
}
