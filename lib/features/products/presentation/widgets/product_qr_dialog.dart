import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../utils/product_media_helper.dart';

class ProductQrDialog extends StatefulWidget {
  final String productName;
  final String qrCodePath;

  const ProductQrDialog({
    super.key,
    required this.productName,
    required this.qrCodePath,
  });

  @override
  State<ProductQrDialog> createState() => _ProductQrDialogState();
}

class _ProductQrDialogState extends State<ProductQrDialog> {
  bool _downloading = false;

  Future<void> _downloadQr() async {
    final url = ProductMediaHelper.fullUrl(widget.qrCodePath);
    if (url.isEmpty) return;

    final selectedDir = await FilePicker.platform.getDirectoryPath();
    if (selectedDir == null) return;

    final fileName =
        'qr_${widget.productName}_${DateTime.now().millisecondsSinceEpoch}.png';
    final savePath = '$selectedDir/$fileName';

    try {
      setState(() => _downloading = true);

      await Dio().download(url, savePath);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR kod saqlandi: $savePath')),
      );

      await OpenFilex.open(savePath);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yuklashda xatolik: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _downloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrUrl = ProductMediaHelper.fullUrl(widget.qrCodePath);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'QR kod',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.productName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 18),
              if (qrUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    qrUrl,
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 220,
                        height: 220,
                        alignment: Alignment.center,
                        color: Colors.grey.shade200,
                        child: const Text('QR rasm ochilmadi'),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: 220,
                  height: 220,
                  alignment: Alignment.center,
                  color: Colors.grey.shade200,
                  child: const Text('QR kod topilmadi'),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: _downloading ? null : _downloadQr,
                  icon: _downloading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.download),
                  label: Text(_downloading ? 'Yuklanmoqda...' : 'QR kodni yuklab olish'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}