package com.teamsoft.ms.usuario.entities;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "user_detail")
public class UserDetail {

    /**
     * Identificador único para el detalle del usuario.
     * Se genera automáticamente por la base de datos (BIGSERIAL).
     */
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_detail_generator")
    @SequenceGenerator(
            name = "user_detail_generator",
            sequenceName = "user_detail_user_detail_id_seq",
            allocationSize = 1
    )
    private Long userDetailId;


    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_app_id", nullable = false)
    private Long userApp;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "documenttype_id", nullable = false)
    private Long documentType;


    @Column(name = "identificationnumber", length = 20, nullable = false)
    private String identificationNumber;


    @Column(name = "dateofbirth", nullable = false)
    private LocalDate dateOfBirth;


    @Column(name = "firstname", length = 50, nullable = false)
    private String firstName;


    @Column(name = "middlename", length = 50)
    private String middleName;


    @Column(name = "firstlastname", length = 50, nullable = false)
    private String firstLastName;


    @Column(name = "secondlastname", length = 50)
    private String secondLastName;


    @Column(name = "address", length = 250)
    private String address;


}
