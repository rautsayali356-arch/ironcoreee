# IronCore Gym Management System

Full Stack Java mini project: JSP + Servlets + JDBC + MySQL + Bootstrap 5.

* **Admin panel** - login, dashboard (total / active / expired members, revenue), members, plans, payments, profile.
* **Public website** - home, plans and pricing, classes and trainers, contact form, member sign-up and login, member account (plan, expiry, payment history, renew).
* **Database** - MySQL with tables, foreign keys and a trigger that activates a membership when a payment is marked Paid.

Default admin login (change it on the Profile page): **admin / Admin@123**

## 1. Fastest way to run: Docker (no installs except Docker)
    docker compose up --build
Open http://localhost:8080/ (public site) and http://localhost:8080/login.jsp (admin).
This starts MySQL, creates the tables and loads demo data, and runs the site on Tomcat 9.
Do not want the demo data? Delete `database/02_sample_data.sql` before the first run.

## 2. Run without Docker (Tomcat 9 + MySQL)
1. Install JDK 11 or 17, Maven, Tomcat 9 and MySQL 8.
2. In MySQL run `database/01_schema.sql`, then (optional) `database/02_sample_data.sql`.
3. Set the database login. Either edit the defaults in `src/main/java/gym/util/Db.java`
   or set environment variables `DB_URL`, `DB_USER`, `DB_PASS`.
4. Build: `mvn clean package` -> creates `target/ROOT.war`.
5. Copy `target/ROOT.war` into Tomcat's `webapps/` folder (delete the old `webapps/ROOT` folder first) and start Tomcat.
6. Open http://localhost:8080/

## 3. Put it online
The app is a standard WAR plus a MySQL database, so any host that runs Docker or Tomcat works.
1. Create a MySQL database on your host (a managed MySQL service or your own server) and run `database/01_schema.sql` on it.
2. Deploy this project with the `Dockerfile` (or upload `target/ROOT.war` to a Tomcat 9 server).
3. Set the environment variables on the host:
   `DB_URL=jdbc:mysql://HOST:3306/gym_db?useSSL=true&serverTimezone=Asia/Kolkata`, `DB_USER`, `DB_PASS`.
4. Open the site, log in as admin, and change the admin password at once.
5. Edit your real gym name, phone, WhatsApp number and address at the top of `src/main/webapp/site/inc/siteHeader.jsp`,
   replace the sample plans and trainers in the database, and use HTTPS (most hosts provide it).
Check each host's current plans and limits before choosing one.

## Project structure
    database/            01_schema.sql, 02_sample_data.sql
    src/main/java/gym/
      util/              Db.java (JDBC helper), Pw.java (password hashing)
      filter/            AdminFilter (login required), EncodingFilter (UTF-8)
      servlet/           AuthServlet, DashboardServlet, MemberAdminServlet, PlanAdminServlet,
                         PaymentAdminServlet, ProfileServlet, SiteServlet, MemberServlet
    src/main/webapp/     admin JSPs, includes/ (sidebar, navbar, footer), site/ (public website), assets/

## How the main flow works
1. A visitor signs up -> a member row and a *Pending* payment are created.
2. The admin opens Payments and clicks **Mark paid** -> the trigger sets the member's expiry date.
3. The member's account shows Active with days left; the dashboard counts and revenue update.

## Known limits (good to mention in the viva)
* Payments are confirmed by the admin; there is no online payment gateway yet.
* One admin role; no CSRF tokens; one database connection per request (no pool).
* Deleting a Paid payment does not shorten the membership.
