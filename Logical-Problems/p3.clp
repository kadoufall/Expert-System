  (deftemplate statement
  (slot type)
  (slot value)
  (slot host))


; Doc-Tito-lie
(defrule Doc-Tito-lie
  ; Order: George, Doc, Tito, Jimmy.
  (statement (type name) (value George) (host ?n1))
  (statement (type name) (value Doc) (host ?n2))
  (statement (type name) (value Tito) (host ?n3))
  (statement (type name) (value Jimmy) (host ?n4))

  ?node1 <- (statement (type Gas-Mileage) (value ?George-Gas-Value) (host ?n1))
  ?node2 <- (statement (type Gas-Mileage) (value ?Doc-Gas-Value&~?George-Gas-Value) (host ?n2))
  ?node3 <- (statement (type Gas-Mileage) (value ?Tito-Gas-Value&~?Doc-Gas-Value&~?George-Gas-Value) (host ?n3))
  ?node4 <- (statement (type Gas-Mileage) (value ?Jimmy-Gas-Value&~?Doc-Gas-Value&~?Tito-Gas-Value&~?George-Gas-Value) (host ?n4))

  ; lie
  ; Doc said: My gas mileage is 20 miles per gallon
  ?gas2 <- (statement (type Gas-Mileage) (value 20) (host ?g2&~?n2))

  ; George said: The guy who owns the Ford is getting 30 miles per gallon.
  ; The guy who gets 20 miles per gallon doesn't own a Chevrolet.
  (statement (type car) (value Ford) (host ?c1))
  ?gas3 <- (statement (type Gas-Mileage) (value 30) (host ?g3&~?g2&?c1))
  (statement (type car) (value Chevrolet) (host ?c2&~?c1&~?g2))

  ; Jimmy said: Doc doesn't drive  a Toyota.
  ; Tito's gas mileage is higher than the guy who drives the Dodge.
  (statement (type car) (value Toyota) (host ?c3&~?c2&~?c1&~?n2))
  (statement (type car) (value Dodge) (host ?c4&~?c3&~?c2&~?c1))
  ?node <- (statement (type Gas-Mileage) (value ?DriveDodge-Gas-Value) (host ?c4))
  (test (> ?Tito-Gas-Value ?DriveDodge-Gas-Value))

  ; lie
  ; Tito said: Doc gets 20 miles per gallon of gas
  ; George's gas mileage is better than Jimmy's.
  (test (< ?George-Gas-Value ?Jimmy-Gas-Value))

  ?gas1 <- (statement (type Gas-Mileage) (value 15) (host ?g1&~?g2&~?g3))
  ?gas4 <- (statement (type Gas-Mileage) (value 25) (host ?g4&~?g1&~?g2&~?g3))

  =>

  (if (or (eq ?node1 ?gas1) (eq ?node1 ?gas2) (eq ?node1 ?gas3) (eq ?node1 ?gas4))
    then (if (or (eq ?node2 ?gas1) (eq ?node2 ?gas2))
      then (if (or (eq ?node3 ?gas1) (eq ?node3 ?gas2))
        then (if (or (eq ?node4 ?gas1) (eq ?node4 ?gas2) (eq ?node4 ?gas3) (eq ?node4 ?gas4))
              then (if (or (eq ?node ?gas1) (eq ?node ?gas2) (eq ?node ?gas3) (eq ?node ?gas4))
                    then (assert (solution name George ?n1)
                                (solution car Ford ?c1)
                                (solution name Doc ?n2)
                                (solution Gas-Mileage 20 ?g2)
                                (solution car Chevrolet ?c2)
                                (solution car Toyota ?c3)
                                (solution Gas-Mileage 30 ?g3)
                                (solution name Tito ?n3)
                                (solution name Jimmy ?n4)
                                (solution Gas-Mileage 15 ?g1)
                                (solution Gas-Mileage 25 ?g4)
                                (solution car Dodge ?c4))
                    )
              )
        )
    )
  )

)

; George-Jimmy-lie
(defrule George-Jimmy-lie
  ; Order: George, Doc, Tito, Jimmy.
  (statement (type name) (value George) (host ?n1))
  (statement (type name) (value Doc) (host ?n2))
  (statement (type name) (value Tito) (host ?n3))
  (statement (type name) (value Jimmy) (host ?n4))

  ?node1 <- (statement (type Gas-Mileage) (value ?George-Gas-Value) (host ?n1))
  ?node2 <- (statement (type Gas-Mileage) (value ?Doc-Gas-Value&~?George-Gas-Value) (host ?n2))
  ?node3 <- (statement (type Gas-Mileage) (value ?Tito-Gas-Value&~?Doc-Gas-Value&~?George-Gas-Value) (host ?n3))
  ?node4 <- (statement (type Gas-Mileage) (value ?Jimmy-Gas-Value&~?Doc-Gas-Value&~?Tito-Gas-Value&~?George-Gas-Value) (host ?n4))

  ; Doc said: My gas mileage is 20 miles per gallon
  ?gas2 <- (statement (type Gas-Mileage) (value 20) (host ?g2&?n2))

  ; lie
  ; George said: The guy who owns the Ford is getting 30 miles per gallon.
  ; The guy who gets 20 miles per gallon doesn't own a Chevrolet.
  (statement (type car) (value Ford) (host ?c1))
  ?gas3 <- (statement (type Gas-Mileage) (value 30) (host ?g3&~?g2&~?c1))
  (statement (type car) (value Chevrolet) (host ?c2&~?c1&?g2))

  ; lie
  ; Jimmy said: Doc doesn't drive  a Toyota.
  ; Tito's gas mileage is higher than the guy who drives the Dodge.
  (statement (type car) (value Toyota) (host ?c3&~?c2&~?c1&~?n2))
  (statement (type car) (value Dodge) (host ?c4&~?c3&~?c2&~?c1))
  ?node <- (statement (type Gas-Mileage) (value ?DriveDodge-Gas-Value) (host ?c4))
  (test (< ?Tito-Gas-Value ?DriveDodge-Gas-Value))

  ; Tito said: Doc gets 20 miles per gallon of gas
  ; George's gas mileage is better than Jimmy's.
  (test (> ?George-Gas-Value ?Jimmy-Gas-Value))

  ?gas1 <- (statement (type Gas-Mileage) (value 15) (host ?g1&~?g2&~?g3))
  ?gas4 <- (statement (type Gas-Mileage) (value 25) (host ?g4&~?g1&~?g2&~?g3))

  =>

  (if (or (eq ?node1 ?gas1) (eq ?node1 ?gas2))
    then (if (or (eq ?node2 ?gas1) (eq ?node2 ?gas2) (eq ?node2 ?gas3) (eq ?node2 ?gas4))
      then (if (or (eq ?node3 ?gas1) (eq ?node3 ?gas2) (eq ?node3 ?gas3) (eq ?node3 ?gas4))
        then (if (or (eq ?node4 ?gas1) (eq ?node4 ?gas2))
              then (if (or (eq ?node ?gas1) (eq ?node ?gas2) (eq ?node ?gas3) (eq ?node ?gas4))
                    then (assert (solution name George ?n1)
                                (solution car Ford ?c1)
                                (solution name Doc ?n2)
                                (solution Gas-Mileage 20 ?g2)
                                (solution car Chevrolet ?c2)
                                (solution car Toyota ?c3)
                                (solution Gas-Mileage 30 ?g3)
                                (solution name Tito ?n3)
                                (solution name Jimmy ?n4)
                                (solution Gas-Mileage 15 ?g1)
                                (solution Gas-Mileage 25 ?g4)
                                (solution car Dodge ?c4))
                    )
              )
        )
    )
  )

)

(defrule print-solution
  ?f1 <- (solution name ?n1 1)
  ?f2 <- (solution car ?c1 1)
  ?f3 <- (solution name ?n2 2)
  ?f4 <- (solution Gas-Mileage ?g1 1)
  ?f5 <- (solution car ?c2 2)
  ?f6 <- (solution car ?c3 3)
  ?f7 <- (solution Gas-Mileage ?g2 2)
  ?f8 <- (solution name ?n3 3)
  ?f9 <- (solution name ?n4 4)
  ?f10 <- (solution Gas-Mileage ?g3 3)
  ?f11 <- (solution Gas-Mileage ?g4 4)
  ?f12 <- (solution car ?c4 4)
  =>
  (retract ?f1 ?f2 ?f3 ?f4 ?f5 ?f6 ?f7 ?f8 ?f9 ?f10 ?f11 ?f12)
  (format t "Index | %-6s | %-9s | %-5s%n"  Name Car Gas-Mileage)
  (format t "------------------------------------------%n")
  (format t "  1   | %-6s | %-9s | %-5d%n" ?n1 ?c1 ?g1)
  (format t "  2   | %-6s | %-9s | %-5d%n" ?n2 ?c2 ?g2)
  (format t "  3   | %-6s | %-9s | %-5d%n" ?n3 ?c3 ?g3)
  (format t "  4   | %-6s | %-9s | %-5d%n" ?n4 ?c4 ?g4)
  (printout t crlf))

(defrule startup
   =>
   (assert (statement (type name) (value George) (host 1))
           (statement (type name) (value Doc) (host 2))
           (statement (type name) (value Tito) (host 3))
           (statement (type name) (value Jimmy) (host 4))
           (statement (type car) (value Ford) (host 1))
           (statement (type car) (value Ford) (host 2))
           (statement (type car) (value Ford) (host 3))
           (statement (type car) (value Ford) (host 4))
           (statement (type car) (value Chevrolet) (host 1))
           (statement (type car) (value Chevrolet) (host 2))
           (statement (type car) (value Chevrolet) (host 3))
           (statement (type car) (value Chevrolet) (host 4))
           (statement (type car) (value Dodge) (host 1))
           (statement (type car) (value Dodge) (host 2))
           (statement (type car) (value Dodge) (host 3))
           (statement (type car) (value Dodge) (host 4))
           (statement (type car) (value Toyota) (host 1))
           (statement (type car) (value Toyota) (host 3))
           (statement (type car) (value Toyota) (host 4))
           (statement (type Gas-Mileage) (value 30) (host 1))
           (statement (type Gas-Mileage) (value 30) (host 2))
           (statement (type Gas-Mileage) (value 30) (host 3))
           (statement (type Gas-Mileage) (value 30) (host 4))
           (statement (type Gas-Mileage) (value 25) (host 1))
           (statement (type Gas-Mileage) (value 25) (host 2))
           (statement (type Gas-Mileage) (value 25) (host 3))
           (statement (type Gas-Mileage) (value 25) (host 4))
           (statement (type Gas-Mileage) (value 20) (host 1))
           (statement (type Gas-Mileage) (value 20) (host 2))
           (statement (type Gas-Mileage) (value 20) (host 3))
           (statement (type Gas-Mileage) (value 20) (host 4))
           (statement (type Gas-Mileage) (value 15) (host 1))
           (statement (type Gas-Mileage) (value 15) (host 2))
           (statement (type Gas-Mileage) (value 15) (host 3))
           (statement (type Gas-Mileage) (value 15) (host 4)))
)
