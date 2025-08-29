import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  // Heights in pixels for expanded and collapsed states
  final double expandedHeightFraction = 0.7;
  final double collapsedHeightFraction = 0.1;

  late AnimationController _controller;
  late Animation<double> _heightFactorAnimation;

  double screenHeight = 0;

  final List<_Option> options = [
    _Option(icon: Icons.photo, label: "Photo/Video"),
    _Option(icon: Icons.person_add, label: "Tag People"),
    _Option(icon: Icons.mood, label: "Feeling/Activity"),
  ];

  bool get isExpanded => _controller.value > 0.5;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0, // start expanded
    );

    _heightFactorAnimation =
        Tween<double>(begin: collapsedHeightFraction, end: expandedHeightFraction)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // Negative dragDelta = drag up, positive = drag down
    final dragDelta = details.primaryDelta ?? 0;

    // Convert drag delta to controller value change
    double fractionDragged = dragDelta / screenHeight;

    _controller.value -= fractionDragged;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.value >= 0.5) {
      _controller.fling(velocity: 1); // expand
    } else {
      _controller.fling(velocity: -1); // collapse
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const Text(
            "Create Post",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...options.map((option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(option.icon, size: 28),
                const SizedBox(width: 16),
                Text(
                  option.label,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          )),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: options
            .map((option) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(option.icon, size: 28),
            const SizedBox(height: 4),
            Text(
              option.label,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Stack(
        children: [
          // Background tap to close or dim area can be added here
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final height =
                  _heightFactorAnimation.value * screenHeight;

              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: height,
                child: GestureDetector(
                  onVerticalDragUpdate: _handleDragUpdate,
                  onVerticalDragEnd: _handleDragEnd,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
                    ),
                    child: ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                      child: isExpanded
                          ? _buildExpandedContent()
                          : _buildCollapsedContent(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Option {
  final IconData icon;
  final String label;
  _Option({required this.icon, required this.label});
}
