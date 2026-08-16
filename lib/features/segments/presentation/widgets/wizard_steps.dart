import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/segments/presentation/bloc/segment_wizard_bloc.dart';

class Step1NicheSelection extends StatelessWidget {
  const Step1NicheSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final niches = [
      {'icon': Icons.smart_toy_outlined, 'name': 'AI Influencer'},
      {'icon': Icons.laptop_outlined, 'name': 'Tech Guru'},
      {'icon': Icons.fitness_center_outlined, 'name': 'Fitness Pro'},
      {'icon': Icons.diamond_outlined, 'name': 'Luxury Life'},
      {'icon': Icons.shopping_bag_outlined, 'name': 'E-commerce'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The Foundation',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text('Name your workspace and choose a content niche.'),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Segment Name',
            hint: 'e.g., Cyber Influencer V1',
            onChanged: (v) {
              final current = context.read<SegmentWizardBloc>().state.segment;
              context.read<SegmentWizardBloc>().add(UpdateSegmentData(current.copyWith(name: v)));
            },
          ),
          const SizedBox(height: 32),
          const Text('Select Niche', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: niches.map((niche) {
              final state = context.watch<SegmentWizardBloc>().state;
              final isSelected = state.segment.niche == niche['name'];
              return _NicheCard(
                icon: niche['icon'] as IconData,
                label: niche['name'] as String,
                isSelected: isSelected,
                onTap: () {
                  context.read<SegmentWizardBloc>().add(
                    UpdateSegmentData(state.segment.copyWith(niche: niche['name'] as String)),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class Step2PersonaEngine extends StatelessWidget {
  const Step2PersonaEngine({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SegmentWizardBloc>().state;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Persona Engine',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 32),
          const Text('Reference Image', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _ImagePickerPlaceholder(
            onTap: () {}, // Trigger image picker logic
          ),
          const SizedBox(height: 32),
          AppTextField(
            label: 'Personality Prompt',
            hint: 'Describe your persona\'s voice, tone, and visual style...',
            maxLines: 4,
            onChanged: (v) {
              context.read<SegmentWizardBloc>().add(
                UpdateSegmentData(state.segment.copyWith(personaPrompt: v)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Step3AutomationConfig extends StatelessWidget {
  const Step3AutomationConfig({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SegmentWizardBloc>().state;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Automation Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 32),
          const Text('Posting Frequency', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: state.segment.postingFrequency,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: ['Daily', '3 times / week', 'Weekly'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (v) {
              context.read<SegmentWizardBloc>().add(
                UpdateSegmentData(state.segment.copyWith(postingFrequency: v)),
              );
            },
          ),
          const SizedBox(height: 32),
          SwitchListTile(
            title: const Text('Auto-pilot Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Directly publish to Instagram without manual review'),
            value: state.segment.autoPublish,
            onChanged: (v) {
              context.read<SegmentWizardBloc>().add(
                UpdateSegmentData(state.segment.copyWith(autoPublish: v)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NicheCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NicheCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey.shade400;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _ImagePickerPlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  const _ImagePickerPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.3), style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey),
            const SizedBox(height: 12),
            Text('Upload Reference Image', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}
