package com.ReSourcesRelationnelles.prod.dto.user;

import com.ReSourcesRelationnelles.prod.entity.RoleEnum;

public class RegisterWithRoleDTO extends RegisterDTO {

    private RoleEnum role;

    public RoleEnum getRole() {
        return role;
    }

    public void setRole(RoleEnum role) {
        this.role = role;
    }
}