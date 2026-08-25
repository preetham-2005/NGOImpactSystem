NGO Aid Distribution & Impact Analysis System

Project Description

The NGO Aid Distribution & Impact Analysis System is a web-based application developed to help NGOs manage beneficiary data, track aid distribution, and evaluate the impact of aid provided. The system stores operational data in a database and generates analytical insights to support decision-making.


Objectives

* Register beneficiaries receiving NGO aid
* Record aid distribution details
* Track post-aid improvement of beneficiaries
* Generate summary reports and impact percentages
* Export data for data analysis using Python


Technologies Used

Backend:

* Java (Servlets, JSP)
* JDBC
* MySQL

Frontend:

* HTML
* CSS

Analytics:

* Python
* Pandas
* Matplotlib


User Roles

* Field Officer: Registers beneficiaries and records aid distribution
* Program Manager: Monitors programs and aid effectiveness
* Admin: Views reports and exports data for analysis


Project Folder Structure

NGOImpactSystem/
├── src/
│   ├── model/
│   ├── dao/
│   ├── service/
│   └── util/
├── WebContent/
│   ├── css/
│   ├── pages/
│   └── index.html
├── database/
│   └── ngo_schema.sql
├── reference_data/
│   ├── program_master.csv
│   └── region_master.csv
├── exports/
│   ├── beneficiaries.csv
│   ├── aid_distribution.csv
│   └── post_aid_impact.csv
├── analytics/
│   └── impact_analysis.py
├── documentation/
│   ├── Project_Overview.md
│   ├── Data_Sources.md
│   ├── Database_Design.md
│   ├── Use_Cases.md
│   └── Reports_And_Analytics.md
└── README.md


Application Workflow

1. User enters data through HTML forms
2. Java Servlets process the request
3. Data is stored in MySQL database
4. Reports are generated using JSP
5. Data is exported as CSV files
6. Python scripts analyze the data and generate insights


Reports Generated

* Total beneficiaries
* Total aid distributed
* Beneficiaries improved after aid
* Impact percentage

Impact Percentage Formula:


Impact % = (Improved Beneficiaries / Total Beneficiaries) × 100



Data Source Note

* Program and region data are manually created based on common NGO operations
* Beneficiary and aid data are generated through the application
* No real or sensitive personal data is used


How to Run the Project

1. Import the project into Eclipse or IntelliJ
2. Execute the SQL file to create the database
3. Update database credentials in DBConnection.java
4. Deploy the project on Apache Tomcat
5. Access the application through index.html


Future Enhancements

* Email notifications
* Role-based authentication
* Dashboard charts
* SMS alerts
* Cloud deployment


