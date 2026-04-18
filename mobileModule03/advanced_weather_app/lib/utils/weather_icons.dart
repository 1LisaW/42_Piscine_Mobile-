import 'package:flutter/material.dart';

IconData weatherIconForCode(int code) {
  switch (code) {
    case 0:
    case 1:
      return Icons.wb_sunny_rounded;
    case 2:
      return Icons.cloud_queue_rounded;
    case 3:
      return Icons.cloud_rounded;
    case 45:
    case 48:
      return Icons.foggy;
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return Icons.grain;
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
      return Icons.umbrella;
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return Icons.ac_unit;
    case 95:
    case 96:
    case 99:
      return Icons.thunderstorm;
    default:
      return Icons.help_outline_rounded;
  }
}
