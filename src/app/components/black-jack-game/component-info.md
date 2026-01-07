# Component Information
This component manages the Black Jack game functionality, including dealing cards, handling player actions (hit, stand, double down), and determining game outcomes. It interacts with various services to manage game state and user profiles.

## key methods
- `startNewGame()` : Initializes a new game, shuffles the deck, and deals initial cards to the player and dealer.

## Guards
 - `blackJackHelpDisclaimerCheckedGuard` : Ensures that the user has acknowledged the disclaimer before accessing the Black Jack game component.