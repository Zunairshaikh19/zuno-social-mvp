import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AiStudioService } from './ai-studio.service';
import { AiStudioController } from './ai-studio.controller';
import { SegmentsModule } from '../segments/segments.module';
import { PostEntity } from '../queue/entities/post.entity';
import { SegmentEntity } from '../segments/entities/segment.entity';
import { UserEntity } from '../auth/entities/user.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([PostEntity, SegmentEntity, UserEntity]),
    SegmentsModule
  ],
  controllers: [AiStudioController],
  providers: [AiStudioService],
})
export class AiStudioModule {}
