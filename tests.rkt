;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname tests) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
(require racket/base)

(require "datatypes.rkt")
(require "levels.rkt")
(require "main.rkt")

; THIS FILE INCLUDES ALL TESTS TO ALL FUNCTIONS

; ======= 1. constant definitons =======
; === constants used in some of the following tests === 

; Images
(define IMAGE-TEST-1 (square 20 "solid" "black"))
(define IMAGE-TEST-2 (rotate ROTATE-SPEED BLUE-GUY-IMG))
(define IMAGE-TEST-3 (rotate ROTATE-SPEED RED-GUY-IMG))
(define IMAGE-TEST-4 (rotate ROTATE-SPEED YELLOW-GUY-IMG))

; Obstacles
(define BLOCK-TEST-1 (make-obstacle OBSTACLE-TYPE-BLOCK
                                    IMAGE-TEST-1
                                    (make-posn 50 50)
                                    (make-dimension 20 20)))
(define BLOCK-TEST-2 (make-obstacle OBSTACLE-TYPE-BLOCK
                                    IMAGE-TEST-1
                                    (make-posn 25 40)
                                    (make-dimension 30 30)))
(define BLOCK-TEST-3 (make-obstacle OBSTACLE-TYPE-BLOCK
                                    IMAGE-TEST-1
                                    (make-posn 200 200)
                                    (make-dimension 20 20)))
(define BLOCK-TEST-4 (make-obstacle OBSTACLE-TYPE-BLOCK BLUE-GUY-IMG (make-posn 600 600) (make-dimension 20 20)))
(define BLOCK-TEST-5 (make-obstacle OBSTACLE-TYPE-BLOCK BLUE-GUY-IMG (make-posn 21 21) (make-dimension 20 20)))
(define BLOCK-TEST-6 (make-obstacle OBSTACLE-TYPE-BLOCK BLUE-GUY-IMG (make-posn 52 76) (make-dimension 20 20)))

(define BLOCK-TEST-7 (make-obstacle OBSTACLE-TYPE-BLOCK BLUE-GUY-IMG (make-posn 10000 10000) (make-dimension 20 20)))
(define BLOCK-TEST-8 (make-obstacle OBSTACLE-TYPE-BLOCK BLUE-GUY-IMG (make-posn 20000 20000) (make-dimension 20 20)))
(define BLOCK-TEST-9 (make-obstacle OBSTACLE-TYPE-BLOCK BLUE-GUY-IMG (make-posn 30000 30000) (make-dimension 20 20)))
(define BLOCK-TEST-10 (make-obstacle OBSTACLE-TYPE-BLOCK BLUE-GUY-IMG (make-posn 230 200) (make-dimension 30 30)))
(define BLOCK-TEST-11 (make-obstacle OBSTACLE-TYPE-BLOCK BLUE-GUY-IMG (make-posn 198 (+ 200 PLAYER-HEIGHT)) (make-dimension 30 30)))

(define WIN-BLOCK-TEST-1 (make-obstacle OBSTACLE-TYPE-WIN-BLOCK BLUE-GUY-IMG (make-posn 230 200) (make-dimension 30 30)))

(define BLADE-TEST-1 (make-obstacle OBSTACLE-TYPE-BLADE
                                    IMAGE-TEST-1
                                    (make-posn 12 13)
                                    (make-dimension 1 6)))
(define BLADE-TEST-2 (make-obstacle OBSTACLE-TYPE-BLADE BLUE-GUY-IMG (make-posn 230 200) (make-dimension 30 30)))

; Players
(define PLAYER-TEST-1 (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                     IMAGE-TEST-1
                                     (make-posn 180 180)
                                     (make-dimension 20 20)))
(define PLAYER-TEST-2 (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                     IMAGE-TEST-1
                                     (make-posn 100 100)
                                     (make-dimension 20 20)))
(define PLAYER-TEST-3 (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                     IMAGE-TEST-1
                                     (make-posn 40 40)
                                     (make-dimension 20 20)))
(define PLAYER-TEST-4 (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                     IMAGE-TEST-1
                                     (make-posn 10 10)
                                     (make-dimension 20 20)))
(define PLAYER-TEST-5 (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                     (rotate ROTATE-SPEED IMAGE-TEST-1)
                                     (make-posn 180 (- 180 JUMP-SPEED))
                                     (make-dimension 20 20)))

(define PLAYER-TEST-6 (make-obstacle OBSTACLE-TYPE-PLAYER-RED RED-GUY-IMG (make-posn 600 511) (make-dimension 70 PLAYER-HEIGHT)))
(define PLAYER-TEST-7 (make-obstacle OBSTACLE-TYPE-PLAYER-RED (rotate (* -1 ROTATE-SPEED) RED-GUY-IMG) (make-posn 600 511) (make-dimension 70 PLAYER-HEIGHT)))
(define PLAYER-TEST-8 (make-obstacle OBSTACLE-TYPE-PLAYER-RED RED-GUY-IMG (make-posn 600 (- 600 JUMP-HEIGHT)) (make-dimension 70 PLAYER-HEIGHT)))
(define PLAYER-TEST-9 (make-obstacle OBSTACLE-TYPE-PLAYER-RED (rotate ROTATE-SPEED RED-GUY-IMG) (make-posn 600 (+ (- 600 JUMP-HEIGHT) JUMP-SPEED)) (make-dimension 70 PLAYER-HEIGHT)))
(define PLAYER-TEST-10 (make-obstacle OBSTACLE-TYPE-PLAYER-RED RED-GUY-IMG (make-posn 400 400) (make-dimension 30 67)))
(define PLAYER-TEST-11 (make-obstacle OBSTACLE-TYPE-PLAYER-RED RED-GUY-IMG (make-posn 200 200) (make-dimension 30 PLAYER-HEIGHT)))
(define PLAYER-TEST-12 (make-obstacle OBSTACLE-TYPE-PLAYER-RED RED-GUY-IMG (make-posn 200 200) (make-dimension 30 30)))
(define PLAYER-TEST-13 (make-obstacle OBSTACLE-TYPE-PLAYER-RED RED-GUY-IMG (make-posn 200 (+ SCREEN-HEIGHT PLAYER-HEIGHT)) (make-dimension 30 30)))

; PState
(define PSTATE-TEST-1 (make-pstate PLAYER-TEST-1 #true 111))
(define PSTATE-TEST-2 (make-pstate PLAYER-TEST-2 #false 111))
(define PSTATE-TEST-3 (make-pstate PLAYER-TEST-2 #true 111))
(define PSTATE-TEST-4 (make-pstate PLAYER-TEST-1 #false 111))
(define PSTATE-TEST-5 (make-pstate BLUE-GUY #false 26))
(define PSTATE-TEST-6 (make-pstate RED-GUY #true 28))
(define PSTATE-TEST-7 (make-pstate YELLOW-GUY #true 28))
(define PSTATE-TEST-8 (make-pstate PLAYER-TEST-4 #true 28))
(define PSTATE-TEST-9 (make-pstate PLAYER-TEST-5 #true 111))
(define PSTATE-TEST-10 (make-pstate PLAYER-TEST-6 #false 21)) 
(define PSTATE-TEST-11 (make-pstate PLAYER-TEST-6 #true 600))
(define PSTATE-TEST-12 (make-pstate PLAYER-TEST-6 #false 600))
(define PSTATE-TEST-13 (make-pstate PLAYER-TEST-7 #false 600))
(define PSTATE-TEST-14 (make-pstate PLAYER-TEST-8 #true 600))
(define PSTATE-TEST-15 (make-pstate PLAYER-TEST-9 #false 600))
(define PSTATE-TEST-16 (make-pstate PLAYER-TEST-10 #false 20))
(define PSTATE-TEST-17 (make-pstate PLAYER-TEST-11 #false 170))
(define PSTATE-TEST-18 (make-pstate PLAYER-TEST-12 #true 170))
(define PSTATE-TEST-19 (make-pstate PLAYER-TEST-13 #true 170))

; Levels
(define LEVEL-TEST-1 (make-level 1 '()))
(define LEVEL-TEST-2 (make-level 2 (list BLOCK-TEST-1 BLADE-TEST-1)))
(define LEVEL-TEST-3 (make-level 3 (list BLOCK-TEST-1)))
(define LEVEL-TEST-4 (make-level 37 '()))
(define LEVEL-TEST-5 (make-level 3 (list BLOCK-TEST-1 BLOCK-TEST-3)))
(define LEVEL-TEST-6 (make-level 3 (list BLOCK-TEST-6)))

; GState
(define GSTATE-TEST-1 (make-gstate PSTATE-TEST-1
                                   MENU-YOU-WON
                                   LEVEL-TEST-1
                                   #false))
(define GSTATE-TEST-2 (make-gstate PSTATE-TEST-2
                                   MENU-YOU-WON
                                   LEVEL-TEST-1
                                   #true))
(define GSTATE-TEST-3 (make-gstate PSTATE-TEST-2       
                                   MENU-YOU-DIED
                                   LEVEL-TEST-1
                                   #true))
(define GSTATE-TEST-4 (make-gstate PSTATE-TEST-4
                                   MENU-YOU-WON
                                   LEVEL-TEST-1
                                   #false))
(define GSTATE-TEST-5 (make-gstate PSTATE-TEST-5      
                                   MENU-YOU-DIED
                                   LEVEL-TEST-2
                                   #true))
(define GSTATE-TEST-6 (make-gstate PSTATE-TEST-6     
                                   MENU-YOU-DIED
                                   LEVEL-TEST-3
                                   #true))
(define GSTATE-TEST-7 (make-gstate PSTATE-TEST-7      
                                   MENU-YOU-DIED
                                   LEVEL-TEST-4
                                   #true))
(define GSTATE-TEST-8 (make-gstate PSTATE-TEST-1
                                   MENU-YOU-WON
                                   LEVEL-TEST-5
                                   #false))
(define GSTATE-TEST-9 (make-gstate PSTATE-TEST-2
                                   MENU-YOU-WON
                                   LEVEL-TEST-5
                                   #false))
(define GSTATE-TEST-10 (make-gstate PSTATE-TEST-8
                                    MENU-YOU-WON
                                    LEVEL-TEST-5
                                    #false))
(define GSTATE-TEST-11 (make-gstate PSTATE-TEST-2 MENU-LEVEL (make-level 2 '()) #true))
(define GSTATE-TEST-11.1 (make-gstate PSTATE-TEST-2 MENU-PAUSE (make-level 2 '()) #true))
(define GSTATE-TEST-12 (make-gstate PSTATE-TEST-5 MENU-LEVEL LEVEL-1 #true))
(define GSTATE-TEST-13 (make-gstate PSTATE-TEST-6 MENU-LEVEL LEVEL-2 #true))
(define GSTATE-TEST-14 (make-gstate PSTATE-TEST-7 MENU-LEVEL LEVEL-3 #true))
(define GSTATE-TEST-15 (make-gstate INITIAL-PSTATE MENU-LEVEL LEVEL-2 #false))
(define GSTATE-TEST-16
  (gstate-set-field "player-state"
                    GSTATE-TEST-15
                    (pstate-set-field "player"
                                      (gstate-player-state GSTATE-TEST-15)
                                      (obstacle-set-field "type"
                                                          (pstate-player (gstate-player-state GSTATE-TEST-15))
                                                          OBSTACLE-TYPE-PLAYER-RED))))
(define GSTATE-TEST-17
  (gstate-set-field "player-state"
                    GSTATE-TEST-15
                    (pstate-set-field "player"
                                      (gstate-player-state GSTATE-TEST-15)
                                      (obstacle-set-field "type"
                                                          (pstate-player (gstate-player-state GSTATE-TEST-15))
                                                          OBSTACLE-TYPE-PLAYER-YELLOW))))
(define GSTATE-TEST-18 (make-gstate PSTATE-TEST-10 MENU-LEVEL (make-level 2 (list BLOCK-TEST-5)) #false))
(define GSTATE-TEST-19 (make-gstate PSTATE-TEST-10 MENU-LEVEL (make-level 2 (list BLOCK-TEST-5 BLOCK-TEST-4)) #false))
(define GSTATE-TEST-20 (make-gstate PSTATE-TEST-11 MENU-LEVEL (make-level 2 (list BLOCK-TEST-5 BLOCK-TEST-4)) #false))
(define GSTATE-TEST-21 (make-gstate PSTATE-TEST-13 MENU-LEVEL (make-level 2 (list BLOCK-TEST-5 BLOCK-TEST-4)) #false))
(define GSTATE-TEST-22 (make-gstate PSTATE-TEST-12 MENU-LEVEL (make-level 2 (list BLOCK-TEST-5 BLOCK-TEST-4)) #false))
(define GSTATE-TEST-23 (make-gstate PSTATE-TEST-14 MENU-LEVEL (make-level 2 '()) #false))
(define GSTATE-TEST-24 (make-gstate PSTATE-TEST-15 MENU-LEVEL (make-level 2 '()) #false))
(define GSTATE-TEST-25 (make-gstate PSTATE-TEST-18 MENU-LEVEL (make-level 0 '()) #false))
(define GSTATE-TEST-26 (make-gstate PSTATE-TEST-18 MENU-LEVEL (make-level 0 (list BLADE-TEST-2)) #false))
(define GSTATE-TEST-27 (make-gstate PSTATE-TEST-18 MENU-LEVEL (make-level 0 (list BLOCK-TEST-10)) #false))
(define GSTATE-TEST-28 (make-gstate PSTATE-TEST-19 MENU-LEVEL (make-level 0 (list BLOCK-TEST-10)) #false))
(define GSTATE-TEST-29 (make-gstate PSTATE-TEST-18 MENU-LEVEL (make-level 0 (list WIN-BLOCK-TEST-1)) #false))
(define GSTATE-TEST-30 (make-gstate PSTATE-TEST-17 MENU-LEVEL (make-level 0 (list BLOCK-TEST-11)) #false))
(define GSTATE-TEST-31 (make-gstate (make-pstate BLUE-GUY #false 90) MENU-CHOOSE-PLAYER LEVEL-1 #false))
(define GSTATE-TEST-32 (make-gstate (make-pstate RED-GUY #false 90) MENU-CHOOSE-PLAYER LEVEL-1 #false))
(define GSTATE-TEST-33 (make-gstate (make-pstate YELLOW-GUY #false 90) MENU-CHOOSE-PLAYER LEVEL-1 #false))
(define GSTATE-TEST-34 (make-gstate (make-pstate BLUE-GUY #false 90) MENU-CHOOSE-LEVEL LEVEL-1 #false))
(define GSTATE-TEST-35 (make-gstate (make-pstate BLUE-GUY #false 90) MENU-CHOOSE-LEVEL LEVEL-2 #false))
(define GSTATE-TEST-36 (make-gstate (make-pstate BLUE-GUY #false 90) MENU-CHOOSE-LEVEL LEVEL-3 #false))
(define GSTATE-TEST-37 (make-gstate (make-pstate BLUE-GUY #false 90) "wrong menu" LEVEL-3 #false))
(define GSTATE-TEST-38 (make-gstate INITIAL-PSTATE MENU-WELCOME LEVEL-1 #false))
(define GSTATE-TEST-39 (make-gstate INITIAL-PSTATE MENU-YOU-WON LEVEL-1 #false))

; ======= 2. tests for file "main.rkt" =======

; ===== GETTERS =====

; obstacle-x examples
(check-expect (obstacle-x BLADE) (posn-x (obstacle-position BLADE)))
(check-expect (obstacle-x BLOCK) (posn-x (obstacle-position BLOCK)))
(check-expect (obstacle-x WIN-BLOCK) (posn-x (obstacle-position WIN-BLOCK)))
(check-expect (obstacle-x BLOCK-TEST-1) 50)
(check-expect (obstacle-x BLADE-TEST-1) 12)

; obstacle-y examples
(check-expect (obstacle-y BLADE) (posn-y (obstacle-position BLADE)))
(check-expect (obstacle-y BLOCK) (posn-y (obstacle-position BLOCK)))
(check-expect (obstacle-y WIN-BLOCK) (posn-y (obstacle-position WIN-BLOCK)))
(check-expect (obstacle-y BLOCK-TEST-1) 50)
(check-expect (obstacle-y BLADE-TEST-1) 13)

; gstate-quit? examples
(check-expect (gstate-quit? START-GAME) #false)
(check-expect (gstate-quit? GSTATE-TEST-1) #false)
(check-expect (gstate-quit? GSTATE-TEST-2) #true)

; gstate-jump? examples
(check-expect (gstate-jump? START-GAME) (pstate-jump (gstate-player-state START-GAME)))
(check-expect (gstate-jump? GSTATE-TEST-1) #true)
(check-expect (gstate-jump? GSTATE-TEST-2) #false)

; gstate-player-x examples
(check-expect (gstate-player-x START-GAME) (posn-x (obstacle-position (pstate-player (gstate-player-state START-GAME)))))
(check-expect (gstate-player-x GSTATE-TEST-1) 180)
(check-expect (gstate-player-x GSTATE-TEST-2) 100)

; gstate-player-y examples
(check-expect (gstate-player-y START-GAME) (posn-y (obstacle-position (pstate-player (gstate-player-state START-GAME)))))
(check-expect (gstate-player-y GSTATE-TEST-1) 180)
(check-expect (gstate-player-y GSTATE-TEST-2) 100)


; ===== SETTERS =====

; obstacle-set-field examples
(check-expect (obstacle-set-field "type" BLUE-GUY OBSTACLE-TYPE-PLAYER-BLUE) BLUE-GUY)
(check-expect (obstacle-set-field "type" BLUE-GUY OBSTACLE-TYPE-BLADE)
              (make-obstacle OBSTACLE-TYPE-BLADE
                             (obstacle-img BLUE-GUY)
                             (obstacle-position BLUE-GUY)
                             (obstacle-dimension BLUE-GUY)))

(check-expect (obstacle-set-field "img" RED-GUY IMAGE-TEST-1)
              (make-obstacle "player-red"
                             IMAGE-TEST-1
                             (obstacle-position RED-GUY)
                             (obstacle-dimension RED-GUY)))

(check-expect (obstacle-set-field "position" RED-GUY (make-posn 11 11))
              (make-obstacle (obstacle-type RED-GUY)
                             (obstacle-img RED-GUY)
                             (make-posn 11 11)
                             (obstacle-dimension RED-GUY)))

(check-expect (obstacle-set-field "dimension" YELLOW-GUY (make-dimension 12 34))
              (make-obstacle (obstacle-type YELLOW-GUY)
                             (obstacle-img YELLOW-GUY)
                             (obstacle-position YELLOW-GUY)
                             (make-dimension 12 34)))

; obstacle-set-x examples
(check-expect (obstacle-set-x BLUE-GUY 88)
              (make-obstacle (obstacle-type BLUE-GUY)
                             (obstacle-img BLUE-GUY)
                             (make-posn 88 (posn-y (obstacle-position BLUE-GUY)))
                             (obstacle-dimension BLUE-GUY)))

(check-expect (obstacle-set-x BLUE-GUY 79)
              (make-obstacle (obstacle-type BLUE-GUY)
                             (obstacle-img BLUE-GUY)
                             (make-posn 79 (posn-y (obstacle-position BLUE-GUY)))
                             (obstacle-dimension BLUE-GUY)))

(check-expect (obstacle-set-x BLADE 31)
              (make-obstacle (obstacle-type BLADE)
                             (obstacle-img BLADE)
                             (make-posn 31 (posn-y (obstacle-position BLADE)))
                             (obstacle-dimension BLADE)))

(check-expect (obstacle-set-x BLOCK 53)
              (make-obstacle (obstacle-type BLOCK)
                             (obstacle-img BLOCK)
                             (make-posn 53 (posn-y (obstacle-position BLOCK)))
                             (obstacle-dimension BLOCK)))

; pstate-set-field examples
(check-expect (pstate-set-field "player" INITIAL-PSTATE BLUE-GUY)
              (make-pstate BLUE-GUY
                           (pstate-jump INITIAL-PSTATE)
                           (pstate-jump-y INITIAL-PSTATE)))

(check-expect (pstate-set-field "player" PSTATE-TEST-1 RED-GUY)
              (make-pstate RED-GUY #true 111))

(check-expect (pstate-set-field "jump" INITIAL-PSTATE #true)
              (make-pstate (pstate-player INITIAL-PSTATE)
                           #true
                           (pstate-jump-y INITIAL-PSTATE)))

(check-expect (pstate-set-field "jump" PSTATE-TEST-1 #false)
              (make-pstate PLAYER-TEST-1 #false 111))

(check-expect (pstate-set-field "jump" PSTATE-TEST-1 #true) PSTATE-TEST-1)
(check-expect (pstate-set-field "jump-y" PSTATE-TEST-1 22)
              (make-pstate PLAYER-TEST-1 #true 22))

(check-expect (pstate-set-field "jump-y" PSTATE-TEST-1 -33)
              (make-pstate PLAYER-TEST-1 #true -33))

; gstate-set-field examples
(check-expect (gstate-set-field "player-state" START-GAME PSTATE-TEST-1)
              (make-gstate PSTATE-TEST-1
                           (gstate-menu START-GAME)
                           (gstate-level START-GAME)
                           (gstate-quit START-GAME)))

(check-expect (gstate-set-field "player-state" START-GAME PSTATE-TEST-2)
              (make-gstate PSTATE-TEST-2
                           (gstate-menu START-GAME)
                           (gstate-level START-GAME)
                           (gstate-quit START-GAME)))

(check-expect (gstate-set-field "player-state" GSTATE-TEST-1 PSTATE-TEST-1) GSTATE-TEST-1)
(check-expect (gstate-set-field "menu" START-GAME MENU-LEVEL)
              (make-gstate (gstate-player-state START-GAME)
                           MENU-LEVEL
                           (gstate-level START-GAME)
                           (gstate-quit START-GAME)))

(check-expect (gstate-set-field "menu" GSTATE-TEST-1 MENU-YOU-WON)
              (make-gstate (gstate-player-state GSTATE-TEST-1)
                           MENU-YOU-WON
                           LEVEL-TEST-1
                           #false))

(check-expect (gstate-set-field "level" START-GAME LEVEL-TEST-1)
              (make-gstate (gstate-player-state START-GAME)
                           (gstate-menu START-GAME)
                           LEVEL-TEST-1
                           (gstate-quit START-GAME)))

(check-expect (gstate-set-field "level" GSTATE-TEST-1 LEVEL-TEST-2)
              (make-gstate (gstate-player-state GSTATE-TEST-1)
                           (gstate-menu GSTATE-TEST-1)
                           LEVEL-TEST-2
                           (gstate-quit GSTATE-TEST-1)))

(check-expect (gstate-set-field "quit" START-GAME #true)
              (make-gstate (gstate-player-state START-GAME)
                           (gstate-menu START-GAME)
                           (gstate-level START-GAME)
                           #true))

(check-expect (gstate-set-field "quit" GSTATE-TEST-1 #false) GSTATE-TEST-1)
(check-expect (gstate-set-field "quit" GSTATE-TEST-1 #true)
              (make-gstate (gstate-player-state GSTATE-TEST-1)
                           (gstate-menu GSTATE-TEST-1)
                           (gstate-level GSTATE-TEST-1)
                           #true))


; gstate-set-jump
(check-expect (gstate-set-jump START-GAME #false) START-GAME)
(check-expect (gstate-set-jump GSTATE-TEST-1 #true) GSTATE-TEST-1)
(check-expect (gstate-set-jump GSTATE-TEST-1 #false) GSTATE-TEST-4)
(check-expect (gstate-set-jump GSTATE-TEST-2 #true)
              (make-gstate PSTATE-TEST-3
                           (gstate-menu GSTATE-TEST-2)
                           (gstate-level GSTATE-TEST-2)
                           (gstate-quit GSTATE-TEST-2)))

; gstate-set-jump-y
(check-expect (gstate-set-jump-y GSTATE-TEST-1 88)
              (make-gstate (make-pstate
                            (pstate-player PSTATE-TEST-1)
                            (pstate-jump PSTATE-TEST-1)
                            88)
                           (gstate-menu GSTATE-TEST-1)
                           (gstate-level GSTATE-TEST-1)
                           (gstate-quit GSTATE-TEST-1)))

(check-expect (gstate-set-jump-y GSTATE-TEST-1 96)
              (make-gstate (make-pstate
                            (pstate-player PSTATE-TEST-1)
                            (pstate-jump PSTATE-TEST-1)
                            96)
                           (gstate-menu GSTATE-TEST-1)
                           (gstate-level GSTATE-TEST-1)
                           (gstate-quit GSTATE-TEST-1)))

(check-expect (gstate-set-jump-y GSTATE-TEST-2 11)
              (make-gstate (make-pstate
                            (pstate-player PSTATE-TEST-2)
                            (pstate-jump PSTATE-TEST-2)
                            11)
                           (gstate-menu GSTATE-TEST-2)
                           (gstate-level GSTATE-TEST-2)
                           (gstate-quit GSTATE-TEST-2)))
(check-expect (gstate-set-jump-y GSTATE-TEST-2 111) GSTATE-TEST-2)

; gstate-set-player-y examples
(check-expect (gstate-set-player-y GSTATE-TEST-1 50)
              (make-gstate (make-pstate
                            (make-obstacle
                             (obstacle-type PLAYER-TEST-1)
                             (obstacle-img PLAYER-TEST-1)
                             (make-posn (obstacle-x PLAYER-TEST-1)
                                        50)
                             (obstacle-dimension PLAYER-TEST-1))
                            (pstate-jump PSTATE-TEST-1)
                            (pstate-jump-y PSTATE-TEST-1))
                           (gstate-menu GSTATE-TEST-1)
                           (gstate-level GSTATE-TEST-1)
                           (gstate-quit GSTATE-TEST-1)))

(check-expect (gstate-set-player-y GSTATE-TEST-1 76)
              (make-gstate (make-pstate
                            (make-obstacle
                             (obstacle-type PLAYER-TEST-1)
                             (obstacle-img PLAYER-TEST-1)
                             (make-posn (obstacle-x PLAYER-TEST-1)
                                        76)
                             (obstacle-dimension PLAYER-TEST-1))
                            (pstate-jump PSTATE-TEST-1)
                            (pstate-jump-y PSTATE-TEST-1))
                           (gstate-menu GSTATE-TEST-1)
                           (gstate-level GSTATE-TEST-1)
                           (gstate-quit GSTATE-TEST-1)))

(check-expect (gstate-set-player-y GSTATE-TEST-1 180) GSTATE-TEST-1)
(check-expect (gstate-set-player-y GSTATE-TEST-2 15)
              (make-gstate (make-pstate
                            (make-obstacle
                             (obstacle-type PLAYER-TEST-2)
                             (obstacle-img PLAYER-TEST-2)
                             (make-posn (obstacle-x PLAYER-TEST-2)
                                        15)
                             (obstacle-dimension PLAYER-TEST-2))
                            (pstate-jump PSTATE-TEST-2)
                            (pstate-jump-y PSTATE-TEST-2))
                           (gstate-menu GSTATE-TEST-2)
                           (gstate-level GSTATE-TEST-2)
                           (gstate-quit GSTATE-TEST-2)))

; ===== HELPER =====

; obstacle-block? examples
(check-expect (obstacle-block? BLUE-GUY) #false)
(check-expect (obstacle-block? BLOCK) #true)
(check-expect (obstacle-block? WIN-BLOCK) #false)
(check-expect (obstacle-block? PLAYER-TEST-1) #false)
(check-expect (obstacle-block? BLOCK-TEST-1) #true)

; gstate-pstate-reset examples
(check-expect
 (gstate-pstate-reset
  ;put blue guy picture rotated in GSTATE-TEST-15 and moved obstacle position
  (gstate-set-field "player-state"
                    GSTATE-TEST-15
                    (pstate-set-field "player"
                                      (gstate-player-state GSTATE-TEST-15)
                                      (obstacle-set-field "img"
                                                          (obstacle-set-field "position"
                                                                              (pstate-player (gstate-player-state GSTATE-TEST-15))
                                                                              (make-posn 33 3782))
                                                          (rotate 13 BLUE-GUY-IMG)))))
 ; expect GSTATE-TEST-15 with blue guy picture
 (gstate-set-field "player-state"
                   GSTATE-TEST-15
                   (pstate-set-field "player"
                                     (gstate-player-state GSTATE-TEST-15)
                                     (obstacle-set-field "img"
                                                         (pstate-player (gstate-player-state GSTATE-TEST-15))
                                                         BLUE-GUY-IMG))))

(check-expect
 (gstate-pstate-reset
  ;put red guy picture rotated in GSTATE-TEST-16 and moved obstacle position
  (gstate-set-field "player-state"
                    GSTATE-TEST-16
                    (pstate-set-field "player"
                                      (gstate-player-state GSTATE-TEST-16)
                                      (obstacle-set-field "img"
                                                          (obstacle-set-field "position"
                                                                              (pstate-player (gstate-player-state GSTATE-TEST-16))
                                                                              (make-posn 21 -33))
                                                          (rotate -80 RED-GUY-IMG)))))
 ; expect GSTATE-TEST-16 with red guy picture
 (gstate-set-field "player-state"
                   GSTATE-TEST-16
                   (pstate-set-field "player"
                                     (gstate-player-state GSTATE-TEST-16)
                                     (obstacle-set-field "img"
                                                         (pstate-player (gstate-player-state GSTATE-TEST-16))
                                                         RED-GUY-IMG))))
(check-expect
 (gstate-pstate-reset
  ;put yellow guy picture rotated in GSTATE-TEST-17 and moved obstacle position
  (gstate-set-field "player-state"
                    GSTATE-TEST-17
                    (pstate-set-field "player"
                                      (gstate-player-state GSTATE-TEST-17)
                                      (obstacle-set-field "img"
                                                          (obstacle-set-field "position"
                                                                              (pstate-player (gstate-player-state GSTATE-TEST-17))
                                                                              (make-posn 28 28))
                                                          (rotate 5 YELLOW-GUY-IMG)))))
 ; expect GSTATE-TEST-17 with yellow guy picture
 (gstate-set-field "player-state"
                   GSTATE-TEST-17
                   (pstate-set-field "player"
                                     (gstate-player-state GSTATE-TEST-17)
                                     (obstacle-set-field "img"
                                                         (pstate-player (gstate-player-state GSTATE-TEST-17))
                                                         YELLOW-GUY-IMG))))

; gstate-restart-level examples
(check-expect (gstate-restart-level START-LEVEL-1) START-LEVEL-1)
(check-expect (gstate-restart-level START-LEVEL-2) START-LEVEL-2)
(check-expect (gstate-restart-level START-LEVEL-3) START-LEVEL-3)
(check-expect (gstate-restart-level GSTATE-TEST-7) START-GAME)

; obstacle-in-frame? examples
(check-expect (obstacle-in-frame?
               (make-obstacle OBSTACLE-TYPE-PLAYER-RED IMAGE-TEST-1 (make-posn -30 -21) (make-dimension 20 20)))
              #false)
(check-expect (obstacle-in-frame?
               (make-obstacle OBSTACLE-TYPE-BLADE IMAGE-TEST-1 (make-posn -30 -21) (make-dimension 50 50)))
              #true)
(check-expect (obstacle-in-frame?
               (make-obstacle OBSTACLE-TYPE-BLOCK IMAGE-TEST-1 (make-posn -80 130) (make-dimension 50 50)))
              #false)
(check-expect (obstacle-in-frame?
               (make-obstacle OBSTACLE-TYPE-WIN-BLOCK IMAGE-TEST-1 (make-posn 80 -130) (make-dimension 50 50)))
              #false)
(check-expect (obstacle-in-frame?
               (make-obstacle OBSTACLE-TYPE-BLOCK IMAGE-TEST-1 (make-posn 60 130) (make-dimension 50 50)))
              #true)
(check-expect (obstacle-in-frame?
               (make-obstacle OBSTACLE-TYPE-PLAYER-RED IMAGE-TEST-1 (make-posn 8000 8000) (make-dimension 50 50)))
              #false)

; obstacle-touching? examples
(check-expect (obstacle-touching? PLAYER-TEST-3
                                  (make-obstacle OBSTACLE-TYPE-BLADE IMAGE-TEST-1 (make-posn 50 50) (make-dimension 30 30)))
              #true)
(check-expect (obstacle-touching? PLAYER-TEST-3
                                  (make-obstacle OBSTACLE-TYPE-BLADE IMAGE-TEST-1 (make-posn 37 36) (make-dimension 30 30)))
              #true)
(check-expect (obstacle-touching?
               (make-obstacle OBSTACLE-TYPE-PLAYER-RED IMAGE-TEST-1 (make-posn 10 15) (make-dimension 20 20))
               (make-obstacle OBSTACLE-TYPE-BLADE IMAGE-TEST-1 (make-posn 120 150) (make-dimension 30 30)))
              #false)
(check-expect (obstacle-touching?
               (make-obstacle OBSTACLE-TYPE-PLAYER-RED IMAGE-TEST-1 (make-posn 0 0) (make-dimension 20 20))
               (make-obstacle OBSTACLE-TYPE-BLADE IMAGE-TEST-1 (make-posn 20 20) (make-dimension 30 30)))
              #true)
(check-expect (obstacle-touching?
               (make-obstacle OBSTACLE-TYPE-PLAYER-RED IMAGE-TEST-1 (make-posn 0 0) (make-dimension 20 20))
               (make-obstacle OBSTACLE-TYPE-BLADE IMAGE-TEST-1 (make-posn 21 20) (make-dimension 30 30)))
              #false)
(check-expect (obstacle-touching? PLAYER-TEST-3
                                  (make-obstacle OBSTACLE-TYPE-BLADE IMAGE-TEST-1 (make-posn 20 10) (make-dimension 30 30)))
              #true)
(check-expect (obstacle-touching?
               (make-obstacle OBSTACLE-TYPE-PLAYER-RED IMAGE-TEST-1 (make-posn 50 50) (make-dimension 20 20))
               (make-obstacle OBSTACLE-TYPE-BLADE IMAGE-TEST-1 (make-posn 30 40) (make-dimension 30 30)))
              #true)


; gstate-flat? examples
(check-expect (gstate-flat? GSTATE-TEST-5) #true)
(check-expect (gstate-flat? GSTATE-TEST-6) #true)
(check-expect (gstate-flat? GSTATE-TEST-7) #true)
(check-expect (gstate-flat?
               (make-gstate (make-pstate
                             (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                            IMAGE-TEST-2
                                            (make-posn 33 33)
                                            (make-dimension 32 32))
                             #false
                             56)
                            MENU-LEVEL
                            (make-level 1 '())
                            #false))
              #false)
(check-expect (gstate-flat?
               (make-gstate (make-pstate
                             (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                            IMAGE-TEST-3
                                            (make-posn 33 33)
                                            (make-dimension 32 32))
                             #false
                             56)
                            MENU-LEVEL
                            (make-level 1 '())
                            #false))
              #false)
(check-expect (gstate-flat?
               (make-gstate (make-pstate
                             (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                            IMAGE-TEST-4
                                            (make-posn 33 33)
                                            (make-dimension 32 32))
                             #false
                             56)
                            MENU-LEVEL
                            (make-level 1 '())
                            #false))
              #false)

; obstacle-on-top? examples
(check-expect (obstacle-on-top? PLAYER-TEST-3 BLOCK-TEST-2) #true)
(check-expect (obstacle-on-top? (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                               (square 20 "solid" "black")
                                               (make-posn 20 20)
                                               (make-dimension 20 (+ 20 JUMP-SPEED)))
                                BLOCK-TEST-2)
              #true)
(check-expect (obstacle-on-top? (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                               (square 20 "solid" "black")
                                               (make-posn 20 20)
                                               (make-dimension 20 (+ 1 (+ 20 JUMP-SPEED))))
                                BLOCK-TEST-2)
              #false)
(check-expect (obstacle-on-top? (make-obstacle OBSTACLE-TYPE-PLAYER-RED
                                               (square 20 "solid" "black")
                                               (make-posn 80 80)
                                               (make-dimension 20 20))
                                BLOCK-TEST-2)
              #false)


; gstate-touches-ground? examples:
(check-expect (gstate-touches-ground? GSTATE-TEST-8) #true)
(check-expect (gstate-touches-ground? GSTATE-TEST-3) #false)
(check-expect (gstate-touches-ground? GSTATE-TEST-9) #false)
(check-expect (gstate-touches-ground? GSTATE-TEST-10) #false)

; === Main functions ===

; gstate-move-player examples
(check-expect (gstate-move-player GSTATE-TEST-18)
              (gstate-set-player-y
               (gstate-set-field "player-state"
                                 GSTATE-TEST-18
                                 (pstate-set-field "player"
                                                   PSTATE-TEST-10
                                                   (obstacle-set-field "img"
                                                                       PLAYER-TEST-6
                                                                       (rotate ROTATE-SPEED RED-GUY-IMG))))
               (+ 511 JUMP-SPEED)))
(check-expect (gstate-move-player GSTATE-TEST-19) GSTATE-TEST-19)
(check-expect (gstate-move-player GSTATE-TEST-20)
              (gstate-set-player-y
               (gstate-set-field "player-state"
                                 GSTATE-TEST-20
                                 (pstate-set-field "player"
                                                   PSTATE-TEST-11
                                                   (obstacle-set-field "img"
                                                                       PLAYER-TEST-6
                                                                       (rotate ROTATE-SPEED RED-GUY-IMG))))
               (- 511 JUMP-SPEED)))
(check-expect (gstate-move-player GSTATE-TEST-21) GSTATE-TEST-22)
(check-expect (gstate-move-player GSTATE-TEST-23) GSTATE-TEST-24)


; move-obstacles examples:
(check-expect (move-obstacles (list BLOCK-TEST-1 BLOCK-TEST-2))
              (list
               (make-obstacle OBSTACLE-TYPE-BLOCK
                              IMAGE-TEST-1
                              (make-posn 25 50)
                              (make-dimension 20 20))
               (make-obstacle OBSTACLE-TYPE-BLOCK
                              IMAGE-TEST-1
                              (make-posn (- 25 LEVEL-SPEED) 40)
                              (make-dimension 30 30))))


(check-expect (move-obstacles (list BLOCK-TEST-3 BLADE-TEST-1))
              (list
               (make-obstacle OBSTACLE-TYPE-BLOCK
                              IMAGE-TEST-1
                              (make-posn (- 200 LEVEL-SPEED) 200)
                              (make-dimension 20 20))
               (make-obstacle OBSTACLE-TYPE-BLADE
                              IMAGE-TEST-1
                              (make-posn (- 12 LEVEL-SPEED) 13)
                              (make-dimension 1 6))))

; handle-key examples
(check-expect (handle-key GSTATE-TEST-2 "q")
              (gstate-set-field "quit" GSTATE-TEST-2 #true))
(check-expect (handle-key GSTATE-TEST-2 "Q")
              (gstate-set-field "quit" GSTATE-TEST-2 #true))


(check-expect (handle-key START-GAME "\r")
              (make-gstate
               (make-pstate
                (make-obstacle
                 "player-blue"
                 BLUE-GUY-IMG
                 (make-posn 200 650)
                 (make-dimension 90 90))
                #false
                650)
               "choose-player"
               #false
               #false))

(check-expect (handle-key GSTATE-TEST-3 " ") (gstate-restart-level GSTATE-TEST-3))
(check-expect (handle-key GSTATE-TEST-3 "escape")
              (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset GSTATE-TEST-3) LEVEL-1) MENU-CHOOSE-LEVEL))
(check-expect (handle-key GSTATE-TEST-3 "a") GSTATE-TEST-3)

(check-expect (handle-key GSTATE-TEST-11.1 "p") (gstate-set-field "menu" GSTATE-TEST-11.1 MENU-LEVEL))
(check-expect (handle-key GSTATE-TEST-11.1 "P") (gstate-set-field "menu" GSTATE-TEST-11.1 MENU-LEVEL))
(check-expect (handle-key GSTATE-TEST-11.1 "escape")
              (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset GSTATE-TEST-11.1) LEVEL-1) MENU-CHOOSE-LEVEL))
(check-expect (handle-key GSTATE-TEST-11.1 "a") GSTATE-TEST-11.1)

(check-expect (handle-key GSTATE-TEST-2 "escape")
              (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset GSTATE-TEST-2) LEVEL-1) MENU-CHOOSE-LEVEL))
(check-expect
 (handle-key GSTATE-TEST-30 " ")
 (make-gstate
  (make-pstate PLAYER-TEST-11 #true 200)
  MENU-LEVEL
  (make-level 0 (list BLOCK-TEST-11))
  #false))
(check-expect
 (handle-key GSTATE-TEST-30 "p")
 (make-gstate PSTATE-TEST-17 MENU-PAUSE (make-level 0 (list BLOCK-TEST-11)) #false))
(check-expect
 (handle-key GSTATE-TEST-30 "P")
 (make-gstate PSTATE-TEST-17 MENU-PAUSE (make-level 0 (list BLOCK-TEST-11)) #false))

(check-expect
 (handle-key GSTATE-TEST-30 "escape")
 (make-gstate
  (pstate-set-field "player" INITIAL-PSTATE RED-GUY)
  MENU-CHOOSE-LEVEL
  LEVEL-1
  #false))
(check-expect
 (handle-key GSTATE-TEST-30 "r") GSTATE-TEST-30)
(check-expect (handle-key GSTATE-TEST-31 "left") GSTATE-TEST-33)
(check-expect (handle-key GSTATE-TEST-32 "left") GSTATE-TEST-31)
(check-expect (handle-key GSTATE-TEST-33 "left") GSTATE-TEST-32)
(check-expect (handle-key GSTATE-TEST-31 "right") GSTATE-TEST-32)
(check-expect (handle-key GSTATE-TEST-32 "right") GSTATE-TEST-33)
(check-expect (handle-key GSTATE-TEST-33 "right") GSTATE-TEST-31)
(check-expect
 (handle-key GSTATE-TEST-31 "\r")
 (make-gstate (pstate-set-field "player" INITIAL-PSTATE BLUE-GUY) MENU-CHOOSE-LEVEL LEVEL-1 #false))
(check-expect (handle-key GSTATE-TEST-32 "escape") START-GAME)
(check-expect (handle-key GSTATE-TEST-33 "r") GSTATE-TEST-33)
(check-expect (handle-key GSTATE-TEST-34 "left") GSTATE-TEST-36)
(check-expect (handle-key GSTATE-TEST-35 "left") GSTATE-TEST-34)
(check-expect (handle-key GSTATE-TEST-36 "left") GSTATE-TEST-35)
(check-expect (handle-key GSTATE-TEST-34 "right") GSTATE-TEST-35)
(check-expect (handle-key GSTATE-TEST-35 "right") GSTATE-TEST-36)
(check-expect (handle-key GSTATE-TEST-36 "right") GSTATE-TEST-34)
(check-expect
 (handle-key GSTATE-TEST-34 "\r")
 (make-gstate (make-pstate BLUE-GUY #false 90) MENU-LEVEL LEVEL-1 #false))
(check-expect
 (handle-key GSTATE-TEST-34 "escape")
 (gstate-set-field "menu" (gstate-set-field "level" START-GAME #false) MENU-CHOOSE-PLAYER))
(check-expect (handle-key GSTATE-TEST-35 "h") GSTATE-TEST-35)
(check-expect (handle-key GSTATE-TEST-37 "r") GSTATE-TEST-37)

(check-expect (handle-key GSTATE-TEST-38 "j") GSTATE-TEST-38)
(check-expect (handle-key GSTATE-TEST-39 "x") GSTATE-TEST-39)
(check-expect
 (handle-key GSTATE-TEST-39 " ")
 (gstate-set-field "menu" (gstate-set-field "level" (gstate-pstate-reset GSTATE-TEST-39) LEVEL-1) MENU-LEVEL))


; draw-obstacles examples:
(check-expect (draw-obstacles (list BLOCK-TEST-1 BLOCK-TEST-2))
              (place-image (obstacle-img BLOCK-TEST-1)
                           (obstacle-x BLOCK-TEST-1)
                           (obstacle-y BLOCK-TEST-1)
                           (draw-obstacles (list BLOCK-TEST-2))))
(check-expect (draw-obstacles (list BLOCK-TEST-3 BLADE-TEST-1))
              (place-image (obstacle-img BLOCK-TEST-3)
                           (obstacle-x BLOCK-TEST-3)
                           (obstacle-y BLOCK-TEST-3)
                           (draw-obstacles (list BLADE-TEST-1))))
(check-expect (draw-obstacles (list BLOCK-TEST-7 BLOCK-TEST-8))
              (place-image (obstacle-img BLOCK-TEST-7)
                           (obstacle-x BLOCK-TEST-7)
                           (obstacle-y BLOCK-TEST-7)
                           (draw-obstacles (list BLOCK-TEST-7))))

(check-expect (draw-obstacles (list BLOCK-TEST-8 BLOCK-TEST-9))
              (place-image (obstacle-img BLOCK-TEST-8)
                           (obstacle-x BLOCK-TEST-8)
                           (obstacle-y BLOCK-TEST-8)
                           (draw-obstacles (list BLOCK-TEST-8))))

; draw-choose-player examples:
(check-expect (draw-choose-player GSTATE-TEST-5) CHOOSE-BLUE)
(check-expect (draw-choose-player GSTATE-TEST-6) CHOOSE-RED)
(check-expect (draw-choose-player GSTATE-TEST-7) CHOOSE-YELLOW)


; draw-choose-level examples:
(check-expect (draw-choose-level GSTATE-TEST-12) CHOOSE-LEVEL-1)
(check-expect (draw-choose-level GSTATE-TEST-13) CHOOSE-LEVEL-2)
(check-expect (draw-choose-level GSTATE-TEST-14) CHOOSE-LEVEL-3)

; draw examples
(check-expect
 (draw (make-gstate INITIAL-PSTATE MENU-WELCOME LEVEL-1 #false))
 WELCOME-PAGE)
(check-expect
 (draw
  (make-gstate
   (pstate-set-field "player" INITIAL-PSTATE BLUE-GUY)
   MENU-CHOOSE-PLAYER
   LEVEL-1
   #false))
 CHOOSE-BLUE)
(check-expect
 (draw
  (make-gstate
   (pstate-set-field "player" INITIAL-PSTATE RED-GUY)
   MENU-CHOOSE-PLAYER
   LEVEL-1
   #false))
 CHOOSE-RED)
(check-expect
 (draw
  (make-gstate
   (pstate-set-field "player" INITIAL-PSTATE YELLOW-GUY)
   MENU-CHOOSE-PLAYER
   LEVEL-1
   #false))
 CHOOSE-YELLOW)
(check-expect
 (draw (make-gstate INITIAL-PSTATE MENU-CHOOSE-LEVEL LEVEL-1 #false))
 CHOOSE-LEVEL-1)
(check-expect
 (draw (make-gstate INITIAL-PSTATE MENU-CHOOSE-LEVEL LEVEL-2 #false))
 CHOOSE-LEVEL-2)
(check-expect
 (draw (make-gstate INITIAL-PSTATE MENU-CHOOSE-LEVEL LEVEL-3 #false))
 CHOOSE-LEVEL-3)
(check-expect
 (draw (make-gstate PSTATE-TEST-16 MENU-LEVEL LEVEL-TEST-6 #false))
 (place-image BLUE-GUY-IMG
              52
              76
              (place-image RED-GUY-IMG
                           400
                           400
                           BACKGROUND)))
(check-expect
 (draw (make-gstate PSTATE-TEST-16 MENU-LEVEL (make-level 0 '()) #false))
 (place-image RED-GUY-IMG
              400
              400
              BACKGROUND))
(check-expect
 (draw (make-gstate PSTATE-TEST-16 MENU-YOU-DIED LEVEL-TEST-6 #false))
 (place-image
  BLUE-GUY-IMG
  52
  76
  (place-image
   RED-GUY-IMG
   400
   400
   (place-image
    (text "YOU DIED" TOP-TEXT-SIZE TOP-TEXT-COLOR)
    TOP-TEXT-X
    TOP-TEXT-Y
    (place-image
     (text "press SPACE to restart" SUB-TEXT-SIZE SUB-TEXT-COLOR)
     SUB-TEXT-X
     SUB-TEXT-Y
     BACKGROUND)))))
(check-expect
 (draw (make-gstate PSTATE-TEST-16 MENU-YOU-WON LEVEL-TEST-6 #false))
 (place-image
  BLUE-GUY-IMG
  52
  76
  (place-image
   RED-GUY-IMG
   400
   400
   (place-image
    (text "YOU WON" TOP-TEXT-SIZE TOP-TEXT-COLOR)
    TOP-TEXT-X
    TOP-TEXT-Y
    (place-image
     (text "press SPACE to restart, ESC to change level" SUB-TEXT-SIZE SUB-TEXT-COLOR)
     SUB-TEXT-X
     SUB-TEXT-Y
     BACKGROUND)))))
(check-expect
 (draw (make-gstate PSTATE-TEST-16 MENU-PAUSE LEVEL-TEST-6 #false))
 (place-image
  BLUE-GUY-IMG
  52
  76
  (place-image
   RED-GUY-IMG
   400
   400
   (place-image
    (text "PAUSE" TOP-TEXT-SIZE TOP-TEXT-COLOR)
    TOP-TEXT-X
    TOP-TEXT-Y
    (place-image
     (text "press p to resume, ESC to change level" SUB-TEXT-SIZE SUB-TEXT-COLOR)
     SUB-TEXT-X
     SUB-TEXT-Y
     BACKGROUND)))))

; move-level examples
(check-expect (move-level GSTATE-TEST-26)
              (gstate-set-field "menu" GSTATE-TEST-26 MENU-YOU-DIED))
(check-expect (move-level GSTATE-TEST-27)
              (gstate-set-field "menu" GSTATE-TEST-27 MENU-YOU-DIED))
(check-expect (move-level GSTATE-TEST-28)
              (gstate-set-field "menu" GSTATE-TEST-28 MENU-YOU-DIED))
(check-expect (move-level GSTATE-TEST-29)
              (gstate-set-field "menu" GSTATE-TEST-29 MENU-YOU-WON))
(check-expect
 (move-level GSTATE-TEST-25)
 (make-gstate
  (make-pstate
   (make-obstacle OBSTACLE-TYPE-PLAYER-RED (rotate ROTATE-SPEED RED-GUY-IMG) (make-posn 200 (- 200 JUMP-SPEED)) (make-dimension 30 30))
   #true
   170)
  MENU-LEVEL
  (make-level 0 '())
  #false))

(check-expect
 (move-level GSTATE-TEST-30)
 (make-gstate
  PSTATE-TEST-17
  MENU-LEVEL
  (make-level
   0
   (list(make-obstacle OBSTACLE-TYPE-BLOCK BLUE-GUY-IMG (make-posn (- 198 LEVEL-SPEED) (+ 200 PLAYER-HEIGHT)) (make-dimension 30 30))))
  #false))

; tick examples:
(check-expect (tick GSTATE-TEST-1)  GSTATE-TEST-1)
(check-expect (tick GSTATE-TEST-11) (move-level GSTATE-TEST-11))



; ======= 3. Tests for file "levels.rkt" =======

; create-line examples
(check-expect (create-line 2 BLOCK-TEST-1)
              (list
               (make-obstacle OBSTACLE-TYPE-BLOCK
                              IMAGE-TEST-1
                              (make-posn 20 740)
                              (make-dimension 20 20))
               (make-obstacle OBSTACLE-TYPE-BLOCK
                              IMAGE-TEST-1
                              (make-posn 0 740)
                              (make-dimension 20 20))))
(check-expect (create-line 3 BLADE-TEST-1)
              (list
               (make-obstacle OBSTACLE-TYPE-BLADE
                              IMAGE-TEST-1
                              (make-posn 2 740)
                              (make-dimension 1 6))
               (make-obstacle OBSTACLE-TYPE-BLADE
                              IMAGE-TEST-1
                              (make-posn 1 740)
                              (make-dimension 1 6))
               (make-obstacle OBSTACLE-TYPE-BLADE
                              IMAGE-TEST-1
                              (make-posn 0 740)
                              (make-dimension 1 6))))

; set-obstacle-position examples
(check-expect (set-obstacle-position BLOCK-TEST-1 (make-posn 10 10))
              (make-obstacle OBSTACLE-TYPE-BLOCK
                             IMAGE-TEST-1
                             (make-posn 10 10)
                             (make-dimension 20 20)))
(check-expect (set-obstacle-position BLADE-TEST-1 (make-posn 89 432))
              (make-obstacle OBSTACLE-TYPE-BLADE
                             IMAGE-TEST-1
                             (make-posn 89 432)
                             (make-dimension 1 6)))

; move-obstacles-to-position examples
(check-expect (move-obstacles-to-position (list BLOCK-TEST-1 BLOCK-TEST-2) 15 20)
              (list
               (make-obstacle OBSTACLE-TYPE-BLOCK
                              IMAGE-TEST-1
                              (make-posn 65 30)
                              (make-dimension 20 20))
               (make-obstacle OBSTACLE-TYPE-BLOCK
                              IMAGE-TEST-1
                              (make-posn 40 20)
                              (make-dimension 30 30))))
(check-expect (move-obstacles-to-position (list BLOCK-TEST-3 BLADE-TEST-1) 100 200)
              (list
               (make-obstacle OBSTACLE-TYPE-BLOCK
                              IMAGE-TEST-1
                              (make-posn 300 0)
                              (make-dimension 20 20))
               (make-obstacle OBSTACLE-TYPE-BLADE
                              IMAGE-TEST-1
                              (make-posn 112 -187)
                              (make-dimension 1 6))))

; list-union examples
(check-expect (list-union (list BLOCK-TEST-1 BLOCK-TEST-2) (list BLOCK-TEST-3)) (list BLOCK-TEST-1 BLOCK-TEST-3 BLOCK-TEST-2))
(check-expect (list-union (list BLOCK-TEST-1) '() ) (list BLOCK-TEST-1))

