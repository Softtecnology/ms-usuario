package com.teamsoft.ms.usuario.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.time.LocalDateTime;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "user_app")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_app_generator")
    @SequenceGenerator(
            name = "user_app_generator",
            sequenceName = "user_app_user_app_id_seq", // <-- Nombre exacto de la secuencia en PostgreSQL
            allocationSize = 1
    )
    @Column(name = "user_app_id")
    private Long id;

    @Column(name = "role_id", length = 100, nullable = false)
    private Long roleId ;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "creation_date", nullable = false)
    private Instant creationDate = Instant.now();

    @UpdateTimestamp
    @Column(name = "update_date")
    private LocalDateTime updateDate;

    @Column(name = "status", nullable = false)
    private Boolean status = true;


}
