import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SegmentEntity } from './entities/segment.entity';
import { CreateSegmentDto } from './dto/create-segment.dto';
import { UpdateSegmentDto } from './dto/update-segment.dto';

@Injectable()
export class SegmentsService {
  constructor(
    @InjectRepository(SegmentEntity)
    private readonly segmentRepository: Repository<SegmentEntity>,
  ) {}

  async create(userId: string, dto: CreateSegmentDto) {
    const segment = this.segmentRepository.create({
      ...dto,
      userId,
    });
    return this.segmentRepository.save(segment);
  }

  async findAll(userId: string) {
    return this.segmentRepository.find({
      where: { userId },
      relations: ['connectedAccounts'],
    });
  }

  async findOne(id: string, userId: string) {
    const segment = await this.segmentRepository.findOne({
      where: { id, userId },
      relations: ['connectedAccounts'],
    });
    if (!segment) {
      throw new NotFoundException('Segment not found');
    }
    return segment;
  }

  async update(id: string, userId: string, dto: UpdateSegmentDto) {
    const segment = await this.findOne(id, userId);
    Object.assign(segment, dto);
    return this.segmentRepository.save(segment);
  }

  async remove(id: string, userId: string) {
    const segment = await this.findOne(id, userId);
    return this.segmentRepository.remove(segment);
  }
}
