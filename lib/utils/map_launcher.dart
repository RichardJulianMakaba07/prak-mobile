import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Membuka koordinat di aplikasi peta (Google Maps) / browser.
Future<void> openInMaps(BuildContext context, double lat, double lng) async {
  final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
  var ok = false;
  try {
    ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    ok = false;
  }
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tidak bisa membuka peta')),
    );
  }
}
