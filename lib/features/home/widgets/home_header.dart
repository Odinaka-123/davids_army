import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader>
    with SingleTickerProviderStateMixin {
  bool _menuOpen = false;
  late final AnimationController _controller;
  late final Animation<double> _opacityAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
    _menuOpen ? _controller.forward() : _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Header Row
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                Text(
                  "David's Army",
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: Color(0xFF3B4930),
                  ),
                ),

                // Menu icon
                IconButton(
                  icon: Icon(
                    _menuOpen ? Icons.close : Icons.menu,
                    size: 28,
                    color: const Color(0xFF3B4930),
                  ),
                  onPressed: _toggleMenu,
                ),
              ],
            ),
          ),

          // Backdrop
          if (_menuOpen)
            FadeTransition(
              opacity: _opacityAnim,
              child: GestureDetector(
                onTap: _toggleMenu,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withAlpha((0.3 * 255).round()),
                ),
              ),
            ),

          // Slide-in menu
          SlideTransition(
            position: _slideAnim,
            child: _menuOpen
                ? Align(
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: double.infinity,
                          color: const Color.fromRGBO(255, 255, 255, 0.9),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 100),
                              _buildMenuItem(context, "Home", "/"),
                              _buildMenuItem(
                                context,
                                "Directory",
                                "/directory",
                              ),
                              _buildMenuItem(
                                context,
                                "Resources",
                                "/resources",
                              ),
                              _buildMenuItem(context, "Events", "/events"),
                              _buildMenuItem(context, "Generals", "/generals"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String route) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).go(route); // Navigate to route
        _toggleMenu(); // Close the menu
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF3B4930),
          ),
        ),
      ),
    );
  }
}
