/// <reference types="@angular/localize" />

import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { environment } from './environments/environment';

type XenonRuntimeConfig = {
  keycloak: {
    url: string;
    realm: string;
    clientId: string;
  };
  SpringAPIServer: {
    url: string;
  };
};

declare global {
  interface Window {
    __XENON_DEV_CONFIG__?: XenonRuntimeConfig;
  }
}

function isPlaceholder(value: string): boolean {
  return value.trim().startsWith('${') && value.trim().endsWith('}');
}

function validateRuntimeConfig(config: XenonRuntimeConfig): void {
  const requiredEntries: Array<{ key: string; value: string }> = [
    { key: 'keycloak.url', value: config.keycloak?.url ?? '' },
    { key: 'keycloak.realm', value: config.keycloak?.realm ?? '' },
    { key: 'keycloak.clientId', value: config.keycloak?.clientId ?? '' },
    { key: 'SpringAPIServer.url', value: config.SpringAPIServer?.url ?? '' },
  ];

  const invalidEntries = requiredEntries.filter(
    (entry) => entry.value.trim().length === 0 || isPlaceholder(entry.value)
  );

  if (invalidEntries.length > 0) {
    const invalidKeys = invalidEntries.map((entry) => entry.key).join(', ');
    throw new Error(
      `Invalid runtime config in /assets/${environment.runtimeConfigFile}. ` +
        `Missing or unresolved values for: ${invalidKeys}`
    );
  }
}

async function loadRuntimeConfig(): Promise<void> {
  const response = await fetch(`/assets/${environment.runtimeConfigFile}`, {
    cache: 'no-store',
  });

  if (!response.ok) {
    throw new Error(
      `Failed to load runtime config from /assets/${environment.runtimeConfigFile}`
    );
  }

  const config = (await response.json()) as XenonRuntimeConfig;
  validateRuntimeConfig(config);
  window.__XENON_DEV_CONFIG__ = config;
}

async function bootstrap(): Promise<void> {
  await loadRuntimeConfig();
  const { AppModule } = await import('./app/app.module');

  await platformBrowserDynamic().bootstrapModule(AppModule, {
    ngZoneEventCoalescing: true,
  });
}

bootstrap().catch((err) => console.error(err));