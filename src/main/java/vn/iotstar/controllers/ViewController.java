// ViewController.java
package vn.iotstar.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {
    
    @GetMapping("/")
    public String index() {
        return "index"; // Trả về index.jsp
    }
    
    @GetMapping("/products")
    public String products() {
        return "products"; // Trả về products.jsp
    }
    
    @GetMapping("/users")
    public String users() {
        return "users"; // Trả về users.jsp
    }
    
    @GetMapping("/categories")
    public String categories() {
        return "categories"; // Trả về categories.jsp
    }
}