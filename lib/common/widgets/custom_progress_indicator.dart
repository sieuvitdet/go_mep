import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProgressStep {
  final String id;
  final String title;
  final String? subtitle;
  final ProgressStepStatus status;
  final Map<String, dynamic>? data;

  ProgressStep({
    required this.id,
    required this.title,
    this.subtitle,
    required this.status,
    this.data,
  });

  factory ProgressStep.fromJson(Map<String, dynamic> json) {
    return ProgressStep(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      status: ProgressStepStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProgressStepStatus.pending,
      ),
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'status': status.name,
      'data': data,
    };
  }
}

enum ProgressStepStatus {
  completed,
  current,
  pending,
  disabled,
}

class CustomProgressIndicator extends StatelessWidget {
  final List<ProgressStep> steps;
  final EdgeInsets? padding;
  final double stepSpacing;
  final double circleRadius;
  final double? circleSpacing; // Distance between circles
  final double? textWidth; // Width for text labels
  final Color completedColor;
  final Color currentColor;
  final Color pendingColor;
  final Color disabledColor;
  final Color lineColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool showSubtitle;
  final Function(ProgressStep)? onStepTap;
  final Widget? customCompletedIcon;
  final Widget? customCurrentIcon;

  const CustomProgressIndicator({
    Key? key,
    required this.steps,
    this.padding,
    this.stepSpacing = 80.0,
    this.circleRadius = 20.0,
    this.circleSpacing,
    this.textWidth,
    this.completedColor = AppColors.green,
    this.currentColor = AppColors.primary,
    this.pendingColor = AppColors.greyLight,
    this.disabledColor = AppColors.grey,
    this.lineColor = AppColors.greyLight,
    this.titleStyle,
    this.subtitleStyle,
    this.showSubtitle = true,
    this.onStepTap,
    this.customCompletedIcon,
    this.customCurrentIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        children: [
          _buildProgressLine(),
          SizedBox(height: 12),
          _buildStepLabels(),
        ],
      ),
    );
  }

  Widget _buildProgressLine() {
    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          if (i == 0)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _buildStepCircle(steps[i], i),
            )
          else if (i == steps.length - 1) ...[
            Expanded(
              child: Container(
                height: 2,
                color: steps[i - 1].status == ProgressStepStatus.completed
                    ? completedColor
                    : lineColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _buildStepCircle(steps[i], i),
            ),
          ] else ...[
            Expanded(
              child: Container(
                height: 2,
                color: steps[i - 1].status == ProgressStepStatus.completed
                    ? completedColor
                    : lineColor,
              ),
            ),
            _buildStepCircle(steps[i], i),
          ],
        ],
      ],
    );
  }

  Widget _buildStepCircle(ProgressStep step, int index) {
    Color circleColor;
    Color? borderColor;
    Widget? icon;
    Color iconColor = Colors.white;

    switch (step.status) {
      case ProgressStepStatus.completed:
        circleColor = AppColors.white; // Bên trong trắng
        borderColor = completedColor; // Viền xanh lá
        icon = customCompletedIcon ??
            Icon(Icons.check, size: 16, color: completedColor); // Icon xanh lá
        break;
      case ProgressStepStatus.current:
        circleColor = currentColor; // Bên trong xanh lá (primary)
        icon = customCurrentIcon ??
            Text(
              '${index + 1}',
              style: TextStyle(
                color: iconColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            );
        break;
      case ProgressStepStatus.pending:
        circleColor = pendingColor;
        iconColor = Colors.grey[600]!;
        icon = Text(
          '${index + 1}',
          style: TextStyle(
            color: iconColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        );
        break;
      case ProgressStepStatus.disabled:
        circleColor = disabledColor;
        iconColor = Colors.grey[400]!;
        icon = Text(
          '${index + 1}',
          style: TextStyle(
            color: iconColor,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        );
        break;
    }

    return GestureDetector(
      onTap: onStepTap != null ? () => onStepTap!(step) : null,
      child: Container(
        width: circleRadius * 2,
        height: circleRadius * 2,
        decoration: BoxDecoration(
          color: circleColor,
          shape: BoxShape.circle,
          border: borderColor != null
              ? Border.all(color: borderColor, width: 2)
              : null,
          boxShadow: step.status == ProgressStepStatus.current
              ? [
                  BoxShadow(
                    color: currentColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildStepLabels() {
    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          if (i == 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Text(
                      steps[i].title,
                      textAlign: TextAlign.center,
                      style: titleStyle ??
                          TextStyle(
                            fontSize: 12,
                            fontWeight:
                                steps[i].status == ProgressStepStatus.current
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                            color: _getTextColor(steps[i].status),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showSubtitle && steps[i].subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        steps[i].subtitle!,
                        textAlign: TextAlign.center,
                        style: subtitleStyle ??
                            TextStyle(
                              fontSize: 10,
                              color: _getTextColor(steps[i].status)
                                  .withValues(alpha: 0.7),
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            )
          else if (i == steps.length - 1)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                    Text(
                      steps[i].title,
                      textAlign: TextAlign.center,
                      style: titleStyle ??
                          TextStyle(
                            fontSize: 12,
                            fontWeight:
                                steps[i].status == ProgressStepStatus.current
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                            color: _getTextColor(steps[i].status),
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showSubtitle && steps[i].subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        steps[i].subtitle!,
                        textAlign: TextAlign.center,
                        style: subtitleStyle ??
                            TextStyle(
                              fontSize: 10,
                              color: _getTextColor(steps[i].status)
                                  .withValues(alpha: 0.7),
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  Text(
                    steps[i].title,
                    textAlign: TextAlign.center,
                    style: titleStyle ??
                        TextStyle(
                          fontSize: 12,
                          fontWeight:
                              steps[i].status == ProgressStepStatus.current
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                          color: _getTextColor(steps[i].status),
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (showSubtitle && steps[i].subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      steps[i].subtitle!,
                      textAlign: TextAlign.center,
                      style: subtitleStyle ??
                          TextStyle(
                            fontSize: 10,
                            color: _getTextColor(steps[i].status)
                                .withValues(alpha: 0.7),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ],
    );
  }

  Color _getTextColor(ProgressStepStatus status) {
    switch (status) {
      case ProgressStepStatus.completed:
        return completedColor;
      case ProgressStepStatus.current:
        return currentColor;
      case ProgressStepStatus.pending:
        return Colors.grey[600]!;
      case ProgressStepStatus.disabled:
        return Colors.grey[400]!;
    }
  }
}

class ProgressIndicatorData {
  final String processId;
  final String title;
  final List<ProgressStep> steps;
  final DateTime? updatedAt;

  ProgressIndicatorData({
    required this.processId,
    required this.title,
    required this.steps,
    this.updatedAt,
  });

  factory ProgressIndicatorData.fromJson(Map<String, dynamic> json) {
    return ProgressIndicatorData(
      processId: json['processId'] ?? '',
      title: json['title'] ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((stepJson) => ProgressStep.fromJson(stepJson))
              .toList() ??
          [],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'processId': processId,
      'title': title,
      'steps': steps.map((step) => step.toJson()).toList(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
