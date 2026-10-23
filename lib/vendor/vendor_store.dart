import 'package:flutter/material.dart';

import 'vendor_models.dart';
import '../theme.dart';

class VendorStore extends ChangeNotifier {
  VendorStore._() {
    _seed();
  }

  static final VendorStore instance = VendorStore._();

  final double rating = 4.8;

  bool online = true;
  int balance = 0;
  int totalJobs = 0;
  List<int> weekEarnings = [];
  List<EarningEntry> history = [];
  List<Job> jobs = [];

  List<Job> get requests =>
      jobs.where((j) => j.status == JobStatus.newRequest).toList();
  List<Job> get active => jobs.where((j) => j.status.isActive).toList();
  List<Job> get completed =>
      jobs.where((j) => j.status == JobStatus.completed).toList();

  int get todayEarnings => weekEarnings[DateTime.now().weekday - 1];

  void _seed() {
    online = true;
    balance = 1240000;
    totalJobs = 126;
    weekEarnings = [180000, 95000, 240000, 120000, 330000, 76500, 150000];
    history = [
      const EarningEntry(
        title: 'Pembayaran - Servis & Cuci AC',
        date: 'Kemarin',
        amount: 102000,
      ),
      const EarningEntry(
        title: 'Penarikan ke rekening BCA',
        date: '2 hari lalu',
        amount: -500000,
      ),
      const EarningEntry(
        title: 'Pembayaran - Pasang Furnitur',
        date: '2 hari lalu',
        amount: 76500,
      ),
      const EarningEntry(
        title: 'Pembayaran - Cat Dinding Ruang Tamu',
        date: '3 hari lalu',
        amount: 297500,
      ),
    ];

    jobs = [
      Job(
        id: 'j1',
        serviceName: 'Servis & Cuci AC',
        categoryLabel: 'Servis AC',
        icon: Icons.ac_unit_rounded,
        color: AppColors.blue,
        customerName: 'Sinta',
        area: 'Beji, Depok',
        fullAddress: 'Jl. Margonda Raya No. 21, Beji, Depok',
        distanceKm: 2.4,
        schedule: 'Hari ini | 13:00',
        price: 120000,
        note: 'AC kamar tidur kurang dingin dan berisik. Ada dua unit di lantai 2.',
        status: JobStatus.newRequest,
      ),
      Job(
        id: 'j2',
        serviceName: 'Perbaikan Pipa Bocor',
        categoryLabel: 'Pipa & Ledeng',
        icon: Icons.plumbing_rounded,
        color: const Color(0xFF0891B2),
        customerName: 'Rudi',
        area: 'Cimanggis, Depok',
        fullAddress: 'Jl. Raya Bogor Km 30 No. 8, Cimanggis, Depok',
        distanceKm: 4.1,
        schedule: 'Hari ini | 15:30',
        price: 150000,
        note: 'Pipa di bawah wastafel dapur menetes terus sejak kemarin.',
        status: JobStatus.newRequest,
      ),
      Job(
        id: 'j3',
        serviceName: 'Pasang Stopkontak & Kabel',
        categoryLabel: 'Listrik',
        icon: Icons.electrical_services_rounded,
        color: const Color(0xFF4F46E5),
        customerName: 'Dewi',
        area: 'Bekasi Selatan',
        fullAddress: 'Jl. Ahmad Yani No. 55, Bekasi Selatan',
        distanceKm: 7.8,
        schedule: 'Besok | 09:00',
        price: 130000,
        note: 'Perlu tambah 3 stopkontak di ruang kerja dan rapikan kabel.',
        status: JobStatus.newRequest,
      ),
      Job(
        id: 'j4',
        serviceName: 'Cuci Sofa & Kursi',
        categoryLabel: 'Kebersihan Rumah',
        icon: Icons.cleaning_services_rounded,
        color: const Color(0xFF0EA5E9),
        customerName: 'Andi',
        area: 'Pancoran Mas, Depok',
        fullAddress: 'Jl. Kartini No. 12, Pancoran Mas, Depok',
        distanceKm: 3.2,
        schedule: 'Hari ini | 11:00',
        price: 150000,
        note: 'Sofa 3 dudukan dan 4 kursi makan, ada noda kopi.',
        status: JobStatus.accepted,
      ),
      Job(
        id: 'j5',
        serviceName: 'Servis & Cuci AC',
        categoryLabel: 'Servis AC',
        icon: Icons.ac_unit_rounded,
        color: AppColors.blue,
        customerName: 'Maya',
        area: 'Sukmajaya, Depok',
        fullAddress: 'Jl. Nusantara No. 3, Sukmajaya, Depok',
        distanceKm: 1.9,
        schedule: 'Kemarin | 10:00',
        price: 120000,
        note: 'Cuci rutin satu unit AC ruang tamu.',
        status: JobStatus.completed,
      ),
      Job(
        id: 'j6',
        serviceName: 'Pasang Furnitur',
        categoryLabel: 'Lainnya',
        icon: Icons.chair_rounded,
        color: const Color(0xFF1E3A8A),
        customerName: 'Budi',
        area: 'Bekasi Barat',
        fullAddress: 'Jl. Kalimalang No. 40, Bekasi Barat',
        distanceKm: 6.3,
        schedule: '2 hari lalu | 14:00',
        price: 90000,
        note: 'Pasang rak dinding dan TV 43 inch.',
        status: JobStatus.completed,
      ),
      Job(
        id: 'j7',
        serviceName: 'Cat Dinding Ruang Tamu',
        categoryLabel: 'Cat & Dekorasi',
        icon: Icons.format_paint_rounded,
        color: const Color(0xFF3B82F6),
        customerName: 'Lia',
        area: 'Beji, Depok',
        fullAddress: 'Jl. Kemiri No. 17, Beji, Depok',
        distanceKm: 2.8,
        schedule: '3 hari lalu | 09:00',
        price: 350000,
        note: 'Cat ulang satu ruang tamu ukuran 4x5 meter.',
        status: JobStatus.completed,
      ),
    ];
  }

  void reset() {
    _seed();
    notifyListeners();
  }

  void setOnline(bool value) {
    online = value;
    notifyListeners();
  }

  void accept(Job job) {
    job.status = JobStatus.accepted;
    notifyListeners();
  }

  void decline(Job job) {
    jobs.remove(job);
    notifyListeners();
  }

  void advance(Job job) {
    switch (job.status) {
      case JobStatus.accepted:
        job.status = JobStatus.onTheWay;
      case JobStatus.onTheWay:
        job.status = JobStatus.inProgress;
      case JobStatus.inProgress:
        job.status = JobStatus.completed;
        balance += job.net;
        totalJobs += 1;
        weekEarnings[DateTime.now().weekday - 1] += job.net;
        history.insert(
          0,
          EarningEntry(
            title: 'Pembayaran - ${job.serviceName}',
            date: 'Baru saja',
            amount: job.net,
          ),
        );
      case JobStatus.newRequest:
      case JobStatus.completed:
        break;
    }
    notifyListeners();
  }
}
