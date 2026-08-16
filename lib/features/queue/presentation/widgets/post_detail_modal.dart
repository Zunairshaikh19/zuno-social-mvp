import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/queue/presentation/bloc/queue_bloc.dart';
import 'package:zunosocial/features/queue/data/models/post_item_model.dart';

class PostDetailModal extends StatefulWidget {
  final PostItemModel post;

  const PostDetailModal({super.key, required this.post});

  static void show(BuildContext context, PostItemModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<QueueBloc>(),
        child: PostDetailModal(post: post),
      ),
    );
  }

  @override
  State<PostDetailModal> createState() => _PostDetailModalState();
}

class _PostDetailModalState extends State<PostDetailModal> {
  late TextEditingController _captionController;
  late TextEditingController _hashtagsController;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.post.caption);
    _hashtagsController = TextEditingController(text: widget.post.hashtags.map((h) => '#$h').join(' '));
  }

  @override
  void dispose() {
    _captionController.dispose();
    _hashtagsController.dispose();
    super.dispose();
  }

  void _onSave() {
    final hashtags = _hashtagsController.text
        .split(' ')
        .where((s) => s.startsWith('#'))
        .map((s) => s.replaceFirst('#', ''))
        .toList();

    context.read<QueueBloc>().add(UpdatePostContent(
          postId: widget.post.id,
          caption: _captionController.text,
          hashtags: hashtags,
        ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPreview(),
                  SizedBox(height: 32.h),
                  AppTextField(
                    label: 'Caption',
                    controller: _captionController,
                    maxLines: 5,
                  ),
                  SizedBox(height: 24.h),
                  AppTextField(
                    label: 'Hashtags',
                    controller: _hashtagsController,
                    hint: '#ai #tech #future',
                  ),
                  SizedBox(height: 32.h),
                  _buildAITriggers(),
                  SizedBox(height: 40.h),
                  _buildActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPreview() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: CachedNetworkImage(
          imageUrl: widget.post.mediaUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAITriggers() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('Regenerate AI Caption'),
            style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16.h)),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        AppButton(
          label: 'Save Changes',
          onPressed: _onSave,
        ),
        SizedBox(height: 12.h),
        if (widget.post.status != PostStatus.published)
          AppButton(
            label: 'Publish Now',
            isSecondary: true,
            onPressed: () {
              context.read<QueueBloc>().add(PublishPostNow(widget.post.id));
              Navigator.of(context).pop();
            },
          ),
        SizedBox(height: 12.h),
        TextButton.icon(
          onPressed: () {
            context.read<QueueBloc>().add(DeletePost(widget.post.id));
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          label: const Text('Delete Draft', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
