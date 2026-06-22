import 'dart:ui_web' as ui_web;
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class WhatsAppBusinessButton extends StatefulWidget {
  final String phoneNumber;
  final String message;
  final VoidCallback onSaved;
  final Widget child;

  const WhatsAppBusinessButton({
    super.key,
    required this.phoneNumber,
    required this.message,
    required this.onSaved,
    required this.child,
  });

  @override
  State<WhatsAppBusinessButton> createState() => _WhatsAppBusinessButtonState();
}

class _WhatsAppBusinessButtonState extends State<WhatsAppBusinessButton> {
  late String _viewId;
  web.HTMLAnchorElement? _anchorElement;

  @override
  void initState() {
    super.initState();
    _viewId = 'wa-biz-link-${DateTime.now().microsecondsSinceEpoch}';

    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;

      anchor.style.display = 'block';
      anchor.style.width = '100%';
      anchor.style.height = '100%';
      anchor.style.background = 'transparent';
      anchor.style.border = 'none';
      anchor.style.cursor = 'pointer';

      _updateAnchor(anchor);

      anchor.addEventListener('click', ((web.Event event) {
        widget.onSaved();
      }).toJS);

      _anchorElement = anchor;
      return anchor;
    });
  }

  @override
  void didUpdateWidget(WhatsAppBusinessButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_anchorElement != null) {
      _updateAnchor(_anchorElement!);
    }
  }

  void _updateAnchor(web.HTMLAnchorElement anchor) {
    final encodedText = Uri.encodeComponent(widget.message);
    anchor.href =
        'whatsapp-biz://send?phone=${widget.phoneNumber}&text=$encodedText';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        Positioned.fill(
          child: HtmlElementView(viewType: _viewId),
        ),
      ],
    );
  }
}
