import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_field_shell.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_select_field.dart';
import '../data/badge_data.dart';

/// Sends a request for a badge earned by service outside mowing: which
/// badge, what the child did, and a photo for an admin to check.
///
/// Returns true once a request has gone in.
Future<bool?> showRequestBadgeDialog(
  BuildContext context, {
  required List<ChallengeBadge> badges,
  required Future<String?> Function(
    ChallengeBadge badge,
    String explanation,
    Uint8List photo,
  ) onSubmit,
}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => RequestBadgeDialog(badges: badges, onSubmit: onSubmit),
    );

class RequestBadgeDialog extends StatefulWidget {
  const RequestBadgeDialog({
    super.key,
    required this.badges,
    required this.onSubmit,
  });

  /// The badges that can be asked for right now.
  final List<ChallengeBadge> badges;

  /// Returns a message to show if it failed.
  final Future<String?> Function(
    ChallengeBadge badge,
    String explanation,
    Uint8List photo,
  ) onSubmit;

  @override
  State<RequestBadgeDialog> createState() => _RequestBadgeDialogState();
}

class _RequestBadgeDialogState extends State<RequestBadgeDialog> {
  final _explanation = TextEditingController();
  final _focus = FocusNode();

  ChallengeBadge? _badge;
  Uint8List? _photo;
  var _sending = false;
  String? _problem;

  static const _boxHeight = 120.0;

  /// The design's notch label on these two boxes.
  static TextStyle get _notch => AppTypography.labelMedium
      .copyWith(fontSize: 10, color: AppColors.olive600);

  /// Both boxes keep the olive outline and their label at rest, as drawn.
  static const _outline = AppColors.borderFocused;

  /// A proof photo only has to show the child at work.
  static const _maxEdge = 1600.0;
  static const _quality = 80;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_rebuild);
    _explanation.addListener(_rebuild);
  }

  @override
  void dispose() {
    _explanation.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  bool get _complete =>
      _badge != null && _explanation.text.trim().isNotEmpty && _photo != null;

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined,
                  color: AppColors.olive600),
              title: Text('Take a photo', style: AppTypography.bodyMedium),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.olive600),
              title: Text('Choose from library', style: AppTypography.bodyMedium),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: _maxEdge,
        maxHeight: _maxEdge,
        imageQuality: _quality,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _photo = bytes);
    } catch (e) {
      // Most often a refused camera or photo permission.
      if (mounted) setState(() => _problem = 'Could not open the ${source.name}.');
    }
  }

  Future<void> _submit() async {
    final badge = _badge;
    final photo = _photo;
    if (badge == null || photo == null) return;

    setState(() {
      _sending = true;
      _problem = null;
    });
    final problem = await widget.onSubmit(badge, _explanation.text, photo);
    if (!mounted) return;
    if (problem == null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _sending = false;
        _problem = problem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final names = [for (final b in widget.badges) b.name];
    final photo = _photo;

    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.dialog),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Semantics(
                button: true,
                label: 'Close',
                child: GestureDetector(
                  onTap: _sending ? null : () => Navigator.pop(context, false),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: AppSpacing.sm,
                      top: AppSpacing.sm,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/badge_close.svg',
                      width: 12,
                      height: 12,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              'Request a Badge',
              textAlign: TextAlign.center,
              style: AppTypography.dialogTitle,
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'To request certain badges, please submit proof below. Most '
              'badge requests require wearing your Raising Men or Raising '
              'Women shirt.',
              textAlign: TextAlign.center,
              style: AppTypography.statLabel,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppSelectField(
              label: 'Select Badge',
              options: names,
              value: _badge?.name,
              enabled: names.isNotEmpty && !_sending,
              placeholder: names.isEmpty ? 'No badges to request right now' : null,
              onChanged: (name) => setState(
                () => _badge = widget.badges.firstWhere((b) => b.name == name),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppFieldShell(
              label: 'Explanation',
              labelStyle: _notch,
              filled: true,
              borderColor: _outline,
              shadow: AppShadows.fieldFocused,
              height: _boxHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: TextField(
                controller: _explanation,
                focusNode: _focus,
                enabled: !_sending,
                maxLines: null,
                expands: true,
                maxLength: 1000,
                textAlignVertical: TextAlignVertical.top,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: AppColors.olive600,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  counterText: '',
                  hintText: 'What service did you do?',
                  hintStyle: AppTypography.bodySmall
                      .copyWith(color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              button: true,
              label: photo == null ? 'Add a photo' : 'Replace the photo',
              child: AppFieldShell(
                label: 'Photo',
                labelStyle: _notch,
                filled: true,
                borderColor: _outline,
                shadow: AppShadows.fieldFocused,
                height: _boxHeight,
                padding: EdgeInsets.zero,
                onTap: _sending ? null : _pickPhoto,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadii.field),
                  child: photo == null
                      ? Center(
                          child: SvgPicture.asset(
                            'assets/icons/upload.svg',
                            width: AppSizes.icon,
                            height: AppSizes.icon,
                          ),
                        )
                      : Image.memory(
                          photo,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                ),
              ),
            ),
            if (_problem != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                _problem!,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: AppColors.danger),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: SizedBox(
                width: 197,
                child: AppPrimaryButton(
                  label: 'Request For Badge',
                  busy: _sending,
                  onPressed: _complete ? _submit : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
