package dev.jinwoo.cryptotalk.controller.user;

import dev.jinwoo.cryptotalk.controller.user.dto.*;
import dev.jinwoo.cryptotalk.model.User;
import dev.jinwoo.cryptotalk.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("user")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<SignUpResponseDto> register(@RequestBody SignUpRequestDto request) {
        SignUpResponseDto response = new SignUpResponseDto();
        HttpStatus status;
        try {
            User user = userService.createUser(request.getPublicKey(), request.getName());
            response.setMessage("등록 성공");
            SignUpResponseDto.Body body = new SignUpResponseDto.Body();
            body.setName(user.getName());
            body.setPublicKey(user.getPublicKey());
            response.setBody(body);
            status = HttpStatus.CREATED;
        } catch (Exception e) {
            response.setMessage("등록 실패");
            status = HttpStatus.INTERNAL_SERVER_ERROR;
        }
        return new ResponseEntity<>(response, status);
    }


    @GetMapping
    public ResponseEntity<GetUserResponseDto> getUser(@RequestParam("publicKey") String publicKey) {
        GetUserResponseDto response = new GetUserResponseDto();
        HttpStatus status;
        try {
            User user = userService.getUser(publicKey);
            response.setMessage("유저 조회 성공");
            GetUserResponseDto.Body body = new GetUserResponseDto.Body();
            body.setPublicKey(user.getPublicKey());
            body.setName(user.getName());
            response.setBody(body);
            status = HttpStatus.OK;
        } catch (Exception e) {
            e.printStackTrace();
            response.setMessage("유저 조회 실패");
            status = HttpStatus.INTERNAL_SERVER_ERROR;
        }
        return new ResponseEntity<>(response, status);
    }

}
