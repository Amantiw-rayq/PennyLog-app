## Developer
**Aman Tiwari**  
🔗 [LinkedIn](https://www.linkedin.com/in/aman-tiwari-a6b627373) | [GitHub](https://github.com/Amantiw-rayq)

# Electronics Sales & Service Tracker App

A custom Flutter application built to streamline job tracking, customer management, and payment collection for local electronics repair shops and service businesses.

---

## Overview

This app is designed to bridge the gap between **technology and local business operations** by providing an intuitive solution for:

- Recording and managing **repair jobs**
- Tracking **drop-off and pick-up dates**
- Monitoring **payment status** (paid/unpaid)
- Organizing **customer details** with profile images
- Offline-first architecture using **Hive (NoSQL)** database
- Generating monthly sales **PDF report**
- keeping track with **Agents Stock and Capital Transactions**   

---

## Features

- **Add New Job Entries** with customer name, mobile, device, issue, cost, and drop-off date
- **Track Payment Status** with color-coded visual cues (green for paid, yellow for pending)
- **Date Tracking** for service events (drop-off/pick-up)
- **Whatsapp bill generation** to facilitate customers
- **Customer Avatar** icons for better UI visualization
- **Local Storage** using Hive – no internet required
- **Real-time Updates** using `ValueListenableBuilder`
- **Backup data** from Device Storage even after the App is Reinstalled
- **Stock and Capital Transaction** track with agents
- **Monthly Sales and Services** PDF report generation and overview
- **No Advertisement Disturbances** as the app is complete offline

---

## Tech Stack

- **Flutter** & **Dart** – Cross-platform development
- **Hive** – Lightweight, blazing fast key-value DB
- **Provider / SetState** – State management
- **Figma** – UI/UX Prototyping & Design
- **GitHub** – Version control and collaboration
- **dart:io & JSON** – For reading/writing backup files.
- **Navigation & Routing**: Flutter’s built-in Navigator



---

## 📦 Installation

```bash
# Clone the repository
git clone https://github.com/Amantiw-rayq/Electronics-sales-services-tracker-app.git

# Navigate to project folder
cd Electronics-sales-services-tracker-app

# Get Flutter packages
flutter pub get

# Run on connected device
flutter run
