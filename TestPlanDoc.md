# Test Plan
## Objective
List functional requirements and test functionality

## Main Menu
**PASS** / FAIL - Display logo. _Working as expected_
**PASS** / FAIL - Display historical high score. _Working as expected_
**PASS** / FAIL - Button to start a new game. _Working as expected_

## Game Play
### Flight Control
_PASS_ / FAIL - Control movement with device accelerometers _Working almost as expected.  Ship is controlled with device accelerometers, however it is possible to fly ship off the screen.  I did have it contained to the device screen, but in adding some other physics body interactions, this functionality broke._

### Firing
**PASS** / FAIL - Fire blaster when screen tapped. _Working as expected.  Can also upgrade blaster to tri-blaster_

### Spawning Enemies
**PASS** / FAIL - Enemies spawn at a variable rate depending on the level. _Working as expected_

### Upgrading Weapons
_PASS_ / FAIL - Possible to upgrade weapon to tri-blaster. _Working as expected for the most part.  If you don't already have the upgrade an upgrade icon appears when you level up.  If you fly into it, you get the upgraded tri-blaster_

### UI Elements
**PASS** / FAIL - Scoreboard to track scores. _Working as expected_
**PASS** / FAIL - Display current level _Working as expected.  Flashes when new level is reached_
**PASS** / FAIL - Display number of lives left. _Working as expected_

## Game Over Screen
**PASS** / FAIL - Populate most recent high score. _Working as expected_
**PASS** / FAIL - Populate historical highest score. _Working as expected.  High score is persistent across restarts of app_
**PASS** / FAIL - Button to restart a new game. _Working as expected_





**_Destroy ALL the invaders!_** ..._pass_
