import 'package:flutter/material.dart';

typedef CustomRefreshCallback = Future<void> Function();
typedef CustomBodyBuilder = Widget Function();

const String NULL_VALUE = '-:-';
final DateTime firstDate = DateTime(1900);
