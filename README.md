# Geometry Run

GROUP MEMBERS
: Agnese Eva Zamboni, XiZhe Lin, Alessandro Lucchesi, Stefano Soardi


## MILESTONE 1
- divided the project in 3 files: 
	1. "main.rkt" contains (almost) all FUNCTIONS needed to play the game
	2. "datatypes.rkt" contains the definitions of all the DATA TYPES DEFINITIONS of types and structures used in the otherfiles (with some examples) and all CONSTANT DEFINITIONS of values needed in the other files (e.g: images, jump speed, jump height, start state, ...). It also contains FUNCTIONS that can be used to DESIGN MAPS faster (e.g: create-pavement creates a pavement of the wanted length)
	3. "map-1.rkt" is dedicated to the construction of MAP 1 (first level of the game). This file only provides the Game State that contains all obstacles wanted in that map. We did this because it can take many lines of code to create a level (even if for now the map contains just a short pavement).
- added images for blocks, player skins, obstacles and background
- created obstacle objects to represent the blocks, different players, blades
- defined main data structures: GameState PlayerState, Obstacle, Dimension
- created some getter and setter functions to access or modify complex structures faster
- added tests for some of the functions implemented
- started implementing event handlers and big-bang function, in particular:
	1. jump (the player can jump pressing space)
	2. move (used in draw: the obstacles move towards the left of the screen on every tick to give the impression that the player is moving forward)
	3. draw (the previous 2 implementations are displayed on the screen correctly. All obstacles contained in a map appear and move)


## MILESTONE 2
- created separate file for tests called "tests.rkt", so that "main.rkt" is more readable
- renamed file "map-1.rkt" to "level-1.rkt"
- changed background image, blade image, block image
- designed the first level
- implemented collisions and death condition
- added ability to restart level after you die (press space)
- implemented win condition

### MADE SOME CHANGES IN STRUCTURES AND DATA TYPES
- added Data Type Level that represents a level: structure that contains the number of level (e.g. 1 for level 1) and obstacles in that level. We did this to make the GState more organised.
- before we referred to levels as "maps". Now we will call them "level" because it's a better word and because there is already a struct-map in racket/base
- **pstate** : removed field "dead" because it is almost unused. Instead of using that field to know when the player dies, now we change Menu of the gstate to MENU-YOU-DIED. To check if the player is dead you check if this state's menu is MENU-YOU-DIED.
- **gstate** : for the same reason as above, the field "win" was almost never used, therefore we removed it, and instead we go directly to MENU-YOU-WON when the player wins.
- removed the field "obstacles", renamed field "map" to "level". Now field "level" is a Level and contains a number and the obstacles of the level
- **obstacle** : changed field "blade" (it was a Boolean, #true if the obstacle is a blade) to "type". "type" is a String that tells the type of the obstacle (player, blade, block, win-block). We did this because we are creating different kinds of obstacles, and it doesn't make sense to have a boolean that can only differentiate one of the types. Now we can differentiate all the types of obstacles

### REFINED IMPLEMENTATION OF EVENT-HANDLERS:
1. **to-draw** : what is drawn depends on the Menu of the GState. If you are in the YOU-DIED menu, text saying "you died" will appear, same for YOU-WON
	- made a (cond ) that will soon satisfy all different menu's (choose player, choose map , ...)
2. **on-tick** : before on-tick just called the move function that made the obstacles move and the player jump. Now it only does it if you are in a level (Menu of GState is LEVEL). If you are not in a Level it doesn't do anything (=> stops moving when you die or win)


## FINAL SUBMISSION

### NEW FEATURES

#### In level
- the player now dies if it crashes on a block (not just from touching blades)
- the player now falls if it's not on the ground
- the player now dies if it falls into holes on the ground
- the player can jump on blocks in the air (platforms)
- the player rotates when he jumps (similar to the real geometry dash)
- designed level 2 and 3

#### In menu's
- added ability to pause and resume game
- added welcome page
- added choose-player page (and ability to choose player)
- added choose-level page (and ability to choose level)

### CHANGES IN STRUCTURES AND DATA TYPES
- **pstate** : pstate now has a new field "jump-y". this field keeps track of the starting position of the jump, so that we know when the jump has reached the maximum height
- **obstacle** : obstacle field "type" now differentiates between the kinds of player (field "type" is one of "player-blue" "player-red" "player-yellow" "blade" "block" "win-block")
- **menu** : added "welcome-page" and "pause" as menu's possible values

### REFINED IMPLEMENTATION OF EVENT-HANDLERS:
- **handle-key** : like "draw" and "tick", this function has a (cond ) that differentiates between the possible MENU of a gstate (Menu is an enumeration)

### DESIGN 
- reduced code duplication in "main-rkt" (using abstraction)
- reduced complexity of "tick" (using filter, ormap , local, ...)
- simple top-level functions that were only used once are now local or lambdas
- renamed file "level-1.rkt" to "levels.rkt". The file contains all levels (because we don't need separate files for each level)
- for this reason the functions needed to design a level faster are moved from file "datatypes.rkt" to file "levels.rkt"

#### Design recipe
- added tests for all functions and that cover all branches (except start function)
- added templates for all top-level functions
- added datatype examples for all data structures
