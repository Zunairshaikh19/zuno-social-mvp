import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, OneToMany } from 'typeorm';
import { SegmentEntity } from '../../segments/entities/segment.entity';

@Entity('users')
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ nullable: true })
  fullName: string;

  @Column({ select: false })
  passwordHash: string;

  @Column({ default: 'starter' })
  planType: 'starter' | 'pro';

  @Column({ nullable: true })
  referralCode: string;

  @CreateDateColumn()
  createdAt: Date;

  @OneToMany(() => SegmentEntity, (segment) => segment.user)
  segments: SegmentEntity[];
}
