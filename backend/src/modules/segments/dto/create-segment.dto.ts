import { IsString, IsNotEmpty, IsBoolean, IsOptional, IsUrl } from 'class-validator';

export class CreateSegmentDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  niche: string;

  @IsBoolean()
  @IsOptional()
  autoPublish?: boolean;

  @IsString()
  @IsOptional()
  postingFrequency?: string;

  @IsString()
  @IsOptional()
  personaPrompt?: string;

  @IsUrl()
  @IsOptional()
  referenceImageUrl?: string;
}
