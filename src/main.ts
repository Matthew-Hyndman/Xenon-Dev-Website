/// <reference types="@angular/localize" />

import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { Amplify } from 'aws-amplify';
import { I18n } from 'aws-amplify/utils';
import awsconfig from '../amplify_outputs.json';
import { environment } from './environments/environment';

/*type XenonRuntimeConfig = {
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
}*/

async function bootstrap(): Promise<void> {
  //await loadRuntimeConfig();
  const { AppModule } = await import('./app/app.module');

  await platformBrowserDynamic().bootstrapModule(AppModule, {
    ngZoneEventCoalescing: true,
  });
}

Amplify.configure(awsconfig);

I18n.putVocabulariesForLanguage('en', {
  //credentials
  'Preferred Username': 'Username',
  'Enter your Preferred Username': 'Enter your Username',
  'Given Name': 'First Name',
  'Enter your Given Name': 'Enter your First Name',
  'Family Name': 'Last Name',
  'Enter your Family Name': 'Enter your Last Name',
  //password requirements
  'Password must have at least 8 characters': 'Be at least 8 characters long',
  'Password must have upper case letters': 'Include at least one uppercase letter (A–Z)',
  'Password must have lower case letters': 'Include at least one lowercase letter (a–z)',
  'Password must have numbers': 'Include at least one number (0–9)',
  'Password must have special characters': 'Include at least one special character (e.g., !@#$%^&*)',
});
I18n.setLanguage('en');

bootstrap().catch((err) => console.error(err));