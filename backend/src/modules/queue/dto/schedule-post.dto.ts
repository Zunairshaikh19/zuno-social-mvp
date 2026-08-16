import { IsString, IsNotEmpty, IsUUID, IsDateString, IsOptional, IsArray, IsUrl } from 'class-validator';

export class SchedulePostDto {
  @IsUUID()
  @IsNotEmpty()
  segmentId: string;

  @IsString()
  @IsNotEmpty()
  topic: string;

  @IsString()
  @IsNotEmpty()
  caption: string;

  @IsArray()
  @IsOptional()
  hashtags?: string[];

  @IsUrl()
  @IsOptional()
  mediaUrl?: string;

  @IsDateString()
  @IsNotEmpty()
  scheduledFor: string;
}
