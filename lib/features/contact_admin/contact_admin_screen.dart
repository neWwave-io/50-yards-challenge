import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_back_button.dart';
import 'contact_admin_controller.dart';
import 'data/contact_admin_repository.dart';
import 'widgets/message_composer.dart';
import 'widgets/past_message_card.dart';
import 'widgets/past_messages_header.dart';
import 'widgets/replies_disabled_banner.dart';

/// A one-way channel from the family to the admin team, opened from the
/// profile page's floating button. Lists what the family has already sent
/// and whether an admin has seen it.
class ContactAdminScreen extends StatefulWidget {
  const ContactAdminScreen({
    super.key,
    this.repository = const ContactAdminRepository(),
    this.onClose,
  });

  static const routeName = 'ContactAdmin';
  static const routePath = '/contactAdmin';

  final ContactAdminRepository repository;
  final VoidCallback? onClose;

  @override
  State<ContactAdminScreen> createState() => _ContactAdminScreenState();
}

class _ContactAdminScreenState extends State<ContactAdminScreen> {
  late final _controller = ContactAdminController(
    repository: widget.repository,
  );
  final _draft = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _draft.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final error = await _controller.send(_draft.text);
    if (!mounted) return;
    if (error == null) {
      _draft.clear();
      FocusScope.of(context).unfocus();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Your message was sent to the admin team.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onClose = widget.onClose;

    return Scaffold(
      backgroundColor: AppColors.olive50,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => RefreshIndicator(
            color: AppColors.olive500,
            onRefresh: _controller.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                onClose == null ? AppSpacing.xl : 0,
                AppSpacing.xl,
                AppSpacing.huge + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                if (onClose != null)
                  Transform.translate(
                    // The back button carries its own gutter; line its arrow
                    // up with the page's edge instead.
                    offset: const Offset(-AppSpacing.xl, 0),
                    child: AppBackButton(onTap: onClose),
                  ),
                Text(
                  'Contact Admin',
                  textAlign: TextAlign.center,
                  style: AppTypography.screenTitle,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Send A Notice Message To The Admin',
                  textAlign: TextAlign.center,
                  style: AppTypography.messageBody,
                ),
                const SizedBox(height: AppSpacing.xl),
                const RepliesDisabledBanner(),
                const SizedBox(height: AppSpacing.lg),
                MessageComposer(
                  controller: _draft,
                  sending: _controller.sending,
                  onSend: _send,
                ),
                const SizedBox(height: AppSpacing.xl),
                PastMessagesHeader(
                  newestFirst: _controller.newestFirst,
                  onToggleOrder: _controller.toggleOrder,
                ),
                const SizedBox(height: AppSpacing.lg),
                ..._pastMessages(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _pastMessages() {
    final messages = _controller.messages;

    if (messages.isEmpty) {
      final String note;
      if (_controller.loading) {
        return const [
          Center(child: CircularProgressIndicator(color: AppColors.olive500)),
        ];
      } else if (_controller.loadError != null) {
        note = '${_controller.loadError} Pull down to try again.';
      } else {
        note = 'Messages you send will show up here.';
      }
      return [
        Text(note, textAlign: TextAlign.center, style: AppTypography.emptyCaption),
      ];
    }

    return [
      for (final (i, message) in messages.indexed) ...[
        if (i > 0) const SizedBox(height: AppSpacing.md),
        PastMessageCard(key: ValueKey(message.id), message: message),
      ],
    ];
  }
}
