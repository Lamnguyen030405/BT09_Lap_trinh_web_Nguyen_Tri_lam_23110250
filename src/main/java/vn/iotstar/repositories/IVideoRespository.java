package vn.iotstar.repositories;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.iotstar.entities.VideoEntity;

@Repository
public interface IVideoRespository extends JpaRepository<VideoEntity, Integer>{
	List<VideoEntity> findByTitleContaining(String name);
	
	Page<VideoEntity> findByTitleContaining(String name, Pageable pageable);
}
