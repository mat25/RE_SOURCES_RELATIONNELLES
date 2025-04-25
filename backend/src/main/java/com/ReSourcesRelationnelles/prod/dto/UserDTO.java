package com.ReSourcesRelationnelles.prod.dto;

import com.ReSourcesRelationnelles.prod.entity.User;

import java.time.LocalDateTime;

public class UserDTO {
    private Long id;
    private String name;
    private String firstName;
    private String pseudo;
    private String email;
    private String status;
    private LocalDateTime registrationDate;
    // En minute
    private Integer timeBan;
    private LocalDateTime banDate;

    public UserDTO(User user) {
        this.id = user.getId();
        this.name = user.getName();
        this.firstName = user.getFirstName();
        this.pseudo = user.getPseudo();
        this.email = user.getEmail();
        this.status = user.getStatus();
        this.registrationDate = user.getRegistrationDate();
        this.timeBan = user.getTimeBan();
        this.banDate = user.getBanDate();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getPseudo() {
        return pseudo;
    }

    public void setPseudo(String pseudo) {
        this.pseudo = pseudo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(LocalDateTime registrationDate) {
        this.registrationDate = registrationDate;
    }

    public Integer getTimeBan() {
        return timeBan;
    }

    public void setTimeBan(Integer timeBan) {
        this.timeBan = timeBan;
    }

    public LocalDateTime getBanDate() {
        return banDate;
    }

    public void setBanDate(LocalDateTime banDate) {
        this.banDate = banDate;
    }
}
