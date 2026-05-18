import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

const schema = a.schema({
  PlayerProfile: a
    .model({
      player_id: a.id().required(),
      username: a.string().required(),
      wins: a.integer().default(0),
      losses: a.integer().default(0),
      pot: a.integer().default(3000),
    })
    .identifier(['player_id'])
    .authorization((allow) => [
      // Temporary phase-1 reset rule: allow API key access while Cognito is removed.
      allow.publicApiKey(),
    ]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    // Temporary phase-1 reset mode: switch back to userPool after auth is recreated.
    defaultAuthorizationMode: 'apiKey',
    apiKeyAuthorizationMode: {
      expiresInDays: 7,
    },
  },
});

