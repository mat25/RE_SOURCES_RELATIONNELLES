package com.ReSourcesRelationnelles.prod.dto.user;

import com.ReSourcesRelationnelles.prod.entity.RoleEnum;
import jakarta.validation.constraints.NotNull;

public class RegisterWithRoleDTO extends RegisterDTO {

    @NotNull(message = "Le rôle est obligatoire.")
    private RoleEnum role;

    public RoleEnum getRole() {
        return role;
    }

    public void setRole(RoleEnum role) {
        this.role = role;
    }
}