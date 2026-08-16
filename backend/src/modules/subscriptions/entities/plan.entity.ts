import { Entity, PrimaryColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('plans')
export class PlanEntity {
  @PrimaryColumn()
  id: string; // 'starter', 'pro'

  @Column()
  name: string;

  @Column('decimal', { precision: 10, scale: 2 })
  priceMonthly: number;

  @Column()
  postsPerMonth: number;

  @Column()
  segmentLimit: number;

  @Column('jsonb')
  features: string[];

  @Column({ default: false })
  isPopularBadge: boolean;

  @CreateDateColumn()
  createdAt: Date;
}
