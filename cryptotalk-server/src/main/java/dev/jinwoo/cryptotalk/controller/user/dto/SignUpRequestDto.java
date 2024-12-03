package dev.jinwoo.cryptotalk.controller.user.dto;

import lombok.Data;

@Data
public class SignUpRequestDto {
    String name;
    String publicKey;
}
