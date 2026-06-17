type XenonDevConfig = {
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
    __XENON_DEV_CONFIG__?: XenonDevConfig;
  }
}

const fallbackConfig: XenonDevConfig = {
  keycloak: {
    url: 'http://localhost:8080',
    realm: 'Xenon-Dev-DEV-ENV',
    clientId: 'xenon-dev-oauth2-client-dev-env-id',
  },
  SpringAPIServer: {
    url: 'http://localhost:8443',
  },
};

const runtimeConfig = window.__XENON_DEV_CONFIG__;

if (!runtimeConfig) {
  console.warn('Runtime config not found, using fallback local config.');
}

const xenonDevConfig: XenonDevConfig = runtimeConfig ?? fallbackConfig;

export default xenonDevConfig;
