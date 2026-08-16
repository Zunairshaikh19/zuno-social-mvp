import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';

class PersonaStyleScreen extends StatefulWidget {
  const PersonaStyleScreen({super.key});

  @override
  State<PersonaStyleScreen> createState() => _PersonaStyleScreenState();
}

class _PersonaStyleScreenState extends State<PersonaStyleScreen> {
  String _selectedStyle = 'Professional';

  final List<Map<String, dynamic>> _styles = [
    {'name': 'Professional', 'desc': 'Informative, formal, and authoritative tone.', 'icon': Icons.business_center_rounded},
    {'name': 'Casual', 'desc': 'Friendly, relatable, and easy-going vibe.', 'icon': Icons.sentiment_satisfied_rounded},
    {'name': 'Hype', 'desc': 'Energetic, emoji-heavy, and exciting.', 'icon': Icons.bolt_rounded},
    {'name': 'Minimalist', 'desc': 'Clean, short sentences, and direct.', 'icon': Icons.shutter_speed_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Style')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(24.w),
              itemCount: _styles.length,
              itemBuilder: (context, index) {
                final style = _styles[index];
                final isSelected = _selectedStyle == style['name'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedStyle = style['name']),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.accentIndigo.withOpacity(0.05) : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected ? AppTheme.accentIndigo : Colors.grey.withOpacity(0.1),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: (style['icon'] as IconData == Icons.bolt_rounded ? Colors.orange : AppTheme.accentIndigo).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(style['icon'], color: style['icon'] == Icons.bolt_rounded ? Colors.orange : AppTheme.accentIndigo),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(style['name'], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.h),
                              Text(style['desc'], style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                            ],
                          ),
                        ),
                        if (isSelected) const Icon(Icons.check_circle_rounded, color: AppTheme.accentIndigo),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: AppButton(
              label: 'Save Style',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
