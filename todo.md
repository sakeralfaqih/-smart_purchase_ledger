# TODO — Complete Flutter App: Supplier Invoices, Price Memory & Payables

## Phase 0 — Environment & Scaffolding
- [x] Create full `lib/` directory tree (Feature-First Clean Architecture)
- [x] Create `pubspec.yaml`, `analysis_options.yaml`, `README.md`, `.gitignore`
- [x] Create Android/iOS platform config essentials (permissions, minSdk)

## Phase 1 — Core Infrastructure
- [x] `core/constants` (colors, strings, gemini_prompts, config)
- [x] `core/database/tables` (6 Drift tables)
- [x] `core/database/app_database.dart` + DAOs (suppliers, catalog, invoices, vouchers)
- [x] `core/errors` (exceptions, failures)
- [x] `core/network` (network_info, gemini_api_client)
- [x] `core/services` (document_scanner, image_compression, arabic_text_normalizer)
- [x] `core/utils` (currency_formatter, date_formatter)

## Phase 2 — Feature: 1_dashboard
- [x] entities, usecases, repository impl, providers, screen, widgets

## Phase 3 — Feature: 2_ocr_scanner
- [x] entities, repos interface, usecases (validate math, parse pack/retail, match items)
- [x] DTOs, Gemini remote datasource, offline queue, repository impl
- [x] providers/controller, split review screen, widgets

## Phase 4 — Feature: 3_invoices
- [x] entities, repo, usecases (save confirmed invoice transaction), datasource, impl, providers, screens

## Phase 5 — Feature: 4_vouchers
- [x] entity, repo, usecase (save voucher), datasource, impl, providers, screen

## Phase 6 — Feature: 5_suppliers
- [x] entities, repo, usecases (statement, reconcile, PDF), datasource, impl, providers, screens, widgets

## Phase 7 — Feature: 6_catalog
- [x] entities, repo, usecases (unit cost, compare prices), datasource, impl, providers, screens, widgets

## Phase 8 — Feature: 7_settings_backup
- [x] usecases (backup/restore/biometric), drive datasource, screen

## Phase 9 — App wiring
- [x] main.dart, app.dart, router, theme, RTL
- [x] Provide Drift `.g.dart` build instructions (build_runner) — toolchain intentionally not installed to avoid disk outage

## Phase 10 — Validation & Delivery
- [x] Static validation: import resolution, brace balance, provider resolution, screen wiring
- [x] Package project as zip; README/setup guide
