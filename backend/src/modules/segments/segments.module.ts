import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SegmentsService } from './segments.service';
import { SegmentsController } from './segments.controller';
import { SegmentEntity } from './entities/segment.entity';
import { ConnectedAccountEntity } from './entities/connected-account.entity';

@Module({
  imports: [TypeOrmModule.forFeature([SegmentEntity, ConnectedAccountEntity])],
  controllers: [SegmentsController],
  providers: [SegmentsService],
  exports: [SegmentsService],
})
export class SegmentsModule {}
