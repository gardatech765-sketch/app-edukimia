import 'package:logger/logger.dart';

/// Global structured logger instance for debugging state transitions,
/// network events, audio plays, and user interactions.
final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,         // Clean output by omitting redundant stack traces
    errorMethodCount: 5,     // Show method calls when exceptions occur
    lineLength: 80,          // standard line width
    colors: true,            // Colorful terminal output
    printEmojis: true,       // Embellish logs with descriptive emojis
  ),
);
