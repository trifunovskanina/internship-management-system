package com.trifunovska.internship.web;

import com.trifunovska.internship.model.UserAccount;
import com.trifunovska.internship.dto.UserProfileDTO;
import com.trifunovska.internship.service.UserAccountService;
import com.trifunovska.internship.service.UserProfileService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/profile")
public class UserProfileController {
    private final UserAccountService userAccountService;
    private final UserProfileService userProfileService;

    public UserProfileController(UserAccountService userAccountService, UserProfileService userProfileService) {
        this.userAccountService = userAccountService;
        this.userProfileService = userProfileService;
    }

    @GetMapping()
    public String viewProfile(Authentication authentication,
                              Model model) {

        String username = authentication.getName();
        UserAccount account = userAccountService.findByUsername(username);

        try {
            UserProfileDTO profile = userProfileService.buildProfile(account);
            model.addAttribute("profile", profile);
        } catch (IllegalStateException e) {
            return "redirect:/profile/incomplete";
        }

        return "profile";
    }

    @GetMapping("/incomplete")
    public String incomplete(Authentication authentication, Model model) {
        return "profile-incomplete";
    }
}
