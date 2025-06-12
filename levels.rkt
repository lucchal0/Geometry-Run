;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname levels) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)
(require racket/base)

(require "datatypes.rkt")

(provide LEVEL-1 START-LEVEL-1 LEVEL-2 START-LEVEL-2 LEVEL-3 START-LEVEL-3 list-union move-obstacles-to-position set-obstacle-position create-line)

; ========= FUNCTIONS USED TO DESIGN A LEVEL =========
; ===== These functions help create different levels =====

; create-line : Number  Obstacle -> List<Obstacles>
; creates a line with the specified number of `obst` obstacles.
; it is an horizontal sequence of `length` obstacles, positioned at initial height.
; header : (define (create-line length obst) '())
; template :
; (define (create-line length obst)
;  (cond [(= length 0) '()]
;        [else (cons ...(obstacle-type obst)...(obstacle-img obst)...length...
;                    ...(obstacle-dimension obst)... (create-line (- length 1) obst)...))))]))
(define (create-line length obst)
  (cond
    ; base case
    [(= length 0) '()]
    [else
     (cons
      ; new obstacle (copy of obst at different position)
      (make-obstacle (obstacle-type obst)
                     (obstacle-img obst)
                     (make-posn
                      (* (- length 1)
                         (dimension-width (obstacle-dimension obst)))
                      (+ INITIAL-Y PLAYER-HEIGHT))
                     (obstacle-dimension obst))
      ; recursion
      (create-line (- length 1) obst))]))

; set-obstacle-position : Obstacle Posn -> Obstacle
; returns an obstacle like `obst` but at position `posn`
; header : (define (set-obstacle-position obst posn) obst)
; template :
; (define (set-obstacle-position obst posn)
;   ... (obstacle-type obst)...(obstacle-img obst)...posn...(obstacle-dimension obst)...))
(define (set-obstacle-position obst posn)
  (make-obstacle
   (obstacle-type obst)
   (obstacle-img obst)
   posn
   (obstacle-dimension obst)))

; move-obstacles-to-position: List<Obstacle> Number Number -> List<Obstacle>
; moves all obstacles in `loo` to the right by `d-x` pixels and up by `d-y` pixels.
; header : (define (move-obstacles loo d-x d-y) loo)
; template :
; (define (move-obstacles-to-position loo d-x d-y)
;  (cond
;    [(empty? loo) '()]
;    [else
;      (cons ... (obstacle-type (first loo))... (obstacle-img (first loo))...(make-posn ...d-x ...d-y...)
;             ... (obstacle-dimension (first loo))... (move-obstacle-to-position (rest loo) d-x d-y)))]))
(define (move-obstacles-to-position loo d-x d-y)
  (cond
    ; base case
    [(empty? loo) '()]
    [else
     (cons
      ; copy of (first loo) but in new position
      (make-obstacle (obstacle-type (first loo))
                     (obstacle-img (first loo))
                     (make-posn (+ d-x (posn-x (obstacle-position (first loo))))
                                (- (posn-y (obstacle-position (first loo))) d-y))
                     (obstacle-dimension (first loo)))
      ; recursion
      (move-obstacles-to-position (rest loo) d-x d-y))]))

; list-union : List<Obstacle> List<Obstacle> -> List<Obstacle>
; returns a List<Obstacle> containings all elements of `loo-1` and `loo-2`
; header : (define (list-union loo-1 loo-2) loo-1)
; template :
; (define (list-union loo-1 loo-2)
;  (cond
;    [(and (empty? loo-1) (empty? loo-2)) '()]
;    [(empty? loo-1) ... (first loo-2)... (list-union loo-1 (rest loo-2))...]
;    [(empty? loo-2) ... (first loo-1) ... (list-union (rest loo-1)) loo-2)...]
;    [else ...(first loo-1)...(first loo-2)...(list-union (rest loo-1) (rest loo-2))...]))
(define (list-union loo-1 loo-2)
  (cond
    ; base case: both lists are empty
    [(and (empty? loo-1) (empty? loo-2))
     '()]
    ; loo-1 is empty but not loo-2
    [(empty? loo-1)
     (cons (first loo-2)
           ; recursion 
           (list-union loo-1 (rest loo-2)))]
    ; loo-2 is empty but not loo-1
    [(empty? loo-2)
     (cons (first loo-1)
           ; recursion
           (list-union (rest loo-1) loo-2))]
    ; both lists aren't empty
    [else
     (cons (first loo-1)
           (cons (first loo-2)
                 ; recursion
                 (list-union (rest loo-1) (rest loo-2))))]))


; ========= LEVELS =========

; ======= LEVEL 1 ========

; Lists of Obstacles
(define LV1-LENGTH 70) ; length of the level measured in blocks
(define LV1-PAVEMENT (create-line LV1-LENGTH BLOCK))
(define LV1-WIN-BLOCK
  (set-obstacle-position WIN-BLOCK
                         ; 20 blocks before end of LV1-PAVEMENT
                         (make-posn
                          (- (* LV1-LENGTH BLOCK-WIDTH)
                             (* 20 BLOCK-WIDTH))
                          WIN-BLOCK-Y)))

(define LV1-OBSTACLES1
  (list (set-obstacle-position BLADE (make-posn 800 INITIAL-Y))
        (set-obstacle-position BLADE (make-posn 1500 INITIAL-Y))
        (set-obstacle-position BLADE (make-posn 1800 (- INITIAL-Y JUMP-HEIGHT)))
        (set-obstacle-position BLADE (make-posn 2100 (- INITIAL-Y JUMP-HEIGHT)))
        (set-obstacle-position BLADE (make-posn 2500 INITIAL-Y))
        (set-obstacle-position BLADE (make-posn 2800 (- INITIAL-Y JUMP-HEIGHT)))
        (set-obstacle-position BLADE (make-posn 3100 INITIAL-Y))
        (set-obstacle-position BLADE (make-posn 3700 INITIAL-Y))
        LV1-WIN-BLOCK))

(define LV1-OBSTACLES (list-union LV1-OBSTACLES1 LV1-PAVEMENT))    

(define LEVEL-1 (make-level 1 LV1-OBSTACLES))
(define START-LEVEL-1 (make-gstate INITIAL-PSTATE MENU-LEVEL LEVEL-1 #false))


; ======= LEVEL 2 =======

(define LV2-PAVEMENT1-LENGTH 8) ; measured in blocks
(define LV2-PAVEMENT1 (create-line LV2-PAVEMENT1-LENGTH BLOCK))

(define LV2-PAVEMENT2-LENGTH 10)
(define LV2-HOLE1-LENGTH 4) ; measured in blocks
(define LV2-PAVEMENT2
  (move-obstacles-to-position
   (create-line LV2-PAVEMENT2-LENGTH BLOCK)
   ; move on the x axis
   (+
    ; hole width
    (* LV2-HOLE1-LENGTH BLOCK-WIDTH)
    ; previous pavement width
    (* LV2-PAVEMENT1-LENGTH BLOCK-WIDTH))
   ; move on the y axis
   0))

(define LV2-BLADE0
  (set-obstacle-position BLADE
                         (make-posn
                          ; 4 blocks before the rightmost obstacle of LV2-PAVEMENT2
                          (- (posn-x (obstacle-position (first LV2-PAVEMENT2)))
                             (* 4 BLOCK-WIDTH))
                          INITIAL-Y)))

(define LV2-PAVEMENT3-LENGTH 4)
(define LV2-PAVEMENT3-HEIGHT 1) ; measured in blocks
(define LV2-PAVEMENT3
  (move-obstacles-to-position
   (create-line LV2-PAVEMENT3-LENGTH BLOCK)
   ; move on the x axis
   ; position of last block of previous pavement
   (+ (posn-x (obstacle-position (first LV2-PAVEMENT2)))
      ; wanted distance from previous pavement
      (* 4 BLOCK-WIDTH))
   ; y axis
   (* LV2-PAVEMENT3-HEIGHT BLOCK-HEIGHT)))

(define LV2-PAVEMENT4-LENGTH 4)
(define LV2-PAVEMENT4-HEIGHT 1)
(define LV2-PAVEMENT4
  (move-obstacles-to-position
   (create-line LV2-PAVEMENT4-LENGTH BLOCK)
   (+ (posn-x (obstacle-position (first LV2-PAVEMENT3)))
      ; wanted distance from previous pavement
      (* 4 BLOCK-WIDTH))
   (* LV2-PAVEMENT4-HEIGHT BLOCK-HEIGHT)))
  
(define LV2-BLADE1
  (set-obstacle-position BLADE
                         (make-posn
                          ; 2 blocks after the rightmost obstacle of LV2-PAVEMENT4
                          (+ (posn-x (obstacle-position (first LV2-PAVEMENT4)))
                             (* 2 BLOCK-WIDTH))
                          (- (posn-y (obstacle-position (first LV2-PAVEMENT4)))
                             JUMP-HEIGHT))))

(define LV2-PAVEMENT5-LENGTH 7)
(define LV2-PAVEMENT5
  (move-obstacles-to-position
   (create-line LV2-PAVEMENT5-LENGTH BLOCK)
   (+ (posn-x (obstacle-position (first LV2-PAVEMENT4)))
      ; wanted distance from previous pavement
      (* 1 BLOCK-WIDTH))
   0))

(define LV2-PAVEMENT6-LENGTH 4)
(define LV2-PAVEMENT6-HEIGHT 2)
(define LV2-PAVEMENT6
  (move-obstacles-to-position
   (create-line LV2-PAVEMENT6-LENGTH BLOCK)
   (+ (posn-x (obstacle-position (first LV2-PAVEMENT5)))
      ; wanted distance from previous pavement
      (* 2 BLOCK-WIDTH))
   (* LV2-PAVEMENT6-HEIGHT BLOCK-HEIGHT)))

(define LV2-BLADE2
  (set-obstacle-position BLADE
                         (make-posn
                          ; 2 blocks after the rightmost obstacle of LV2-PAVEMENT5
                          (+ (posn-x (obstacle-position (first LV2-PAVEMENT5)))
                             (* 2 BLOCK-WIDTH))
                          INITIAL-Y)))

(define LV2-PAVEMENT7-LENGTH 4)
(define LV2-PAVEMENT7-HEIGHT 4)
(define LV2-PAVEMENT7
  (move-obstacles-to-position
   (create-line LV2-PAVEMENT7-LENGTH BLOCK)
   (+ (posn-x (obstacle-position (first LV2-PAVEMENT6)))
      ; wanted distance from previous pavement
      (* 2 BLOCK-WIDTH))
   (* LV2-PAVEMENT7-HEIGHT BLOCK-HEIGHT)))

(define LV2-BLADE3
  (set-obstacle-position BLADE
                         (make-posn
                          ; 2 blocks after the rightmost obstacle of LV2-PAVEMENT6
                          (+ (posn-x (obstacle-position (first LV2-PAVEMENT6)))
                             (* 2 BLOCK-WIDTH))
                          (- INITIAL-Y (* 2 BLOCK-HEIGHT)))))

(define LV2-PAVEMENT8-LENGTH 20)
(define LV2-PAVEMENT8
  (move-obstacles-to-position
   (create-line LV2-PAVEMENT8-LENGTH BLOCK)
   ; distance from previous pavement
   (+ (posn-x (obstacle-position (first LV2-PAVEMENT7)))
      (* 1 BLOCK-WIDTH))
   0))

(define LV2-BLADE4
  (set-obstacle-position BLADE
                         (make-posn
                          ; 8 blocks before rightmost block of LV2-PAVEMENT8
                          (- (posn-x (obstacle-position (first LV2-PAVEMENT8)))
                             (* 8 BLOCK-WIDTH))
                          INITIAL-Y)))

(define LV2-PAVEMENT
  (list-union
   LV2-PAVEMENT1
   (list-union
    LV2-PAVEMENT2
    (list-union
     LV2-PAVEMENT3
     (list-union
      LV2-PAVEMENT4
      (list-union
       LV2-PAVEMENT5
       (list-union
        LV2-PAVEMENT6
        (list-union
         LV2-PAVEMENT7
         LV2-PAVEMENT8))))))))

(define LV2-WIN-BLOCK
  (set-obstacle-position WIN-BLOCK
                         (make-posn
                          ; 4 blocks before the rightmost block of LV2-PAVEMENT8
                          (- (posn-x (obstacle-position (first LV2-PAVEMENT8)))
                             (* 4 BLOCK-WIDTH))
                          WIN-BLOCK-Y)))

(define LV2-OBSTACLES
  (cons LV2-BLADE0
        (cons LV2-BLADE1
              (cons LV2-BLADE2
                    (cons LV2-BLADE3
                          (cons LV2-WIN-BLOCK
                                LV2-PAVEMENT))))))

(define LEVEL-2 (make-level 2 LV2-OBSTACLES))
(define START-LEVEL-2 (make-gstate INITIAL-PSTATE MENU-LEVEL LEVEL-2 #false))


; ======= LEVEL 3 =======

(define LV3-PAVEMENT-LENGTH 30) ; measured in blocks
(define LV3-PAVEMENT (create-line LV3-PAVEMENT-LENGTH BLOCK))

(define LV3-WIN-BLOCK
  (set-obstacle-position WIN-BLOCK
                         (make-posn
                          (- (* 53 BLOCK-WIDTH) (* 5 BLOCK-WIDTH))
                                                      WIN-BLOCK-Y)))

(define LV3-BLOCK0 (set-obstacle-position BLOCK (make-posn 1000 INITIAL-Y)))
(define LV3-BLOCK1 (set-obstacle-position BLOCK (make-posn 1500 INITIAL-Y)))
(define LV3-BLOCK2 (set-obstacle-position BLOCK (make-posn 1500 560)))
(define LV3-BLOCK3 (set-obstacle-position BLOCK (make-posn 3000 INITIAL-Y)))
(define LV3-BLOCK4 (set-obstacle-position BLOCK (make-posn 3600 INITIAL-Y)))

(define LV3-OBSTACLES
  (cons (set-obstacle-position BLADE (make-posn 800 INITIAL-Y))
        (cons (set-obstacle-position BLADE (make-posn 890 INITIAL-Y))
              (cons LV3-BLOCK0
                    (cons LV3-BLOCK1
                          (cons LV3-BLOCK2
                                (cons (set-obstacle-position BLADE (make-posn 1800 (- INITIAL-Y JUMP-HEIGHT)))
                                      (cons (set-obstacle-position BLADE (make-posn 2100 INITIAL-Y))
                                            (cons LV3-BLOCK3
                                                  (cons (set-obstacle-position BLADE (make-posn 2700 INITIAL-Y))
                                                        (cons (set-obstacle-position BLADE (make-posn 3000 (- INITIAL-Y JUMP-HEIGHT)))
                                                              (cons (set-obstacle-position BLADE (make-posn 3300 INITIAL-Y))
                                                                    (cons LV3-BLOCK4
                                                                          (cons (set-obstacle-position BLADE (make-posn 3900 INITIAL-Y))
                                                                                (cons LV3-WIN-BLOCK LV3-PAVEMENT)))))))))))))))


(define LEVEL-3 (make-level 3 LV3-OBSTACLES))
(define START-LEVEL-3 (make-gstate INITIAL-PSTATE MENU-LEVEL LEVEL-3 #false))