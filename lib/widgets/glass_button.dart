import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';

/// A premium, highly customizable Glassmorphic button and card container.
/// Applies a frosted glass blur effect, thin glowing borders, and subtle gradients.
/// Triggers clean haptic feedback automatically upon interaction.
class GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  
  /// Determines if the button is interactive or styled as active.
  final bool isActive;
  
  /// Controls the curve radius of the container (e.g. large curves resemble water droplets).
  final double borderRadius;
  
  /// Custom border color. Fallbacks to cyan highlight if [isActive] is true.
  final Color? borderColor;
  
  /// Custom background overlay fill color.
  final Color? fillColor;
  
  final double paddingVertical;
  final double paddingHorizontal;

  const GlassButton({
    super.key,
    required this.child,
    this.onTap,
    this.isActive = true,
    this.borderRadius = 24.0,
    this.borderColor,
    this.fillColor,
    this.paddingVertical = 16.0,
    this.paddingHorizontal = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorder = Border.all(
      color: borderColor ?? 
          (isActive 
              ? AppColors.accentNeon.withValues(alpha: 0.4) 
              : Colors.white.withValues(alpha: 0.12)),
      width: 1.5,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: effectiveBorder,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                fillColor ?? (isActive ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.02)),
                fillColor ?? (isActive ? Colors.white.withValues(alpha: 0.03) : Colors.white.withValues(alpha: 0.01)),
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              splashColor: AppColors.accentNeon.withValues(alpha: 0.2),
              highlightColor: Colors.transparent,
              onTap: onTap != null
                  ? () {
                      HapticFeedback.lightImpact();
                      onTap!();
                    }
                  : null,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: paddingVertical,
                  horizontal: paddingHorizontal,
                ),
                child: Center(child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
