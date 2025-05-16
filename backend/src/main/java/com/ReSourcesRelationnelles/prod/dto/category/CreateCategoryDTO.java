package com.ReSourcesRelationnelles.prod.dto.category;

import com.ReSourcesRelationnelles.prod.entity.Category;

public class CreateCategoryDTO {
    private String name;

    public CreateCategoryDTO() {}

    public CreateCategoryDTO(Category category) {
        this.name = category.getName();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
