import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BullModule } from '@nestjs/bullmq';
import { AuthModule } from './modules/auth/auth.module';
import { SegmentsModule } from './modules/segments/segments.module';
import { AiStudioModule } from './modules/ai-studio/ai-studio.module';
import { QueueModule } from './modules/queue/queue.module';
import { SubscriptionsModule } from './modules/subscriptions/subscriptions.module';
import { ReferralModule } from './modules/referral/referral.module';
import { IntegrationsModule } from './modules/integrations/integrations.module';
import { AnalyticsModule } from './modules/analytics/analytics.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        url: config.get<string>('DATABASE_URL'),
        autoLoadEntities: true,
        synchronize: true,
        ssl: true,
        extra: {
          ssl: {
            rejectUnauthorized: false,
          },
        },
      }),
      inject: [ConfigService],
    }),
    BullModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        connection: { host: config.get('REDIS_HOST'), port: config.get('REDIS_PORT') },
      }),
      inject: [ConfigService],
    }),
    AuthModule,
    SegmentsModule,
    AiStudioModule,
    QueueModule,
    SubscriptionsModule,
    ReferralModule,
    IntegrationsModule,
    AnalyticsModule,
  ],
})
export class AppModule {}
