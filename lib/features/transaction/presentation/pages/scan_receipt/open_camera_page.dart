import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:money_management_mobile/features/transaction/domain/services/image_picker_service.dart';
import 'package:money_management_mobile/injection_container.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OpenCameraPage extends StatefulWidget {
  const OpenCameraPage({super.key});

  @override
  State<OpenCameraPage> createState() => _OpenCameraPageState();
}

class _OpenCameraPageState extends State<OpenCameraPage> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInit = false;
  final ImagePickerService _imagePickerService = getIt<ImagePickerService>();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras[0],
          // Proporsional / high depends on device, standard mostly fits 16:9 
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInit = true;
          });
        }
      }
    } catch (e) {
        if (mounted) {
          AppSnackBar.showError(context, 'Gagal inisiasi kamera: $e');
        }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final XFile file = await _controller!.takePicture();
        if (mounted) {
          context.pushReplacement(AppRouter.scanLoading, extra: File(file.path));
        }
      } catch (e) {
        if (mounted) {
          AppSnackBar.showError(context, 'Gagal mengambil foto: $e');
        }
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final File? image = await _imagePickerService.pickFromGallery();
      if (image != null && mounted) {
        context.pushReplacement(AppRouter.scanLoading, extra: image);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Gagal memilih dari galeri: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          
          // Action UI Overlay
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _pickFromGallery,
                  icon: const PhosphorIcon(PhosphorIconsRegular.image, color: Colors.white, size: 32),
                  tooltip: 'Pilih dari Galeri',
                ),
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      color: Colors.white.withAlpha(80),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer balance
              ],
            ),
          ),

          // Close Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: const PhosphorIcon(PhosphorIconsRegular.x, color: Colors.white, size: 28),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}
