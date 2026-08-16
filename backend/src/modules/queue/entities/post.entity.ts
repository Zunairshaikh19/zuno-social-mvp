import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { SegmentEntity } from '../../segments/entities/segment.entity';

@Entity('posts')
export class PostEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  segmentId: string;

  @ManyToOne(() => SegmentEntity, (segment) => segment.posts)
  segment: SegmentEntity;

  @Column()
  topic: string;

  @Column({ type: 'text' })
  caption: string;

  @Column({ type: 'jsonb', nullable: true })
  hashtags: string[];

  @Column({ nullable: true })
  mediaUrl: string;

  @Column({ default: 'draft' })
  status: 'draft' | 'scheduled' | 'published' | 'failed';

  @Column({ type: 'timestamp', nullable: true })
  scheduledFor: Date;

  @Column({ type: 'timestamp', nullable: true })
  publishedAt: Date;

  @CreateDateColumn()
  createdAt: Date;
}
