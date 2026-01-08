# Services Information
This is general information about the services used in the application.

## AuthenticationService
The main service responsible for handling user authentication, including login, logout, and session management. It interacts with the backend authentication server to validate user credentials.

## BlackJackGameService
For managing and storing state of the dealerTimerToggle. `getPlayerProfile()` method retrieves the player's profile information from the backend API and returns a `Hand` oject if an account is detected.

## BlackJackHelpService
Checks session storage and manages `hasUserAgreedToDisclaimer` item.

## PlayerProfileService
Handles retrieval and updating of player profile information. It communicates with the backend API to fetch user data and update profile settings.