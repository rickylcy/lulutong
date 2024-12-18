import 'package:flutter/material.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  bool isMenuOpen = false; // Tracks if the menu is open
  bool isFABVisible = true;
  Offset fabPosition =
      Offset.zero; // Initial FAB position, dynamically set later

  final double fabSize = 56.0; // Default FAB size
  final double margin = 20.0; // Margin from screen edges

  void toggleFABVisibility() {
    setState(() {
      isFABVisible = !isFABVisible; // Toggle FAB visibility
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Calculate initial FAB position after layout is complete
      final Size screenSize = MediaQuery.of(context).size;
      final double jobListHeight =
          screenSize.height * 0.2 + 60; // Job list height

      setState(() {
        fabPosition = Offset(
          screenSize.width - fabSize - margin, // Right side
          screenSize.height -
              jobListHeight -
              fabSize -
              margin -
              60, // Above job list
        );
      });
    });
  }

  void _snapToNearestEdge(Size screenSize, double jobListHeight) {
    double x = fabPosition.dx;
    double y = fabPosition.dy;

    // Screen dimensions
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    // Determine the closest edge
    double leftDistance = x;
    double rightDistance = screenWidth - x - fabSize;
    double topDistance = y;
    double bottomDistance = screenHeight - y - fabSize - jobListHeight - 60;

    if (leftDistance <= rightDistance &&
        leftDistance <= topDistance &&
        leftDistance <= bottomDistance) {
      // Snap to Left
      x = margin;
    } else if (rightDistance <= topDistance &&
        rightDistance <= bottomDistance) {
      // Snap to Right
      x = screenWidth - fabSize - margin;
    } else if (topDistance <= bottomDistance) {
      // Snap to Top
      y = margin;
    } else {
      // Snap to Above Job List
      y = screenHeight - fabSize - jobListHeight - margin - 60;
    }

    // Clamp within screen boundaries
    setState(() {
      fabPosition = Offset(
        x.clamp(margin, screenWidth - fabSize - margin),
        y.clamp(margin, screenHeight - jobListHeight - fabSize - margin),
      );
    });
  }

  void _toggleMenu() {
    final Size screenSize = MediaQuery.of(context).size;
    final double jobListHeight = screenSize.height * 0.2 + 50;

    setState(() {
      isMenuOpen = !isMenuOpen;
    });

    double x = fabPosition.dx;
    double y = fabPosition.dy;

    // Screen dimensions
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    // Determine the closest edge
    double leftDistance = x;
    double rightDistance = screenWidth - x - fabSize;
    double topDistance = y;
    double bottomDistance = screenHeight - y - fabSize - jobListHeight;

    if (leftDistance <= rightDistance &&
        leftDistance <= topDistance &&
        leftDistance <= bottomDistance) {
      // Snap to Left
      print("LEFT");
      if (bottomDistance < 200) {
        if (isMenuOpen) {
          print("124124");
          y -= 200;
        }
      }
    } else if (rightDistance <= topDistance &&
        rightDistance <= bottomDistance) {
      // Snap to Right
      print("RIGHT");
      if (isMenuOpen) {
        print("1");
        x = screenWidth - fabSize - margin - 100;
        y -= 200;
      } else {
        print("2");
        x = screenWidth - fabSize - margin;
        y += 200;
      }
    } else if (topDistance <= bottomDistance) {
      // Snap to Top
      print("TOP");
    } else {
      print("BOT");
      // Snap to Above Job List
      if (isMenuOpen) {
        print("1");
        y -= 200;
      } else {
        print("2");
        y += 200;
      }
    }

    // Clamp within screen boundaries
    setState(() {
      fabPosition = Offset(
        x.clamp(margin, screenWidth - fabSize - margin),
        y.clamp(margin, screenHeight - fabSize - margin),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double jobListHeight =
        screenSize.height * 0.2 + 60; // Job List Panel Height

    return // Draggable FAB with Menu
        AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: fabPosition.dx,
      top: fabPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            fabPosition = Offset(
              fabPosition.dx + details.delta.dx,
              fabPosition.dy + details.delta.dy,
            );
          });
        },
        onPanEnd: (details) {
          _snapToNearestEdge(screenSize, jobListHeight);
        },
        child: Column(
          crossAxisAlignment: fabPosition.dx < screenSize.width / 2
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (isMenuOpen)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuButton(
                      icon: Icons.play_arrow,
                      label: "Start Route",
                      onPressed: () => print("Start Route"),
                    ),
                    _buildMenuButton(
                      icon: Icons.add,
                      label: "Add Parcel",
                      onPressed: () => print("Add Parcel"),
                    ),
                    _buildMenuButton(
                      icon: Icons.qr_code_scanner,
                      label: "Scan Address",
                      onPressed: () => print("Scan Address"),
                    ),
                  ],
                ),
              ),
            FloatingActionButton(
              onPressed: _toggleMenu,
              child: Icon(isMenuOpen ? Icons.close : Icons.menu),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 14)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          minimumSize: const Size(0, 40), // Compact size
        ),
      ),
    );
  }
}
