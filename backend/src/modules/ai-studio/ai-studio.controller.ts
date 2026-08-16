import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { AiStudioService } from './ai-studio.service';
import { GeneratePostDto } from './dto/generate-post.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { UserEntity } from '../auth/entities/user.entity';

@Controller('ai')
@UseGuards(JwtAuthGuard)
export class AiStudioController {
  constructor(private readonly aiStudioService: AiStudioService) {}

  @Post('generate-post')
  generatePost(@GetUser() user: UserEntity, @Body() dto: GeneratePostDto) {
    return this.aiStudioService.generatePost(user.id, dto);
  }
}
