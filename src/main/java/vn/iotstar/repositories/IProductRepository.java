package vn.iotstar.repositories;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;


import vn.iotstar.entities.ProductEntity;

@Repository
public interface IProductRepository extends JpaRepository<ProductEntity, Long> {

	// Hiển thị tất cả product có price từ thấp đến cao
    @Query("SELECT p FROM ProductEntity p ORDER BY p.unitprice ASC")
    List<ProductEntity> findAllOrderByPriceAsc();
    
    // Lấy tất cả product của 01 category
    List<ProductEntity> findByCategoryCateid(int cateid);
    
    // Tìm theo tên
    List<ProductEntity> findByProductnameContaining(String name);

}
