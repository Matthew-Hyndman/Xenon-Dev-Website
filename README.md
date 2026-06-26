## Welcome to Xenon Dev's repository!!!

This repository is where Xenon Dev’s source code is backed-up and stored to then be deployed on ASW amplify.

## Current Features:

-	Keycloak Authentication
-	Black Jack leaderboard
-	Black Jack Game (non-monetary betting system included)
-	Cat Fact Public API

## Docker setup

in the base directory of the project, run the following command to build the docker images:

```bash
    docker compose up --build -d
```
Also, if you want to start over, just run:

```bash
    docker compose down -v
```

The first container to start is the postgresql database, however you will need to restart the container (**not start**) after it has been initialized.

Next, **start** the keycloak container and wait for it to automatically generate the necessary configurations and tables in the DB.

when the keycloak container is finished, go back to the postgresql container and open the terminal, then run the following commands in this sequence:

```bash
    psql -h localhost -p 5432 -d Xenon-Dev-DB -U Xenon-Dev-Admin
```

This will log you into the database.

run the following queries to create the player_profile relationship and view for the Black Jack leaderboard:

```sql
    ALTER TABLE public.user_entity ADD COLUMN IF NOT EXISTS player_profile_id bigint REFERENCES public.player_profile(player_id);

    CREATE OR REPLACE VIEW public.accounts_with_player_profiles_view AS
    SELECT ue.username,
    pp.wins,
    pp.losses,
    pp.pot
   FROM public.user_entity ue
     JOIN public.player_profile pp ON ((ue.player_profile_id = pp.player_id));

    ALTER VIEW public.accounts_with_player_profiles_view OWNER TO "Xenon-Dev-Admin";
```

Verify that the view and player_profile exists by running:

```bash
    \dt #for tables
    \dv #for views
```

Finally, start the backend and frontend containers, and you should be able to access the application at http://localhost:4200.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

## Additional resource references:

[MightyKingVideo – Balatro – Playing Cards](https://www.spriters-resource.com/fullview/222133/)

[majesticloulou – dapper cat](https://imgur.com/gallery/dapper-cat-5MndptK)
