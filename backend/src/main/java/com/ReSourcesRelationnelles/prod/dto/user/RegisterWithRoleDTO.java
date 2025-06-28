package com.ReSourcesRelationnelles.prod.dto.user;

import com.ReSourcesRelationnelles.prod.entity.RoleEnum;
import jakarta.validation.constraints.NotNull;

public class RegisterWithRoleDTO extends RegisterDTO {

    @NotNull(message = "Le rôle est obligatoire.")
    private RoleEnum role;

    public RegisterWithRoleDTO() {
        super();
    }

    public RegisterWithRoleDTO(String name, String firstName, String username, String email, String password, RoleEnum role) {
        super(name, firstName, username, email, password);
        this.role = role;
    }


    public RoleEnum getRole() {
        return role;
    }

    public void setRole(RoleEnum role) {
        this.role = role;
    }
}