import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/constants.dart';
import 'dart:developer' as developer;

/// Shows a floating top message with a shrinking progress line.
///
/// Usage:
/// showTopFloatingMessage(context, 'Error happened', isError: true, duration: Duration(seconds: 3));

/// Keep a reference to the currently-displayed overlay so we only show one at a time.
OverlayEntry? _currentTopFloatingEntry;

void showTopFloatingMessage(
  BuildContext context,
  String message, {
  bool isError = true,
  Duration duration = const Duration(milliseconds: 2500),
}) {
  developer.log('showTopFloatingMessage called', name: 'TopFloatingMessage', error: {'message': message, 'isError': isError});

  // If an existing message is visible, remove it first so only one is shown.
  if (_currentTopFloatingEntry != null) {
    try {
      _currentTopFloatingEntry!.remove();
    } catch (_) {}
    _currentTopFloatingEntry = null;
  }

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => SafeArea(
      child: _TopFloatingMessageWidget(
        message: message,
        isError: isError,
        duration: duration,
        onFinish: () {
          // When the widget finishes its animation remove the entry and clear the reference
          try {
            entry.remove();
          } catch (_) {}
          if (_currentTopFloatingEntry == entry) _currentTopFloatingEntry = null;
        },
      ),
    ),
  );

  _currentTopFloatingEntry = entry;

  try {
    // Prefer the app-level overlay so the message is visible above navigators/routes
    developer.log('Locating overlay via appNavigatorKey...', name: 'TopFloatingMessage');
    developer.log('appNavigatorKey.overlay not available; falling back to Overlay.of(context, rootOverlay: true)', name: 'TopFloatingMessage');
    final overlay = Overlay.of(context, rootOverlay: true);
    overlay.insert(entry);
    developer.log('Overlay inserted via context.rootOverlay', name: 'TopFloatingMessage');
  } catch (e, st) {
    developer.log('Failed to insert overlay: $e\n$st', name: 'TopFloatingMessage');
    // fallback so the user still sees the message
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {}
    _currentTopFloatingEntry = null;
  }
}

class _TopFloatingMessageWidget extends StatefulWidget {
  final String message;
  final bool isError;
  final Duration duration;
  final VoidCallback onFinish;

  const _TopFloatingMessageWidget({
    Key? key,
    required this.message,
    required this.isError,
    required this.duration,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<_TopFloatingMessageWidget> createState() => _TopFloatingMessageWidgetState();
}

class _TopFloatingMessageWidgetState extends State<_TopFloatingMessageWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinish();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = 8.0; // SafeArea already applied
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: GestureDetector(
            onTap: () {
              // allow manual dismiss
              widget.onFinish();
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: screenWidth * 0.92,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    // Use the app primary color for the dialog background
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.message,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      // A thin line that shrinks from full to 0. Use red for the progress color.
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 1.0 - _controller.value,
                          minHeight: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
