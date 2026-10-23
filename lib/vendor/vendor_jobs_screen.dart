import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'vendor_job_detail_screen.dart';
import 'vendor_models.dart';
import 'vendor_store.dart';

class VendorJobsScreen extends StatelessWidget {
  const VendorJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = VendorStore.instance;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pekerjaan'),
          bottom: const TabBar(
            labelColor: AppColors.blue,
            unselectedLabelColor: AppColors.muted,
            indicatorColor: AppColors.blue,
            dividerColor: AppColors.line,
            tabs: [
              Tab(text: 'Baru'),
              Tab(text: 'Aktif'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: store,
          builder: (context, _) => TabBarView(
            children: [
              _JobList(
                jobs: store.requests,
                empty: 'Belum ada permintaan baru.',
              ),
              _JobList(
                jobs: store.active,
                empty: 'Tidak ada pekerjaan yang sedang berjalan.',
              ),
              _JobList(
                jobs: store.completed,
                empty: 'Belum ada pekerjaan selesai.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JobList extends StatelessWidget {
  const _JobList({required this.jobs, required this.empty});

  final List<Job> jobs;
  final String empty;

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            empty,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.muted),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: jobs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _JobTile(job: jobs[i]),
    );
  }
}

class _JobTile extends StatelessWidget {
  const _JobTile({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => VendorJobDetailScreen(job: job)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              IconBadge(icon: job.icon, color: job.color, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.serviceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${job.area} | ${job.distanceKm.toStringAsFixed(1)} km',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    Text(
                      job.schedule,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    StatusChip(
                      label: job.status.label,
                      color: job.status.color,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    rupiah(job.net),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blue,
                    ),
                  ),
                  const Text(
                    'bersih',
                    style: TextStyle(fontSize: 10.5, color: AppColors.muted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
