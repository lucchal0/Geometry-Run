;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname datatypes) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
(require racket/base)

; this file contains all datatypes definitions and examples.
; it also contains all constants needed for the main file.
; everything useful is provided.

; only provided things that are useful for other files. please check if something is provided before using it in other files
(provide
 ; Structures
 (struct-out dimension) (struct-out obstacle) (struct-out pstate) (struct-out level) (struct-out gstate)
 ; Movements and Speed
 JUMP-SPEED LEVEL-SPEED JUMP-HEIGHT ROTATE-SPEED
 ; Dimensions
 PLAYER-HEIGHT BLOCK-WIDTH BLOCK-HEIGHT SCREEN-WIDTH SCREEN-HEIGHT
; Obstacle Types
 OBSTACLE-TYPE-PLAYER-BLUE OBSTACLE-TYPE-PLAYER-RED OBSTACLE-TYPE-PLAYER-YELLOW OBSTACLE-TYPE-BLOCK OBSTACLE-TYPE-BLADE OBSTACLE-TYPE-WIN-BLOCK
; Images
 BLUE-GUY-IMG BLUE-GUY-90-IMG RED-GUY-IMG RED-GUY-90-IMG YELLOW-GUY-IMG YELLOW-GUY-90-IMG BACKGROUND
 CHOOSE-BLUE CHOOSE-RED CHOOSE-YELLOW CHOOSE-LEVEL-1 CHOOSE-LEVEL-2 CHOOSE-LEVEL-3 WELCOME-PAGE
 ; Positions
 INITIAL-Y WIN-BLOCK-Y
 ; Obstacles
 BLADE BLOCK WIN-BLOCK BLUE-GUY RED-GUY YELLOW-GUY
 ; Menus
 MENU-WELCOME MENU-CHOOSE-PLAYER MENU-CHOOSE-LEVEL MENU-LEVEL MENU-YOU-DIED MENU-YOU-WON MENU-PAUSE
 ; PStates
 INITIAL-PSTATE
; GStates
 START-GAME CHOOSE-PLAYER
 ; Text
 TOP-TEXT-X TOP-TEXT-Y TOP-TEXT-COLOR TOP-TEXT-SIZE SUB-TEXT-X SUB-TEXT-Y SUB-TEXT-COLOR SUB-TEXT-SIZE)


; ======== DATA TYPES : DEFINITIONS ========
; === this section contains the Data Types definitions. The examples are all in the next sections. ===

; Dimension is a structure (make-dimension width height) representing the dimensions of an object,
; where:
; - width is a positive Number
; - height is a positive Number
(define-struct dimension [width height] #:transparent)


; ObstacleType is one of :
; - "player-blue"
; - "player-red"
; - "player-yellow"
; - "block"
; - "blade"
; - "win-block"
; ObstacleType is an Enumeration. The constant definitions for these Strings are in the next section.


; Obstacle is a structure (make-obstacle type img position dimension),
; where:
; - type is an ObstacleType
; - img is an Image
; - position is a Posn representing the position of the obstacle
; - dimension is a Dimension representing the hitbox of the obstacle
(define-struct obstacle [type img position dimension] #:transparent)


; Menu is one of the following strings:
; - "welcome-page“ if you are in the welcome page
; - "choose-player" if you are in the menu where you can choose player
; - "choose-level"  if you are in the menu where you can choose level
; - "level"  if you are in a level
; - "you-died" if you are on the screen that appears when the player dies in a level
; - "you-won" if you are on the screen that appears when the player wins in a level
; - "pause" if you paused a level
; Menu is an Enumeration. The constant definitions for these Strings are in the next section.


; PState is a structure (make-pstate player jump jump-y) representing the state of the player,
; where:
; - player is an Obstacle representing the player
; - jump is a Boolean, #true if the player is jumping, otherwise #false
; - jump-y is a Number representing the y positon at which the player jumped
(define-struct pstate [player jump jump-y] #:transparent)


; Level is a structure (make-level number obstacles) where:
; - number is a Number representing the number of this level (1 for level-1, 2 for level-2 , ...)
; - obstacles is a List<Obstacle> representing the obstacles in this level
(define-struct level [number obstacles] #:transparent)


; GState is a structure (make-state player-state menu level quit) representing the state of the game
; where:
; - player-state is a PState representing the state of the player
; - menu is a Menu
; - level is a Level representing the level we are in 
; - quit is a Boolean, #true if the player has quit the game, otherwise #false
(define-struct gstate [player-state menu level quit] #:transparent)


; ======== USEFUL CONSTANTS DEFINITIONS ========
; === This sections contains all constants needed in main program ===


; Movements and Speed
; the following equation should be satisfied so one jump on a continuous pavement makes a 180 degree rotation:
; JUMP-HEIGHT / JUMP-SPEED  =  90 / - ROTATE-SPEED
(define JUMP-SPEED 25)
(define LEVEL-SPEED 25)
(define JUMP-HEIGHT 250)
(define ROTATE-SPEED -9) ; negative for clock-wise rotation.

; Dimensions:
(define PLAYER-WIDTH 90)  
(define PLAYER-HEIGHT 90) 
(define BLADE-WIDTH 90)
(define BLADE-HEIGHT 90)
(define BLOCK-WIDTH 90)  
(define BLOCK-HEIGHT 90) 
(define SCREEN-WIDTH 1400) 
(define SCREEN-HEIGHT 870)

(define PLAYER-DIMENSION (make-dimension PLAYER-WIDTH PLAYER-HEIGHT))
(define BLADE-DIMENSION (make-dimension BLADE-WIDTH BLADE-HEIGHT))
(define BLOCK-DIMENSION (make-dimension BLOCK-WIDTH BLOCK-HEIGHT))
(define WIN-BLOCK-DIMENSION (make-dimension BLOCK-WIDTH SCREEN-HEIGHT))

; Obstacle Types Constants Definitions:
(define OBSTACLE-TYPE-PLAYER-BLUE "player-blue")
(define OBSTACLE-TYPE-PLAYER-RED "player-red")
(define OBSTACLE-TYPE-PLAYER-YELLOW "player-yellow")
(define OBSTACLE-TYPE-BLOCK "block")
(define OBSTACLE-TYPE-BLADE "blade")
(define OBSTACLE-TYPE-WIN-BLOCK "win-block")

; Images
(define BLUE-GUY-IMG (bitmap "images/blue_guy.png"))
(define BLUE-GUY-90-IMG (rotate 90 BLUE-GUY-IMG))
(define RED-GUY-IMG (bitmap "images/red_guy.png"))
(define RED-GUY-90-IMG (rotate 90 RED-GUY-IMG))
(define YELLOW-GUY-IMG (bitmap "images/yellow_guy.png"))
(define YELLOW-GUY-90-IMG (rotate 90 YELLOW-GUY-IMG))
(define BLADE-IMG (bitmap "images/blade.png"))
(define BLOCK-IMG (bitmap "images/block.jpg"))
(define WIN-BLOCK-IMG (bitmap "images/winning_light.png"))
(define BACKGROUND (bitmap "images/background.jpg"))
(define CHOOSE-BLUE (bitmap "images/choose_blue.png"))
(define CHOOSE-RED (bitmap "images/choose_red.png"))
(define CHOOSE-YELLOW (bitmap "images/choose_yellow.png"))
(define CHOOSE-LEVEL-1 (bitmap "images/level-1.png"))
(define CHOOSE-LEVEL-2 (bitmap "images/level-2.png"))
(define CHOOSE-LEVEL-3 (bitmap "images/level-3.png"))
(define WELCOME-PAGE (bitmap "images/welcome.png"))

; Positions
(define INITIAL-X 200)     ; can be adapted
(define INITIAL-Y 650)     ; can be adapted
(define INITIAL-POSITION (make-posn INITIAL-X INITIAL-Y))
; the win-block image appears too high on the screen, therefore we have to move it down by hand
(define WIN-BLOCK-Y 400)   ; adapt this if you change image for the winning block

; Obstacles
(define BLADE (make-obstacle OBSTACLE-TYPE-BLADE BLADE-IMG (make-posn 0 0) BLADE-DIMENSION))
(define BLOCK (make-obstacle OBSTACLE-TYPE-BLOCK BLOCK-IMG (make-posn 0 0) BLOCK-DIMENSION))
(define WIN-BLOCK (make-obstacle OBSTACLE-TYPE-WIN-BLOCK WIN-BLOCK-IMG (make-posn 0 WIN-BLOCK-Y) WIN-BLOCK-DIMENSION))

; Initialized Players
(define BLUE-GUY (make-obstacle OBSTACLE-TYPE-PLAYER-BLUE BLUE-GUY-IMG INITIAL-POSITION PLAYER-DIMENSION))
(define YELLOW-GUY (make-obstacle OBSTACLE-TYPE-PLAYER-YELLOW YELLOW-GUY-IMG INITIAL-POSITION PLAYER-DIMENSION))
(define RED-GUY (make-obstacle OBSTACLE-TYPE-PLAYER-RED RED-GUY-IMG INITIAL-POSITION PLAYER-DIMENSION))

; Menu constants:
(define MENU-WELCOME "welcome-page")
(define MENU-CHOOSE-PLAYER "choose-player")
(define MENU-CHOOSE-LEVEL "choose-level")
(define MENU-LEVEL "level")
(define MENU-YOU-DIED "you-died")
(define MENU-YOU-WON "you-won")
(define MENU-PAUSE "pause")

; useful Player States
(define INITIAL-PSTATE (make-pstate BLUE-GUY #false INITIAL-Y))

; useful Game States
(define START-GAME (make-gstate INITIAL-PSTATE MENU-WELCOME #false #false ))
(define CHOOSE-PLAYER (make-gstate INITIAL-PSTATE MENU-CHOOSE-PLAYER #false #false ))

; text
(define TOP-TEXT-X (/ SCREEN-WIDTH 2)) 
(define TOP-TEXT-Y 170)  
(define TOP-TEXT-COLOR "white") 
(define TOP-TEXT-SIZE 90)

(define SUB-TEXT-X (/ SCREEN-WIDTH 2))
(define SUB-TEXT-Y 250)
(define SUB-TEXT-COLOR "white") 
(define SUB-TEXT-SIZE 30)


; ======== DATA TYPES : EXAMPLES ==========
; === more examples of data types: only for design, never used ===


; Dimension Examples:
(define DIMENSION1 (make-dimension 100 200))
(define DIMENSION2 (make-dimension 200 20))
(define DIMENSION3 (make-dimension 33 33))


; Obstacle Examples:
(define OBSTACLE1 (make-obstacle OBSTACLE-TYPE-PLAYER-BLUE BLUE-GUY-IMG (make-posn 0 0) DIMENSION1))
(define OBSTACLE2 (make-obstacle OBSTACLE-TYPE-BLOCK BLOCK-IMG (make-posn 10 10) DIMENSION2))
(define OBSTACLE3 (make-obstacle OBSTACLE-TYPE-BLADE BLADE-IMG (make-posn 200 200) DIMENSION3))


; PState Examples:
(define PSTATE1 (make-pstate OBSTACLE1 #true 0))
(define PSTATE2 (make-pstate OBSTACLE2 #true 210))
(define PSTATE3 (make-pstate RED-GUY #false 330))


; Level Examples:
(define LEVEL1 (make-level 1 '()))
(define LEVEL2 (make-level 2 (list OBSTACLE2)))
(define LEVEL3 (make-level 3 (list OBSTACLE2 OBSTACLE3)))


; GState Examples:
(define GSTATE1 (make-gstate PSTATE1 MENU-CHOOSE-LEVEL #false #false))
(define GSTATE2 (make-gstate PSTATE2 MENU-LEVEL (make-level 2 '()) #true))
(define GSTATE3 (make-gstate PSTATE3 MENU-CHOOSE-PLAYER (make-level 1 '()) #true))
