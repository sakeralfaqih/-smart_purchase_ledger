import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// عارض صورة الفاتورة مع تكبير/تحريك، إعادة ضبط التكبير، وتنقّل بين الصفحات.
class InteractiveInvoiceImageViewer extends StatefulWidget {
  const InteractiveInvoiceImageViewer({
    super.key,
    required this.imagePaths,
  });

  final List<String> imagePaths;

  @override
  State<InteractiveInvoiceImageViewer> createState() =>
      _InteractiveInvoiceImageViewerState();
}

class _InteractiveInvoiceImageViewerState
    extends State<InteractiveInvoiceImageViewer> {
  int _index = 0;
  late final TransformationController _transformController;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _changePage(int newIndex) {
    setState(() {
      _index = newIndex;
      _transformController.value = Matrix4.identity();
    });
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return const ColoredBox(
        color: AppColors.background,
        child: Center(child: Text('لا توجد صورة')),
      );
    }
    final safeIndex = _index.clamp(0, widget.imagePaths.length - 1);
    final path = widget.imagePaths[safeIndex];

    return ColoredBox(
      color: Colors.black87,
      child: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              key: ValueKey<String>(path),
              transformationController: _transformController,
              minScale: 0.8,
              maxScale: 5.0,
              child: Center(
                child: Image.file(
                  File(path),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.white54),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: IconButton(
              tooltip: 'إعادة ضبط التكبير',
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
              onPressed: _resetZoom,
              icon: const Icon(
                Icons.center_focus_strong,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          if (widget.imagePaths.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed:
                        safeIndex > 0 ? () => _changePage(safeIndex - 1) : null,
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'صفحة ${safeIndex + 1} / ${widget.imagePaths.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    onPressed: safeIndex < widget.imagePaths.length - 1
                        ? () => _changePage(safeIndex + 1)
                        : null,
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
