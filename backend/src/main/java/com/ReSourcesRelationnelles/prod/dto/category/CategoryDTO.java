package com.ReSourcesRelationnelles.prod.dto.category;

import com.ReSourcesRelationnelles.prod.entity.Category;

public class CategoryDTO {
    private Long id;
    private String name;
    private Boolean active;

    public CategoryDTO() {}

    public CategoryDTO(Category category) {
        this.id = category.getId();
        this.name = category.getName();
        this.active = category.isActive();
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

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }
}
