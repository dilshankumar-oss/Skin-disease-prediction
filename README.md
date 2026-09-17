# 🏥 Skin Disease Analysis & J2EE Web System

A comprehensive J2EE Web Application built with **Tomcat 10+ (Jakarta EE)**, **Servlets 6.0**, **JSP**, **Custom Tags**, and a **Dual Database Architecture** (Oracle DB with automatic embedded H2 DB fallback).

---

## 🚀 Key Features & Assignment Modules

1. **Skin Disease Patient Analysis CRUD System** (`/AnalysisServlet`)
   - Interactive diagnosis & record management for dermatological cases.
2. **To-Do Application using Servlets & JDBC** (`/TodoServlet`)
   - Full task management interface with status tracking.
3. **Student Record Management System** (`/StudentServlet`)
   - Complete CRUD operations for student profiles.
4. **Factorial Calculation in JSP** (`factorial.jsp`)
   - JSP page demonstrating recursive math functions.
5. **Method Overloading in JSP** (`overloading.jsp`)
   - Demonstrating function overloading directly within JSP declarations.
6. **Bean Parameter Display** (`usebean_demo.jsp`)
   - Using `<jsp:useBean>` and `<jsp:setProperty>` / `<jsp:getProperty>`.
7. **Custom Tag Libraries** (`custom_tag.jsp`)
   - Custom JSP tag handler (`<app:currentDate />`) and tag file components.
8. **Session & Implicit Objects Demo** (`session_demo.jsp`)
   - Demonstrating HTTP session state management and JSP implicit objects (`request`, `session`, `application`).
9. **Servlet Lifecycle Handler** (`/ServletLifeCycleDemo`)
   - Live demonstration of `init()`, `service()`, and `destroy()` lifecycle events.

---

## ⚙️ Zero-Configuration Database Setup

The project features a **Smart Auto-Fallback Database System**:
- **Oracle DB**: Connection is attempted automatically (`jdbc:oracle:thin:@localhost:1521:xe`).
- **Embedded H2 Database (Fallback)**: If Oracle DB is not running or installed, the application **automatically connects to an embedded H2 database** in Oracle compatibility mode.
- **Auto-Schema Creation**: Tables (`LOGIN`, `STUDENT`, `DISEASE_ANALYSIS`, `TODO`) and sample data are **automatically generated on first run**. No manual SQL script execution required!

---

## 🛠️ How to Run

### Option 1: Run with Apache Tomcat 10+ (Recommended)
1. Download or clone this repository:
   ```bash
   git clone https://github.com/dilshankumar-oss/Skin-disease-prediction.git
   ```
2. Copy the contents of `src/main/webapp` into your Tomcat `webapps/SkinDiseaseAnalysis` folder.
3. Start Tomcat and visit:
   ```
   http://localhost:8080/SkinDiseaseAnalysis/
   ```

### Option 2: Import in Eclipse IDE
1. Open Eclipse -> **File** -> **Import** -> **Existing Projects into Workspace**.
2. Select the cloned folder `Skin-disease-prediction`.
3. Right click project -> **Run As** -> **Run on Server** (Select Tomcat v10.1).

### Option 3: Build with Maven
```bash
mvn clean package
```
This generates `target/SkinDiseaseAnalysis.war` ready to deploy on any Servlet container.

---

## 📁 Project Structure

```
SkinDiseaseAnalysis/
├── pom.xml                   # Maven Build File
├── build.bat                 # Windows CLI compilation script
├── schema.sql                # Oracle database initialization script
└── src/
    └── main/
        ├── java/
        │   └── com/skindisease/
        │       ├── db/       # DBConnection.java (Auto-Fallback)
        │       ├── model/    # Java Beans (Student, Patient, Todo, etc.)
        │       ├── servlet/  # Jakarta Servlets
        │       └── tag/      # Custom Tag Handlers
        └── webapp/
            ├── WEB-INF/
            │   ├── web.xml   # Servlet mappings
            │   ├── lib/      # ojdbc11, h2, jakarta.servlet-api JARs
            │   └── classes/  # Pre-compiled .class files
            └── *.jsp         # JSP pages & UI dashboards
```

---

## 🔒 Default Login Credentials

- **Admin User**: `admin` / `admin123`
- **Doctor User**: `doctor` / `derm123`
