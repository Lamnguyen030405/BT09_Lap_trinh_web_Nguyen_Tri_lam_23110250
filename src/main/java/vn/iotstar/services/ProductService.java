package vn.iotstar.services;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entities.Category;
import vn.iotstar.entities.Product;
import vn.iotstar.entities.User;
import vn.iotstar.repositories.CategoryRepository;
import vn.iotstar.repositories.ProductRepository;
import vn.iotstar.repositories.UserRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProductService {
    
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
    
    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }
    
    public List<Product> getProductsSortedByPrice() {
        return productRepository.findAllByOrderByPriceAsc();
    }
    
    public List<Product> getProductsByCategory(Long categoryId) {
        return productRepository.findByCategoryId(categoryId);
    }
    
    @Transactional
    public Product createProduct(String title, Integer quantity, String desc, 
                                Double price, Long userId, Long categoryId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Product product = Product.builder()
                .title(title)
                .quantity(quantity)
                .desc(desc)
                .price(price)
                .user(user)
                .build();
        
        if (categoryId != null) {
            Category category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new RuntimeException("Category not found"));
            product.setCategory(category);
        }
        
        return productRepository.save(product);
    }
    
    @Transactional
    public Product updateProduct(Long id, String title, Integer quantity, 
                                String desc, Double price, Long userId, Long categoryId) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        
        product.setTitle(title);
        product.setQuantity(quantity);
        product.setDesc(desc);
        product.setPrice(price);
        
        if (userId != null) {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            product.setUser(user);
        }
        
        if (categoryId != null) {
            Category category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new RuntimeException("Category not found"));
            product.setCategory(category);
        }
        
        return productRepository.save(product);
    }
    
    @Transactional
    public boolean deleteProduct(Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }
}