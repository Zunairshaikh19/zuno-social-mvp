import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserEntity } from '../auth/entities/user.entity';
import { PlanEntity } from './entities/plan.entity';

@Injectable()
export class SubscriptionsService implements OnModuleInit {
  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    @InjectRepository(PlanEntity)
    private readonly planRepository: Repository<PlanEntity>,
  ) {}

  async onModuleInit() {
    await this.seedPlans();
  }

  private async seedPlans() {
    const count = await this.planRepository.count();
    if (count === 0) {
      const plans = [
        {
          id: 'starter',
          name: 'Starter',
          priceMonthly: 19.0,
          postsPerMonth: 16,
          segmentLimit: 1,
          features: [
            '1 Segment / Persona',
            '16 auto-posts / month',
            'Meta OAuth Integration',
            'Basic Analytics',
          ],
          isPopularBadge: false,
        },
        {
          id: 'pro',
          name: 'Pro',
          priceMonthly: 35.0,
          postsPerMonth: 30,
          segmentLimit: 2,
          isPopularBadge: true,
          features: [
            '2 Segments / Personas',
            '30 auto-posts / month',
            'Highest Priority Gemini generation',
            'Full Analytics Suite',
            'AI Image Variations',
          ],
        },
      ];
      await this.planRepository.save(plans);
      console.log('Plans seeded successfully');
    }
  }

  async getSubscriptionInfo(userId: string) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    return {
      planType: user.planType,
      referralCode: user.referralCode,
    };
  }

  async getPlans() {
    return this.planRepository.find({ order: { priceMonthly: 'ASC' } });
  }

  async subscribe(userId: string, planId: string) {
    await this.userRepository.update(userId, { planType: planId as 'starter' | 'pro' });
    return { message: 'Subscription updated' };
  }

  async getStats(userId: string, segmentId?: string) {
    const user = await this.userRepository.findOne({
      where: { id: userId },
      relations: ['segments', 'segments.posts']
    });

    if (!user) {
      throw new Error('User not found');
    }

    let activeSegment = user.segments && user.segments.length > 0 ? user.segments[0] : null;

    if (segmentId) {
      activeSegment = user.segments.find(s => s.id === segmentId) || activeSegment;
    }

    const postsUsed = activeSegment?.posts ? activeSegment.posts.length : 0;

    // Get plan details for quota
    const plan = await this.planRepository.findOne({ where: { id: user.planType } });
    const totalPostsQuota = plan ? plan.postsPerMonth : 16;

    // Find next scheduled post
    const nextPost = activeSegment?.posts
      ? activeSegment.posts
          .filter(p => p.status === 'scheduled')
          .sort((a, b) => a.scheduledFor.getTime() - b.scheduledFor.getTime())[0]
      : null;

    return {
      activeSegmentId: activeSegment?.id || null,
      activeSegmentName: activeSegment?.name || 'No Active Persona',
      nextScheduledPost: nextPost?.scheduledFor ? nextPost.scheduledFor.toISOString() : null,
      postsUsed: postsUsed,
      totalPostsQuota: totalPostsQuota,
      isMetaConnected: activeSegment ? true : false,
      planType: user.planType,
    };
  }
}
