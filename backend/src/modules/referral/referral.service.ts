import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserEntity } from '../auth/entities/user.entity';

@Injectable()
export class ReferralService {
  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
  ) {}

  async getStats(userId: string) {
    const user = await this.userRepository.findOne({ where: { id: userId } });

    // In a real app, you would have a ReferralEntity to track these.
    // For now, we return dynamic but simulated data based on user ID.
    const referralCode = user.referralCode || `ZUNO_${userId.substring(0, 6).toUpperCase()}`;

    if (!user.referralCode) {
      await this.userRepository.update(userId, { referralCode });
    }

    return {
      referralCode: referralCode,
      shareableLink: `https://zunosocial.com/invite/${referralCode}`,
      totalInvited: 2, // Simulated
      activeSubscribers: 1, // Simulated
      creditsEarnedUsd: 19.0, // Simulated
      freePostsUnlocked: 5, // Simulated
    };
  }
}
