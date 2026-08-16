import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { SegmentsService } from './segments.service';
import { CreateSegmentDto } from './dto/create-segment.dto';
import { UpdateSegmentDto } from './dto/update-segment.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { UserEntity } from '../auth/entities/user.entity';

@Controller('segments')
@UseGuards(JwtAuthGuard)
export class SegmentsController {
  constructor(private readonly segmentsService: SegmentsService) {}

  @Post()
  create(@GetUser() user: UserEntity, @Body() createSegmentDto: CreateSegmentDto) {
    return this.segmentsService.create(user.id, createSegmentDto);
  }

  @Get()
  findAll(@GetUser() user: UserEntity) {
    return this.segmentsService.findAll(user.id);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @GetUser() user: UserEntity) {
    return this.segmentsService.findOne(id, user.id);
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @GetUser() user: UserEntity,
    @Body() updateSegmentDto: UpdateSegmentDto,
  ) {
    return this.segmentsService.update(id, user.id, updateSegmentDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string, @GetUser() user: UserEntity) {
    return this.segmentsService.remove(id, user.id);
  }
}
