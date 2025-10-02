package vn.iotstar.controllers;

import lombok.RequiredArgsConstructor;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;
import vn.iotstar.entities.Category;
import vn.iotstar.entities.Product;
import vn.iotstar.entities.User;
import vn.iotstar.services.CategoryService;
import vn.iotstar.services.ProductService;
import vn.iotstar.services.UserService;

import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class GraphQLController {
    
    private final CategoryService categoryService;
    private final UserService userService;
    private final ProductService productService;
    
    // ===== CATEGORY QUERIES =====
    @QueryMapping
    public List<Category> getAllCategories() {
        return categoryService.getAllCategories();
    }
    
    @QueryMapping
    public Category getCategoryById(@Argument Long id) {
        return categoryService.getCategoryById(id).orElse(null);
    }
    
    // ===== USER QUERIES =====
    @QueryMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }
    
    @QueryMapping
    public User getUserById(@Argument Long id) {
        return userService.getUserById(id).orElse(null);
    }
    
    // ===== PRODUCT QUERIES =====
    @QueryMapping
    public List<Product> getAllProducts() {
        return productService.getAllProducts();
    }
    
    @QueryMapping
    public Product getProductById(@Argument Long id) {
        return productService.getProductById(id).orElse(null);
    }
    
    @QueryMapping
    public List<Product> getProductsSortedByPrice() {
        return productService.getProductsSortedByPrice();
    }
    
    @QueryMapping
    public List<Product> getProductsByCategory(@Argument Long categoryId) {
        return productService.getProductsByCategory(categoryId);
    }
    
    // ===== CATEGORY MUTATIONS =====
    @MutationMapping
    public Category createCategory(@Argument Map<String, Object> input) {
        String name = (String) input.get("name");
        String images = (String) input.get("images");
        return categoryService.createCategory(name, images);
    }
    
    @MutationMapping
    public Category updateCategory(@Argument Long id, @Argument Map<String, Object> input) {
        String name = (String) input.get("name");
        String images = (String) input.get("images");
        return categoryService.updateCategory(id, name, images);
    }
    
    @MutationMapping
    public Boolean deleteCategory(@Argument Long id) {
        return categoryService.deleteCategory(id);
    }
    
    // ===== USER MUTATIONS =====
    @MutationMapping
    public User createUser(@Argument Map<String, Object> input) {
        String fullname = (String) input.get("fullname");
        String email = (String) input.get("email");
        String password = (String) input.get("password");
        String phone = (String) input.get("phone");
        List<Long> categoryIds = (List<Long>) input.get("categoryIds");
        return userService.createUser(fullname, email, password, phone, categoryIds);
    }
    
    @MutationMapping
    public User updateUser(@Argument Long id, @Argument Map<String, Object> input) {
        String fullname = (String) input.get("fullname");
        String email = (String) input.get("email");
        String password = (String) input.get("password");
        String phone = (String) input.get("phone");
        List<Long> categoryIds = (List<Long>) input.get("categoryIds");
        return userService.updateUser(id, fullname, email, password, phone, categoryIds);
    }
    
    @MutationMapping
    public Boolean deleteUser(@Argument Long id) {
        return userService.deleteUser(id);
    }
    
    // ===== PRODUCT MUTATIONS =====
    @MutationMapping
    public Product createProduct(@Argument Map<String, Object> input) {
        String title = (String) input.get("title");
        Integer quantity = (Integer) input.get("quantity");
        String desc = (String) input.get("desc");
        Double price = ((Number) input.get("price")).doubleValue();
        Long userId = Long.valueOf(input.get("userId").toString());
        Long categoryId = input.get("categoryId") != null ? 
                Long.valueOf(input.get("categoryId").toString()) : null;
        return productService.createProduct(title, quantity, desc, price, userId, categoryId);
    }
    
    @MutationMapping
    public Product updateProduct(@Argument Long id, @Argument Map<String, Object> input) {
        String title = (String) input.get("title");
        Integer quantity = (Integer) input.get("quantity");
        String desc = (String) input.get("desc");
        Double price = ((Number) input.get("price")).doubleValue();
        Long userId = Long.valueOf(input.get("userId").toString());
        Long categoryId = input.get("categoryId") != null ? 
                Long.valueOf(input.get("categoryId").toString()) : null;
        return productService.updateProduct(id, title, quantity, desc, price, userId, categoryId);
    }
    
    @MutationMapping
    public Boolean deleteProduct(@Argument Long id) {
        return productService.deleteProduct(id);
    }
    
    // ===== SCHEMA MAPPINGS (for nested fields) =====
    @SchemaMapping(typeName = "Product", field = "user")
    public User getProductUser(Product product) {
        return product.getUser();
    }
    
    @SchemaMapping(typeName = "Product", field = "category")
    public Category getProductCategory(Product product) {
        return product.getCategory();
    }
    
    @SchemaMapping(typeName = "User", field = "categories")
    public List<Category> getUserCategories(User user) {
        return List.copyOf(user.getCategories());
    }
    
    @SchemaMapping(typeName = "User", field = "products")
    public List<Product> getUserProducts(User user) {
        return List.copyOf(user.getProducts());
    }
}