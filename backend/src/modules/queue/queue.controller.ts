import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import { QueueService } from './queue.service';
import { SchedulePostDto } from './dto/schedule-post.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { UserEntity } from '../auth/entities/user.entity';

@Controller('queue')
@UseGuards(JwtAuthGuard)
export class QueueController {
  constructor(private readonly queueService: QueueService) {}

  @Get()
  findAll(@GetUser() user: UserEntity) {
    return this.queueService.findAll(user.id);
  }

  @Post('schedule')
  schedule(@GetUser() user: UserEntity, @Body() dto: SchedulePostDto) {
    return this.queueService.schedule(user.id, dto);
  }

  @Post('publish-now/:id')
  publishNow(@Param('id') id: string, @GetUser() user: UserEntity) {
    return this.queueService.publishNow(id, user.id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @GetUser() user: UserEntity, @Body() dto: Partial<SchedulePostDto>) {
    return this.queueService.update(id, user.id, dto);
  }

  @Delete(':id')
  remove(@Param('id') id: string, @GetUser() user: UserEntity) {
    return this.queueService.remove(id, user.id);
  }
}
