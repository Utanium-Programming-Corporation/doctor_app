# Privacy Policy

**Last Updated:** April 18, 2026

**Effective Date:** April 18, 2026

---

## 1. Introduction

Welcome to the **Doctors App** ("App", "we", "our", or "us"). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our clinic management platform, which is designed for healthcare providers, clinic administrators, and their staff.

We are committed to protecting the privacy and security of all personal information — including Protected Health Information (PHI) — handled through the App. Please read this policy carefully. If you disagree with any part of this policy, please discontinue use of the App.

---

## 2. Who This Policy Applies To

This policy applies to all users of the App, including:

- **Clinic Administrators** — individuals responsible for managing one or more clinics on the platform.
- **Healthcare Providers** — doctors, nurses, pharmacists, and other licensed practitioners using the App.
- **Clinic Staff** — receptionists and other administrative staff.
- **Patients** — individuals whose health records and appointments are managed through the App.

---

## 3. Information We Collect

### 3.1 Account & Identity Information
- Full name, email address, phone number, and role (e.g., doctor, receptionist).
- Professional credentials (license numbers, specialty) for healthcare providers.
- Authentication credentials (managed securely via Supabase Auth; passwords are never stored in plain text).

### 3.2 Clinic & Organizational Information
- Clinic name, address, contact details, and location data.
- Staff assignments and organizational hierarchy within a clinic.

### 3.3 Patient Health Information (PHI)
- Patient demographics (name, date of birth, contact information).
- Medical history, diagnoses, prescriptions, and SOAP notes.
- Lab results and attached medical documents.
- Appointment records and visit history.
- Triage assessments and vitals.
- Billing and invoice records associated with encounters.

### 3.4 Scheduling & Queue Data
- Appointment details (date, time, provider, type, status).
- Queue tokens and check-in times.
- Waitlist entries.

### 3.5 Device & Usage Information
- Device type, operating system, and app version.
- IP address and general geolocation (country/region level).
- Crash reports and diagnostic logs (non-PHI only).

### 3.6 Communications
- Messages sent within the in-app messaging system between staff and patients.
- Notification preferences and delivery logs.

---

## 4. How We Use Your Information

We use the information we collect to:

- **Provide and operate the App** — managing appointments, queues, patient records, billing, and inventory.
- **Authenticate users** and enforce role-based access control (RBAC) to ensure users only access data they are authorized to view.
- **Deliver healthcare services** — enabling providers to access patient records, prescriptions, and lab results necessary for care delivery.
- **Send notifications and reminders** — appointment reminders, queue status updates, and system alerts via email, SMS, or push notification.
- **Maintain audit logs** — recording access and modifications to sensitive data for compliance and accountability.
- **Improve the App** — analyzing anonymized usage patterns to improve performance and user experience.
- **Ensure security** — detecting and preventing unauthorized access, fraud, and abuse.

---

## 5. Data Sharing and Disclosure

We do **not** sell your personal information or PHI to third parties. We may share information only in the following circumstances:

### 5.1 Within Your Clinic
Patient data and records are accessible only to authorized staff within the same clinic, enforced through Row Level Security (RLS) on the database.

### 5.2 Service Providers
We engage trusted third-party service providers who process data on our behalf under strict data processing agreements, including:
- **Supabase** — cloud database, authentication, storage, and real-time infrastructure.
- **Communication providers** (e.g., Twilio, SendGrid) — for sending SMS, WhatsApp, and email notifications.
- **Cloud storage** — for secure storage of medical attachments and lab results.

All service providers are contractually bound to use your data only for the purposes we specify and to protect it appropriately.

### 5.3 Legal Requirements
We may disclose information when required by law, court order, or governmental authority, or when necessary to protect the rights, property, or safety of our users, the public, or the App.

### 5.4 Business Transfers
In the event of a merger, acquisition, or sale of assets, your data may be transferred to the successor entity, subject to the same privacy protections described in this policy.

---

## 6. Data Security

We implement industry-standard technical and organizational security measures to protect your data:

- **Encryption in transit**: All data is transmitted over HTTPS/TLS.
- **Encryption at rest**: Data stored in Supabase is encrypted at rest.
- **Row Level Security (RLS)**: Database-level policies enforce that users can only access data belonging to their authorized clinic(s) and role.
- **Role-Based Access Control (RBAC)**: Access to features and data is restricted based on user role (super admin, clinic admin, doctor, nurse, receptionist, pharmacist, patient).
- **Audit Logging**: All access and modifications to sensitive records are logged in an append-only audit trail.
- **Secure Authentication**: Multi-factor options are supported; passwords are hashed using industry-standard algorithms managed by Supabase Auth.
- **Secure File Storage**: Patient documents, lab results, and attachments are stored in access-controlled storage buckets with bucket-level security policies.

Despite these measures, no system is 100% secure. We encourage users to use strong, unique passwords and to report any suspected unauthorized access immediately.

---

## 7. Data Retention

- **Active account data** is retained for as long as the clinic account is active and as required by applicable medical records laws.
- **Audit logs** are retained for a minimum of **7 years** to support compliance and legal requirements.
- **Deleted records** are soft-deleted and permanently purged after a retention period defined by the clinic administrator, subject to legal minimum retention requirements.
- **Anonymized analytics** data may be retained indefinitely.

Upon account termination, we will securely delete or anonymize personal data within **90 days**, unless retention is required by law.

---

## 8. Your Rights

Depending on your jurisdiction, you may have the following rights:

- **Right of Access** — request a copy of the personal data we hold about you.
- **Right to Rectification** — request correction of inaccurate or incomplete data.
- **Right to Erasure** — request deletion of your data, subject to legal retention requirements.
- **Right to Restrict Processing** — request that we limit how we use your data.
- **Right to Data Portability** — request your data in a structured, machine-readable format.
- **Right to Object** — object to certain types of processing.
- **Right to Withdraw Consent** — where processing is based on consent, you may withdraw it at any time.

To exercise any of these rights, please contact us at the address provided in Section 12. We will respond within **30 days**.

---

## 9. Children's Privacy

The App is intended for use by healthcare professionals and clinic administrators. It is not directed at individuals under the age of 18 for account registration purposes. Patient records for minors are managed by authorized adult guardians and healthcare providers under applicable law.

---

## 10. International Data Transfers

Your data may be processed and stored in countries other than your own, including countries where Supabase infrastructure operates. Where data is transferred internationally, we ensure adequate protections are in place in accordance with applicable data protection laws.

---

## 11. Changes to This Policy

We may update this Privacy Policy from time to time. When we do, we will:
- Update the "Last Updated" date at the top of this document.
- Notify clinic administrators via in-app notification or email if changes are material.

Continued use of the App after changes take effect constitutes acceptance of the revised policy.

---

## 12. Contact Us

If you have any questions, concerns, or requests regarding this Privacy Policy or how we handle your data, please contact us:

**Doctors App — Privacy Team**
Email: privacy@doctors-app.example.com
Address: [Company Address]

---

*This Privacy Policy was prepared for the Doctors App clinic management platform.*
