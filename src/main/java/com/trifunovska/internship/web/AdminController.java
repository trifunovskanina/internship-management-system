package com.trifunovska.internship.web;

import com.trifunovska.internship.model.UserAccount;
import com.trifunovska.internship.model.enums.Role;
import com.trifunovska.internship.service.UserAccountService;
import jakarta.transaction.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {
    private final UserAccountService userAccountService;

    public AdminController(UserAccountService userAccountService) {
        this.userAccountService = userAccountService;
    }

    @GetMapping("/users")
    public String viewUsers(Authentication authentication,
                            Model model) {

        List<UserAccount> users = userAccountService.findAll();

        model.addAttribute("users", users);
        model.addAttribute("roles", Role.values());

        return "admin-users";
    }

    @PostMapping("/users/{id}/role")
    @Transactional
    public String updateUser(@PathVariable Integer id,
                             @RequestParam Role role) {
        userAccountService.updateRole(id, role);
        return "redirect:/admin/users";
    }

    @PostMapping("/users/{id}/toggle")
    public String toggleUser(@PathVariable int id, Authentication authentication) {
        userAccountService.toggleEnabled(id);
        return "redirect:/admin/users";
    }
}
