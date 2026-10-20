import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/models.dart';
import 'success_screen.dart';

/// Step 2 of booking: review the order, pick GoPay or Dana, and pay.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.item,
    required this.schedule,
    required this.address,
  });

  final ServiceItem item;
  final String schedule;
  final String address;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentId = SampleData.paymentMethods.first.id;
  bool _paying = false;
  bool _premium = false; // whether customer chose a fixed/premium worker

  late Worker _assignedWorker;

  static const int _serviceFee = 5000; // platform fee, flat (prototype)

  int get _baseWithWorker {
    final multiplier = _assignedWorker.priceMultiplier;
    return (widget.item.price * multiplier).round();
  }

  int get _total => _baseWithWorker + _serviceFee + (_premium ? SampleData.premiumFee : 0);

  PaymentMethod get _selectedPayment =>
      SampleData.paymentMethods.firstWhere((p) => p.id == _paymentId);

  @override
  void initState() {
    super.initState();
    // Assign a worker when the checkout screen is shown. Default is random.
    _assignedWorker = SampleData.assignWorker(widget.item.id, SampleData.city, premium: _premium);
  }

  void _togglePremium(bool? v) {
    setState(() {
      _premium = v ?? false;
      _assignedWorker = SampleData.assignWorker(widget.item.id, SampleData.city, premium: _premium);
    });
  }

  void _pay() {
    setState(() => _paying = true);
    // Prototype: simulate payment, then show success.
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SuccessScreen(
            item: widget.item,
            schedule: widget.schedule,
            paymentMethod: _selectedPayment.name,
            total: _total,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            _orderCard(),
            const SizedBox(height: 12),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _premium,
              onChanged: _togglePremium,
              title: const Text('Pilih teknisi khusus (biaya +Rp25.000)'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 10),
            const Text('Metode pembayaran',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            ...SampleData.paymentMethods.map(_paymentTile),
            const SizedBox(height: 20),
            _priceSummary(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _orderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EBF5)),
      ),
      child: Column(
        children: [
          // Assigned worker summary
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _assignedWorker.verified ? const Color(0xFFEFF6FF) : const Color(0xFFF3F4F6),
                child: Text(
                  _assignedWorker.name.split(' ').first,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_assignedWorker.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 14, color: const Color(0xFFF59E0B)),
                        const SizedBox(width: 4),
                        Text(_assignedWorker.rating.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        if (_assignedWorker.verified)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                            child: const Text('Terverifikasi', style: TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(formatIdr((widget.item.price * _assignedWorker.priceMultiplier).round()), style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2563EB))),
            ],
          ),
          const Divider(height: 20),
          _row('Layanan', widget.item.name),
          const Divider(height: 20),
          _row('Jadwal', widget.schedule),
          const Divider(height: 20),
          _row('Alamat', widget.address),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 84,
          child: Text(label,
              style:
                  const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        ),
        Expanded(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A))),
        ),
      ],
    );
  }

  Widget _paymentTile(PaymentMethod p) {
    final selected = p.id == _paymentId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _paymentId = p.id),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  selected ? const Color(0xFF2563EB) : const Color(0xFFE6EBF5),
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: p.brandColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(p.tag,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(p.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD6E6FF)),
      ),
      child: Column(
        children: [
          _priceRow('Harga layanan', formatIdr(_baseWithWorker)),
          const SizedBox(height: 8),
          _priceRow('Biaya layanan', formatIdr(_serviceFee)),
          if (_premium) ...[
            const SizedBox(height: 8),
            _priceRow('Biaya pilih teknisi', formatIdr(SampleData.premiumFee)),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          _priceRow('Total', formatIdr(_total), bold: true),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool bold = false}) {
    final style = bold
        ? const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A))
        : const TextStyle(fontSize: 14, color: Color(0xFF475569));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: style), Text(value, style: style)],
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE6EBF5))),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _paying ? null : _pay,
          child: _paying
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.4, color: Colors.white),
                )
              : Text('Bayar ${formatIdr(_total)}'),
        ),
      ),
    );
  }
}


