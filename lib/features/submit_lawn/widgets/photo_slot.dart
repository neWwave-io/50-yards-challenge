import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';

/// A labelled photo box: an upload icon until a picture is chosen, then the
/// picture itself. Tapping asks camera or library, either way.
class PhotoSlot extends StatelessWidget {
  const PhotoSlot({
    super.key,
    required this.label,
    required this.photo,
    required this.onPicked,
  });

  final String label;
  final Uint8List? photo;
  final ValueChanged<Uint8List> onPicked;

  /// Proof photos only need to show the lawn; this keeps an upload to a few
  /// hundred KB on a phone camera.
  static const _maxEdge = 1600.0;
  static const _quality = 80;

  Future<void> _pick(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadii.dropdown),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SourceOption(
                icon: Icons.photo_camera_outlined,
                label: 'Take a photo',
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              _SourceOption(
                icon: Icons.photo_library_outlined,
                label: 'Choose from library',
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;

    final XFile? file;
    try {
      file = await ImagePicker().pickImage(
        source: source,
        maxWidth: _maxEdge,
        maxHeight: _maxEdge,
        imageQuality: _quality,
      );
    } catch (e) {
      // Most often a refused camera or photo permission.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the ${source.name}: $e')),
        );
      }
      return;
    }
    if (file == null) return;
    onPicked(await file.readAsBytes());
  }

  @override
  Widget build(BuildContext context) {
    final bytes = photo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTypography.prompt),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          button: true,
          label: bytes == null ? 'Add $label' : 'Replace $label',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _pick(context),
            child: Container(
              height: AppSizes.photoSlotHeight,
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.field),
                boxShadow: AppShadows.photoSlot,
              ),
              child: bytes == null
                  ? SvgPicture.asset(
                      'assets/icons/upload.svg',
                      width: AppSizes.icon,
                      height: AppSizes.icon,
                    )
                  : Image.memory(
                      bytes,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: AppColors.olive600),
        title: Text(label, style: AppTypography.bodyMedium),
        onTap: onTap,
      );
}
