package vn.iotstar.services;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entities.Category;
import vn.iotstar.entities.User;
import vn.iotstar.repositories.CategoryRepository;
import vn.iotstar.repositories.UserRepository;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class UserService {
    
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }
    
    @Transactional
    public User createUser(String fullname, String email, String password, 
                          String phone, List<Long> categoryIds) {
        User user = User.builder()
                .fullname(fullname)
                .email(email)
                .password(password)
                .phone(phone)
                .build();
        
        if (categoryIds != null && !categoryIds.isEmpty()) {
            Set<Category> categories = new HashSet<>(categoryRepository.findAllById(categoryIds));
            user.setCategories(categories);
        }
        
        return userRepository.save(user);
    }
    
    @Transactional
    public User updateUser(Long id, String fullname, String email, 
                          String password, String phone, List<Long> categoryIds) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        user.setFullname(fullname);
        user.setEmail(email);
        if (password != null && !password.isEmpty()) {
            user.setPassword(password);
        }
        user.setPhone(phone);
        
        if (categoryIds != null) {
            Set<Category> categories = new HashSet<>(categoryRepository.findAllById(categoryIds));
            user.setCategories(categories);
        }
        
        return userRepository.save(user);
    }
    
    @Transactional
    public boolean deleteUser(Long id) {
        if (userRepository.existsById(id)) {
            userRepository.deleteById(id);
            return true;
        }
        return false;
    }
}