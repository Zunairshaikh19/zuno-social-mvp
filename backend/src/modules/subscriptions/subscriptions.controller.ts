import { Controller, Get, Post, Body, Query, UseGuards } from '@nestjs/common';
import { SubscriptionsService } from './subscriptions.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { UserEntity } from '../auth/entities/user.entity';

@Controller('subscriptions')
@UseGuards(JwtAuthGuard)
export class SubscriptionsController {
  constructor(private readonly subscriptionsService: SubscriptionsService) {}

  @Get('plans')
  getPlans() {
    return this.subscriptionsService.getPlans();
  }

  @Post('subscribe')
  subscribe(@GetUser() user: UserEntity, @Body('planId') planId: string) {
    return this.subscriptionsService.subscribe(user.id, planId);
  }

  @Get('me')
  getSubscriptionInfo(@GetUser() user: UserEntity) {
    return this.subscriptionsService.getSubscriptionInfo(user.id);
  }

  @Get('stats')
  getStats(@GetUser() user: UserEntity, @Query('segmentId') segmentId?: string) {
    return this.subscriptionsService.getStats(user.id, segmentId);
  }
}
