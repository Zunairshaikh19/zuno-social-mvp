import { IsString, IsNotEmpty, IsUUID } from 'class-validator';

export class GeneratePostDto {
  @IsUUID()
  @IsNotEmpty()
  segmentId: string;

  @IsString()
  @IsNotEmpty()
  topic: string;
}
