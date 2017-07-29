(deftemplate statement 
  (slot location)
  (slot nationality) 
  (slot color) 
  (slot drink)
  (slot pet)
  (slot smokes))

;;;;;;;;;;;;;;;;;;;;;;;
; Rules according to facts
;;;;;;;;;;;;;;;;;;;;;;; 
; The English lives in the red house
(defrule state1
  ?node <- (statement (nationality ?na) (color ?co)) 
  =>
  (if (and (eq ?na English) (neq ?co red))
    then (retract ?node))
  (if (and (neq ?na English) (eq ?co red))
    then (retract ?node)))

; The Swedish keeps dogs
(defrule state2
  ?node <- (statement (nationality ?na) (pet ?pet)) 
  =>
  (if (and (eq ?na Swedish) (neq ?pet dogs))
    then (retract ?node))
  (if (and (neq ?na Swedish) (eq ?pet dogs))
    then (retract ?node)))

; The Danish drink tea
(defrule state3
  ?node <- (statement (nationality ?na) (drink ?dr)) 
  =>
  (if (and (eq ?na Danish) (neq ?dr tea))
    then (retract ?node))
  (if (and (neq ?na Danish) (eq ?dr tea))
    then (retract ?node)))

; The owner of the green house drink coffee
(defrule state4
  ?node <- (statement (color ?co) (drink ?dr)) 
  =>
  (if (and (eq ?co green) (neq ?dr coffee))
    then (retract ?node))
  (if (and (neq ?co green) (eq ?dr coffee))
    then (retract ?node)))

; The Pall Mall smoker keeps birds
(defrule state5
  ?node <- (statement (smokes ?co) (pet ?pet)) 
  =>
  (if (and (eq ?co The-Pall-Mall) (neq ?pet birds))
    then (retract ?node))
  (if (and (neq ?co The-Pall-Mall) (eq ?pet birds))
    then (retract ?node)))

; The owner of the yellow house smokes Dunhill
(defrule state6
  ?node <- (statement (color ?co) (smokes ?sm)) 
  =>
  (if (and (eq ?co yellow) (neq ?sm Dunhill))
    then (retract ?node))
  (if (and (neq ?co yellow) (eq ?sm Dunhill))
    then (retract ?node)))

; The man in the center house drinks milk
(defrule state7
  ?node <- (statement (location 3) (drink ?dr)) 
  =>
  (if (neq ?dr milk) 
    then (retract ?node)))

; The Norwegian lives in the first house
(defrule state8
  ?node1 <- (statement (location 1) (nationality ?na))
  =>
  (if (neq ?na Norwegian) 
    then (retract ?node1)))

; The man who smokes Blue-Master drinks beer
(defrule state9
  ?node2 <- (statement (drink ?dr2) (smokes ?sm2))
  =>
  (if (and (eq ?dr2 beer) (neq ?sm2 Blue-Master))
    then (retract ?node2))
  (if (and (neq ?dr2 beer) (eq ?sm2 Blue-Master))
    then (retract ?node2))) 

; The German smokes Prince
(defrule state10
  ?node3 <- (statement (nationality ?na3) (smokes ?sm3))
  =>
  (if (and (eq ?na3 German) (neq ?sm3 Prince))
    then (retract ?node3))
  (if (and (neq ?na3 German) (eq ?sm3 Prince))
    then (retract ?node3))) 

; The green house is just to the left of the white one
(deffunction check1 (?color1 ?color2)
  (if (and (eq ?color1 green) (eq ?color2 white))
    then TRUE else FALSE ))

; The Blend smoker has a neighbor who keeps cats
(deffunction check2 (?smoke ?pet)
  (if (and (eq ?smoke Blend) (eq ?pet cats))
    then TRUE else FALSE ))

; The Blend smoker has a neighbor who drinks water
(deffunction check3 (?smoke ?drink)
  (if (and (eq ?smoke Blend) (eq ?drink water))
    then TRUE else FALSE ))

; The man who keeps horses lives next to the Dunhill smoker
(deffunction check4 (?pet ?smoke)
  (if (and (eq ?pet horses) (eq ?smoke Dunhill))
    then TRUE else FALSE ))

; The Norwegian lives next to the blue house
(deffunction check5 (?nationality ?color)
  (if (and (eq ?nationality Norwegian) (eq ?color blue))
    then TRUE else FALSE ))

(deffunction print-fish (?nationality ?pet)
  (if (eq ?pet fish) 
    then (printout t "Solution: The "?nationality " keeps fish"crlf)))


;;;;;;;;;;;;;;;;;;;;;;;
; Find and print solution
;;;;;;;;;;;;;;;;;;;;;;;

(defrule solution
  ?node1 <- (statement (location 1) (nationality ?n1) (color ?c1) (drink ?d1) (pet ?p1) (smokes ?s1))
  ?node2 <- (statement (location 2) (nationality ?n2&~?n1) (color ?c2&~?c1) (drink ?d2&~?d1) (pet ?p2&~?p1) (smokes ?s2&~?s1))
  ?node3 <- (statement (location 3) (nationality ?n3&~?n2&~?n1) (color ?c3&~?c2&~?c1) (drink ?d3&~?d2&~?d1) (pet ?p3&~?p2&~?p1) (smokes ?s3&~?s2&~?s1))
  ?node4 <- (statement (location 4) (nationality ?n4&~?n3&~?n2&~?n1) (color ?c4&~?c3&~?c2&~?c1) (drink ?d4&~?d3&~?d2&~?d1) (pet ?p4&~?p3&~?p2&~?p1) (smokes ?s4&~?s3&~?s2&~?s1))
  ?node5 <- (statement (location 5) (nationality ?n5&~?n4&~?n3&~?n2&~?n1) (color ?c5&~?c4&~?c3&~?c2&~?c1) (drink ?d5&~?d4&~?d3&~?d2&~?d1) (pet ?p5&~?p4&~?p3&~?p2&~?p1) (smokes ?s5&~?s4&~?s3&~?s2&~?s1))
  =>
  (if (or (check1 ?c1 ?c2) (check1 ?c2 ?c3) (check1 ?c3 ?c4) (check1 ?c4 ?c5))
  then (if (or (check2 ?s1 ?p2) (check2 ?s2 ?p1) (check2 ?s2 ?p3) (check2 ?s3 ?p2) (check2 ?s3 ?p4) (check2 ?s4 ?p3) (check2 ?s4 ?p5) (check2 ?s5 ?p4) )
  then (if (or (check3 ?s1 ?d2) (check3 ?s2 ?d1) (check3 ?s2 ?d3) (check3 ?s3 ?d2) (check3 ?s3 ?d4) (check3 ?s4 ?d3) (check3 ?s4 ?d5) (check3 ?s5 ?d4) )
  then (if (or (check4 ?p1 ?s2) (check4 ?p2 ?s1) (check4 ?p2 ?s3) (check4 ?p3 ?s2) (check4 ?p3 ?s4) (check4 ?p4 ?s3) (check4 ?p4 ?s5) (check4 ?p5 ?s4))
  then (if (or (check5 ?n1 ?c2) (check5 ?n2 ?c1) (check5 ?n2 ?c3) (check5 ?n3 ?c2) (check5 ?n3 ?c4) (check5 ?n4 ?c3) (check5 ?n4 ?c5) (check5 ?n5 ?c4))
  then (assert  (solution 1 ?n1 ?c1 ?d1 ?p1 ?s1)
          (solution 2 ?n2 ?c2 ?d2 ?p2 ?s2)
          (solution 3 ?n3 ?c3 ?d3 ?p3 ?s3)
          (solution 4 ?n4 ?c4 ?d4 ?p4 ?s4)
          (solution 5 ?n5 ?c5 ?d5 ?p5 ?s5))
     (or (print-fish ?n1 ?p1) (print-fish ?n2 ?p2) (print-fish ?n3 ?p3) (print-fish ?n4 ?p4) (print-fish ?n5 ?p5)) )))))) 

(defrule print-solution
  ?node1 <- (solution 1 ?n1 ?c1 ?d1 ?p1 ?s1)
  ?node2 <- (solution 2 ?n2 ?c2 ?d2 ?p2 ?s2)
  ?node3 <- (solution 3 ?n3 ?c3 ?d3 ?p3 ?s3)
  ?node4 <- (solution 4 ?n4 ?c4 ?d4 ?p4 ?s4)
  ?node5 <- (solution 5 ?n5 ?c5 ?d5 ?p5 ?s5)
  =>
  (printout t crlf)
  (printout t "The total information: " crlf)
  (format t "Index | %-11s | %-6s | %-6s | %-6s | %-10s%n"  Nationality Color Drink Pet Smokes)
  (format t "----------------------------------------------------------------%n")
    (format t "  1   | %-11s | %-6s | %-6s | %-6s | %-10s%n" ?n1 ?c1 ?d1 ?p1 ?s1)
    (format t "  2   | %-11s | %-6s | %-6s | %-6s | %-10s%n" ?n2 ?c2 ?d2 ?p2 ?s2)
    (format t "  3   | %-11s | %-6s | %-6s | %-6s | %-10s%n" ?n3 ?c3 ?d3 ?p3 ?s3)
    (format t "  4   | %-11s | %-6s | %-6s | %-6s | %-10s%n" ?n4 ?c4 ?d4 ?p4 ?s4)
    (format t "  5   | %-11s | %-6s | %-6s | %-6s | %-10s%n" ?n5 ?c5 ?d5 ?p5 ?s5)
    (printout t crlf)
    (halt))

;;;;;;;;;;;;;;;;;;;;;;;
; Start
;;;;;;;;;;;;;;;;;;;;;;;
(defrule startup
   =>
   (assert  (value location 1)
        (value location 2)
        (value location 3)
        (value location 4)
        (value location 5)))

(defrule set-nationality
  ?node <- (value location ?loc) 
  =>
  (retract ?node)
  (assert (value1 ?loc English)
        (value1 ?loc Swedish)
        (value1 ?loc Danish)
        (value1 ?loc Norwegian)
        (value1 ?loc German)))

(defrule set-color
  ?node <- (value1 ?loc ?na) 
  =>
  (retract ?node)
  (assert (value2 ?loc ?na red) 
        (value2 ?loc ?na green)
        (value2 ?loc ?na white)
        (value2 ?loc ?na yellow)
        (value2 ?loc ?na blue)))

(defrule set-pet
  ?node <- (value2 ?loc ?na ?col) 
  =>
  (retract ?node)
  (assert (value3 ?loc ?na ?col dogs) 
        (value3 ?loc ?na ?col birds) 
        (value3 ?loc ?na ?col cats) 
        (value3 ?loc ?na ?col horses) 
        (value3 ?loc ?na ?col fish)))

(defrule set-drink
  ?node <- (value3 ?loc ?na ?col ?pet)
  =>
  (retract ?node)
  (assert (value4 ?loc ?na ?col ?pet water) 
        (value4 ?loc ?na ?col ?pet coffee)
        (value4 ?loc ?na ?col ?pet milk)
        (value4 ?loc ?na ?col ?pet beer)
        (value4 ?loc ?na ?col ?pet tea)))

(defrule set-smokes
  ?node <- (value4 ?loc ?na ?col ?pet ?dri)
  =>
  (retract ?node)
  (assert (statement (location ?loc) (nationality ?na) (color ?col) (pet ?pet) (drink ?dri) (smokes The-Pall-Mall))
        (statement (location ?loc) (nationality ?na) (color ?col) (pet ?pet) (drink ?dri) (smokes Dunhill))
        (statement (location ?loc) (nationality ?na) (color ?col) (pet ?pet) (drink ?dri) (smokes Blend))
        (statement (location ?loc) (nationality ?na) (color ?col) (pet ?pet) (drink ?dri) (smokes Blue-Master))
        (statement (location ?loc) (nationality ?na) (color ?col) (pet ?pet) (drink ?dri) (smokes Prince))))
