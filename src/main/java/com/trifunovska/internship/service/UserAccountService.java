package com.trifunovska.internship.service;

import com.trifunovska.internship.model.UserAccount;
import com.trifunovska.internship.model.enums.Role;
import com.trifunovska.internship.repository.UserAccountRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class UserAccountService {
    private final UserAccountRepository userAccountRepository;

    public UserAccountService(UserAccountRepository userAccountRepository) {
        this.userAccountRepository = userAccountRepository;
    }

    public UserAccount findByUsername(String username) {
        return userAccountRepository.findByUsername(username).orElseThrow();
    }

    public List<UserAccount> findAll() {
        return userAccountRepository.findAll();
    }

    public UserAccount findById(Integer id) {
        return userAccountRepository.findById(id).orElseThrow();
    }

    @Transactional
    public void toggleEnabled(Integer id) {
        UserAccount userAccount = findById(id);
        userAccount.setEnabled(!userAccount.getEnabled());
        userAccountRepository.save(userAccount);
    }

    @Transactional
    public void updateRole(Integer id, Role role) {
        UserAccount user = findById(id);
        user.setRole(role);
        userAccountRepository.save(user);
    }
}
