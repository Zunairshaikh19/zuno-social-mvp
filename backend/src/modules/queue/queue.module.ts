import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BullModule } from '@nestjs/bullmq';
import { QueueService } from './queue.service';
import { QueueController } from './queue.controller';
import { PostEntity } from './entities/post.entity';
import { PublishProcessor } from './publish.processor';
import { SegmentsModule } from '../segments/segments.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([PostEntity]),
    BullModule.registerQueue({
      name: 'post-publishing',
    }),
    SegmentsModule,
  ],
  controllers: [QueueController],
  providers: [QueueService, PublishProcessor],
})
export class QueueModule {}
