# Xenon Dev Website – Manual Test Cases

This document lists manual test cases for a tester to verify that all features are working correctly and the application is ready for deployment.

---

## Table of Contents

1. [Navigation & Header](#1-navigation--header)
2. [Landing Page](#2-landing-page)
3. [About Page (Site Info)](#3-about-page-site-info)
4. [Authentication – Login & Logout](#4-authentication--login--logout)
5. [BlackJack Help / Rules & Disclaimer Page](#5-blackjack-help--rules--disclaimer-page)
6. [BlackJack Game](#6-blackjack-game)
7. [Leaderboard](#7-leaderboard)
8. [User Profile Page](#8-user-profile-page)
9. [Footer](#9-footer)
10. [Routing & Guards](#10-routing--guards)
11. [Responsive / Mobile Layout](#11-responsive--mobile-layout)

---

## 1. Navigation & Header

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| NAV-01 | Logo links to Landing page | Click the Xenon Dev logo / title image | Browser navigates to `/landing` | |
| NAV-02 | "Welcome" nav link | Click the "Welcome" nav link | Browser navigates to `/landing` | |
| NAV-03 | "About" nav link | Click the "About" nav link | Browser navigates to `/site-info` | |
| NAV-04 | "BlackJack" nav link | Click the "BlackJack" nav link | Browser navigates to `/black-jack-help` (disclaimer page) | |
| NAV-05 | "Login" link visible when logged out | Open the site without being logged in | The "Login" nav link is visible; "Profile" and "Logout" links are hidden | |
| NAV-06 | "Profile" and "Logout" visible when logged in | Log in successfully | The "Profile" and "Logout" nav links are visible; "Login" link is hidden | |
| NAV-07 | Mobile hamburger button visible | View the site on a mobile/narrow viewport | A hamburger (≡) icon button appears in the header | |
| NAV-08 | Mobile nav opens on hamburger click | On a mobile viewport, click the hamburger button | A slide-in mobile nav menu appears with available links | |
| NAV-09 | Mobile nav closes on link click | Open the mobile nav, then click any link | The mobile nav menu closes after selecting a link | |
| NAV-10 | Mobile nav closes on scroll | Open the mobile nav, then scroll the page | The mobile nav menu closes when the user scrolls | |

---

## 2. Landing Page

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| LAND-01 | Page loads correctly | Navigate to `/landing` | "Welcome" heading and announcement text are displayed | |
| LAND-02 | Username shown when logged in | Log in, then navigate to `/landing` | The logged-in user's username is displayed below the "Welcome" heading | |
| LAND-03 | Username not shown when logged out | Log out, then navigate to `/landing` | No username is displayed | |
| LAND-04 | "About" landing card navigates | Click the "About" card/icon | Browser navigates to `/site-info` | |
| LAND-05 | "BlackJack" landing card navigates (logged out) | Without logging in, click the "BlackJack♦♣" card | Browser navigates to `/black-jack-help` | |
| LAND-06 | "BlackJack" landing card navigates (logged in) | Log in, then click the "BlackJack♦♣" card | Browser navigates to `/black-jack-help` | |
| LAND-07 | Cat Fact button visible | Navigate to `/landing` | "Get me a cool Cat Fact with an API" button is visible | |
| LAND-08 | Cat Fact loads on button click | Click the "Get me a cool Cat Fact with an API" button | A cat fact and a cat image/gif are displayed on the page | |
| LAND-09 | Cat Fact text is non-empty | Click the cat fact button | The fact text contains at least one character (API responded successfully) | |
| LAND-10 | Cat Fact API URL displayed | Navigate to `/landing` | The API URL `https://catfact.ninja/fact` and Swagger URL are shown on the page | |

---

## 3. About Page (Site Info)

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| ABOUT-01 | Page loads correctly | Navigate to `/site-info` | "About" heading is displayed with developer information | |
| ABOUT-02 | Phase 1 section visible | Navigate to `/site-info` | "Phase 1 (completed)" section is present and readable | |
| ABOUT-03 | Phase 1.5 updates table visible | Navigate to `/site-info` | The Phase 1.5 updates table with rows (e.g., "General UI update") is displayed | |
| ABOUT-04 | Phase 2 section visible | Navigate to `/site-info` | "Phase 2" section is present with Keycloak and RabbitMQ references | |
| ABOUT-05 | Phase 3 section visible | Navigate to `/site-info` | "Phase 3" section is present with Stripe reference | |
| ABOUT-06 | Keycloak logo links to Keycloak website | Click the Keycloak logo/link | Opens `https://www.keycloak.org` | |
| ABOUT-07 | RabbitMQ logo links to RabbitMQ website | Click the RabbitMQ logo/link | Opens `https://www.rabbitmq.com/` | |
| ABOUT-08 | Stripe logo links to Stripe website | Click the Stripe logo/link | Opens `https://www.stripe.com` | |
| ABOUT-09 | "Did you know?" Xenon fact visible | Scroll to the bottom of `/site-info` | The Xenon element fact block is displayed | |

---

## 4. Authentication – Login & Logout

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| AUTH-01 | Login link redirects to Keycloak | Click the "Login" nav link | Browser is redirected to the Keycloak login page | |
| AUTH-02 | Successful login | Enter valid credentials on Keycloak login page and submit | User is redirected back to the website and is now logged in; "Profile" and "Logout" nav links are visible | |
| AUTH-03 | Invalid credentials rejected | Enter invalid username/password and submit | Keycloak shows an error message; user remains on the login page | |
| AUTH-04 | Logout clears session | While logged in, click the "Logout" nav link | User is logged out; "Login" nav link reappears; "Profile" and "Logout" links are hidden | |
| AUTH-05 | Register a new account | On the Keycloak login page, click "Register" and fill in the form | A new account is created and the user is directed back to the website | |
| AUTH-06 | Unverified email alert shown | Log in with an account whose email has not been verified | An alert banner is shown on the Profile page warning that the email is unverified | |

---

## 5. BlackJack Help / Rules & Disclaimer Page

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| BJH-01 | Page loads correctly | Navigate to `/black-jack-help` | Rules and disclaimer content are displayed | |
| BJH-02 | Card tooltip demo visible | Navigate to `/black-jack-help` | The demo card with tooltip instructions is visible | |
| BJH-03 | Card tooltip on hover (desktop) | Hover the mouse over the demo card | The card flips/tooltip shows the card value | |
| BJH-04 | Card tooltip on press (mobile) | On a touch device, tap the demo card | The card flips/tooltip shows the card value | |
| BJH-05 | Continue button without checking disclaimer | Click "Continue" without checking the disclaimer checkbox | An error message is shown: "You must tick the check box to Continue to the game" | |
| BJH-06 | Continue button after checking disclaimer (logged out) | Check the disclaimer checkbox, then click "Continue" | User is redirected to `/black-jack-game` | |
| BJH-07 | Continue button after checking disclaimer (logged in, no profile) | Log in (no existing player profile), agree to disclaimer, click "Continue" | A player profile is created and the user is redirected to `/black-jack-game` | |
| BJH-08 | Continue button after checking disclaimer (logged in, existing profile) | Log in (with an existing player profile), agree to disclaimer, click "Continue" | The user is redirected to `/black-jack-game` without creating a duplicate profile | |
| BJH-09 | Player Profile Creation disclaimer item visible only when logged in | Log in and navigate to `/black-jack-help` | Disclaimer item 8 ("Player Profile Creation") is visible | |
| BJH-10 | Player Profile Creation disclaimer item hidden when logged out | Log out and navigate to `/black-jack-help` | Disclaimer item 8 is not visible | |
| BJH-11 | Page protected by authentication guard | Log out, then navigate directly to `/black-jack-help` | The page loads (this route requires `blackJackHelpAuthenticationGuard` – verify the guard behaviour per the project spec) | |

---

## 6. BlackJack Game

### 6.1 Game Startup

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| BJG-01 | Game page requires disclaimer | Navigate directly to `/black-jack-game` without agreeing to the disclaimer | User is redirected (guard active); they cannot bypass the disclaimer | |
| BJG-02 | Betting dialog shown on new game (betting enabled) | Start a new game with the "Use Betting" toggle checked | A SweetAlert2 dialog asking "How many tokens are you betting" appears | |
| BJG-03 | Default bet is half of pot | Open the betting dialog | The slider and number input are pre-filled with half the current pot value | |
| BJG-04 | Bet slider and number input are synchronised | Move the slider in the betting dialog | The number input updates to match, and vice versa | |
| BJG-05 | "Place Bet" confirms the bet | Set a bet amount and click "Place Bet" | The bet amount is deducted from the pot; the game starts | |
| BJG-06 | "I am not betting" disables betting | Click "I am not betting" in the betting dialog | Betting is disabled; the game starts without a bet and pot/bet labels are hidden | |
| BJG-07 | Initial card dealt to dealer | After confirming bet | Dealer has exactly 1 card | |
| BJG-08 | Initial card dealt to player | After confirming bet | Player has exactly 1 card | |
| BJG-09 | Player starts with pot of 3000 when no profile | Start the game without a logged-in player profile | The pot starts at 3000 tokens | |

### 6.2 Game Actions

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| BJG-10 | Hit adds a card to the player's hand | Click the "Hit" button | Player's hand gains one card and the score updates | |
| BJG-11 | Hit causes bust when score exceeds 21 | Keep hitting until the player's score exceeds 21 | A "Bust!" dialog is shown and a new game starts | |
| BJG-12 | Stand triggers dealer's turn | Click the "Stand" button | Dealer draws cards until their score meets or exceeds the player's score or busts | |
| BJG-13 | Player wins when dealer busts | Stand and wait for dealer to exceed 21 | A "You Win!!!" dialog is shown; player wins tally increments | |
| BJG-14 | Player wins when score is higher than dealer | Stand with a higher score than the dealer without either busting | A "You Win!!!" dialog is shown | |
| BJG-15 | Player loses when dealer score is higher | Stand with a lower score than the dealer | A "You Lost" dialog is shown; losses tally increments | |
| BJG-16 | Draw when scores are equal | Stand with the same score as the dealer | A "Draw!" dialog is shown; bet is returned to the pot | |
| BJG-17 | BlackJack payout (1.5×) | Get a BlackJack (Ace + 10-value card) | "Black Jack!!!" dialog shown; payout is 1.5× the bet (rounded) | |
| BJG-18 | Standard win payout (2×) | Win a hand without BlackJack | Payout is 2× the bet (rounded) | |
| BJG-19 | Double Down deals one card then stands | Click "Double Down" when betting is active | One card is dealt to the player; if not bust, the dealer's turn proceeds immediately | |
| BJG-20 | Double Down bust | Click "Double Down" and the resulting card busts the player | A "Bust!" dialog is shown | |
| BJG-21 | Double Down win payout (2× multiplied) | Win after doubling down | Payout is doubled compared to a standard win | |
| BJG-22 | Card tooltip shown on hover (desktop) | Hover over a card in the game | A tooltip/flip shows the card's value | |

### 6.3 Game Settings

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| BJG-23 | "Use Betting" toggle disables betting mid-session | Uncheck "Use Betting" checkbox | A new game starts with betting disabled; pot/bet labels are hidden | |
| BJG-24 | "Use Dealer Card Reveal Delay" toggle works | Enable the "Use Dealer Card Reveal Delay" toggle, then click "Stand" | Dealer cards appear with a visible delay (~1.25 s between cards) | |
| BJG-25 | Dealer reveal delay preference is persisted | Enable the delay toggle, refresh the page, and return to the game | The toggle is still checked (preference stored in local storage) | |
| BJG-26 | Wins counter increments on win | Win a game | The "Wins" counter displayed in the game increases by 1 | |
| BJG-27 | Losses counter increments on loss | Lose a game | The "Losses" counter displayed in the game increases by 1 | |

### 6.4 Authenticated Game Features

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| BJG-28 | Logged-in player name shown as hand name | Log in and start a game | The player's hand label displays the logged-in username | |
| BJG-29 | Pot value loaded from player profile | Log in (with existing player profile) and start a game | The pot value matches the value stored in the player profile | |
| BJG-30 | Wins/losses sync to player profile | Win or lose a game while logged in | The wins/losses are updated in the player profile (visible on the Profile page after saving) | |
| BJG-31 | "Leaderboard" button visible only when logged in | Log in and navigate to `/black-jack-game` | A "Leaderboard" button is visible next to the game controls | |
| BJG-32 | "Leaderboard" button hidden when logged out | Log out and navigate to `/black-jack-game` | No "Leaderboard" button is visible | |
| BJG-33 | "Leaderboard" button navigates to leaderboard | While logged in, click the "Leaderboard" button | Browser navigates to `/black-jack-leaderboard` | |

---

## 7. Leaderboard

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| LB-01 | Page requires authentication | Navigate directly to `/black-jack-leaderboard` while logged out | User is redirected (guard active); they cannot view the leaderboard without logging in | |
| LB-02 | Page requires disclaimer | Navigate directly to `/black-jack-leaderboard` without completing the disclaimer | User is redirected to the disclaimer page | |
| LB-03 | Loading spinner shown while data fetches | Navigate to `/black-jack-leaderboard` | An animated loader is displayed while the leaderboard data is fetching | |
| LB-04 | Leaderboard table renders | Navigate to `/black-jack-leaderboard` after logging in and completing the disclaimer | A table with columns "Username", "Wins", "Losses", "Pot" is displayed | |
| LB-05 | Leaderboard data is correct | Compare the table data with known player profile values | The Username, Wins, Losses, and Pot values are accurate | |
| LB-06 | Pagination controls visible | Navigate to `/black-jack-leaderboard` with more entries than the page size | Pagination controls (page numbers, first/last links) are displayed | |
| LB-07 | Pagination changes page | Click "Next" or a specific page number | The table updates to show the next page of players | |
| LB-08 | Page size selector changes number of rows | Change the "Page Size" dropdown to a different value | The table updates to show the selected number of rows per page | |
| LB-09 | "Back" button navigates to BlackJack game | Click the "← Back" button | Browser navigates to `/black-jack-game` | |
| LB-10 | "Back to top" link scrolls to top | Scroll down the leaderboard, then click "back to top" | The page scrolls back to the top of the leaderboard table | |
| LB-11 | Row animation on load | Navigate to `/black-jack-leaderboard` | Rows slide in alternately from the left and right with a staggered animation delay | |

---

## 8. User Profile Page

### 8.1 View Profile

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| UP-01 | Page requires authentication | Navigate to `/user-profile` while logged out | User is redirected to login (Keycloak guard active) | |
| UP-02 | Profile details displayed | Log in and navigate to `/user-profile` | Username, email, and full name are displayed in the Account Details table | |
| UP-03 | Player profile stats displayed (if profile exists) | Log in with an account that has a player profile | A "Player Profile" table is displayed showing Player Profile ID, Wins, Losses, and Pot | |
| UP-04 | Player profile section hidden (if no profile) | Log in with an account that has no player profile | The "Player Profile" table and related buttons are not displayed | |
| UP-05 | Unverified email alert shown | Log in with an unverified email | An alert is displayed: "Your email is unverified. To resend verification email click here" | |

### 8.2 Edit Profile

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| UP-06 | Edit mode activated | Click the "Edit" button | The profile fields become editable inputs; "Save" and "Revert" buttons appear; "Edit" button disappears | |
| UP-07 | Revert individual username | In edit mode, change the username, then click the ↺ (revert) button next to username | The username input reverts to the original value | |
| UP-08 | Revert individual email | In edit mode, change the email, then click the ↺ (revert) button next to email | The email input reverts to the original value | |
| UP-09 | Revert individual first name | In edit mode, change the first name, then click the ↺ (revert) button | The first name input reverts to the original value | |
| UP-10 | Revert individual last name | In edit mode, change the last name, then click the ↺ (revert) button | The last name input reverts to the original value | |
| UP-11 | "Revert" button reverts all fields | In edit mode, change multiple fields, then click the "Revert" button | All input fields revert to their original values and edit mode is closed | |
| UP-12 | Save valid profile update | In edit mode, make valid changes, then click "Save" | Changes are saved; edit mode closes; updated values are displayed | |
| UP-13 | Save with invalid email | In edit mode, enter an invalid email (e.g., `notanemail`), then click "Save" | Validation error is shown; the form is not submitted | |
| UP-14 | Save with empty username | In edit mode, clear the username field, then click "Save" | Validation error is shown; the form is not submitted | |
| UP-15 | Email change triggers verification prompt | In edit mode, change the email to a new valid one, then click "Save" | A SweetAlert2 confirmation dialog warns that a new verification email will be sent | |
| UP-16 | Confirming email change sends verification email | Complete the email change confirmation dialog | The email is updated; a verification email is sent to the new address | |
| UP-17 | Cancelling email change reverts email | Decline the email change in the confirmation dialog | The email field reverts to the original value and no changes are saved to the email | |

### 8.3 Re-verification Email

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| UP-18 | Re-send verification email | Navigate to `/user-profile` with an unverified email; click "click here" in the alert | A success SweetAlert2 dialog confirms the verification email has been sent | |

### 8.4 Player Profile Management

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| UP-19 | Reset player profile – confirm | Click "Reset Player Profile Data", then confirm in the dialog | A success dialog is shown; wins, losses, and pot are reset to their default values | |
| UP-20 | Reset player profile – cancel | Click "Reset Player Profile Data", then cancel in the dialog | No changes are made; the player profile data is unchanged | |
| UP-21 | Delete player profile – confirm | Click "Delete Player Profile", then confirm in the dialog | A success dialog is shown; the "Player Profile" table and its buttons are removed from the page | |
| UP-22 | Delete player profile – cancel | Click "Delete Player Profile", then cancel in the dialog | No changes are made; the player profile remains visible | |

### 8.5 Account Deletion

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| UP-23 | Delete account – wrong confirmation text | Click "Delete Account", type anything other than "DELETE", then confirm | Validation message shown: `You need to type "DELETE" to confirm`; account is not deleted | |
| UP-24 | Delete account – correct confirmation | Click "Delete Account", type "DELETE", then confirm | Account is deleted; the user is logged out and cannot log in with the deleted credentials | |
| UP-25 | Delete account – cancel | Click "Delete Account", then cancel the dialog | No changes are made; the user remains on the profile page | |

---

## 9. Footer

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| FOOT-01 | Email address displayed | Scroll to the footer on any page | `matthew@xenon-dev.com` is displayed | |
| FOOT-02 | LinkedIn link works | Click the LinkedIn icon in the footer | Opens the LinkedIn profile in a new tab | |
| FOOT-03 | GitHub link works | Click the GitHub icon in the footer | Opens the GitHub profile in a new tab | |
| FOOT-04 | Font Awesome link works | Click the Font Awesome icon in the footer | Opens `https://fontawesome.com` | |
| FOOT-05 | Bootstrap link works | Click the Bootstrap icon in the footer | Opens `https://getbootstrap.com` | |
| FOOT-06 | SweetAlert2 link works | Click the SweetAlert2 logo in the footer | Opens the ngx-sweetalert2 GitHub page | |
| FOOT-07 | Jasmine link works | Click the Jasmine logo in the footer | Opens `https://jasmine.github.io/index.html` | |
| FOOT-08 | AWS Amplify link works | Click the AWS icon in the footer | Opens `https://aws.amazon.com/amplify/` | |

---

## 10. Routing & Guards

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| RG-01 | Unknown route redirects to Landing | Navigate to any undefined path (e.g., `/unknown`) | User is redirected to `/landing` | |
| RG-02 | Root path redirects to Landing | Navigate to `/` | User is redirected to `/landing` | |
| RG-03 | BlackJack game requires disclaimer | Navigate directly to `/black-jack-game` without having agreed to the disclaimer | User is redirected away from the game page | |
| RG-04 | BlackJack leaderboard requires login | Navigate directly to `/black-jack-leaderboard` while logged out | User is redirected to the login page | |
| RG-05 | BlackJack leaderboard requires disclaimer | Navigate directly to `/black-jack-leaderboard` while logged in but without completing the disclaimer | User is redirected to the disclaimer page | |
| RG-06 | User profile requires login | Navigate directly to `/user-profile` while logged out | User is redirected to the login page | |

---

## 11. Responsive / Mobile Layout

| TC-ID | Test Case | Steps | Expected Result | Pass/Fail |
|-------|-----------|-------|-----------------|-----------|
| MOB-01 | Mobile viewport renders correctly | Resize the browser to a mobile width (≤576 px) or use a mobile device | All pages render without horizontal overflow; text is readable | |
| MOB-02 | Desktop-only tips hidden on mobile | View the BlackJack help page on a mobile device | The "hover over the card" tip is hidden; the "press the card" tip is shown | |
| MOB-03 | Desktop tips shown on desktop | View the BlackJack help page on a desktop browser | The "hover over the card" tip is shown; the "press the card" tip is hidden | |
| MOB-04 | Landing page cards stack on mobile | View the landing page on a mobile viewport | The "About" and "BlackJack" landing cards stack vertically | |
| MOB-05 | BlackJack game cards wrap on mobile | Play the BlackJack game on a mobile viewport | Cards wrap to a new row instead of overflowing the screen | |

---

*Last updated: 2026-03-16*
