import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/segments/presentation/bloc/segment_wizard_bloc.dart';
import 'package:zunosocial/features/segments/presentation/widgets/wizard_steps.dart';

class SegmentWizardScreen extends StatelessWidget {
  const SegmentWizardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SegmentWizardBloc>(),
      child: BlocConsumer<SegmentWizardBloc, SegmentWizardState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Segment created successfully!')),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('New Persona Wizard'),
              leading: state.currentStep > 0
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.read<SegmentWizardBloc>().add(PreviousStep()),
                    )
                  : null,
            ),
            body: Column(
              children: [
                _WizardProgressHeader(currentStep: state.currentStep),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildStep(state.currentStep),
                  ),
                ),
                _WizardNavigationFooter(state: state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return const Step1NicheSelection();
      case 1:
        return const Step2PersonaEngine();
      case 2:
        return const Step3AutomationConfig();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _WizardProgressHeader extends StatelessWidget {
  final int currentStep;
  const _WizardProgressHeader({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= currentStep;
          final isCompleted = index < currentStep;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32.h,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                  ),
                ),
                if (index < 2)
                  Expanded(
                    child: Container(
                      height: 2.h,
                      color: isActive && currentStep > index
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _WizardNavigationFooter extends StatelessWidget {
  final SegmentWizardState state;
  const _WizardNavigationFooter({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (state.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.read<SegmentWizardBloc>().add(PreviousStep()),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56.h),
                ),
                child: const Text('Back'),
              ),
            ),
          if (state.currentStep > 0) SizedBox(width: 16.w),
          Expanded(
            flex: 2,
            child: AppButton(
              label: state.currentStep == 2 ? 'Launch Persona' : 'Next Step',
              isLoading: state.isSubmitting,
              onPressed: () {
                if (state.currentStep == 2) {
                  context.read<SegmentWizardBloc>().add(SubmitSegment());
                } else {
                  context.read<SegmentWizardBloc>().add(NextStep());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
