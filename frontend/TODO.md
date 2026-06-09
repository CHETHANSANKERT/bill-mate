# Bill Mate Enhancement TODO

Current Working Directory: d:/chethan_documents/projects/flutter_files/bill_mate

## Approved Plan Steps (High Priority Focus: Inventory, Customer, Search/Filter + UI/UX)

### Phase 1: Inventory/Stock Tracking
- [x] 1.1 Update Item model (lib/model/bill/item.dart) - add stockQuantity field, copyWith.
- [x] 1.2 DB Migration (lib/services/local/db_service.dart) - bump version to 3, ALTER TABLE item ADD COLUMN stockQuantity REAL DEFAULT 0; Update insertItem/getAllItems/ findItemIsPresent/getDistinctFieldValuesInItem to handle stock.
- [x] 1.3 Update all_items.dart - add stock column, low-stock color/warning (red if <10), edit button/dialog for stock update.
- [ ] 1.4 Update add_item_dialog.dart/add_products.dart - add stock display/check (prevent over-sell), update sold qty deducts from stock.
- [ ] 1.5 Extend CreateBillBloc - add stock check events/states.

### Phase 2: Customer Management
- [ ] 2.1 Create Customer model (lib/model/customer/customer.dart).
- [ ] 2.2 DB: Add customers table CRUD in db_service.dart (_onUpgrade version 4).
- [ ] 2.3 Create Customer BLoC (lib/bloc/customer/customer_bloc.dart/events/states).
- [ ] 2.4 Create screens: lib/screens/customer/create_customer.dart, all_customers.dart.
- [ ] 2.5 Update Sale model/DB - add customerId, customerName.
- [ ] 2.6 Update create_bill screens - customer dropdown/select, link to sale.
- [ ] 2.7 Update all_sales.dart - show customer.

### Phase 3: Search/Filter
- [ ] 3.1 Add search bar/filter chips to all_sales.dart (by date/store/customer/invoice), BillBloc filter states.
- [ ] 3.2 Add search to all_items.dart (name/stock), low-stock filter.
- [ ] 3.3 billing_home_screen.dart - add pull-refresh, search overlays.

### Phase 4: UI/UX Enhancements
- [ ] 4.1 Home screen metrics cards (total sales/customers/items/stock value).
- [ ] 4.2 Material3 polish (elevations, shapes), animations.
- [ ] 4.3 Routes: Add customer paths to app_pages.dart/app_routes.dart.

### Follow-up
- flutter pub get
- Test DB migration, features end-to-end.
- Update lib_analysis.md if needed.

**Next: Phase 2.1 - Customer model created**

Phase 1 Inventory ✅

