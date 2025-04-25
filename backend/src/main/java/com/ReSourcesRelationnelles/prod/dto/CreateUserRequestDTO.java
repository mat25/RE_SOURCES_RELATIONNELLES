package com.ReSourcesRelationnelles.prod.dto;

public class CreateUserRequestDTO {
    private String name;
    private String firstName;
    private String pseudo;
    private String email;
    private String password;

    public CreateUserRequestDTO() {
    }

    public CreateUserRequestDTO(String name, String firstName, String pseudo, String email, String password) {
        this.name = name;
        this.firstName = firstName;
        this.pseudo = pseudo;
        this.email = email;
        this.password = password;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }


}