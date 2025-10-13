package com.teamsoft.ms.usuario.entities;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "document_type")
public class DocumentType {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "document_type_generator")
    @SequenceGenerator(
            name = "document_type_generator",
            sequenceName = "document_type_document_type_id_seq",
            allocationSize = 1
    )
    private Long documentTypeId;

    @Column(name = "description", length = 250, nullable = false)
    private String description;

    @Column(name = "status", nullable = false)
    private Boolean status = true;


}
