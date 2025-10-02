package vn.iotstar.controllers;

import lombok.RequiredArgsConstructor;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import vn.iotstar.entities.UserEntity;
import vn.iotstar.repositories.IUserRepository;

import java.sql.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class UserController {
    
    private final IUserRepository userRepository;
    	
    @QueryMapping
    public List<UserEntity> getAllUsers() {
        return userRepository.findAll();
    }
    
    @QueryMapping
    public UserEntity getUserById(@Argument int id) {
        return userRepository.findById(id).orElse(null);
    }
    
    @QueryMapping
    public UserEntity getUserByUsername(@Argument String username) {
        return userRepository.findByUsername(username).orElse(null);
    }
    
    @MutationMapping
    public UserEntity createUser(@Argument Map<String, Object> input) {
        UserEntity user = new UserEntity();
        user.setUsername((String) input.get("username"));
        user.setPassword((String) input.get("password")); // Nên mã hóa trong thực tế
        user.setFullname((String) input.get("fullname"));
        user.setEmail((String) input.get("email"));
        user.setPhone((String) input.get("phone"));
        user.setImage((String) input.get("image"));
        
        if (input.containsKey("roleid")) {
            user.setRoleid(((Number) input.get("roleid")).intValue());
        } else {
            user.setRoleid(2); // Default role: user
        }
        
        if (input.containsKey("status")) {
            user.setStatus(((Number) input.get("status")).intValue());
        } else {
            user.setStatus(1); // Active
        }
        
        user.setCreatedate(new java.sql.Date(System.currentTimeMillis()));
        
        return userRepository.save(user);
    }
    
    @MutationMapping
    public UserEntity updateUser(@Argument int id, @Argument Map<String, Object> input) {
        UserEntity user = userRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
        
        if (input.containsKey("username")) {
            user.setUsername((String) input.get("username"));
        }
        if (input.containsKey("password")) {
            user.setPassword((String) input.get("password"));
        }
        if (input.containsKey("fullname")) {
            user.setFullname((String) input.get("fullname"));
        }
        if (input.containsKey("email")) {
            user.setEmail((String) input.get("email"));
        }
        if (input.containsKey("phone")) {
            user.setPhone((String) input.get("phone"));
        }
        if (input.containsKey("image")) {
            user.setImage((String) input.get("image"));
        }
        if (input.containsKey("roleid")) {
            user.setRoleid(((Number) input.get("roleid")).intValue());
        }
        if (input.containsKey("status")) {
            user.setStatus(((Number) input.get("status")).intValue());
        }
        
        return userRepository.save(user);
    }
    
    @MutationMapping
    public Boolean deleteUser(@Argument int id) {
        if (userRepository.existsById(id)) {
            userRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
