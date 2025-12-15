Cross-Platform Sales Metrics & Invoice Comparison App
Project Overview

This is a Flutter-based cross-platform mobile application built to demonstrate sales analytics, data visualization, and invoice reconciliation using clean architecture and Bloc state management.

The app focuses on:

Reading structured sales data

Displaying KPIs and charts on a dashboard

Comparing Purchase Order and Invoice PDFs

Exporting discrepancy reports

Supporting offline access via local caching

The solution is designed to be maintainable, scalable, and production-ready.

Tech Stack

Flutter – Android & iOS app development

Bloc (flutter_bloc) – State management

Hive – Offline data caching

fl_chart – Charts & data visualization

Syncfusion PDF – PDF parsing & viewing

File Picker – Selecting PDF files

Path Provider – File storage access

CSV Export (Custom Utility) – Report generation

Project Architecture

The project follows a Clean Architecture approach:

Presentation Layer
UI screens, widgets, and user interactions

Bloc Layer
Events, states, and business logic

Data Layer
Models and local data sources (JSON, Hive, PDF parsing)

Utils Layer
Helper methods for charts, calculations, and exports

This structure ensures clarity, testability, and easy future enhancements.

Folder Structure
lib/
 ├── bloc/
 │   ├── sales_dashboard/
 │   └── invoice_compare/
 │
 ├── data/
 │   ├── models/
 │   └── datasources/
 │
 ├── utils/
 │
 ├── view/
 │   ├── dashboard/
 │   └── invoice_compare/
 │
 └── main.dart


///================ SALES DASHBOARD MODULE =================///

Sales Dashboard

The dashboard presents business-critical insights in a clean and modern UI.

Features

Total Sales KPI

Active Stores KPI

Top Brand KPI

Year-over-Year (YoY) Sales Growth

Brand-based filtering

Monthly Sales Trend (Line Chart)

Active Stores by Region (Bar Chart)

Data Handling

Sales data was pre-processed from Excel to JSON, as allowed by the assignment.

JSON schema mirrors the original Excel structure.

Data is cached using Hive to ensure offline availability.

///================ INVOICE COMPARISON MODULE =================///

Invoice & Purchase Order Comparison

This module compares Purchase Orders and Proforma Invoices to identify discrepancies.

Features

Select PO and Invoice PDFs

Preview PDFs inside the app

Parse structured text-based PDFs

Match items using SKU codes

Highlight quantity and price mismatches

Clear visual indicators for matched/mismatched items

Notes

Designed for text-based PDFs

OCR for scanned PDFs is intentionally out of scope

///================ CSV EXPORT MODULE =================///

CSV Discrepancy Report Export

Generates a CSV report containing:

Item Code

PO Quantity & Price

Invoice Quantity & Price

Mismatch indicators

CSV is saved to app-specific external storage

File opens automatically after export for easy verification

///================ OFFLINE SUPPORT =================///

Offline Caching

Sales data is cached using Hive

Dashboard remains functional without internet access

Improves performance and reliability

///================ STATE MANAGEMENT =================///

State Management

Bloc pattern is used throughout the app

Clear separation of events, states, and logic

Predictable UI updates and easier debugging

How to Run the Project

Clone the repository

Run flutter pub get

Ensure assets are added in pubspec.yaml

Run the app using flutter run

Demo Flow

Load sales data

View dashboard KPIs and charts

Apply brand filter

Check YoY sales growth

Open Invoice Comparison

Select PO and Invoice PDFs

Compare discrepancies

Export CSV report

Conclusion

This project demonstrates:

Clean Flutter architecture

Real-world data analytics

PDF document reconciliation

Offline-first design

Production-ready coding practices

The application can be extended further for enterprise analytics and finance reconciliation use cases.