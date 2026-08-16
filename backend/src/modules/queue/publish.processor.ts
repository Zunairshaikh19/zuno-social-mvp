import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PostEntity } from './entities/post.entity';
import { SegmentsService } from '../segments/segments.service';

@Processor('post-publishing')
export class PublishProcessor extends WorkerHost {
  constructor(
    @InjectRepository(PostEntity)
    private readonly postRepository: Repository<PostEntity>,
    private readonly segmentsService: SegmentsService,
  ) {
    super();
  }

  async process(job: Job<{ postId: string }>): Promise<any> {
    const { postId } = job.data;
    const post = await this.postRepository.findOne({
      where: { id: postId },
      relations: ['segment', 'segment.connectedAccounts'],
    });

    if (!post) return;

    try {
      const igAccount = post.segment.connectedAccounts.find(a => a.platform === 'instagram' && a.isConnected);

      if (!igAccount) {
        throw new Error('No connected Instagram account found');
      }

      // Meta Graph API Implementation
      // 1. Create Media Container: POST /{ig-user-id}/media
      // 2. Publish Container: POST /{ig-user-id}/media_publish

      console.log(`Publishing post ${post.id} to Instagram account ${igAccount.platformAccountId}`);

      // Simulating API call
      await new Promise(resolve => setTimeout(resolve, 2000));

      post.status = 'published';
      post.publishedAt = new Date();
      await this.postRepository.save(post);

    } catch (error) {
      console.error(`Failed to publish post ${post.id}:`, error.message);
      post.status = 'failed';
      await this.postRepository.save(post);
      throw error;
    }
  }
}
