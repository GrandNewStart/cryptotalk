package dev.jinwoo.cryptotalk.controller.message.dto;

import lombok.Data;

@Data
public class MessageDto {
    String id, from, to;
    String data;
    String date;
}
