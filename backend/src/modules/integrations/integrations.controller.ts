import { Controller, Get, Post, Delete, Param, Body } from '@nestjs/common';
import { IntegrationsService } from './integrations.service';

@Controller('integrations')
export class IntegrationsController {
  constructor(private readonly integrationsService: IntegrationsService) {}

  @Get(':segmentId')
  async getConnectedAccounts(@Param('segmentId') segmentId: string) {
    return this.integrationsService.getConnectedAccounts(segmentId);
  }

  @Post('connect')
  async connectAccount(@Body() body: { segmentId: string; platform: string; accessToken: string }) {
    return this.integrationsService.connectAccount(body.segmentId, body.platform, body.accessToken);
  }

  @Delete(':accountId')
  async disconnectAccount(@Param('accountId') accountId: string) {
    return this.integrationsService.disconnectAccount(accountId);
  }
}
