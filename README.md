# FixIT — PT Fixit Infrastruktur Prima

**Strategic Planning & Operations Division**  
**Early-Stage Startup — In Development**

FixIT is a prospective digital marketplace designed to connect clients with trusted blue-collar service providers (AC technicians, plumbers, cleaners, and mechanics) in the Greater Jakarta region, initially focusing on Depok and Bekasi. Operating on a lean, bootstrapped business model, FixIT takes a flat 15% commission per visit, allowing vendors and clients to negotiate final service prices directly.

## 🎯 Problem Statement

The informal service sector in Indonesia is highly fragmented. Homeowners struggle to find reliable, vetted technicians, while skilled independent workers (*tukang*) face difficulties with customer acquisition and digital marketing. Current market solutions enforce rigid pricing models that do not account for job complexity. FixIT provides a transparent directory and review system, empowering workers to set their own visit rates while facilitating direct negotiation for the final service cost.

## 💰 Business & Revenue Model

- **Commission**: Flat 15% on the base visit fee (*Tarif Kunjungan*) set by the vendor
- **Zero commission on materials & labor**: Vendors retain 100% of on-site labor and spare parts revenue
- **Pioneer Promo**: 0–5% commission for pilot vendors' first three months
- **Customer Service Fee (*Biaya Layanan*)**: Rp 3,000–Rp 5,000 flat at checkout (covers payment gateway fees)
- **Vendor Withdrawal**: Rp 2,500 BI-FAST fee per withdrawal; one free withdrawal per week subsidized
- **Phase 2**: Smart Split Invoice — 10% commission on Labor, 0% on Parts

## 🛠 Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart SDK ^3.13.5) |
| UI | Material 3 (M3) |
| Brand Colors | Royal Purple & Ink (trust/professionalism), Sunglow Gold (vendor accents) |
| Architecture | Single-codebase dual-role (customer + vendor in one binary) |
| State | In-memory mock (Phase 1) → Supabase PostgreSQL (Phase 2) |
| Auth | JWT AuthStorage (scaffolded, ready for backend) |
| Testing | 36-test automated suite |

## 📈 Development Phases

| Phase | Focus |
|-------|-------|
| **Phase 1: Prototyping** *(Current)* | MVP frontend complete, mocked state, 36-test suite covering UI, directory filtering, and 5-step vendor onboarding |
| **Phase 2: Technical MVP** | Supabase backend integration, JWT authentication, PostgreSQL migration |
| **Phase 3: Pilot Launch** | Localized rollout in Depok/Bekasi, test CAC and platform stability |

## 🔐 Legal Status

- Currently operating without a formal legal entity
- Roadmap: Incorporate as a **PT (Perseroan Terbatas)** aligned with pilot launch
- Equity: Maximum 25% offered to external investors (50/50 capital/labor valuation)

## 🔧 Vendor Onboarding (5-Step)

1. Identity & demographics collection
2. Specialization categorization
3. Work hour configuration
4. Mandatory portfolio proof (photo/video per specialty)
5. Security verification (KTP + biometric selfie)

## 🗺 Strategic Roadmap

1. Database & API Migration — Replace mock data with live PostgreSQL tables
2. WhatsApp OTP Integration — Cost-free phone verification via local Node.js bot
3. Real-Time Job Synchronization — WebSockets for status machine (Request → Accepted → En Route → In Progress → Completed)
4. Payment Gateway Integration — Midtrans or Xendit (GoPay, DANA, QRIS)

## 📁 Project Structure

```
lib/
├── auth/                  # Authentication flows
│   ├── welcome_screen.dart   # Role selection (customer/vendor)
│   ├── phone_screen.dart     # Phone number entry (+62)
│   ├── otp_screen.dart       # 6-digit OTP verification
│   └── user_role.dart        # UserRole enum
├── data/                  # Static prototype data
│   ├── sample_data.dart      # Services, categories, workers, time slots, payment methods
│   ├── specialties.dart      # Worker specialties (20+ trades grouped by category)
│   └── worker_directory.dart # Worker filter, search, sort, seeded profiles
├── models/                # Data models
│   ├── models.dart           # ServiceCategory, ServiceItem, PaymentMethod, TimeSlot, Worker
│   └── worker_profile.dart   # WorkerProfile, PortfolioItem, Review, DayHours, Gender
├── screens/               # Customer app screens
│   ├── root_shell.dart       # Bottom nav shell (Beranda/Transaksi/Pesan/Fixie)
│   ├── home_screen.dart      # Home with categories, promos, reviews
│   ├── all_services_screen.dart
│   ├── category_screen.dart
│   ├── service_detail_screen.dart
│   ├── booking_screen.dart   # Date, time, address
│   ├── checkout_screen.dart  # Payment, premium option, price summary
│   ├── success_screen.dart   # Order confirmation
│   ├── orders_screen.dart    # Order history
│   ├── messages_screen.dart  # Conversation list
│   ├── chat_screen.dart      # Chat with worker/customer
│   ├── fixie_screen.dart     # AI assistant chat
│   └── profile_screen.dart   # Customer profile & settings
├── vendor/                # Vendor app
│   ├── vendor_shell.dart     # Bottom nav shell (Beranda/Pekerjaan/Pesan/Pendapatan)
│   ├── vendor_home_screen.dart
│   ├── vendor_apply_screen.dart   # 5-step onboarding
│   ├── vendor_jobs_screen.dart    # Job tabs (Baru/Aktif/Selesai)
│   ├── vendor_job_detail_screen.dart
│   ├── vendor_messages_screen.dart
│   ├── vendor_earnings_screen.dart
│   ├── vendor_profile_screen.dart
│   ├── vendor_store.dart     # Vendor state (jobs, balance, earnings)
│   ├── vendor_models.dart    # Job, JobStatus, EarningEntry, commission
│   ├── vendor_pickers.dart   # Specialty & area picker sheets
│   ├── portfolio_editor.dart # Portfolio add/edit sheet
│   └── work_hours_editor.dart # Weekly hours editor
├── widgets/               # Shared UI components
│   ├── common.dart           # rupiah formatter, cardDecoration, SectionTitle, StatusChip, IconBadge, comingSoon
│   └── worker_widgets.dart   # WorkerAvatar, StarRating, RatingLabel, SelectChip, PortfolioEditor, ReviewTile, WorkHoursList
├── services/              # API & auth
│   ├── api_client.dart       # HTTP client with auth headers
│   └── auth_storage.dart     # SharedPreferences wrapper
└── theme.dart              # AppColors, AppTheme (light theme)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.13.5 or higher
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An Android emulator or iOS simulator (or physical device)

### Installation

```bash
# Clone the repository
git clone https://github.com/RafaelJo28/FixIT.git
cd FixIT

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Web Build
```bash
flutter build web
```

### Run Tests
```bash
flutter test
```

## 🎨 Design System

### Colors
| Name | Hex | Usage |
|------|-----|-------|
| Royal Purple | `#723CD6` | Primary brand, trust & professionalism |
| Ink | `#140F26` | Corporate dark, primary text |
| Sunglow Gold | `#EDB158` | Vendor accents, highlights |
| Success | `#10B981` | Completed status |
| Danger | `#DC2626` | Errors, destructive actions |

### Typography
- **Font family**: Plus Jakarta Sans
- **Headings**: `w800` (ExtraBold), letter-spacing `-0.3` to `-0.1`
- **Body**: `w600` / `w700`
- **Captions**: `w500` / `w600`, size 11–13px

### Spacing & Radius
- Card radius: 20px
- Button radius: 16px
- Input radius: 16px
- Chip radius: 12px
- Card border: 1px `#EBE6F5`
- Minimal elevation; separation via borders and background tints

## 🔄 User Flows

### Customer Journey
```
Welcome → Phone → OTP → Home → Browse Services → Service Detail → Booking → Checkout → Success → Orders / Chat
```

### Vendor Journey
```
Welcome → Phone → OTP → 5-Step Onboarding → Pending Approval → (Demo Approve) → Vendor Home → Accept Job → Update Status → Earnings / Profile
```

## 💰 Revenue Model

- **Commission**: Flat 15% on the base visit fee (*Tarif Kunjungan*)
- **Zero commission on materials & labor**: Vendors keep 100% of on-site labor and spare parts
- **Pioneer Promo**: 0–5% commission for pilot vendors' first 3 months
- **Customer Service Fee (*Biaya Layanan*)**: Rp 3,000–Rp 5,000 flat at checkout
- **Vendor Withdrawal**: Rp 2,500 BI-FAST fee; one free withdrawal per week subsidized
- **Phase 2**: Smart Split Invoice — 10% on Labor, 0% on Parts

## 🔧 Backend Integration

The app is currently prototype-ready with mocked data. To connect a real backend:

1. Wire `ApiClient` to Supabase PostgreSQL tables, replacing in-memory mock data
2. Implement JWT authentication via `AuthStorage`
3. Migrate vendor profiles, reviews, and portfolios to live backend
4. Enable real file uploads for portfolio and document verification
5. Connect Midtrans or Xendit for GoPay, DANA, and QRIS payments

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/auth_flow_test.dart
```

Test coverage includes:
- Auth flow (phone → OTP → role-based navigation)
- Vendor onboarding (all 5 steps)
- Vendor flow (home, jobs, earnings, profile, messages)
- Worker directory (search, filters, sorting, validation)
- Widget tests (navigation tabs, home screen content)

## 📄 License & Ownership

**PT Fixit Infrastruktur Prima** — All rights reserved. Early-stage startup in development.

---

Strategic Planning & Operations Division • Depok/Bekasi, Indonesia 🇮🇩
