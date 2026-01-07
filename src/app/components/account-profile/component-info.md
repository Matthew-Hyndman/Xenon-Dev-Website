# Component Information
This component manages the user's account profile, allowing them to view and update their personal information, preferences, and settings. It interacts with authentication and user services to retrieve and save profile data.

## key methods
- `constructor()`: initialises from builder and calls `getUserDetails()`.
- `getUserDetails()`: retrieves the user's profile information from the `AuthenticationService` service.
- `save()`: checks if the form is valid, creates a user representation block, and sends it to the `AuthenticationService` service to update the user's profile. sets from data if successful.

## Guards
 - `keycloakGuard`: Ensures that the user is authenticated before accessing the account profile component.