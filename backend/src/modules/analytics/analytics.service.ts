import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PostEntity } from '../queue/entities/post.entity';

@Injectable()
export class AnalyticsService {
  constructor(
    @InjectRepository(PostEntity)
    private readonly postRepository: Repository<PostEntity>,
  ) {}

  async getOverview(userId: string, segmentId?: string, timeframe: string = '7d') {
    const query = this.postRepository.createQueryBuilder('post')
      .innerJoin('post.segment', 'segment')
      .where('segment.userId = :userId', { userId });

    if (segmentId) {
      query.andWhere('post.segmentId = :segmentId', { segmentId });
    }

    const posts = await query.getMany();
    const publishedPosts = posts.filter(p => p.status === 'published');

    return {
      totalPostsPublished: publishedPosts.length,
      totalImpressions: publishedPosts.length * 250, // Mock calculation
      engagementRate: 5.4,
      audienceGrowthPct: 12.1,
      weeklyPerformance: [120, 450, 320, 600, 500, 800, 750],
      topPerformingPosts: publishedPosts.slice(0, 3),
    };
  }
}
