import { Injectable, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { SegmentsService } from '../segments/segments.service';
import { GeneratePostDto } from './dto/generate-post.dto';
import { PostEntity } from '../queue/entities/post.entity';
import { SegmentEntity } from '../segments/entities/segment.entity';
import { UserEntity } from '../auth/entities/user.entity';

@Injectable()
export class AiStudioService {
  private genAI: GoogleGenerativeAI;

  constructor(
    private readonly configService: ConfigService,
    private readonly segmentsService: SegmentsService,
    @InjectRepository(PostEntity)
    private readonly postRepository: Repository<PostEntity>,
    @InjectRepository(SegmentEntity)
    private readonly segmentRepository: Repository<SegmentEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
  ) {
    this.genAI = new GoogleGenerativeAI(this.configService.get('GEMINI_API_KEY'));
  }

  async generatePost(userId: string, dto: GeneratePostDto) {
    const segment = await this.segmentsService.findOne(dto.segmentId, userId);

    // Quota Check
    const user = await this.userRepository.findOne({
      where: { id: userId },
      relations: ['segments', 'segments.posts']
    });

    const totalPosts = user.segments.reduce((acc, s) => acc + (s.posts?.length || 0), 0);
    const quota = user.planType === 'pro' ? 30 : 16;

    if (totalPosts >= quota) {
      throw new BadRequestException('Monthly content quota reached. Please upgrade your plan.');
    }

    const model = this.genAI.getGenerativeModel({ model: 'gemini-pro' });

    const prompt = `
      As an AI social media manager, generate a viral Instagram post.
      Niche: ${segment.niche}
      Persona: ${segment.personaPrompt || 'Professional and engaging'}
      Topic: ${dto.topic}

      Requirements:
      1. Engaging caption.
      2. 15-20 relevant hashtags.

      Format the output as JSON:
      {
        "caption": "...",
        "hashtags": ["tag1", "tag2", ...]
      }
    `;

    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    let aiResponse;
    try {
      aiResponse = JSON.parse(text.substring(text.indexOf('{'), text.lastIndexOf('}') + 1));
    } catch (e) {
      aiResponse = {
        caption: text,
        hashtags: [],
      };
    }

    // Save to DB as draft
    const post = this.postRepository.create({
      segmentId: segment.id,
      topic: dto.topic,
      caption: aiResponse.caption,
      hashtags: aiResponse.hashtags,
      status: 'draft',
      mediaUrl: 'https://images.unsplash.com/photo-1614728263952-84ea256f9679', // Placeholder
    });

    const savedPost = await this.postRepository.save(post);

    return {
      ...aiResponse,
      id: savedPost.id,
      segmentId: segment.id,
      imageUrl: savedPost.mediaUrl,
      topic: dto.topic,
      characterConsistencyScore: 0.95,
      suggestedTime: new Date().toISOString(),
    };
  }
}
