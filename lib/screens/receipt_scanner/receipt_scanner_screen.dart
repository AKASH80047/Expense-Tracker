import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';

class ReceiptScannerScreen extends ConsumerStatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  ConsumerState<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends ConsumerState<ReceiptScannerScreen> with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  bool _receiptExtracted = false;
  late AnimationController _laserController;

  // Extracted mock fields
  String _store = 'Amazon India';
  String _category = 'Shopping';
  double _amount = 2499;
  String _paymentMethod = 'UPI';
  final DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  void _startScan({bool isCamera = true}) {
    setState(() {
      _isScanning = true;
      _receiptExtracted = false;
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _receiptExtracted = true;
          // Vary the mock data if chosen from gallery vs camera
          if (!isCamera) {
            _store = 'Starbucks Coffee';
            _category = 'Food & Dining';
            _amount = 750;
            _paymentMethod = 'Credit Card';
          } else {
            _store = 'Amazon India';
            _category = 'Shopping';
            _amount = 2499;
            _paymentMethod = 'UPI';
          }
        });
      }
    });
  }

  void _addExtractedTransaction() {
    final newTx = TransactionModel(
      id: 'tx_scan_${DateTime.now().millisecondsSinceEpoch}',
      title: _store,
      category: _category,
      amount: _amount,
      type: TransactionType.expense,
      walletId: 'w_credit',
      walletName: _paymentMethod == 'UPI' ? 'HDFC Bank' : 'Credit Card',
      date: _date,
      notes: 'Auto-scanned via AI Smart Receipt OCR',
      receiptStore: _store,
    );

    ref.read(transactionsProvider.notifier).addTransaction(newTx);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('✓ Added ${CurrencyFormatter.format(_amount)} from $_store'),
          ],
        ),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Receipt Scanner'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Viewfinder / Scan Area
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2022),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [AppShadows.elevated],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Receipt Graphic Placeholder
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _receiptExtracted ? Icons.task_alt_rounded : Icons.document_scanner_rounded,
                            size: 48,
                            color: _receiptExtracted ? AppColors.success : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _isScanning
                              ? 'AI OCR Analyzing Receipt...'
                              : _receiptExtracted
                                  ? 'Receipt Extracted Successfully!'
                                  : 'Align receipt within the frame',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isScanning ? 'Extracting vendor, date & tax amount' : 'Supports physical paper & digital bills',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),

                    // Laser Scanning Bar Animation
                    if (_isScanning)
                      AnimatedBuilder(
                        animation: _laserController,
                        builder: (context, child) {
                          return Positioned(
                            top: 40 + (_laserController.value * 190),
                            left: 30,
                            right: 30,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.8),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons: Take Photo & Choose Gallery
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isScanning ? null : () => _startScan(isCamera: true),
                      icon: const Icon(Icons.camera_alt_outlined, size: 18),
                      label: const Text('Take Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isScanning ? null : () => _startScan(isCamera: false),
                      icon: const Icon(Icons.photo_library_outlined, size: 18),
                      label: const Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Extracted Receipt Card (when extracted)
              if (_receiptExtracted) ...[
                Text(
                  'Extracted Receipt Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: const [AppShadows.card],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _store,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                CurrencyFormatter.formatDate(_date),
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                          Text(
                            CurrencyFormatter.format(_amount),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.cardBorder),
                      const SizedBox(height: 12),
                      _buildReceiptRow('Category', _category),
                      _buildReceiptRow('Payment Method', _paymentMethod),
                      _buildReceiptRow('Confidence Score', '99.4% (Verified)'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _addExtractedTransaction,
                          child: const Text('Add Transaction to App'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
