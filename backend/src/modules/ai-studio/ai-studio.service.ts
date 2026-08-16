import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { SegmentsService } from '../segments/segments.service';
import { GeneratePostDto } from './dto/generate-post.dto';

@Injectable()
export class AiStudioService {
  private genAI: GoogleGenerativeAI;

  constructor(
    private readonly configService: ConfigService,
    private readonly segmentsService: SegmentsService,
  ) {
    this.genAI = new GoogleGenerativeAI(this.configService.get('GEMINI_API_KEY'));
  }

  async generatePost(userId: string, dto: GeneratePostDto) {
    const segment = await this.segmentsService.findOne(dto.segmentId, userId);

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
        "hashtags": ["#tag1", "#tag2", ...]
      }
    `;

    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    try {
      // Basic JSON extraction from text if needed, or assume model follows format
      return JSON.parse(text.substring(text.indexOf('{'), text.lastIndexOf('}') + 1));
    } catch (e) {
      return {
        caption: text,
        hashtags: [],
      };
    }
  }
}
