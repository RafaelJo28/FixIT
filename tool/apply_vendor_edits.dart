// TEMPORARY helper script. Run once with `dart run tool/apply_vendor_edits.dart`,
// then delete this file. It makes exact, verified text edits and preserves
// each file's line endings and UTF-8 encoding.
import 'dart:io';

void replaceOnce(String path, String from, String to) {
  final original = File(path).readAsStringSync();
  final text = original.replaceAll('\r\n', '\n');
  final count = from.allMatches(text).length;
  if (count != 1) {
    stderr.writeln('FAILED $path: expected exactly 1 match, found $count for:');
    stderr.writeln(from);
    exit(1);
  }
  final i = text.indexOf(from);
  final updated = text.substring(0, i) + to + text.substring(i + from.length);
  final crlf = original.contains('\r\n');
  File(path).writeAsStringSync(crlf ? updated.replaceAll('\n', '\r\n') : updated);
  stdout.writeln('ok    $path');
}

void main() {
  replaceOnce(
    'lib/vendor/vendor_store.dart',
    r'''import 'vendor_models.dart';
import '../theme.dart';''',
    r'''import '../data/worker_directory.dart';
import '../theme.dart';
import 'vendor_models.dart';''',
  );
  replaceOnce(
    'lib/vendor/vendor_store.dart',
    r'''  VendorStore._() {
    _seed();
  }''',
    r'''  VendorStore._() {
    _seed();
    // Rebuild vendor screens whenever the public profile changes.
    WorkerDirectory.instance.addListener(notifyListeners);
  }''',
  );
  replaceOnce(
    'lib/vendor/vendor_store.dart',
    r'''  final double rating = 4.8;''',
    r'''  double get rating => WorkerDirectory.instance.me.rating;''',
  );
  replaceOnce(
    'lib/vendor/vendor_home_screen.dart',
    r'''import '../theme.dart';
import '../widgets/common.dart';
import 'vendor_job_detail_screen.dart';''',
    r'''import '../data/worker_directory.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/worker_widgets.dart';
import 'vendor_job_detail_screen.dart';''',
  );
  replaceOnce(
    'lib/vendor/vendor_home_screen.dart',
    r'''  const _VendorHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.blue,
            child: Text(
              'H',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, Pak Hendra',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),''',
    r'''  const _VendorHeader();

  @override
  Widget build(BuildContext context) {
    final me = WorkerDirectory.instance.me;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          WorkerAvatar(name: me.name, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${me.honorific} ${me.firstName}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),''',
  );
  replaceOnce(
    'lib/vendor/vendor_home_screen.dart',
    r'''const _VendorHeader(),''',
    r'''_VendorHeader(),''',
  );
  replaceOnce(
    'lib/vendor/vendor_job_detail_screen.dart',
    r'''label: 'Harga layanan',''',
    r'''label: 'Tarif kunjungan',''',
  );
  stdout.writeln('ALL EDITS APPLIED');
}
