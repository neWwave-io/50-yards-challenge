import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_primary_button.dart';

/// The message box and its "Send Message" button, on a glass card.
class MessageComposer extends StatefulWidget {
  const MessageComposer({
    super.key,
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_rebuild);
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    _focusNode.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        // Flattened: a translucent fill lets the card's own shadow tint it.
        color: AppColors.rowFill,
        borderRadius: BorderRadius.circular(AppRadii.row),
        boxShadow: AppShadows.cardRaised,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: _focusNode.requestFocus,
            child: Container(
              height: AppSizes.messageBoxHeight,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? AppColors.borderFocused
                      : AppColors.borderDefault,
                ),
                borderRadius: BorderRadius.circular(AppRadii.field),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                enabled: !widget.sending,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: AppTypography.messageBody
                    .copyWith(color: AppColors.textDefault),
                cursorColor: AppColors.olive500,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message',
                  hintStyle: AppTypography.messageBody,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            label: 'Send Message',
            busy: widget.sending,
            onPressed: hasText ? widget.onSend : null,
          ),
        ],
      ),
    );
  }
}
