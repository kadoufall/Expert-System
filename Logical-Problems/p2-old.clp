(deftemplate statement 
  (slot type) 
  (slot value) 
  (slot host))

(defrule find-solution
  ; The English lives in the red house
  (statement (type nationality) (value English) (host ?n1))
  (statement (type color) (value red) (host ?c1&?n1))

  ; The Swedish keeps dogs
  (statement (type nationality) (value Swedish) (host ?n2&~?n1))
  (statement (type pet) (value dogs) (host ?p1&?n2))

  ; The Danish drinks tea
  (statement (type nationality) (value Danish) (host ?n3&~?n2&~?n1))
  (statement (type drink) (value tea) (host ?d1&?n3))

  ; The green house is just to the left of the white one
  ; The owner of the green house drinks coffee
  (statement (type color) (value white) (host ?c2&~?c1))
  (statement (type color) (value green) (host ?c3&~?c2&~?c1&=(- ?c2 1)))
  (statement (type drink) (value coffee) (host ?d2&~?d1&?c3))

  ; The Pall Mall smoker keeps birds
  (statement (type smokes) (value The-Pall-Mall) (host ?s1))
  (statement (type pet) (value birds) (host ?p2&~?p1&?s1))

  ; The owner of the yellow house smokes Dunhill
  (statement (type color) (value yellow) (host ?c4&~?c3&~?c2&~?c1))
  (statement (type smokes) (value Dunhill) (host ?s2&~?s1&?c4))

  ; The man in the center house drinks milk
  (statement (type drink) (value milk) (host ?d3&~?d2&~?d1&3))

  ; The Norwegian lives in the first house
  (statement (type nationality) (value Norwegian) (host ?n4&~?n3&~?n2&~?n1&1))

  ; The Blend smoker has a neighbor who keeps cats
  (statement (type smokes) (value Blend) (host ?s3&~?s2&~?s1))
  (statement (type pet) (value cats) (host ?p3&~?p2&~?p1&:(or (= ?s3 (- ?p3 1)) (= ?s3 (+ ?p3 1)))))

  ; The man who keeps horses lives next to the Dunhill smoker
  (statement (type pet) (value horses) (host ?p4&~?p3&~?p2&~?p1))
  (statement (type smokes) (value Dunhill) (host ?s2&~?s1&:(or (= ?p4 (- ?s2 1)) (= ?p4 (+ ?s2 1)))))

  ; The man who smokes Blue-Master drinks beer
  (statement (type smokes) (value Blue-Master) (host ?s4&~?s3&~?s2&~?s1))
  (statement (type drink) (value beer) (host ?d4&~?d3&~?d2&~?d1&?s4))

  ; The German smokes Prince
  (statement (type nationality) (value German) (host ?n5&~?n4&~?n3&~?n2&~?n1))
  (statement (type smokes) (value Prince) (host ?s5&~?s4&~?s3&~?s2&~?s1&?n5))

  ; The Norwegian lives next to the blue house
  (statement (type color) (value blue) (host ?c5&~?c4&~?c3&~?c2&~?c1&:(or (= ?c5 (- ?n4 1)) (= ?c5 (+ ?n4 1)))))

  ; The Blend smoker has a neighbor who drinks water
  (statement (type drink) (value water) (host ?d5&~?d4&~?d3&~?d2&~?d1&:(or (= ?d5 (- ?s3 1)) (= ?d5 (+ ?s3 1)))))

  ; Who keeps fish
  (statement (type pet) (value fish) (host ?p5&~?p4&~?p3&~?p2&~?p1))

  => 
  (assert (solution nationality English ?n1)
          (solution color red ?c1)
          (solution nationality Swedish ?n2)
          (solution pet dogs ?p1)
          (solution color white ?c2)
          (solution color green ?c3)
          (solution drink tea ?d1)
          (solution drink coffee ?d2) 
          (solution smokes The-Pall-Mall ?s1)
          (solution pet birds ?p2)
          (solution nationality Danish ?n3)
          (solution drink milk ?d3)
          (solution nationality Norwegian ?n4)
          (solution smokes Dunhill ?s2)
          (solution pet cats ?p3)
          (solution smokes Blend ?s3)
          (solution drink beer ?d4) 
          (solution nationality German ?n5)
          (solution smokes Blue-Master ?s4)
          (solution pet horses ?p4) 
          (solution smokes Prince ?s5)
          (solution color yellow ?c4)
          (solution color blue ?c5)
          (solution drink water ?d5)
          (solution pet fish ?p5))
  )

(defrule print-solution
  ?f1 <- (solution nationality ?n1 1)
  ?f2 <- (solution color ?c1 1)
  ?f3 <- (solution pet ?p1 1)
  ?f4 <- (solution drink ?d1 1)
  ?f5 <- (solution smokes ?s1 1)
  ?f6 <- (solution nationality ?n2 2)
  ?f7 <- (solution color ?c2 2)
  ?f8 <- (solution pet ?p2 2)
  ?f9 <- (solution drink ?d2 2)
  ?f10 <- (solution smokes ?s2 2)
  ?f11 <- (solution nationality ?n3 3)
  ?f12 <- (solution color ?c3 3)
  ?f13 <- (solution pet ?p3 3)
  ?f14 <- (solution drink ?d3 3)
  ?f15 <- (solution smokes ?s3 3)
  ?f16 <- (solution nationality ?n4 4)
  ?f17 <- (solution color ?c4 4)
  ?f18 <- (solution pet ?p4 4)
  ?f19 <- (solution drink ?d4 4)
  ?f20 <- (solution smokes ?s4 4)
  ?f21 <- (solution nationality ?n5 5)
  ?f22 <- (solution color ?c5 5)
  ?f23 <- (solution pet ?p5 5)
  ?f24 <- (solution drink ?d5 5)
  ?f25 <- (solution smokes ?s5 5)
  =>
  (retract ?f1 ?f2 ?f3 ?f4 ?f5 ?f6 ?f7 ?f8 ?f9 ?f10 ?f11 ?f12 ?f13 ?f14
           ?f15 ?f16 ?f17 ?f18 ?f19 ?f20 ?f21 ?f22 ?f23 ?f24 ?f25)
  (format t "HOUSE | %-11s | %-6s | %-6s | %-12s | %-13s%n" 
            Nationality Color Pet Drink Smokes)
  (format t "--------------------------------------------------------------------%n")
  (format t "  1   | %-11s | %-6s | %-6s | %-12s | %-13s%n" ?n1 ?c1 ?p1 ?d1 ?s1)
  (format t "  2   | %-11s | %-6s | %-6s | %-12s | %-13s%n" ?n2 ?c2 ?p2 ?d2 ?s2)
  (format t "  3   | %-11s | %-6s | %-6s | %-12s | %-13s%n" ?n3 ?c3 ?p3 ?d3 ?s3)
  (format t "  4   | %-11s | %-6s | %-6s | %-12s | %-13s%n" ?n4 ?c4 ?p4 ?d4 ?s4)
  (format t "  5   | %-11s | %-6s | %-6s | %-12s | %-13s%n" ?n5 ?c5 ?p5 ?d5 ?s5)
  (printout t crlf crlf))

(defrule startup
   =>
   (assert (value color red) 
           (value color green) 
           (value color white)
           (value color yellow)
           (value color blue)
           (value nationality English)
           (value nationality Swedish)
           (value nationality Danish) 
           (value nationality Norwegian)
           (value nationality German)
           (value pet dogs)
           (value pet birds)
           (value pet cats)
           (value pet horses)
           (value pet fish)
           (value drink water)
           (value drink coffee)
           (value drink milk)
           (value drink beer)
           (value drink tea)
           (value smokes The-Pall-Mall)
           (value smokes Dunhill)
           (value smokes Blend)
           (value smokes Blue-Master)
           (value smokes Prince)) 
   )

(defrule generate-combinations
   ?f <- (value ?s ?e)
   =>
   (retract ?f)
   (assert (statement (type ?s) (value ?e) (host 1))
           (statement (type ?s) (value ?e) (host 2))
           (statement (type ?s) (value ?e) (host 3))
           (statement (type ?s) (value ?e) (host 4))
           (statement (type ?s) (value ?e) (host 5))))



