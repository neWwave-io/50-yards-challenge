import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/child_options.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_date_picker_dialog.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_select_field.dart';
import '../../../../core/widgets/app_tap_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../child.dart';

/// The moss-green card for entering one child's details.
class AddChildCard extends StatefulWidget {
  const AddChildCard({
    super.key,
    required this.index,
    required this.child,
    required this.onChanged,
    required this.onRemove,
    required this.onDone,
  });

  /// One-based — the card is titled "CHILD 1".
  final int index;

  final Child child;
  final ValueChanged<Child> onChanged;
  final VoidCallback onRemove;

  /// Commits the card; disabled until every field is answered.
  final VoidCallback onDone;

  @override
  State<AddChildCard> createState() => _AddChildCardState();
}

class _AddChildCardState extends State<AddChildCard> {
  late final TextEditingController _name =
      TextEditingController(text: widget.child.name);

  @override
  void initState() {
    super.initState();
    _name.addListener(
      () => widget.onChanged(widget.child.copyWith(name: _name.text)),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showAppDatePicker(
      context,
      initialDate: widget.child.dateOfBirth,
      // A challenger is a kid, so eighteen years of history is plenty.
      firstDate: DateTime(now.year - 18),
      lastDate: now,
    );
    if (picked != null) {
      widget.onChanged(widget.child.copyWith(dateOfBirth: picked));
    }
  }

  Future<void> _pickPhoto() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (mounted) widget.onChanged(widget.child.copyWith(photo: bytes));
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child;
    final dob = child.dateOfBirth;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.moss50,
        border: Border.all(color: AppColors.borderDefault),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CHILD ${widget.index}',
                style: AppTypography.groupLabel,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onRemove,
                child: Text('Remove', style: AppTypography.groupAction),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Kid Name',
            controller: _name,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTapField(
            label: 'Date of birth',
            value: dob == null ? null : formatBirthday(dob),
            onTap: _pickDate,
            trailing: SvgPicture.asset(
              'assets/icons/calendar.svg',
              width: AppSizes.icon,
              height: AppSizes.icon,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppSelectField(
            label: 'Gender',
            options: [for (final g in ChildGender.values) g.label],
            value: child.gender?.label,
            onChanged: (label) => widget.onChanged(
              child.copyWith(gender: ChildGender.fromLabel(label)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppSelectField(
            label: 'Shirt Size',
            options: kShirtSizes,
            value: child.shirtSize,
            onChanged: (size) =>
                widget.onChanged(child.copyWith(shirtSize: size)),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: _PhotoWell(photo: child.photo, onTap: _pickPhoto),
          ),
          const SizedBox(height: AppSpacing.md),
          AppPrimaryButton(
            label: 'Add',
            onPressed: child.isComplete ? widget.onDone : null,
          ),
        ],
      ),
    );
  }
}

class _PhotoWell extends StatelessWidget {
  const _PhotoWell({required this.photo, required this.onTap});

  final Uint8List? photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: AppSizes.photo,
        height: AppSizes.photo,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.borderDefault),
          borderRadius: BorderRadius.circular(AppRadii.field),
        ),
        clipBehavior: Clip.antiAlias,
        child: photo == null
            ? SvgPicture.asset(
                'assets/icons/camera.svg',
                width: AppSizes.icon,
                height: AppSizes.icon,
              )
            : Image.memory(
                photo!,
                width: AppSizes.photo,
                height: AppSizes.photo,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
