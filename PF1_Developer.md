
# Geometry Run - Developer Guide

# Project Structure

The project is divided in different files for readability purporses.
- **"main.rkt"** : contains all the functions needed to run the program
- **"datatypes.rkt"** : contains all structures and data types definitions. It also contains ALL CONSTANTS needed in other files.
- **"levels.rkt"** : contains functions needed to design a level. Also contains the construction of the levels.
- **"tests.rkt"** : contains tests for all functions to make "main.rkt" more readable. Make sure that your tests cover all branches!
- images folder : contains all images.

## Used libraries:

- _2htdp/universe_ : for the big-bang function

- _2htdp/image_ : for images

- _racket/base_ : to provide definitions between the files

## Main Functions

>**(gstate-set-field field gstate value)**
>It takes a field name, a GState, and a new value as input, and returns a new GState with the specified field set to the new value. All other fields of the returned GState  are equal to those of the original GState.
>
>Example:
>
>       (define OLD-GSTATE (make-gstate PSTATE "game-menu" LEVEL #f)) 
>       (define NEW-GSTATE (gstate-set-field "menu" old-gstate "main-menu"))
>In this example, NEW-GSTATE will be a GState with the same values as OLD-GSTATE, but with the menu field set to "main-menu".
>Similarly, we implemented **pstate-set-field** and **obstacle-set-field**

>**(handle-key gstate key)**
>
>The handle-key function is used to update the game state (gstate) based on the key that was pressed by the player (key). It does this by checking the current menu state of the game and reacting accordingly.

>**(draw gstate)**
>
>The draw function takes a gstate as input and returns an image that represents the game state.
>
>The draw function first defines some local functions, draw-level and text-top-sub.
>
>draw-level returns an image of the level in the gstate.
>
>text-top-sub returns the background image with some text overlaid on top. The text is split into two parts, top and sub, which are drawn in different text styles. 
>
>In the body, the draw function uses cond to select the appropriate image to return based on the value of gstate-menu. If gstate-menu is MENU-WELCOME, then the WELCOME-PAGE image is returned. If gstate-menu is MENU-CHOOSE-PLAYER, then the draw-choose-player function is called to return the appropriate image. Similarly, if gstate-menu is MENU-CHOOSE-LEVEL or MENU-LEVEL, the draw-choose-level or draw-level function is called.
>
>For other Menus, the text-top-sub function is called to return the appropriate image with the relevant text overlaid on top.

>**(gstate-move-player gstate)**
> This function in charge of rotating the player and moving it up or down .
> If the player is not touching the ground, and the pstate field "jump" is #false, it moves down and rotates.
> If "jump" is #true, the player moves up and rotates
> If the player reaches maximum jump height (JUMP-HEIGHT + "jump-y") "jump" becomes #false and it moves down
> If the player is touching the ground it doesn't move vertically, but if the rotation isn't complete it keeps rotating

>**(move-level gstate)**
>
>This function is in charge of checking if the player in the given gstate has died or won and to move the level accordingly.
>
>This function first defines a local function and some local constants.
>
>move moves the components of gstate, this is done by first moving all obstacles in gstate to the left, and then by calling **gstate-move-player**.
>
>- TOUCHING-OBSTACLES filters all obstacles in gstate that are touching the player.
>- TOUCHING-BLADES? determines if there are blades in TOUCHING-OBSTACLES
>- TOUCHING-WIN-BLOCKS? determines if there is a win-block in TOUCHING-OBSTACLES
>- TOUCHING-BLOCKS filters all the blocks from TOUCHING-OBSTACLES
>- GROUND-BLOCKS filters all the blocks in TOUCHING-BLOCKS that are under the player
>- CRASHED-BLOCKS? determines if the player is touching some blocks but isn't on them
>
>In the body, the move-level function uses a cond to determine the state of the game. Using TOUCHING-BLADES?, CRASHED-BLOCKS? and checking if the player fell out of the screen, the function determines if the player has died and sets the menu to YOU-DIED-MENU. SImilarly, using TOUCHING-WIN-BLOCKS? it sets the menu to YOU-WON-MENU. If these are not the case, the level can move. 
>
>In the case where the player is standing on a block, in addition to moving the level, the y position of the player is set so that it stands perfectly on the block.
> NOTE: this is because when jumping or falling, the player is moved up / down by a constant JUMP-SPEED. It can happen that the distance between the player and the platform is not a multiple of JUMP-SPEED. This would result in the player landing slightly under the actual border of the block.

>**(start gstate)**
>
>start calls the big-bang function.
>- on-tick calls **move-level**, only if gstate's menu is "level"
>- to-draw calls **draw**
>- on-key calls **handle-key**
>- stop-when stops when the field quit of gstate is #true

# Developer Tips

## How to add characters
1. provide image in "datatypes.rkt"
2. add ObstacleType for your new character
2. create obstacle in "datatypes.rkt" with new image and type
3. edit images CHOOSE-BLUE CHOOSE-RED and CHOOSE-YELLOW and create image for the choice of your player
4. edit function draw-choose-player
5. edit function gstate-pstate-reset
6. edit function gstate-flat?

## How to add level
1. define obstacles in "levels.rkt" using the functions that you can find there
2. create level (make-level number obstacles)
3. create gstate (make-gstate INITIAL-PSTATE MENU-LEVEL your-level #false)
4. provide your-level and your-gstate
5. edit images CHOOSE-LEVEL-1 CHOOSE-LEVEL-2 CHOOSE-LEVEL-3 and create image for the choice of your level
6. edit function draw-choose-level
7. edit function gstate-restart-level



