package vn.iotstar.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebViewController {
    
    @GetMapping("/")
    public String index() {
        return "index";
    }
    
    @GetMapping("/products")
    public String products() {
        return "products";
    }
    
    @GetMapping("/categories")
    public String categories() {
        return "categories";
    }
    
    @GetMapping("/users")
    public String users() {
        return "users";
    }
}