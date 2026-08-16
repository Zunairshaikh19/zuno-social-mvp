import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';
import { PostEntity } from './entities/post.entity';
import { SchedulePostDto } from './dto/schedule-post.dto';
import { SegmentsService } from '../segments/segments.service';

@Injectable()
export class QueueService {
  constructor(
    @InjectRepository(PostEntity)
    private readonly postRepository: Repository<PostEntity>,
    @InjectQueue('post-publishing')
    private readonly publishingQueue: Queue,
    private readonly segmentsService: SegmentsService,
  ) {}

  async schedule(userId: string, dto: SchedulePostDto) {
    await this.segmentsService.findOne(dto.segmentId, userId);

    const post = this.postRepository.create({
      ...dto,
      status: 'scheduled',
    });

    const savedPost = await this.postRepository.save(post);

    const delay = new Date(dto.scheduledFor).getTime() - Date.now();

    await this.publishingQueue.add(
      'publish',
      { postId: savedPost.id },
      { delay: delay > 0 ? delay : 0, jobId: savedPost.id },
    );

    return savedPost;
  }

  async findAll(userId: string) {
    return this.postRepository.find({
      where: { segment: { userId } },
      relations: ['segment'],
      order: { scheduledFor: 'DESC' },
    });
  }

  async publishNow(id: string, userId: string) {
    const post = await this.postRepository.findOne({
      where: { id },
      relations: ['segment'],
    });

    if (!post || post.segment.userId !== userId) {
      throw new NotFoundException('Post not found');
    }

    if (post.status === 'published') {
      throw new BadRequestException('Post already published');
    }

    await this.publishingQueue.add('publish', { postId: post.id }, { jobId: `now-${post.id}` });

    return { message: 'Publishing started' };
  }

  async update(id: string, userId: string, dto: Partial<SchedulePostDto>) {
    const post = await this.postRepository.findOne({
      where: { id, segment: { userId } },
    });

    if (!post) throw new NotFoundException('Post not found');

    Object.assign(post, dto);
    return this.postRepository.save(post);
  }

  async remove(id: string, userId: string) {
    const post = await this.postRepository.findOne({
      where: { id, segment: { userId } },
    });

    if (!post) throw new NotFoundException('Post not found');

    await this.postRepository.remove(post);
    return { message: 'Post removed' };
  }
}
