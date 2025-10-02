package vn.iotstar.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

import vn.iotstar.entities.UserEntity;

@Repository
public interface IUserRepository extends JpaRepository<UserEntity, Integer>{
	
	Optional<UserEntity> findByUsername(String username);
    Optional<UserEntity> findByEmail(String email);

    // Kiểm tra tồn tại
    boolean existsByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByPhone(String phone);
}
