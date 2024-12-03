package dev.jinwoo.cryptotalk.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;
import java.util.UUID;

@Entity(name = "tb_message")
@Data
public class Message {
    @Id
    String id = UUID.randomUUID().toString();
    @Column(name = "sender")
    String from;
    @Column(name = "recipient")
    String to;
    String data;
    Date date;
}
