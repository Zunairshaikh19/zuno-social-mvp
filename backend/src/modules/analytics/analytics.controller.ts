import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { AnalyticsService } from './analytics.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { GetUser } from '../auth/decorators/get-user.decorator';

@Controller('analytics')
@UseGuards(JwtAuthGuard)
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('overview')
  getOverview(
    @GetUser('id') userId: string,
    @Query('segmentId') segmentId?: string,
    @Query('timeframe') timeframe?: string,
  ) {
    return this.analyticsService.getOverview(userId, segmentId, timeframe);
  }
}
