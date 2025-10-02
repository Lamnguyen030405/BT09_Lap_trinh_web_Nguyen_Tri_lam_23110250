package vn.iotstar.repositories;


import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.iotstar.entities.CategoryEntity;

@Repository
public interface ICategoryRepository extends JpaRepository<CategoryEntity, Integer> {
	List<CategoryEntity> findByCatenameContaining(String name);
	
	Page<CategoryEntity> findByCatenameContaining(String name, Pageable pageable);
	
	List<CategoryEntity> findByUserid(int userid);
	
	Optional<CategoryEntity> findByCatename(String name);
}
