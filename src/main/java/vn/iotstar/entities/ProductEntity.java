package vn.iotstar.entities;

import java.io.Serializable;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "products")
public class ProductEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Long productid;

    @Column(name = "product_name", length = 500, nullable = false)
    private String productname;

    @Column(name = "quantity", nullable = false)
    private int quantity;

    @Column(name = "unit_price", nullable = false)
    private double unitprice;

    @Column(name = "images", length = 200)
    private String images;

    @Column(name = "description", length = 500, nullable = false)
    private String description;

    @Column(name = "discount", nullable = false)
    private double discount;

    @Temporal(TemporalType.TIMESTAMP)
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Column(name = "create_date")
    private Date createdate;

    @Column(name = "status", nullable = false)
    private short status;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "cate_id") // ánh xạ đúng cột FK
    private CategoryEntity category;
}
