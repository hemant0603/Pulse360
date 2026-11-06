<img width="1634" height="822" alt="Screenshot 2026-11-06 202826" src="https://github.com/user-attachments/assets/9d4b0e9d-a596-4e2d-bb8d-bfeceae41955" />
<img width="1920" height="1080" alt="Screenshot (85)" src="https://github.com/user-attachments/assets/c852ca6b-92e0-460e-8159-368c9e406ca4" />
<img width="1920" height="1080" alt="Screenshot (80)" src="https://github.com/user-attachments/assets/6ae4733b-5b75-441a-a312-0515e1a4f59c" />
<img width="1920" height="1080" alt="Screenshot (79)" src="https://github.com/user-attachments/assets/1c6333e7-b57f-472b-b0b0-43d4a5684e23" />
<img width="1920" height="1080" alt="Screenshot (82)" src="https://github.com/user-attachments/assets/b92a9b8e-2cbc-44cf-a67c-fed115b8b2b2" />
# 🏋️‍♂️ Pulse360 - Gym Management System (Salesforce CRM)

Hi! 👋 I built **Pulse360** as a hands-on Salesforce project to learn and apply core Admin and Developer concepts on a real-world business problem. 

It is a CRM app designed for a multi-branch gym where staff can manage members, trainers, daily workouts, payments, and memberships all in one place.

---

## 🛠️ Tech Stack Used
* **Salesforce Admin:** Custom Objects, Relationships, Roll-Up Summary Fields, Validation Rules, Reports & Dashboards
* **Automation:** Salesforce Flows (Record-Triggered, Scheduled, and Screen Flow)
* **Salesforce Dev:** Apex Triggers, Handler Classes, Test Classes, SOQL, Lightning Web Components (LWC), JavaScript
* **Security:** Roles, Custom Profiles, OWD, Sharing Rules, Field-Level Security (FLS)

---

## 🚀 What I Built in This Project

### 1. 🗄️ Database & Data Validation
* Created **9 Custom Objects** to store gym data: `Gym__c`, `Membership_Plan__c`, `Member__c`, `Trainer__c`, `Equipment__c`, `Training_Session__c`, `Payment__c`, `Enrollment__c`, and `Session_Booking__c`.
* **Relationships:** 
  * Linked `Member__c` to `Gym__c` using a **Lookup** relationship so member records aren't accidentally deleted if a gym branch record is removed.
  * Used **Master-Detail** for `Payment__c`, `Trainer__c`, and `Equipment__c`.
  * Created **Junction Objects** (`Enrollment__c` and `Session_Booking__c`) to connect multiple members with multiple plans and workout sessions.
* **Roll-Up Summary Fields:** Automatically counts total gym equipment (`Total_Equipments__c`) and live bookings per session (`Current_Bookings__c`).
* **4 Validation Rules:** Blocks invalid entries like members under 16 years old, negative payment amounts, wrong enrollment dates, or invalid phone numbers (must be 10 digits).

### 2. ⚡ Process Automation (3 Flows)
* **Welcome Email (Record-Triggered Flow):** Automatically sends a welcome email whenever a new member joins the gym.
* **Expiry Reminder (Scheduled Flow):** Runs every morning at 6:00 AM to check whose membership is expiring in 3 days and sends them a reminder email.
* **New Member Onboarding (Screen Flow):** A simple step-by-step form for the front desk that creates the **Member**, **Enrollment**, and **Payment** records together on a single screen.

### 3. 💻 Custom Coding (Apex & LWC)
* **Session Capacity Trigger (`before insert` on `Session_Booking__c`):** Checks if a workout session is already full (`Current_Bookings__c >= Max_Capacity__c`) and shows an error message using `addError()` to stop overbooking.
* **Payment Trigger (`after insert, after update` on `Payment__c`):** Whenever a payment status is marked as `Paid`, this trigger automatically updates the member's `Enrollment__c` status to `Active`.
* **Clean Code & Testing:** Used separate **Trigger Handler classes** (`with sharing`), kept SOQL/DML outside of loops (bulkified), and wrote **Unit Test Classes** covering both positive and negative test cases with 100% pass rate.
* **Expiring Memberships Tracker (LWC):** Built a custom component (`expiringMemberships`) for the Home Page so staff can quickly see memberships expiring in the next 7 days.
  * Includes a live search bar to filter members by name without reloading the page.
  * Dynamically shows how many days are left (`Expires today`, `3 Days left`, etc.).
  * Clicking on a member's name opens their record page directly.

### 4. 🔐 User Access & Security
* **Role Hierarchy:** Set up roles for `Gym Owner` ➔ `Gym Manager` ➔ `Trainer` & `Front Desk`.
* **4 Custom Profiles:** Created separate profiles (`Gym_Admin`, `Gym_Manager`, `Trainer`, `Front_Desk`) so people only see what they need. For example, Trainers cannot see any `Payment__c` records, and Front Desk staff cannot delete records.
* **OWD & Sharing Rules:** Kept `Member__c` as **Private** by default for privacy, and added a **Criteria-Based Sharing Rule** to share active member records among the branch staff.
* **Field-Level Security (FLS):** Made the payment amount field Read-Only for Gym Managers so payment figures cannot be edited after creation.

### 5. 📊 Reports & Dashboard
* Created **8 Custom Reports** and combined them into an **Executive Dashboard** to track Active Members, Revenue Collected, Pending Payments, Popular Plans, and Branch-wise performance.

---

## 📸 Screenshots

### 💻 LWC - Expiring Memberships Tracker (Home Page)
![Expiring Memberships LWC](<img width="1633" height="822" alt="image" src="https://github.com/user-attachments/assets/b567aaf3-37a3-4224-89ce-94016210a5a2" />
)

### 📊 Pulse360 Executive Dashboard
![Executive Dashboard](<img width="1920" height="1080" alt="Screenshot (84)" src="https://github.com/user-attachments/assets/9b057b68-19ea-48a0-a139-2f2781943cad" />
)

### ⚡ Screen Flow - New Member Onboarding
![Onboarding Screen Flow](<img width="1920" height="1080" alt="Screenshot (80)" src="https://github.com/user-attachments/assets/e3e0ce71-2959-4f30-a432-70c4f9b6c9ea" />
)


### 📩 Record-Triggered Flow - Member Welcome Email
![Member Welcome Email Flow](<img width="1920" height="1080" alt="Screenshot (82)" src="https://github.com/user-attachments/assets/b5f0d6f5-49f0-4bf5-b82e-30becfb346cb" />
)


### ⏰ Scheduled Flow - Expiry Reminder
![Scheduled Expiry Flow](<img width="1920" height="1080" alt="Screenshot (79)" src="https://github.com/user-attachments/assets/0eb098ec-a1b6-4197-807f-0a864018f418" />
)

### 🔐 Role Hierarchy
![Role Hierarchy](<img width="1920" height="1080" alt="Screenshot (85)" src="https://github.com/user-attachments/assets/7a11b8d4-6524-4826-9464-99b5f4174f95" />
)

---

## 🙋‍♂️ About Me
**Hemant Kumar Atal**  

📫 [LinkedIn](https://www.linkedin.com/in/hemant-kumar-atal/) | [Trailhead](https://www.salesforce.com/trailblazer/hemantkumaratal)| [Email](mailto:hemantkumaratal2020@gmail.com)
