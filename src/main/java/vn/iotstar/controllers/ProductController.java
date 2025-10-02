// ProductController.java
package vn.iotstar.controllers;

import lombok.RequiredArgsConstructor;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import vn.iotstar.entities.CategoryEntity;
import vn.iotstar.entities.ProductEntity;
import vn.iotstar.repositories.ICategoryRepository;
import vn.iotstar.repositories.IProductRepository;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ProductController {
    
    private final IProductRepository productRepository;
    private final ICategoryRepository categoryRepository;
    
    @QueryMapping
    public List<ProductEntity> getAllProducts() {
        return productRepository.findAll();
    }
    
    @QueryMapping
    public ProductEntity getProductById(@Argument Long id) {
        return productRepository.findById(id).orElse(null);
    }
    
    @QueryMapping
    public List<ProductEntity> getProductsSortedByPrice() {
        return productRepository.findAllOrderByPriceAsc();
    }
    
    @QueryMapping
    public List<ProductEntity> getProductsByCategory(@Argument int cateid) {
        return productRepository.findByCategoryCateid(cateid);
    }
    
    @QueryMapping
    public List<ProductEntity> searchProducts(@Argument String name) {
        return productRepository.findByProductnameContaining(name);
    }
    
    @MutationMapping
    public ProductEntity createProduct(@Argument Map<String, Object> input) {
        ProductEntity product = new ProductEntity();
        product.setProductname((String) input.get("productname"));
        product.setQuantity(((Number) input.get("quantity")).intValue());
        product.setUnitprice(((Number) input.get("unitprice")).doubleValue());
        product.setDescription((String) input.get("description"));
        product.setImages((String) input.get("images"));
        
        if (input.containsKey("discount")) {
            product.setDiscount(((Number) input.get("discount")).doubleValue());
        } else {
            product.setDiscount(0.0);
        }
        
        product.setStatus(input.containsKey("status") ? 
            ((Number) input.get("status")).shortValue() : (short) 1);
        
        product.setCreatedate(new Date());
        
        if (input.containsKey("cateid") && input.get("cateid") != null) {
            int cateid = ((Number) input.get("cateid")).intValue();
            CategoryEntity category = categoryRepository.findById(cateid)
                .orElseThrow(() -> new RuntimeException("Category not found with id: " + cateid));
            product.setCategory(category);
        }
        
        return productRepository.save(product);
    }
    
    @MutationMapping
    public ProductEntity updateProduct(@Argument Long id, @Argument Map<String, Object> input) {
        ProductEntity product = productRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
        
        if (input.containsKey("productname")) {
            product.setProductname((String) input.get("productname"));
        }
        if (input.containsKey("quantity")) {
            product.setQuantity(((Number) input.get("quantity")).intValue());
        }
        if (input.containsKey("unitprice")) {
            product.setUnitprice(((Number) input.get("unitprice")).doubleValue());
        }
        if (input.containsKey("description")) {
            product.setDescription((String) input.get("description"));
        }
        if (input.containsKey("images")) {
            product.setImages((String) input.get("images"));
        }
        if (input.containsKey("discount")) {
            product.setDiscount(((Number) input.get("discount")).doubleValue());
        }
        if (input.containsKey("status")) {
            product.setStatus(((Number) input.get("status")).shortValue());
        }
        if (input.containsKey("cateid")) {
            int cateid = ((Number) input.get("cateid")).intValue();
            CategoryEntity category = categoryRepository.findById(cateid)
                .orElseThrow(() -> new RuntimeException("Category not found"));
            product.setCategory(category);
        }
        
        return productRepository.save(product);
    }
    
    @MutationMapping
    public Boolean deleteProduct(@Argument Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }
}