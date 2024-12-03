package dev.jinwoo.cryptotalk.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity(name="tb_user")
@Data
public class User {
    @Id
    String publicKey;
    String name;
}
