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
      allow.owner(),
      allow.authenticated().to(['read']),
    ]),
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    // All models use owner-based auth, so userPool is the only mode needed.
    defaultAuthorizationMode: 'userPool',
  },
});

