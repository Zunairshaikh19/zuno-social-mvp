import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { SegmentEntity } from './segment.entity';

@Entity('connected_accounts')
export class ConnectedAccountEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  segmentId: string;

  @ManyToOne(() => SegmentEntity, (segment) => segment.connectedAccounts)
  segment: SegmentEntity;

  @Column()
  platform: 'instagram';

  @Column()
  platformAccountId: string;

  @Column({ select: false })
  accessToken: string;

  @Column({ type: 'timestamp' })
  tokenExpiresAt: Date;

  @Column({ default: true })
  isConnected: boolean;
}
