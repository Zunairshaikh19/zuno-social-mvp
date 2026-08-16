import { Injectable } from '@nestjs/common';

@Injectable()
export class IntegrationsService {
  private connectedAccounts = [
    {
      id: '1',
      segmentId: '1',
      platform: 'Instagram',
      accountName: '@zuno_social_alpha',
      isConnected: true,
      scopes: ['instagram_content_publish', 'pages_manage_posts'],
    },
  ];

  async getConnectedAccounts(segmentId: string) {
    return this.connectedAccounts.filter(acc => acc.segmentId === segmentId);
  }

  async connectAccount(segmentId: string, platform: string, accessToken: string) {
    // Mock connection logic
    const newAccount = {
      id: Math.random().toString(36).substr(2, 9),
      segmentId,
      platform,
      accountName: `@new_${platform.toLowerCase()}_acc`,
      isConnected: true,
      scopes: ['basic_scope'],
    };
    this.connectedAccounts.push(newAccount);
    return newAccount;
  }

  async disconnectAccount(accountId: string) {
    this.connectedAccounts = this.connectedAccounts.filter(acc => acc.id !== accountId);
    return { success: true };
  }
}
