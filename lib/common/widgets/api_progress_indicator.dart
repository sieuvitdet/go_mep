import 'dart:async';

import 'package:flutter/material.dart';
import 'custom_progress_indicator.dart';

class ApiProgressIndicator extends StatefulWidget {
  final String? apiEndpoint;
  final Map<String, dynamic>? apiHeaders;
  final Map<String, dynamic>? requestBody;
  final ProgressIndicatorData? staticData;
  final Function(ProgressStep)? onStepTap;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final EdgeInsets? padding;
  final double stepSpacing;
  final double circleRadius;
  final Color completedColor;
  final Color currentColor;
  final Color pendingColor;
  final Color disabledColor;
  final Color lineColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool showSubtitle;
  final Widget? customCompletedIcon;
  final Widget? customCurrentIcon;
  final Duration refreshInterval;
  final bool autoRefresh;

  const ApiProgressIndicator({
    Key? key,
    this.apiEndpoint,
    this.apiHeaders,
    this.requestBody,
    this.staticData,
    this.onStepTap,
    this.loadingWidget,
    this.errorWidget,
    this.padding,
    this.stepSpacing = 80.0,
    this.circleRadius = 20.0,
    this.completedColor = const Color(0xFF4CAF50),
    this.currentColor = const Color(0xFF2196F3),
    this.pendingColor = const Color(0xFFE0E0E0),
    this.disabledColor = const Color(0xFFBDBDBD),
    this.lineColor = const Color(0xFFE0E0E0),
    this.titleStyle,
    this.subtitleStyle,
    this.showSubtitle = true,
    this.customCompletedIcon,
    this.customCurrentIcon,
    this.refreshInterval = const Duration(seconds: 30),
    this.autoRefresh = false,
  }) : super(key: key);

  @override
  State<ApiProgressIndicator> createState() => _ApiProgressIndicatorState();
}

class _ApiProgressIndicatorState extends State<ApiProgressIndicator> {
  ProgressIndicatorData? _progressData;
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    if (widget.staticData != null) {
      _progressData = widget.staticData;
    } else if (widget.apiEndpoint != null) {
      _fetchProgressData();
      if (widget.autoRefresh) {
        _startAutoRefresh();
      }
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(widget.refreshInterval, (_) {
      if (mounted) {
        _fetchProgressData();
      }
    });
  }

  Future<void> _fetchProgressData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Here you would integrate with your existing API service
      // For now, this is a placeholder for API integration
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Example: Using your repository pattern
      // final response = await context.read<Repository>().getProgressData(
      //   endpoint: widget.apiEndpoint!,
      //   headers: widget.apiHeaders,
      //   body: widget.requestBody,
      // );

      // For demonstration, we'll use mock data
      final mockResponse = _getMockApiResponse();
      final data = ProgressIndicatorData.fromJson(mockResponse);

      if (mounted) {
        setState(() {
          _progressData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _getMockApiResponse() {
    return {
      "processId": "process_001",
      "title": "Đơn mua HHDV",
      "updatedAt": DateTime.now().toIso8601String(),
      "steps": [
        {
          "id": "step_1",
          "title": "Chuẩn đoán",
          "subtitle": "Đánh giá tình trạng",
          "status": "completed",
          "data": {
            "completedAt": "2024-01-15T10:30:00Z",
            "notes": "Hoàn thành chuẩn đoán"
          }
        },
        {
          "id": "step_2",
          "title": "Mua HHDV",
          "subtitle": "Đặt hàng thiết bị",
          "status": "current",
          "data": {
            "startedAt": "2024-01-15T14:00:00Z",
            "estimatedCompletion": "2024-01-16T12:00:00Z"
          }
        },
        {
          "id": "step_3",
          "title": "Thành toán",
          "subtitle": "Thanh toán hóa đơn",
          "status": "pending",
          "data": {}
        }
      ]
    };
  }

  Future<void> _refreshData() async {
    if (widget.apiEndpoint != null) {
      await _fetchProgressData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _progressData == null) {
      return widget.loadingWidget ?? _buildDefaultLoading();
    }

    if (_error != null && _progressData == null) {
      return widget.errorWidget ?? _buildDefaultError();
    }

    if (_progressData == null) {
      return const SizedBox.shrink();
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_progressData!.title.isNotEmpty)
              Padding(
                padding: widget.padding ?? const EdgeInsets.all(16.0),
                child: Text(
                  _progressData!.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            CustomProgressIndicator(
              steps: _progressData!.steps,
              padding: widget.padding,
              stepSpacing: widget.stepSpacing,
              circleRadius: widget.circleRadius,
              completedColor: widget.completedColor,
              currentColor: widget.currentColor,
              pendingColor: widget.pendingColor,
              disabledColor: widget.disabledColor,
              lineColor: widget.lineColor,
              titleStyle: widget.titleStyle,
              subtitleStyle: widget.subtitleStyle,
              showSubtitle: widget.showSubtitle,
              onStepTap: widget.onStepTap,
              customCompletedIcon: widget.customCompletedIcon,
              customCurrentIcon: widget.customCurrentIcon,
            ),
            if (_progressData!.updatedAt != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Cập nhật lần cuối: ${_formatDateTime(_progressData!.updatedAt!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Không thể tải dữ liệu tiến trình',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Lỗi không xác định',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Extension to integrate with your existing Repository pattern
extension ProgressIndicatorRepository on dynamic {
  Future<Map<String, dynamic>> getProgressData({
    required String endpoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
  }) async {
    // Integration with your existing repository
    // This would use your current HTTP client (Dio) and error handling

    // Example implementation:
    // final response = await dio.post(
    //   endpoint,
    //   data: body,
    //   options: Options(headers: headers),
    // );
    //
    // return response.data;

    throw UnimplementedError('Integrate with your existing Repository class');
  }
}
