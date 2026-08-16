import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/ai_studio/presentation/bloc/ai_studio_bloc.dart';
import 'package:zunosocial/features/ai_studio/data/models/ai_generated_post_model.dart';

import 'package:zunosocial/core/l10n/app_localizations.dart';

class AiStudioScreen extends StatefulWidget {
  const AiStudioScreen({super.key});

  @override
  State<AiStudioScreen> createState() => _AiStudioScreenState();
}

class _AiStudioScreenState extends State<AiStudioScreen> {
  final _promptController = TextEditingController();
  bool _usePersona = true;
  String _selectedAspectRatio = '1:1';

  final List<String> _inspirationTags = [
    'Daily Outfit',
    'Tech Review',
    'Morning Motivation',
    'Industry News',
    'Product Launch',
  ];

  void _onGenerate() {
    if (_promptController.text.isNotEmpty) {
      context.read<AiStudioBloc>().add(
            GenerateInstantPostRequested(
              segmentId: 'active_seg',
              promptTopic: _promptController.text,
              usePersonaReference: _usePersona,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => sl<AiStudioBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.translate('ai_studio'))),
        body: BlocConsumer<AiStudioBloc, AiStudioState>(
          listener: (context, state) {
            if (state is AiActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppTheme.successEmerald),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is AiStudioInitial) _buildComposer(context),
                  if (state is AiGeneratingText || state is AiGeneratingImage) _buildGeneratingState(state),
                  if (state is AiGenerationSuccess) _buildReviewStudio(context, state.post),
                  if (state is AiGenerationFailure) _buildErrorState(state.message),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInDown(
          child: Text(
            l10n.translate('what_create'),
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(height: 24.h),
        AppTextField(
          label: l10n.translate('post_topic'),
          hint: 'e.g., A review of the latest neural link interface...',
          controller: _promptController,
          maxLines: 4,
          onChanged: (v) => setState(() {}),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8,
          children: _inspirationTags
              .map((tag) => ActionChip(
                    label: Text(tag),
                    onPressed: () {
                      _promptController.text = tag;
                      setState(() {});
                    },
                  ))
              .toList(),
        ),
        SizedBox(height: 32.h),
        SwitchListTile(
          title: Text(l10n.translate('use_persona'), style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Ensures the generated character matches your active segment.'),
          value: _usePersona,
          onChanged: (v) => setState(() => _usePersona = v),
        ),
        SizedBox(height: 24.h),
        Text(l10n.translate('aspect_ratio'), style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['1:1', '4:5', '9:16'].map((ratio) {
            final isSelected = _selectedAspectRatio == ratio;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: OutlinedButton(
                  onPressed: () => setState(() => _selectedAspectRatio = ratio),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected ? Theme.of(context).primaryColor : null,
                    foregroundColor: isSelected ? Colors.white : null,
                  ),
                  child: Text(ratio),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 48.h),
        AppButton(
          label: l10n.translate('generate_content'),
          onPressed: _promptController.text.isEmpty ? () {} : _onGenerate,
          isLoading: false,
        ),
      ],
    );
  }

  Widget _buildGeneratingState(AiStudioState state) {
    final step = state is AiGeneratingText ? 1 : 2;
    return Center(
      child: Column(
        children: [
          SizedBox(height: 100.h),
          SizedBox(
            height: 200.h,
            width: double.infinity,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
              ),
            ),
          ),
          SizedBox(height: 40.h),
          FadeIn(
            child: Text(
              step == 1 ? 'Step 1: Crafting your caption...' : 'Step 2: Rendering consistent visual...',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(height: 16.h),
          const LinearProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildReviewStudio(BuildContext context, AiGeneratedPostModel post) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInDown(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.translate('review_post'), style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppTheme.successEmerald.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: AppTheme.successEmerald, size: 16),
                    SizedBox(width: 4.w),
                    Text(
                      '${(post.characterConsistencyScore * 100).toInt()}% Match',
                      style: const TextStyle(color: AppTheme.successEmerald, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: CachedNetworkImage(
            imageUrl: post.imageUrl,
            height: 350.h,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey.shade200),
          ),
        ),
        SizedBox(height: 24.h),
        GlassCard(
          height: null,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.translate('new_caption'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                SizedBox(height: 12.h),
                Text(post.caption, style: TextStyle(fontSize: 15.sp)),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8,
                  children: post.hashtags.map((h) => Text('#$h', style: TextStyle(color: Theme.of(context).primaryColor))).toList(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 32.h),
        AppButton(
          label: l10n.translate('add_to_queue'),
          onPressed: () => context.read<AiStudioBloc>().add(ScheduleGeneratedPost(post, DateTime.now())),
        ),
        SizedBox(height: 12.h),
        AppButton(
          label: l10n.translate('publish_now'),
          isSecondary: true,
          onPressed: () {},
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.read<AiStudioBloc>().add(RegenerateCaptionOnly(post.topic)),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.translate('new_caption')),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.read<AiStudioBloc>().add(RegenerateImageOnly(referenceImageUrl: post.imageUrl, style: 'Photorealistic')),
                icon: const Icon(Icons.image_outlined),
                label: Text(l10n.translate('new_visual')),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Discard & Try Again', style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 100.h),
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16.h),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 32.h),
          AppButton(label: 'Try Again', onPressed: () => setState(() {}))
        ],
      ),
    );
  }
}
