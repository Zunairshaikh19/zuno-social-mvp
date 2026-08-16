import { Module } from '@nestjs/common';
import { AiStudioService } from './ai-studio.service';
import { AiStudioController } from './ai-studio.controller';
import { SegmentsModule } from '../segments/segments.module';

@Module({
  imports: [SegmentsModule],
  controllers: [AiStudioController],
  providers: [AiStudioService],
})
export class AiStudioModule {}
