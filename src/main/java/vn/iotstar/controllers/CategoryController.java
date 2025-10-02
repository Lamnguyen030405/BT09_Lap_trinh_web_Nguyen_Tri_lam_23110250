package vn.iotstar.controllers;

import lombok.RequiredArgsConstructor;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import vn.iotstar.entities.CategoryEntity;
import vn.iotstar.repositories.ICategoryRepository;

import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class CategoryController {
    
    private final ICategoryRepository categoryRepository;
    
    @QueryMapping
    public List<CategoryEntity> getAllCategories() {
        return categoryRepository.findAll();
    }
    
    @QueryMapping
    public CategoryEntity getCategoryById(@Argument int id) {
        return categoryRepository.findById(id).orElse(null);
    }
    
    @QueryMapping
    public List<CategoryEntity> getCategoriesByUser(@Argument int userid) {
        return categoryRepository.findByUserid(userid);
    }
    
    @MutationMapping
    public CategoryEntity createCategory(@Argument Map<String, Object> input) {
        CategoryEntity category = new CategoryEntity();
        category.setCatename((String) input.get("catename"));
        category.setIcon((String) input.get("icon"));
        
        if (input.containsKey("userid")) {
            category.setUserid(((Number) input.get("userid")).intValue());
        }
        
        return categoryRepository.save(category);
    }
    
    @MutationMapping
    public CategoryEntity updateCategory(@Argument int id, @Argument Map<String, Object> input) {
        CategoryEntity category = categoryRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Category not found with id: " + id));
        
        if (input.containsKey("catename")) {
            category.setCatename((String) input.get("catename"));
        }
        if (input.containsKey("icon")) {
            category.setIcon((String) input.get("icon"));
        }
        if (input.containsKey("userid")) {
            category.setUserid(((Number) input.get("userid")).intValue());
        }
        
        return categoryRepository.save(category);
    }
    
    @MutationMapping
    public Boolean deleteCategory(@Argument int id) {
        if (categoryRepository.existsById(id)) {
            categoryRepository.deleteById(id);
            return true;
        }
        return false;
    }
}