package com.ReSourcesRelationnelles.prod.dto;

public class UserByIdDTO {
    private Long id;

    public UserByIdDTO(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
