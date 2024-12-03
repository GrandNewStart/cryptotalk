package dev.jinwoo.cryptotalk.controller.user.dto;

import lombok.Data;

@Data
public class GetUserResponseDto {
    String message;
    Body body;
    @Data
    public static class Body {
        String publicKey;
        String name;
    }
}
