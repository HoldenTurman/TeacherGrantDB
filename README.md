# TeacherGrantDB
A simple yet practical database project built to help teachers track their grants and spending — while giving you hands‑on experience with SQL and relational database design.

## Project Purpose
This project was created to:  
- Give you (as a Computer Science student) a real‑world style database project for honing your SQL skills.  
- Provide a usable tool for teachers to monitor grants, how much they spend, and stay organized.  
- Explore core concepts like tables, relationships, inserts, updates, and queries in a structured way.

## Technology & Setup
- **Database engine:** PostgreSQL  
- **Tools:** Beekeeper Studio or DBeaver to connect and work with the database.  
- **Tables included:**  
  - `teachers`  
  - `grants`  
  - `spending_logs`  

## Database Structure Overview
Here’s a simplified version of how the tables relate:

| Table            | Purpose                                                             |
|-----------------|---------------------------------------------------------------------|
| `teachers`       | Stores each teacher’s information (ID, name, contact, etc)         |
| `grants`         | Tracks individual grants (ID, teacher ID, amount, start / end date)|
| `spending_logs`  | Records spending entries tied to a grant (log ID, grant ID, amount, date, description) |

### Example Relationships
- One teacher → can have many grants  
- One grant → can have many spending logs  
- Spending logs tie back to grants (and thus to the teacher indirectly)
