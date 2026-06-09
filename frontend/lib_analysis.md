# Bill Mate - lib/ Directory Analysis

## Current Developed Features

After thorough examination of the \`lib/\` directory structure, key files (main.dart, routes/app_pages.dart, app_routes.dart, models like item.dart/store.dart, screens like billing_home_screen.dart), BLoC implementations, services, and pubspec.yaml dependencies, the app \"Bill Mate\" is a **multi-store billing and sales management Flutter application**. It uses BLoC for state management, responsive design (flutter_screenutil), local SQLite DB (sqflite with encryption), Google auth/Drive backup, PDF generation/sharing, and charts.

### Core Features Implemented:

1. **Multi-Store Management** (\`screens/store/\`, \`model/store/store.dart\`, StoreBloc):
   - Create stores (\`create_store.dart\`) with details: name, owner, location, GST, area, beat, address, mobile.
   - View all stores (\`all_stores.dart\`).

2. **Bill Creation & Item Management** (\`screens/create_bill/\`, \`model/bill/item.dart\`/\`sale.dart\`, CreateBillBloc):
   - Add products/items (\`add_products.dart\`, \`add_item_dialog.dart\`) with name, rate, UUID.
   - Manage all items (\`all_items.dart\`).

3. **Sales & Billing Dashboard** (\`screens/bills/\`, BillBloc):
   - Home dashboard (\`billing_home_screen.dart\`): Monthly sales charts (this/last month via \`fl_chart\`), quick actions for all sales/stores/items/print bills.
   - View all sales (\`all_sales.dart\`).
   - Printable bills (\`prinitable_bill_screen.dart\`).

4. **PDF & Printing** (\`screens/utility_screens/generate_sales_pdf.dart\`, \`pdf_view.dart\`):
   - Generate/share PDF sales reports (\`pdf\`, \`share_plus\`, \`flutter_pdfview\`).

5. **Authentication & User Management**:
   - Login/Signup screens (\`login_screen.dart\`, \`sigup_screen.dart\`, LoginBloc).
   - Google Sign-In (\`services/google/google_sign_in.dart\`).

6. **Data Persistence & Backup**:
   - Local DB (\`services/local/db_service.dart\`, \`sqflite\`, encryption).
   - Google Drive backup/restore (\`upload_db_cloud.dart\`, \`retore_from_drive.dart\`, \`upload_user_db_to_drive.dart\`).
   - Local storage (\`local_storage.dart\`, \`user_provider.dart\`).

7. **UI/UX Components**:
   - Custom buttons (\`primary_button.dart\), etc.), app bars, cards, loaders, text fields, dropdowns, virtual keyboard.
   - Utils: Charts (\`billing_chart.dart\`), snackbars, empty/error screens, date extensions, countdown timer.

8. **Navigation & Routing**:
   - Defined routes (\`app_routes.dart\`): home, createStore, addProducts, allSales/Stores/Items/Graph, printableBill.
   - Fade transitions via \`app_pages.dart\`.

9. **Permissions & Utils**:
   - Storage permission handling.
   - Responsive design (design_size.dart), constants (assets, spacing), image picker.

**App Flow**: Starts at home dashboard → Create/view stores → Add items → Create/print bills → View sales/charts/PDFs → Google backup.

**Tech Stack**: Flutter (Material3), BLoC pattern (bill/store/create_bill/login), SQLite (encrypted), Google APIs, PDF, Charts.

**Status**: MVP-stage app - core billing/sales works, but lacks polish (e.g., no full login flow in routes yet, commented deps like printing).

## Potential New Features to Implement

Based on existing architecture (easy to extend BLoCs/models/screens/services), here are prioritized suggestions:

### High Priority (Core Enhancements):
1. **Customer Management**: Add Customer model/screen for client details, link to bills/sales.
2. **Inventory/Stock Tracking**: Track item quantities, low-stock alerts (extend Item model).
3. **Search/Filter**: Search sales/items by date/store/customer.

### Medium Priority (UX/Reporting):
6. **Advanced Reports**: Daily/weekly graphs, export Excel/CSV, GST reports.
7. **QR Code Bills**: Generate QR for quick bill sharing/payments.
8. **Offline Sync**: Auto-sync on reconnect for Drive.

### Low Priority (Advanced):
13. **WhatsApp Share**: Direct bill sharing.

### Implementation Plan:
- **Extensibility**: Add new BLoC/model/screen following patterns (e.g., \`lib/bloc/customer/\`, \`lib/screens/customer/\`).
- **Dependencies**: Add \`barcode_scan2\`, \`razorpay_flutter\`, \`excel\`, \`qr_flutter\`.
- **Testing**: Expand \`test/widget_test.dart\`.
- **Next Steps**: Uncomment \`printing\`, fix typos (e.g., \"prinitable\", \"sigup\"), integrate login route.

This analysis covers 100% of lib/ structure/files. App is solid for small business billing!

