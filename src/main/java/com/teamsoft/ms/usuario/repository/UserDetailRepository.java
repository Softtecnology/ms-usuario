package com.teamsoft.ms.usuario.repository;

import com.teamsoft.ms.usuario.entities.UserDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserDetailRepository extends JpaRepository<UserDetail, Long> {
    Optional<UserDetail> findById(long id);


    Optional<UserDetail> findByidentificationNumber(String identificationNumber);

}

