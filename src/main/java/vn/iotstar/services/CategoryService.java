package vn.iotstar.services;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entities.Category;
import vn.iotstar.repositories.CategoryRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CategoryService {
    
    private final CategoryRepository categoryRepository;
    
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }
    
    public Optional<Category> getCategoryById(Long id) {
        return categoryRepository.findById(id);
    }
    
    @Transactional
    public Category createCategory(String name, String images) {
        Category category = Category.builder()
                .name(name)
                .images(images)
                .build();
        return categoryRepository.save(category);
    }
    
    @Transactional
    public Category updateCategory(Long id, String name, String images) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));
        category.setName(name);
        category.setImages(images);
        return categoryRepository.save(category);
    }
    
    @Transactional
    public boolean deleteCategory(Long id) {
        if (categoryRepository.existsById(id)) {
            categoryRepository.deleteById(id);
            return true;
        }
        return false;
    }
}