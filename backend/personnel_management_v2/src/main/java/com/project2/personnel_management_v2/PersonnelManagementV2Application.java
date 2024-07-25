package com.project2.personnel_management_v2;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

//Excluding DataSource auto-configuration because we are not using a database connection for now
@SpringBootApplication(exclude = DataSourceAutoConfiguration.class)
public class PersonnelManagementV2Application {

	public static void main(String[] args) {
		SpringApplication.run(PersonnelManagementV2Application.class, args);
	}

}
