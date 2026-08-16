import { IsString, IsNotEmpty, IsUUID, IsBoolean, IsOptional } from 'class-validator';

export class GeneratePostDto {
  @IsUUID()
  @IsNotEmpty()
  segmentId: string;

  @IsString()
  @IsNotEmpty()
  topic: string;

  @IsBoolean()
  @IsOptional()
  usePersona?: boolean;
}
