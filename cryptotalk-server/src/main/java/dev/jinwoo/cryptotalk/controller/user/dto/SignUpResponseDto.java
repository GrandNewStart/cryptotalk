package dev.jinwoo.cryptotalk.controller.user.dto;

import lombok.Data;

@Data
public class SignUpResponseDto {
    String message;
    Body body;

    @Data
    public static class Body {
        Integer id;
        String name;
        String publicKey;
    }
}
