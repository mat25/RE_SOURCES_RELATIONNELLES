package com.ReSourcesRelationnelles.prod.infrastructure;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

@Configuration
public class DatabaseConfig {

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setUrl("jdbc:mysql://localhost:3306/db_re_sources_relationnelles");
        dataSource.setUsername("root");
        dataSource.setPassword("password");
        return dataSource;
    }
}