;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
(require racket/base)

(require "datatypes.rkt")
(require "levels.rkt")

; This file contains all function definitions, and the main function to run the game.
; All datatypes definitions and constant definitions are in the file "datatypes.rkt"
; All tests for these functions are in "tests.rkt"
; The game states for the levels are provided by "levels.rkt"

; provide functions for testing
(provide
 ; getters / setters
 obstacle-x obstacle-y gstate-quit? gstate-jump? gstate-player-x gstate-player-y obstacle-set-field obstacle-set-x pstate-set-field gstate-set-field
 gstate-set-jump gstate-set-jump-y gstate-set-player-y
 ; helpers
 obstacle-block? gstate-pstate-reset gstate-restart-level obstacle-in-frame? obstacle-touching? gstate-flat? obstacle-on-top? gstate-touches-ground?
 ; main
 gstate-move-player move-obstacles handle-key draw-obstacles draw-choose-player draw-choose-level draw move-level tick)


; ======= GETTER AND SETTER FUNCTIONS FOR STRUCTURES =======


; ===== GETTERS =====

; === These functions allow to retrieve the content of a structure more easily ==

; obstacle-x : Obstacle -> Number
; returns the x position of `obst`
; header : (define (obstacle-x obst) 0)
; template :
; (define (obstacle-x obst) ...(obstacle-position obst)...)
(define (obstacle-x obst)
  (posn-x (obstacle-position obst)))


; obstacle-y : Obstacle -> Number
; returns the y position of `obst`
; header : (define (obstacle-y obst) 0)
; template :
; (define (obstacle-y obst) ...(obstacle-position obst)...)
(define (obstacle-y obst)
  (posn-y (obstacle-position obst)))


; gstate-quit? : GState -> Boolean
; returns #true if the game has been quit, otherwise returns #false
; header : (define (gstate-quit? gstate) #false)
; template :
; (define (gstate-quit? gstate) ...(gstate-quit gstate)...)
(define (gstate-quit? gstate)
  (gstate-quit gstate))


; gstate-jump? : GState -> Boolean
; returns #true if the player is jumping in `gstate`, otherwise #false
; header : (define (gstate-jump? gstate) #false)
; template :
; (define (gstate-jump? gstate) ...(gstate-player-state gstate)... ... (pstate-jump ...)...)
(define (gstate-jump? gstate)
  (pstate-jump (gstate-player-state gstate)))


; gstate-player-x : GState -> Number
; returns the x position of the player in `gstate`
; header : (define (gstate-player-x gstate) 0)
; template :
; (define (gstate-player-x gstate) ...(gstate-player-state gstate).... ...(obstacle-x (pstate-player ...)... )
(define (gstate-player-x gstate)
  (obstacle-x (pstate-player (gstate-player-state gstate))))


; gstate-player-y : GState -> Number
; returns the y position of the player in `gstate`
; header : (define (gstate-player-y gstate) 0)
; template :
; (define (gstate-player-y gstate) ...(gstate-player-state gstate).... ...(obstacle-y (pstate-player ...)... )
(define (gstate-player-y gstate)
  (obstacle-y (pstate-player (gstate-player-state gstate))))



; ===== SETTERS =====

;  === These functions allow you to change the contents of a structure more easily ===


; obstacle-set-field : String Obstacle Any -> Obstacle
; returns an Obstacle with `value` in the field specified by `field`.
; all other fields of the returned Obstacle are equal to those of `obst`
; Remarks :
; `field` is one of :
; - "type" , "img" , "position" , "dimension"
; `value` is assumed to have the correct type for the specified field
; header : (define (obstacle-set-field field obst value) obst)
; template :
;(define (obstacle-set-field field obst value)
;  (make-obstacle
;   (if (...field...) value (...))
;   (if (...field...) value (...)) 
;   (if (...field...) value (...))
;   (if (...field...) value (...))))
(define (obstacle-set-field field obst value)
  (make-obstacle
   (if (string=? field "type")
       value
       (obstacle-type obst))
   (if (string=? field "img")
       value
       (obstacle-img obst))
   (if (string=? field "position")
       value
       (obstacle-position obst))
   (if (string=? field "dimension")
       value
       (obstacle-dimension obst))))


; obstacle-set-x : Obstacle Number -> Obstacle
; sets the x position of `obst` to `value`
; header: (define (obstacle-set-x obst value) obst)
; template :
; (define (obstacle-set-x obst value)
;   (obstacle-set-field "position" obst (make-posn ... value ...)))
(define (obstacle-set-x obst value)
 (obstacle-set-field "position"
                     obst
                     (make-posn
                      value
                      (obstacle-y obst))))


; pstate-set-field: String PState Any -> PState
; returns a PState with `value` in the field specified by `field`.
; all other fields of the returned PState are equal to those of `pstate`
; Remarks :
; `field` is one of :
; - "player" , "jump" , "jump-y"
; `value` is assumed to have the correct type for the specified field
; header : (define (pstate-set-field field pstate value) pstate)
; template :
;(define (pstate-set-field field pstate value)
;  (make-pstate
;   (if (...field...) value (...))
;   (if (...field...) value (...))
;   (if (...field...) value (...))))
(define (pstate-set-field field pstate value)
  (make-pstate
   (if (string=? field "player")
       value
       (pstate-player pstate))
   (if (string=? field "jump")
       value
       (pstate-jump pstate))
   (if (string=? field "jump-y")
       value
       (pstate-jump-y pstate))))


; gstate-set-field: String GState Any -> Gstate
; returns a GState with `value` in the field specified by `field`.
; all other fields of ther returned GState are equal to those of `gstate`
; Remarks : 
; `field` is one of :
; - "player-state" , "menu" , "level" , "quit"
; `value` is assumed to have the correct type for the specified field
; header : (define (gstate-set-field field gstate value) gstate)
; template :
;(define (gstate-set-field field gstate value)
;  (make-gstate
;   (if (...) value (...))
;   (if (...) value (...))
;   (if (...) value (...))
;   (if (...) value (...)))))
(define (gstate-set-field field gstate value)
  (make-gstate
   (if (string=? field "player-state")
       value
       (gstate-player-state gstate)) 
   (if (string=? field "menu")
       value
       (gstate-menu gstate))
   (if (string=? field "level")
       value
       (gstate-level gstate))
   (if (string=? field "quit")
       value
       (gstate-quit gstate))))


; gstate-set-jump : GState Boolean -> GState
; sets the jump field of the player of `gstate` to the given `bool`.
; header : (define (gstate-set-jump gstate bool) gstate)
; template :
; (define (gstate-set-jump gstate bool) (gstate-set-field ... gstate ... bool ...))
(define (gstate-set-jump gstate bool)
  (gstate-set-field "player-state"
                    gstate
                    (pstate-set-field "jump"
                                      (gstate-player-state gstate)
                                      bool)))


; gstate-set-jump-y : GState Number -> GState
; sets the jump-y field of the player of `gstate` to the given `value`. This represents the height
; at which the player starts the jump.
; header : (define (gstate-set-jump-y gstate value) gstate)
; template :
; (define (gstate-set-jump-y gstate bool) (gstate-set-field ... gstate ... value ...))
(define (gstate-set-jump-y gstate value)
  (gstate-set-field "player-state"
                    gstate
                    (pstate-set-field "jump-y"
                                      (gstate-player-state gstate)
                                      value)))


; gstate-set-player-y : GState Number -> GState
; sets the y position of the player of `gstate` to `value`
; header : (define (gstate-set-player-y gstate value) gstate)
; template :
; (define (gstate-set-player-y gstate value) (gstate-set-field ... gstate ... value... ))
(define (gstate-set-player-y gstate new-y)
  (gstate-set-field "player-state"
                    gstate
                    (pstate-set-field "player"
                                      (gstate-player-state gstate)
                                      (obstacle-set-field "position"
                                                          (pstate-player (gstate-player-state gstate))
                                                          (make-posn (gstate-player-x gstate)
                                                                     new-y)))))



; ======= HELPER FUNCTIONS =======

; === These are helper functions for other functions ===


; obstacle-block? : Obstacle -> Boolean
; returns #true if `obst` is a block, otherwise #false
; header : (define (obstacle-block? obst) #false)
; template :
; (define (obstacle-block? obst) ...(obstacle-type obst)...)
(define (obstacle-block? obst)
  (string=? (obstacle-type obst) OBSTACLE-TYPE-BLOCK))


; gstate-pstate-reset : GState -> GState
; reset the player's position and image into initial state
; header : (define (gstate-pstate-reset gstate) gstate)
; template :
; (define (gstate-pstate-reset gstate)
;  (cond [(equal? OBSTACLE-TYPE-PLAYER-BLUE (obstacle-type (pstate-player (gstate-player gstate)))) ...gstate... BLUE-GUY]
;        [(equal? OBSTACLE-TYPE-PLAYER-RED (obstacle-type (pstate-player (gstate-player gstate)))) ...gstate... RED-GUY]
;        [(equal? OBSTACLE-TYPE-PLAYER-YELLOW (obstacle-type (pstate-player (gstate-player gstate)))) ...gstate... YELLOW-GUY]))
(define (gstate-pstate-reset gstate)
  (cond
    [(equal? (obstacle-type (pstate-player (gstate-player-state gstate))) OBSTACLE-TYPE-PLAYER-BLUE)
     (gstate-set-field "player-state" gstate (pstate-set-field "player" INITIAL-PSTATE BLUE-GUY))]
    [(equal? (obstacle-type (pstate-player (gstate-player-state gstate))) OBSTACLE-TYPE-PLAYER-RED)
     (gstate-set-field "player-state" gstate (pstate-set-field "player" INITIAL-PSTATE RED-GUY))]
    [(equal? (obstacle-type (pstate-player (gstate-player-state gstate))) OBSTACLE-TYPE-PLAYER-YELLOW)
     (gstate-set-field "player-state" gstate (pstate-set-field "player" INITIAL-PSTATE YELLOW-GUY))]))


; gstate-restart-level : GState -> GState
; restarts the level that you are in from the beginning. if there is an error you are taken to the start of the game
; header : (define (gstate-restart-level gstate) gstate)
; template :
; (define (gstate-restart-level gstate)
;  (cond
;   [( = 1 (level-number (gstate-level gstate))) ...]
;   [( = 2 (level-number (gstate-level gstate))) ...]
;   ...))
(define (gstate-restart-level gstate)
  (cond
    [(= 1
        (level-number (gstate-level gstate)))
     (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset gstate) LEVEL-1) MENU-LEVEL)]
    [(= 2
        (level-number (gstate-level gstate)))
     (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset gstate) LEVEL-2) MENU-LEVEL)]
    [(= 3
        (level-number (gstate-level gstate))) 
     (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset gstate) LEVEL-3) MENU-LEVEL)]
    [else
     START-GAME]))
 

; obstacle-in-frame? Obstacle -> Boolean
; returns #true if `obst` is in the screen of the game, otherwise #false
; header : (define (obstacle-in-frame? obst) #false)
; template : 
; (define (obstacle-in-frame? obst)
;  (and ...(obstacle-x obst)... ...SCREEN-WIDTH... ...(obstacle-y obst)... SCREEN-HEIGHT... )))
(define (obstacle-in-frame? obst)
  (and
   ; check x axis
   (and
    ; check border on the left (where obstacles exit the screen)
    (>= (obstacle-x obst)
        (- 0 (dimension-width (obstacle-dimension obst))))
    ; check border on the right (obstacle enters the screen)
    (<= (obstacle-x obst)
        SCREEN-WIDTH))
   ; check y axis
   (and
    ; check top border
    (>= (obstacle-y obst)
        (- 0 (dimension-height (obstacle-dimension obst))))
    ; check bottom border
    (<= (obstacle-y obst)
        SCREEN-HEIGHT))))


; obstacle-touching? : Obstacle Obstacle -> Boolean
; returns #true if `player` is touching `obst`, otherwise #false 
; header : (define (obstacle-touching? player obst) #false) 
; template :
; (define (obstacle-touching? player obst)
;  (and ...(obstacle-x player)... ...(obstacle-x obst)... ...(obstacle-y player)... ...(obstacle-y obst)...
;    ...(dimension-width (obstacle-dimension player))... ...(dimension-width (obstacle-dimension obst))... 
;    ...(dimension-height (obstacle-dimension player)... ...(dimension-height (obstacle-dimension obst))...))
(define (obstacle-touching? player obst)
  (and
       ; check if the obstacles intersect on the x axis
       (or
        ; case where player's right side (player x + player width) is between `obst`'s left side and `obst`'s right side
        (and
         ; player's right side is past `obst`'s left side
         (>= (+ (obstacle-x player)
                (dimension-width (obstacle-dimension player)))
             (obstacle-x obst))
         ; player's right side is before `obst`'s right side
         (<= (+ (obstacle-x player)
                (dimension-width (obstacle-dimension player)))
             (+ (obstacle-x obst)
                (dimension-width (obstacle-dimension obst)))))
        ; case where player's left side is between `obst`'s left side and `obst`'s right side
        (and
         ; player's left side is past `obst`'s left side
         (>= (obstacle-x player)
             (obstacle-x obst))
         ; player's left side is before `obst`'s right side
         (<= (obstacle-x player)
             (+ (obstacle-x obst)
                (dimension-width (obstacle-dimension obst)))))) 
       ; check if the obstacles intersect on the y axis
       (or
        ; case where player's bottom side (player y + player height) is between `obst`'s top side and `obst`'s bottom side
        (and
         ; player's bottom side is under `obst`'s top side
         (>= (+ (obstacle-y player)
                (dimension-height (obstacle-dimension player))) 
             (obstacle-y obst))
         ; player's bottom side is above `obst`'s bottom side
         (<= (+ (obstacle-y player)
                (dimension-height (obstacle-dimension player)))
             (+ (obstacle-y obst)
                (dimension-height (obstacle-dimension obst)))))
        ; case where player's top side is between `obst`'s top side and `obst`'s bottom side
        (and
         ; player's top side is under `obst`'s top side
         (>= (obstacle-y player)
             (obstacle-y obst))
         ; player's top side is above `obst`'s bottom side 
         (<= (obstacle-y player)
             (+ (obstacle-y obst)
                (dimension-height (obstacle-dimension obst))))))))


; gstate-flat? GState -> Boolean
; returns #true if the player's image in `gstate` is perfectly straight or rotated by 90 or 180 or 270 degrees. otherwise, #false.
; header : (define (gstate-flat? gstate) #false)
; template :
; (define (gstate-flat? gstate) (or ...(obstacle-img (pstate-player (gstate-player-state gstate)))... (rotate 180 ...) ...))
(define (gstate-flat? gstate)
  (local
    (
     ; gstate-player-img : GState -> Image
     ; returns the image of the player in `gstate`
     ; header : (define (gstate-player-img gstate) BLUE-GUY-IMG)
     (define (gstate-player-img gstate)
       (obstacle-img (pstate-player (gstate-player-state gstate)))))

    (or
     ;case where player is blue
     (or (equal? (gstate-player-img gstate) BLUE-GUY-IMG)
         (equal? (gstate-player-img gstate) (rotate 180 BLUE-GUY-IMG)))
     (or (equal? (gstate-player-img gstate) BLUE-GUY-90-IMG)
         (equal? (gstate-player-img gstate) (rotate 180 BLUE-GUY-90-IMG)))
     ;case where player is red
     (or (equal? (gstate-player-img gstate) RED-GUY-IMG)
         (equal? (gstate-player-img gstate) (rotate 180 RED-GUY-IMG)))
     (or (equal? (gstate-player-img gstate) RED-GUY-90-IMG)
         (equal? (gstate-player-img gstate) (rotate 180 RED-GUY-90-IMG)))
     ;case where player is yellow
     (or (equal? (gstate-player-img gstate) YELLOW-GUY-IMG)
         (equal? (gstate-player-img gstate) (rotate 180 YELLOW-GUY-IMG)))
     (or (equal? (gstate-player-img gstate) YELLOW-GUY-90-IMG)
         (equal? (gstate-player-img gstate) (rotate 180 YELLOW-GUY-90-IMG))))))


; obstacle-on-top? : Obstacle Obstacle -> Boolean
; assumes that `player` and `obst` are touching.
; returns #true if player is on top of `obst`, #false if player is touching block in other places.
; header : (define (obstacle-on-top? player obst) #false)
; template :
; (define (obstacle-on-top? player obst) ...(obstacle-y player)... ...(obstacle-y obst)...)
(define (obstacle-on-top? player obst)
  (and
   ; bottom of player is between top of block and (top of block - JUMP-SPEED)
   (>= (+ (obstacle-y player)
          (dimension-height (obstacle-dimension player)))
       (obstacle-y obst))
   ; bottom of player is over (top of block - JUMP-SPEED)
   (<= (+ (obstacle-y player)
          (dimension-height (obstacle-dimension player)))
       (+ (obstacle-y obst) JUMP-SPEED))))


; gstate-touches-ground? GState -> Boolean
; returns #true if the player in `gstate` is touching the ground, otherwise #false 
; header : (define (gstate-touches-ground? gstate) #false)
; template :
; (define (gstate-touches-ground? gstate) ...(obstacle-on-top? (pstate-player (gstate-player-state gstate)) ...)...)
(define (gstate-touches-ground? gstate)
  ; check if player is on top of a block, among the obstacles that are touching the player
  (ormap
   (lambda (x) (obstacle-on-top? (pstate-player (gstate-player-state gstate)) x))
   ; list of all block obstacles that are touching the player
   (filter
    (lambda (x) (and (obstacle-block? x) (obstacle-touching? (pstate-player (gstate-player-state gstate)) x)))
    (level-obstacles (gstate-level gstate))))) 

; ========= MAIN FUNCTIONS ========= 

; ===== MOVE =====

; these functions make the level move and make the player jump / fall
 
; gstate-move-player : GState -> GState
; moves the player up or down if it's jumping or falling 
; header : (define (gstate-move-player gstate) gstate)
; template :
; (define (gstate-move-player gstate)
;  (cond ...(gstate-touches-ground? gstate)...(gstate-jump? gstate...) ...(jump gstate)...(fall gstate)...(rotate-player gstate)...)))
(define (gstate-move-player gstate)
  (local
    (
     ; rotate-player : GState -> GState
     ; returns a gstate with the player's image rotated by ROTATE-SPEED
     ; header : (define (rotate-player gstate) gstate)
     (define (rotate-player gstate)
       (gstate-set-field
        "player-state"
        gstate
        (pstate-set-field
         "player"
         (gstate-player-state gstate)
         (obstacle-set-field 
          "img"
          (pstate-player (gstate-player-state gstate))
          (rotate ROTATE-SPEED (obstacle-img (pstate-player (gstate-player-state gstate))))))))

     ; jump : GState -> GState
     ; moves the player up (for a jump) by JUMP-SPEED and rotates player
     ; header : (define (jump gstate) gstate)
     (define (jump gstate)
       (rotate-player
        (gstate-set-player-y gstate
                             (- (gstate-player-y gstate) JUMP-SPEED))))

     ; fall : GState -> GState
     ; moves the player down by JUMP-SPEED and rotates player
     ; header : (define (fall gstate) gstate)
     (define (fall gstate)
       (rotate-player
        (gstate-set-player-y gstate
                             (+ (gstate-player-y gstate) JUMP-SPEED)))))
    
    (cond
    [; if player is touching the ground and jump is not #true
     (and (gstate-touches-ground? gstate)
          (not (gstate-jump? gstate)))
     ; if it's in the middle of a rotation continue rotating until it's flat. If it's flat don't rotate
     (if (gstate-flat? gstate) gstate (rotate-player gstate))]
    ; when you reach maximum jumping height, field "jump" becomes #false and go down by JUMP-SPEED
    [(<= (gstate-player-y gstate) (- (pstate-jump-y (gstate-player-state gstate)) JUMP-HEIGHT))
     (gstate-set-jump (fall gstate) #false)]
    ; if player is in the air and jump = #true -> go up by JUMP-SPEED
    [(and
       (> (gstate-player-y gstate) (- (pstate-jump-y (gstate-player-state gstate)) JUMP-HEIGHT)) 
       (gstate-jump? gstate))
     (jump gstate)]
    ; if player is not touching the ground -> go down
    [else
     (fall gstate)])))


; move-obstacles List<Obstacles> -> List<Obstacles>
; moves each obstacle in `loo` to the left by LEVEL-SPEED 
; header : (define (move-obstacles loo) loo)
; template :
; (define (move-obstacles loo)
;  (cond [(empty? loo) ...]
;        [else ... (obstacle-set-x (first loo) ...) ... (move-obstacles (rest loo))...]))
(define (move-obstacles loo)
  (cond
    [(empty? loo) '()]
    [else
     (cons
      (obstacle-set-x (first loo)
                      (- (obstacle-x (first loo))
                         LEVEL-SPEED))
      (move-obstacles (rest loo)))]))


; ======= BIG BANG HANDLERS =======

; === These functions are called by the big-bang function


; ===== KEY HANDLER =====

; handle-key : GState KeyEvent -> GState
; returns a new GState according to the key pressed:
; - "q" -> quit game
; - " " -> jump or restart level if player is dead
; - "p" -> pause
; - "p" -> resume
; header : (define (handle-key gstate key) gstate)
; template :
; (define (handle-key gstate key)
; (cond [(string=? (gstate-menu gstate) MENU-LEVEL) ... (cond ... key ...)]
;       [(string=? (gstate-menu gstate) MENU-PAUSE) ... (cond ... key ...)]
;       [(string=? (gstate-menu gstate) MENU-YOU-DIED) ... (cond ... key ...)]
;       [(string=? (gstate-menu gstate) MENU-YOU-WON) ... (cond ... key ...)]
;       [(string=? (gstate-menu gstate) MENU-CHOOSE-LEVEL) ... (cond ... key ...)]
;       [(string=? (gstate-menu gstate) MENU-CHOOSE-PLAYER) ... (cond ... key ...)])) 
(define (handle-key gstate key)
  (cond
    ; everywhere: press q -> quit
    [(or(equal? key "q")(equal? key "Q"))
     (gstate-set-field "quit" gstate #true)]

    ; == if you are in welcome page ==
    [(string=? (gstate-menu gstate) MENU-WELCOME)
    (cond
      [(equal? key "\r") CHOOSE-PLAYER]
      [else gstate])]
    
    ; == if you are in a level ==
    [(string=? (gstate-menu gstate) MENU-LEVEL)
     (cond
       ; if you are touching the floor and press spacebar -> jump
       [(and (equal? key " ")
             (gstate-touches-ground? gstate))
        (gstate-set-jump
         (gstate-set-jump-y gstate (gstate-player-y gstate))
         #true)]
       ; if you press p -> pause
       [(or(equal? key "p")(equal? key "P"))
        ; sets the menu of `gstate` to the pause menu.
        ; the returned GState contains the information that the game has been paused.
        (gstate-set-field "menu" gstate MENU-PAUSE)]
       ; if you press esc -> choose level menu
       [(equal? key "escape")
        (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset gstate) LEVEL-1) MENU-CHOOSE-LEVEL)]
       [else gstate])]
    
    ; == if you are in you won menu ==
    [(string=? (gstate-menu gstate) MENU-YOU-WON) 
     (cond
       ; if you press space -> restart level
       [(equal? key " ") (gstate-restart-level gstate)]
       ; if you press esc -> choose level menu
       [(equal? key "escape")
        (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset gstate) LEVEL-1) MENU-CHOOSE-LEVEL)]
       [else gstate])]
    
    ; == if you are in you died menu ==
    [(string=? (gstate-menu gstate) MENU-YOU-DIED) 
     (cond
       ; if you press space -> restart level
       [(equal? key " ")
        (gstate-restart-level gstate)]
       ; if you press esc -> choose level menu
       [(equal? key "escape")
        (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset gstate) LEVEL-1) MENU-CHOOSE-LEVEL)]
       [else gstate])]
    
    ; == if you are in pause menu ==
    [(string=? (gstate-menu gstate) MENU-PAUSE)
     (cond
       ; if you press p -> resume game
       [(or(equal? key "p")(equal? key "P"))
        ; sets the menu of `gstate` to the level menu.
        ; the returned GState contains the information that the game has been resumed.
        (gstate-set-field "menu" gstate MENU-LEVEL)]
       ; if you press esc -> choose level menu
       [(equal? key "escape")
        (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset gstate) LEVEL-1) MENU-CHOOSE-LEVEL)]
       [else gstate])]
    
    ; == if you are in choose player menu ==
    [(string=? (gstate-menu gstate) MENU-CHOOSE-PLAYER)
     (cond
       ; if you press left or right arrow -> select player
       [(equal? key "left")
        (cond
          [(equal? (pstate-player (gstate-player-state gstate)) BLUE-GUY)
           (gstate-set-field "player-state" gstate (pstate-set-field "player" (gstate-player-state gstate) YELLOW-GUY))]
          [(equal? (pstate-player (gstate-player-state gstate)) RED-GUY)
           (gstate-set-field "player-state" gstate (pstate-set-field "player" (gstate-player-state gstate) BLUE-GUY))]
          [(equal? (pstate-player (gstate-player-state gstate)) YELLOW-GUY)
           (gstate-set-field "player-state" gstate (pstate-set-field "player" (gstate-player-state gstate) RED-GUY))])]
       [(equal? key "right")
        (cond
          [(equal? (pstate-player (gstate-player-state gstate)) BLUE-GUY)
           (gstate-set-field "player-state" gstate (pstate-set-field "player" (gstate-player-state gstate) RED-GUY))]
          [(equal? (pstate-player (gstate-player-state gstate)) RED-GUY)
           (gstate-set-field "player-state" gstate (pstate-set-field "player" (gstate-player-state gstate) YELLOW-GUY))]
          [(equal? (pstate-player (gstate-player-state gstate)) YELLOW-GUY)
           (gstate-set-field "player-state" gstate (pstate-set-field "player" (gstate-player-state gstate) BLUE-GUY))])]
       ; if you press enter -> choose level menu
       [(equal? key "\r")
        (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset gstate) LEVEL-1) MENU-CHOOSE-LEVEL)]
       ; if you press esc -> welcome page menu
       [(equal? key "escape") START-GAME]
       [else gstate])]
    
    ; == if you are in choose level menu ==
    [(string=? (gstate-menu gstate) MENU-CHOOSE-LEVEL)
     (cond
       ;if you press left or right arrow -> select level 
       [(equal? key "left")
        (cond
          [(equal? (gstate-level gstate) LEVEL-1)
           (gstate-set-field "level" gstate LEVEL-3)] 
          [(equal? (gstate-level gstate) LEVEL-2)
           (gstate-set-field "level" gstate LEVEL-1)]
          [(equal? (gstate-level gstate) LEVEL-3)
           (gstate-set-field "level" gstate LEVEL-2)])]
       [(equal? key "right")
        (cond
          [(equal? (gstate-level gstate) LEVEL-1)
           (gstate-set-field "level" gstate LEVEL-2)]
          [(equal? (gstate-level gstate) LEVEL-2)
           (gstate-set-field "level" gstate LEVEL-3)]
          [(equal? (gstate-level gstate) LEVEL-3)
           (gstate-set-field "level" gstate LEVEL-1)])]
       ; if you press enter -> start level
       [(equal? key "\r")
        (gstate-set-field "menu" gstate MENU-LEVEL)]
       ; if you press esc -> choose player menu
       [(equal? key "escape")
        (gstate-set-field "menu" (gstate-set-field "level" START-GAME #false) MENU-CHOOSE-PLAYER)]
       [else gstate])]
    [else gstate]))

 

; ===== DRAW =====
 
; draw-obstacles List<Obstacles> -> Image 
; Returns an Image with the obstacles that have to appear on the screen
; header : (define (draw-obstacles loo) BACKGROUND)
; template :
; (define (draw-obstacles loo)
;   (cond [(empty? loo) ...]
;         [(obstacle-in-frame? (first loo)) ...(obstacle-img (first loo))... (obstacle-x (frst loo))... (obstacle-y (first loo))... (draw-obstacles (rest loo))..]
;         [else ...(draw-obstacles (rest loo))...]))))
(define (draw-obstacles loo) 
  (cond
    [(empty? loo) BACKGROUND]
    ; if the x position of the obstacle is in the frame it can be drawn
    [(obstacle-in-frame? (first loo))
     (place-image (obstacle-img (first loo))
                  (obstacle-x (first loo))
                  (obstacle-y (first loo))
                  (draw-obstacles (rest loo)))] ; recursive call
    ; if the obstacle is not in the frame, don't draw it
    [else
     (draw-obstacles (rest loo))])) ; recursive call


; draw-choose-player : GState -> Image
; returns an Image representing the choice of the player in the choose-player-menu
; Remark : we assume that the menu of `gstate` is the choose-player menu
; header : (define (draw-choose-player gstate) CHOOSE-BLUE)
; template :
; (define (draw-choose-player gstate)
;  (cond
;    [(equal? (pstate-player (gstate-player-state gstate)) BLUE-GUY) ... CHOOSE-BLUE ...]
;    [(equal? (pstate-player (gstate-player-state gstate)) RED-GUY) ... CHOOSE-RED ...]
;    [(equal? (pstate-player (gstate-player-state gstate)) YELLOW-GUY) ... CHOOSE-YELLOW ...]))
(define (draw-choose-player gstate)
  (cond
    [(equal? (pstate-player (gstate-player-state gstate)) BLUE-GUY)
     CHOOSE-BLUE]
    [(equal? (pstate-player (gstate-player-state gstate)) RED-GUY)
     CHOOSE-RED]
    [(equal? (pstate-player (gstate-player-state gstate)) YELLOW-GUY)
     CHOOSE-YELLOW]))


; draw-choose-level : GState -> Image
; returns an Image representing the choice of the level in the choose-level-menu
; Remark : we assume that the menu of `gstate` is the choose-level menu
; header : (define (choose-level gstate) CHOOSE-LEVEL-1)
; template :
; (define (draw-choose-level gstate)
;  (cond
;    [(equal? (gstate-level gstate) LEVEL-1) ... CHOOSE-LEVEL-1...]
;    [(equal? (gstate-level gstate) LEVEL-2) ... CHOOSE-LEVEL-2...]
;    [(equal? (gstate-level gstate) LEVEL-3) ... CHOOSE-LEVEL-3...]))
(define (draw-choose-level gstate)
  (cond
    [(equal? (gstate-level gstate) LEVEL-1)
     CHOOSE-LEVEL-1]
    [(equal? (gstate-level gstate) LEVEL-2)
     CHOOSE-LEVEL-2]
    [(equal? (gstate-level gstate) LEVEL-3)
     CHOOSE-LEVEL-3]))


; draw : GState -> Image
; Draws an Image representing the current game state.
; header : (define (draw gstate) BACKGROUND)
; template :
; (define (draw gstate)
;  (cond [(string=? (gstate-menu gstate) MENU-CHOOSE-PLAYER) ...]
;        [(string=? (gstate-menu gstate) MENU-CHOOSE-LEVEL) ...]
;        [(string=? (gstate-menu gstate) MENU-LEVEL)) ...(draw-level gstate)...]
;        [(string=? (gstate-menu gstate) MENU-YOU-DIED) ...]
;        [(string=? (gstate-menu gstate) MENU-YOU-WON) ...]
;        [(string=? (gstate-menu gstate) MENU-PAUSE) ...]))
(define (draw gstate)
  (local
    (
     ; draw-level : GState -> Image
     ; Returns an Image of the level in `gstate` (character, obstacles and background)
     ; header : (define (draw-level gstate) BACKGROUND)
     (define (draw-level gstate)
       (place-image
        (obstacle-img (pstate-player (gstate-player-state gstate)))
        (gstate-player-x gstate)
        (gstate-player-y gstate)
        (draw-obstacles (level-obstacles (gstate-level gstate)))))

     ; text-top-sub  : String String Image -> Image
     ; returns `background` with the text `top` in top-text style and `sub` in sub-text style
     ; header : (define (text-top-sub top sub background) background)
     (define (text-top-sub top sub background)
       (place-image
        (text top TOP-TEXT-SIZE TOP-TEXT-COLOR)
        TOP-TEXT-X
        TOP-TEXT-Y
        (place-image
         (text sub SUB-TEXT-SIZE SUB-TEXT-COLOR)
         SUB-TEXT-X
         SUB-TEXT-Y
         background))))

    (cond
      ; if you are in menu welcome page
      [(string=? (gstate-menu gstate) MENU-WELCOME)
       WELCOME-PAGE]
      ; if you are in menu choose player
      [(string=? (gstate-menu gstate) MENU-CHOOSE-PLAYER)
       (draw-choose-player gstate)]
      ; if you are in menu choose level 
      [(string=? (gstate-menu gstate) MENU-CHOOSE-LEVEL)
       (draw-choose-level gstate)]
      ; if you are in a level
      [(string=? (gstate-menu gstate) MENU-LEVEL)
       (draw-level gstate)]
      ; if you are in menu you died
      [(string=? (gstate-menu gstate) MENU-YOU-DIED)
       (text-top-sub "YOU DIED" "press SPACE to restart" (draw-level gstate))]
      ; if you are in menu you won
      [(string=? (gstate-menu gstate) MENU-YOU-WON)
       (text-top-sub "YOU WON" "press SPACE to restart, ESC to change level" (draw-level gstate))]
      ; if you are in menu pause
      [(string=? (gstate-menu gstate) MENU-PAUSE)
       (text-top-sub "PAUSE" "press p to resume, ESC to change level" (draw-level gstate))])))





; ===== TICK =====

; move-level : GState -> GState
; sets gstate accordingly if player dies or win, otherwise moves the level
; header: (define (move-level gstate) gstate)
; template :
; (define (move-level gstate)
;   ...(obstacles-touching? ...)...(obstacle-on-top?...)...(gstate-set-dead gstate)... (gstate-set-won gstate)... (gstate-move-player gstate)... (move-obstacles ...)...)
(define (move-level gstate)
  (local (
          ; move : GState -> GState
          ; moves the components in `gstate` accordingly: obstacles move right to left,
          ; the player jumps or falls
          ; header (define (move gstate) gstate)
          (define (move gstate)
            (gstate-move-player
             (gstate-set-field "level"
                               gstate
                               (make-level (level-number (gstate-level gstate))
                                           (move-obstacles (level-obstacles (gstate-level gstate)))))))

          ; Obstacle representing the player
          (define PLAYER (pstate-player (gstate-player-state gstate)))
          ; list of all the obstacles that are touching the player
          (define TOUCHING-OBSTACLES
            (filter
             (lambda (x) (obstacle-touching? PLAYER x))
             (level-obstacles (gstate-level gstate))))
          ; determines if blades are touching the player
          (define TOUCHING-BLADES?
            (ormap
             (lambda (x)
               ; Obstacle -> Boolean
               ; returns #true if `x` is a blade, otherwise #false
               (string=? (obstacle-type x) OBSTACLE-TYPE-BLADE))
             TOUCHING-OBSTACLES))
          ; determines if a winning-block is touching the player
          (define TOUCHING-WIN-BLOCKS?
            (ormap
             (lambda (x)
               ; Obstacle -> Boolean
               ; returns #true if `x` is a win block, otherwise #false
               (string=? (obstacle-type x) OBSTACLE-TYPE-WIN-BLOCK))
             TOUCHING-OBSTACLES))
          ; list of the blocks that are touching the player
          (define TOUCHING-BLOCKS 
            (filter
             (lambda (x) (obstacle-block? x))
             TOUCHING-OBSTACLES))
          ; list of the blocks that the player is standing on
          (define GROUND-BLOCKS
            (filter
             (lambda (x) (obstacle-on-top? PLAYER x))
             TOUCHING-BLOCKS))
          ; determines is the player has crashed on a block
          (define CRASHED-BLOCKS?
            (ormap
             (lambda (x) (not (obstacle-on-top? PLAYER x)))
             TOUCHING-BLOCKS))
          )
   
    (cond
      ; player is touching win-block -> win
      [TOUCHING-WIN-BLOCKS?
       ; set the menu of `gstate` to the you-won menu.
       ;contains the information that the player has won.
       (gstate-set-field "menu" gstate MENU-YOU-WON)]
      
      ; cases where the player should die
      [(or
        ; player is touching a blade -> die
        TOUCHING-BLADES?
        ; player has crashed on a block -> die
        CRASHED-BLOCKS?
        ; player fell out of screen -> die
        (not (obstacle-in-frame? (pstate-player (gstate-player-state gstate)))))
       
       ; sets the menu of `gstate` to the you-died menu.
       ; contains the information that the player is dead.
       (gstate-set-field "menu" gstate MENU-YOU-DIED)]
   
      ; player is standing on a block -> move AND set y of player as top of the block to avoid imperfections
      [(cons? GROUND-BLOCKS)
       (move
        (gstate-set-player-y gstate
                      (- (obstacle-y (first GROUND-BLOCKS))
                         PLAYER-HEIGHT)))] 
      [else
       (move gstate)])))

; tick : GState -> Gstate
; decides what to do on tick:
; if you are in a level, move the character, check for collisions
; header : (define (tick gstate) gstate)
; template :
; (define (tick gstate)
;  (cond
;    [(string=? (gstate-menu gstate) MENU-LEVEL) ... (move-level gstate)]
;    [else ...gstate...]))
(define (tick gstate)
  (cond
    ; if you are in a level
    [(string=? (gstate-menu gstate) MENU-LEVEL) 
     (move-level gstate)]
    [else
     gstate]))


; ======== START FUNCTION =========

; start: Gstate -> Gstate
; Main function that starts the game
; call (start START-GAME) to start the game
; header : (define (start gstate) gstate)
; template
; (define (start gstate)
;  (big-bang gstate)
;   [on-tick ...]
;   [to-draw ...]
;   [on-key ...]
;   [stop-when ...]))
(define (start gstate)
  (big-bang gstate
    [on-tick tick]
    [to-draw draw]
    [on-key handle-key]
    [stop-when gstate-quit?]))

; Auto start
(start START-GAME)

