import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxify/controllers/auth_controller.dart';
import 'package:voxify/views/about/about.dart';
import 'package:voxify/views/home/home.dart';
import 'package:voxify/views/profile/profile.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthController>(context, listen: false).loadUserData();
    });
  }

  int _currentIndex = 1;

  final List<Widget> _pages = const [
    ProfilePageView(),
    HomePageView(),
    AboutPageView(),
  ];

  @override
  Widget build(BuildContext context) {
    const double circleSize = 56.0;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              bottom: 18,
              left: _getCirclePosition(context, _currentIndex, circleSize),
              child: Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),

            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: 'Perfil',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.map_rounded,
                    label: 'Home',
                    index: 1,
                  ),
                  _buildNavItem(
                    icon: Icons.info_rounded,
                    label: 'Sobre',
                    index: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getCirclePosition(
    BuildContext context,
    int index,
    double circleSize,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 3;
    return (itemWidth * index) + (itemWidth / 2) - (circleSize / 2);
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _currentIndex = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedTransform(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.translationValues(
                    0,
                    isSelected ? -6 : 0,
                    0,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isSelected ? 28 : 24,
                  ),
                ),
                const SizedBox(height: 2),

                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper para animar transformações de posição simples
class AnimatedTransform extends StatelessWidget {
  final Widget child;
  final Matrix4 transform;
  final Duration duration;

  const AnimatedTransform({
    super.key,
    required this.child,
    required this.transform,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      transform: transform,
      transformAlignment: Alignment.center,
      child: child,
    );
  }
}
