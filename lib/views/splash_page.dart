import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Pantalla de carga personalizada para la aplicación IMC
/// Diseño moderno y atractivo con múltiples animaciones
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador principal para animaciones secuenciales
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Controlador para rotación continua
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Controlador para efecto de pulso
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Animaciones principales
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutBack),
      ),
    );

    // Animación de rotación continua
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Animación de pulso
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Iniciar animaciones
    _mainController.forward();
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);

    // Navegar después de la animación
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/bienvenida');
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF4A90E2),
              Color(0xFF2E86AB),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Partículas de fondo animadas
            _buildAnimatedParticles(),

            // Contenido principal
            Center(
              child: AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo principal con múltiples efectos
                            _buildMainLogo(),

                            const SizedBox(height: 40),

                            // Título con efecto gradiente
                            _buildGradientTitle(),

                            const SizedBox(height: 16),

                            // Subtítulo elegante
                            _buildSubtitle(),

                            const SizedBox(height: 60),

                            // Indicador de carga moderno
                            _buildModernLoader(),

                            const SizedBox(height: 30),

                            // Texto de carga con efecto typewriter
                            _buildLoadingText(),

                            const SizedBox(height: 80),

                            // Crédito del desarrollador con estilo
                            _buildDeveloperCredit(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Partículas de fondo animadas
  Widget _buildAnimatedParticles() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            final double size = 20 + (index * 8);
            final double left =
                (index * 60.0) % MediaQuery.of(context).size.width;
            final double top =
                (index * 80.0) % MediaQuery.of(context).size.height;

            return Positioned(
              left: left,
              top: top,
              child: Transform.rotate(
                angle: _rotationAnimation.value + (index * 0.5),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // Logo principal con efectos visuales
  Widget _buildMainLogo() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFF0F4F8)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  spreadRadius: 5,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  spreadRadius: -5,
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Círculo interno con gradiente
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF4A90E2).withValues(alpha: 0.1),
                          const Color(0xFF2E86AB).withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                  ),
                ),
                // Ícono principal - Medición/Salud
                const Center(
                  child: Icon(
                    Icons.straighten, // Regla/medición
                    size: 70,
                    color: Color(0xFF2E86AB),
                  ),
                ),
                // Ícono secundario (balanza)
                const Positioned(
                  bottom: 25,
                  right: 25,
                  child: Icon(
                    Icons.monitor_weight_outlined,
                    size: 30,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Título con efecto gradiente
  Widget _buildGradientTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, Color(0xFFF0F4F8), Colors.white],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: const Text(
        'Calculadora IMC',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 2.0,
          shadows: [
            Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black26),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Subtítulo elegante
  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: const Text(
        'Tu salud, nuestro compromiso',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.8,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Indicador de carga moderno
  Widget _buildModernLoader() {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Círculo exterior
            Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
            // Círculo interior
            Transform.rotate(
              angle: -_rotationAnimation.value * 0.7,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Texto de carga con efecto
  Widget _buildLoadingText() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        // Calcular opacidad segura (entre 0.6 y 1.0)
        double opacity = 0.6 + (_pulseAnimation.value - 1.0) * 0.4;
        opacity = opacity.clamp(0.0, 1.0); // Asegurar que esté en rango válido

        return Opacity(
          opacity: opacity,
          child: const Text(
            'Inicializando aplicación...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.0,
            ),
          ),
        );
      },
    );
  }

  // Crédito del desarrollador con estilo
  Widget _buildDeveloperCredit() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.code,
            size: 16,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 8),
          const Text(
            'Desarrollado por Bassam Asfur',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
