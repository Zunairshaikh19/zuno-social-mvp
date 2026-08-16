import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany } from 'typeorm';
import { UserEntity } from '../../auth/entities/user.entity';
import { PostEntity } from '../../queue/entities/post.entity';
import { ConnectedAccountEntity } from './connected-account.entity';

@Entity('segments')
export class SegmentEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @ManyToOne(() => UserEntity, (user) => user.segments)
  user: UserEntity;

  @Column()
  name: string;

  @Column()
  niche: string;

  @Column({ default: false })
  autoPublish: boolean;

  @Column({ nullable: true })
  postingFrequency: string; // e.g., "DAILY", "WEEKLY"

  @Column({ type: 'text', nullable: true })
  personaPrompt: string;

  @Column({ nullable: true })
  referenceImageUrl: string;

  @OneToMany(() => PostEntity, (post) => post.segment)
  posts: PostEntity[];

  @OneToMany(() => ConnectedAccountEntity, (account) => account.segment)
  connectedAccounts: ConnectedAccountEntity[];
}
