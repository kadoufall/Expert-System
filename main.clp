;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;自定义模版;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 景点
(deftemplate attraction
  (slot id)
  (multislot name)
  (multislot location)
  (multislot label)
  (multislot time))
; 城市
(deftemplate city
  (slot id)
  (slot name)
  (slot location)
  (slot discription)
  (multislot transportation)
  (multislot attractions))
; 决策树节点
(deftemplate node
  (slot name)
  (slot type)
  (slot att)
  (slot question)
  (slot node1) (slot node2) (slot node3) (slot node4) (slot node5)
  (multislot answer)
  (slot discription))
; 用于推荐中的临时模版
(deftemplate recommended
  (slot id)
  (multislot name)
  (multislot location)
  (multislot label))
; 用于规则跳转的临时模版
(deftemplate gotoa
  (slot id)
  (multislot content)
  (multislot content1)
  (slot loc))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;初始化;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule initialize
  =>
  (load-facts "facts.dat")
  (printout t "Welcome to use my expert system. This system is designed for Sichuan tourism." crlf)
  (printout t "1.In the first part, I can guess the attraction you think at your heart. But you're supposed to answer some quetions firstly" crlf)
  (printout t "2.In the second part, I can recommend an attraction to you based on your choices." crlf)
  (printout t "3.In the third part, I can generate a tourist route to you based on your choices" crlf)
  (printout t "4.In the fourth part, I can recommend attractions which are similar to your input attraction." crlf)
  (printout t "5.In the fifth part, I can introduce the cities in Sichuan and their attractions shortly." crlf)
  (printout t "Input 1 2 3 4 5 to go to each usecase, input q for exit" crlf)
  (printout t "You can input q to exit wherever the sysytem performs." crlf)
  (printout t crlf)
  (bind ?answer (read))
  (while (and (neq ?answer 1) (neq ?answer 2) (neq ?answer 3) (neq ?answer 4) (neq ?answer 5))
    (if (eq ?answer q)
      then (break)
      else (printout t "Invalid input" crlf) (bind ?answer (read)))
  )
  (if (neq ?answer q)
    then (assert (Go-part ?answer)))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;第一部分;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 初始化第一部分
(defrule initialize-1
  (Go-part 1)
  (not (node (name root)))
  =>
  (load-facts "useCase1.dat")
  (assert (current-node root)))

; 读取yes no
(deffunction which-answer (?question)
  (printout t ?question crlf)
  (bind ?answer (read)  )
  (while (and (neq ?answer yes) (neq ?answer no) (neq ?answer q))
    (printout t ?question crlf)
    (bind ?answer (read)))
  (if (neq ?answer q)
    then (return ?answer))
)

; 读取NEWSC
(deffunction which-answer-location (?question)
  (printout t ?question crlf)
  (bind ?answer (read))
  (while (and (neq ?answer north) (neq ?answer east) (neq ?answer west) (neq ?answer south) (neq ?answer central) (neq ?answer q))
    (printout t ?question crlf)
    (bind ?answer (read)))
  (if (neq ?answer q)
    then (return ?answer))
)

; 打印选择并读取culture nature mixed
(deffunction which-answer-type (?question)
  (printout t ?question crlf)
  (bind ?answer (read))
  (while (and (neq ?answer culture) (neq ?answer nature) (neq ?answer mixed) (neq ?answer q))
    (printout t ?question crlf)
    (bind ?answer (read)))
  (if (neq ?answer q)
    then (return ?answer))
)

; 找到answer
(defrule ask-decision-node-question
  (Go-part 1)
  ?node <- (current-node ?name)
  (node (name ?name)
        (type decision)
        (att ?att)
        (question ?question))
  (not (answer ?))

  =>
  (if (eq ?att type)
    then (assert (answer (which-answer-type ?question)))
    else (if (eq ?att location)
            then (assert (answer (which-answer-location ?question)))
            else (assert (answer (which-answer ?question))))))

; yes，下一个节点
(defrule proceed-to-yes-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node1 ?yes-node))
  ?answer <- (answer yes)
  =>
  (retract ?node ?answer)
  (assert (current-node ?yes-node)))

; no，下一个节点
(defrule proceed-to-no-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node2 ?no-node))
  ?answer <- (answer no)
  =>
  (retract ?node ?answer)
  (assert (current-node ?no-node)))

; north，下一个节点
(defrule proceed-to-north-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node1 ?north-node))
  ?answer <- (answer north)
  =>
  (retract ?node ?answer)
  (assert (current-node ?north-node)))

; east，下一个节点
(defrule proceed-to-east-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node2 ?east-node))
  ?answer <- (answer east)
  =>
  (retract ?node ?answer)
  (assert (current-node ?east-node)))

; west，下一个节点
(defrule proceed-to-west-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node3 ?west-node))
  ?answer <- (answer west)
  =>
  (retract ?node ?answer)
  (assert (current-node ?west-node)))

; south，下一个节点
(defrule proceed-to-south-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node4 ?south-node))
  ?answer <- (answer south)
  =>
  (retract ?node ?answer)
  (assert (current-node ?south-node)))

; central，下一个节点
(defrule proceed-to-central-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node5 ?central-node))
  ?answer <- (answer central)
  =>
  (retract ?node ?answer)
  (assert (current-node ?central-node)))

; nature，下一个节点
(defrule proceed-to-nature-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node2 ?nature-node))
  ?answer <- (answer nature)
  =>
  (retract ?node ?answer)
  (assert (current-node ?nature-node)))

; culture，下一个节点
(defrule proceed-to-culture-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node1 ?culture-node))
  ?answer <- (answer culture)
  =>
  (retract ?node ?answer)
  (assert (current-node ?culture-node)))

; mixed，下一个节点
(defrule proceed-to-mixed-branch
  ?node <- (current-node ?name)
  (node (name ?name)
        (node3 ?mixed-node))
  ?answer <- (answer mixed)
  =>
  (retract ?node ?answer)
  (assert (current-node ?mixed-node)))

; 打印出答案
(defrule get-answer
  ?node <- (current-node ?name)
  (node (name ?name) (type finalAnswer) (answer $?before ?answer  $?after))
  (attraction (name $?attName) (id ?answer))
  =>
  (if (eq ?answer 0)
    then (printout t "Oh, I don't know the attraction!" crlf)
    else (printout t "The attraction may be " ?attName crlf)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;第二部分;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defrule initialize-2
  (Go-part 2)
  (not (node (name root)))
  =>
  (load-facts "useCase2.dat")
  (printout t "In this part, I can recommend to you a special or" crlf)
  (printout t "a series of attractions besed on your choices." crlf)
  (printout t "I'll ask your some questions, then let's begin!" crlf crlf)
  (printout t "Sichuan is a wondeful place for touring. There're many" crlf)
  (printout t "featured attractions, which are the representations " crlf)
  (printout t "of Sichuan. You can also see all kinds of nature or " crlf)
  (printout t "culture attractions. What's more, it's up to you to " crlf)
  (printout t "choose whether consider the expenditure or orientation " crlf)
  (printout t "firstly or not." crlf crlf)
  (printout t "Please input which factor would you consider firstly. featured/nature/culture/expenditure/orientation " crlf)
  (assert (current-node root))
  (assert (current-case 2))
  (assert (recommended ))
)


; 打印选择并读取
(deffunction get-input (?num ?node1 ?node2 ?node3 ?node4 ?node5)
  (bind ?answer (read))
  (if (eq ?num 1)
    then (while (and (neq ?answer q) (neq ?answer ?node1))
            (printout t "Invaid input" crlf)
            (bind ?answer (read))))
  (if (eq ?num 2)
    then (while (and (neq ?answer ?node1) (neq ?answer ?node2) (neq ?answer q))
          (printout t "Invaid input" crlf)
          (bind ?answer (read))))
  (if (eq ?num 3)
    then (while (and (neq ?answer ?node1) (neq ?answer ?node2) (neq ?answer ?node3) (neq ?answer q))
          (printout t "Invaid input" crlf)
          (bind ?answer (read))))
  (if (eq ?num 4)
    then (while (and (neq ?answer ?node1) (neq ?answer ?node2) (neq ?answer ?node3) (neq ?answer ?node4) (neq ?answer q))
          (printout t "Invaid input" crlf)
          (bind ?answer (read))))
  (if (eq ?num 5)
    then (while (and (neq ?answer ?node1) (neq ?answer ?node2) (neq ?answer ?node3) (neq ?answer ?node4) (neq ?answer ?node5) (neq ?answer q))
          (printout t "Invaid input" crlf)
          (bind ?answer (read))))

  (if (eq ?answer q)
    then (exit))

  (if (eq ?answer ?node1)
    then (return 1)
    else (if (eq ?answer ?node2)
            then (return 2)
            else(if (eq ?answer ?node3)
                  then (return 3)
                  else (if (eq ?answer ?node4)
                          then (return 4)
                          else (return 5)))))
)

; 找到answer
(defrule ask-decision-node-question-2
  (Go-part 2)
  ?node <- (current-node ?name)
  (node (name ?name)
        (type decision)
        (att ?att)
        (question ?question)
        (node1 ?node1)(node2 ?node2)(node3 ?node3)(node4 ?node4)(node5 ?node5))
  (not (answer ?))
  (current-case 2)
  =>
  (if (eq ?att type2)
    then (assert (answer (get-input 5 featured nature culture expenditure orientation)))
  )
  (if (eq ?att featured)
    then (printout t "Sichuan has many featured attractions, such as animals places where  " crlf)
         (printout t "have pandas or dinosaur's sites. Scenes such as snow-mountain, " crlf)
         (printout t "beautiful scenery and some special scenery. Sichuan also has plenty of famous" crlf)
         (printout t "World-Heritage and five-A attractions. Famous for Sichuan dish, you can" crlf)
         (printout t "also go to attractions with delicious food. Sichuan has a long history." crlf)
         (printout t "Historic attractions are also recommended" crlf crlf)
         (printout t "Please input which factor would you consider. annimals/scene/famous/food/history " crlf)
         (assert (answer (get-input 5 annimals scene famous food history)))
  )
  (if (eq ?att featured-annimals)
    then (printout t "Sichuan is famous for pandas, the same as dinosaur sites.  " crlf)
         (printout t "Please input which factor would you consider. panda/dinosaur/all " crlf)
         (assert (answer (get-input 3 panda dinosaur all nil nil)))
  )
  (if (eq ?att featured-scene)
    then (printout t "There're many special scenes, such as snow-mountain, very beautiful  " crlf)
         (printout t "scenes and some special scenes" crlf)
         (printout t "Please input which factor would you consider. snow/beauty/special/all " crlf)
         (assert (answer (get-input 4 snow beauty special all nil)))
  )
  (if (eq ?att featured-famous)
    then (printout t "There're many famous scenes, such as World-Heritage and five-A attractions  " crlf)
         (printout t "Please input which factor would you consider. world/five-A/all " crlf)
         (assert (answer (get-input 3 world five-A all nil nil)))
  )
  (if (eq ?att featured-history)
    then (printout t "There're many historic scenes, some of which are commemorate celebrities  " crlf)
         (printout t "some are about the Three-Kingdoms or ancient Shu, some are ancient town. " crlf)
         (printout t "Please input which factor would you consider. celebrity/Three-Kingdoms/ancient-town/ancient-Shu/all " crlf)
         (assert (answer (get-input 5 celebrity Three-Kingdoms ancient-town ancient-Shu all)))
  )
  (if (eq ?att natural)
    then (printout t "Sichuan has a favorable environment. There're many kinds of annimals.  " crlf)
         (printout t "Beautiful landscapes are also common here. A high vegetation coverage " crlf)
         (printout t "guarantees people's health. And as a result of the change of environment, " crlf)
         (printout t "There are also many special natural attractions." crlf)
         (printout t "Please input which factor would you consider. annimals/beauty/health/special " crlf)
         (assert (answer (get-input 4 annimals beauty health special nil)))
  )
  (if (eq ?att cultural)
    then (printout t "Sichuan has a long time history, which means the place is fulled with  " crlf)
         (printout t "cultural atmosphere. Some attractions are commemorate celebrities, some " crlf)
         (printout t "are about religions, some are about Three-Kingdoms, some are about " crlf)
         (printout t "ancient-dynasty, and some are just historic ancient town." crlf)
         (printout t "Please input which factor would you consider. celebrity/religion/Three-Kingdoms/ancient-town/ancient-dynasty " crlf)
         (assert (answer (get-input 5 celebrity religion Three-Kingdoms ancient-town ancient-dynasty)))
  )
  (if (eq ?att panda)
    then (printout t "There're four main places where pandas live. Please choose which city " crlf)
         (printout t "you'd like go or show all: Chengdu/YaAn/Guangyuan/all " crlf)
         (assert (answer (get-input 4 Chengdu YaAn Guangyuan all nil)))
  )
  (if (eq ?att snow-mountain)
    then (printout t "There're four featured snow-mountain. The main differance is the expenditure. " crlf)
         (printout t "You can choose average cost(500-1000/person) or high cost(>1000/person) or all." crlf)
         (printout t "Please input high/average/all" crlf)
         (assert (answer (get-input 3 high average all nil nil)))
  )
  (if (eq ?att special)
    then (printout t "The special featured attractions can be classify into four types. The first is " crlf)
         (printout t "caused by 512 Wenchuan earthquake. The second can be the high Technology. The " crlf)
         (printout t "third can be special natural scenes" crlf)
         (printout t "Please input earthquake/technology/natural/all" crlf)
         (assert (answer (get-input 4 earthquake technology natural all nil)))
  )
  (if (eq ?att health)
    then (printout t "The healthy attractions are located in all the orientations of Sichuan. " crlf)
         (printout t "Most of them have a low cost and you'd not worry about weather also. " crlf)
         (printout t "Please input north/south/west/east/central" crlf)
         (assert (answer (get-input 5 north south west east central)))
  )
  (if (eq ?att celebrity)
    then (printout t "There're many celebrities born in Sichuan. You can choose to see  " crlf)
         (printout t "attractions which is commemorating ancient celebrities or contemporary. " crlf)
         (printout t "Please input ancient/contemporary/all" crlf)
         (assert (answer (get-input 3 ancient contemporary all nil nil)))
  )
  (if (eq ?att religion)
    then (printout t "The religionary attractions can be classify into Buddhist attractions  " crlf)
         (printout t "and Taoist attractions " crlf)
         (printout t "Please input Buddhist/Taoist/all" crlf)
         (assert (answer (get-input 3 Buddhist Taoist all nil nil)))
  )

)
; 处理预算分支,读取输入
(defrule proceed-to-expenditure-0
  (Go-part 2)
  (current-node n4)
  =>
  (printout t "There're all kinds of attractions, which has different cost. The high  " crlf)
  (printout t "cost may be higher than 1000/person. The low cost may be lower than " crlf)
  (printout t "500/person. And the average cost may be 500-1000/person. So which" crlf)
  (printout t "range would you like to choose? Please input high/low/average" crlf)

  (bind ?expenditure (read))
  (while (and (neq ?expenditure high) (neq ?expenditure low) (neq ?expenditure average))
    (if (eq ?expenditure q)
      then (break))
    (printout t "Invalid input" crlf)
    (bind ?expenditure (read))
  )

  (if (eq ?expenditure q)
    then
    else (assert (gotoa (id 1) (content ?expenditure) (loc 1)))
  )
)
; 是否进一步根据种类划分
(defrule proceed-to-expenditure-1
  (Go-part 2)
  ?thisCon <- (gotoa (id 1) (content ?expenditure) (loc 1))
  =>
  (printout t "Would you like to classify the attractions based on culture/nature/mixed" crlf)
  (printout t "If yes, input culture/nature/mixed, else input no" crlf)
  (bind ?choice (read))
  (while (and (neq ?choice culture) (neq ?choice nature) (neq ?choice no) (neq ?choice mixed))
    (if (eq ?choice q)
      then (break))
    (printout t "Invalid input" crlf)
    (bind ?choice (read))
  )

  (if (eq ?choice no)
    then  (modify ?thisCon (content ?expenditure) (loc 2))
    else )
  (if (and (neq ?choice no) (neq ?choice q))
      then (modify ?thisCon (content ?expenditure ?choice) (loc 2)))
  (printout t crlf)
)
; 打印
(defrule proceed-to-expenditure-2
  (Go-part 2)
  ?tem <- (gotoa (id 1) (content $?findLable) (loc 2))
  (attraction (name $?name) (label $?label))
  =>
;  (retract ?tem)
  (if (subsetp ?findLable ?label)
    then (printout t "The attraction may be " ?name crlf))
)
; 处理方位分支
(defrule proceed-to-orientation-0
  (Go-part 2)
  (current-node n5)
  =>
  (printout t "Sichuan has so many attractions, and they are located in all the orientations.  " crlf)
  (printout t "You can choose all five orientations to see the respective attractions. " crlf)
  (printout t "Please input north/east/west/south/central" crlf)
  (bind ?orientation (read))
  (while (and (neq ?orientation north) (neq ?orientation east) (neq ?orientation west) (neq ?orientation south) (neq ?orientation central))
    (if (eq ?orientation q)
      then (break))
    (printout t "Invalid input" crlf)
    (bind ?orientation (read))
  )

  (if (eq ?orientation q)
    then
    else (assert (gotoa (id 2) (content ?orientation) (loc 1)))
  )
)
; 是否进一步根据种类划分
(defrule proceed-to-orientation-1
  (Go-part 2)
  ?thisCon <- (gotoa (id 2) (content ?orientation) (loc 1))
  =>
  (printout t "Would you like to classify the attractions based on culture/nature/mixed" crlf)
  (printout t "If yes, input culture/nature/mixed, else input no" crlf)
  (bind ?choice (read))
  (while (and (neq ?choice culture) (neq ?choice nature) (neq ?choice no) (neq ?choice mixed))
    (if (eq ?choice q)
      then (break))
    (printout t "Invalid input" crlf)
    (bind ?choice (read))
  )

  (if (eq ?choice no)
    then  (modify ?thisCon (content ?orientation) (loc 2))
    else )
  (if (and (neq ?choice no) (neq ?choice q))
      then (modify ?thisCon (content ?orientation) (content1 ?choice) (loc 2)))
  (printout t crlf)
)
; 打印
(defrule proceed-to-orientation-2
  (Go-part 2)
  ?tem <- (gotoa (id 2) (content $?findLoc) (content1 $?findLable) (loc 2))
  (attraction (name $?name) (location $?location) (label $?label))
  =>
  (if (and (subsetp ?findLoc ?location) (eq (length$ ?findLable) 0))
    then (printout t "The attraction may be " ?name crlf))
  (if (and (subsetp ?findLoc ?location) (subsetp ?findLable ?label) (neq (length$ ?findLable) 0))
    then (printout t "The attraction may be " ?name crlf))
)

; 下一个节点
(defrule proceed-to-branch
  (Go-part 2)
  ?oldNode <- (current-node ?name)
  (node (name ?name)
        (node1 ?node1)(node2 ?node2)(node3 ?node3)(node4 ?node4)(node5 ?node5))
  ?oldAnswer <- (answer ?which)
  =>
  (retract ?oldNode ?oldAnswer)
  (if (eq ?which 1)
    then (assert (current-node ?node1)))
  (if (eq ?which 2)
    then (assert (current-node ?node2)))
  (if (eq ?which 3)
    then (assert (current-node ?node3)))
  (if (eq ?which 4)
    then (assert (current-node ?node4)))
  (if (eq ?which 5)
    then (assert (current-node ?node5)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;第三部分;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 初始化
(defrule initialize-3
  (Go-part 3)
  =>
  (printout t "In this part, I'll generate a tourist route to you. Firstly, would" crlf)
  (printout t "you like to consider how to go to Sichuan? I mean that you should choose" crlf)
  (printout t "airplane, train, high-speed-rail, shipping to take. Or if you choose car or " crlf)
  (printout t "coach, it would be no matter which city you arrive in firstly" crlf)
  (printout t "Please input airplane/train/high-speed-rail/shipping/noMatter" crlf)
  (printout t  crlf)
  (assert (current-case 3))

  (bind ?choice (read))
  (while (and (neq ?choice airplane) (neq ?choice train) (neq ?choice high-speed-rail) (neq ?choice shipping) (neq ?choice noMatter))
    (if (eq ?choice q)
      then (break))
    (printout t "Invalid input" crlf)
    (bind ?choice (read))
  )

  (if (eq ?choice q)
    then
    else (assert (gotoa (id 1) (content ?choice)))
        (printout t "You can arrive in the following cities firstly:" crlf)
        (assert (gotoa (id 100) (content)))
        (assert (firstTrans ?choice))
  )
)
; 打印该交通方式下所有的城市
(defrule print-read-city
  (declare (salience 10))
  (Go-part 3)
  (gotoa (id 1) (content $?choice))
  (city (id ?id) (name ?name) (transportation $?transportation))
  ?tem <- (gotoa (id 100) (content $?con&:(not (member$ ?id $?con))))
  =>
  (if (eq ?choice noMatter)
    then (printout t ?id " " ?name crlf)
         (modify ?tem (content (insert$ ?con 1 ?id)))
  )
  (if (subsetp ?choice ?transportation)
    then (printout t ?id " " ?name crlf)
         (modify ?tem (content (insert$ ?con 1 ?id)))
  )
)
; 读取输入：起点城市
(defrule print-read-city-1
  (declare (salience 9))
  (Go-part 3)
  ?tem <- (gotoa (id 100) (content $?con))    ; 当前交通方式下所有的城市
  =>
  (printout t "" crlf)
  (printout t "Please choose the city where you want to arrive firstly" crlf)
  (printout t "Please input the city's id " crlf)

  (bind ?choice (read))
  (while (not (member$ ?choice $?con))
    (if (eq ?choice q)
      then (break))
    (printout t "Invalid input" crlf)
    (bind ?choice (read))
  )

  (if (eq ?choice q)
    then
    else (assert (firstCity ?choice))
         (assert (gotoa (id 99) (content)))
         (assert (gotoa (id 98) (content)))
         (assert (moreCity 0))
         (printout t "The first city has the following attractions:" crlf)
  )
)
; 输出起点城市的景点
(defrule print-read-city-2
  (declare (salience 9))
  (firstCity ?choice)
  (city (id ?choice) (name ?cityName))
  (attraction (id ?id) (name $?name) (location $?location&:(member$ ?cityName $?location)))
  ?tem <- (gotoa (id 99) (content $?con&:(not (member$ ?id $?con)))) ; 当前城市所有的景点
  =>
  (printout t ?id " " ?name crlf)
  (modify ?tem (content (insert$ ?con 1 ?id)))
)
; 添加起点城市景点
(defrule print-read-city-3
  (declare (salience 8))
  ?temm <- (gotoa (id 99) (content $?con))   ; 当前城市所有的景点
  ?temm1 <- (gotoa (id 98) (content $?con1))  ; 行程单
  ?more <- (moreCity 0)
  =>
  (printout t "Please input the attractions' id if you want to go " crlf)
  (printout t "You can input only one attraction once. Input q to stop adding or there is no attractions" crlf)

  (bind ?choice (read))
  (while (not (member$ ?choice ?con))
    (if (eq ?choice q)
      then (break))
    (printout t "Invalid input" crlf)
    (bind ?choice (read))
  )

  (if (eq ?choice q)
    then (retract ?more)(assert (moreCity 1))
         (printout t "Let's add more attractions to our tourist route" crlf)
         (printout t "More cities are as follows:" crlf)
         (assert (gotoa (id 97) (content)))  ; 更多城市List
    else (modify ?temm1 (content (insert$ ?con1 1 ?choice)))     ; 行程景点
  )

)
; 打印更多城市并添加到城市list
(defrule print-read-city-4
  (declare (salience 8))
  (moreCity 1)
  (firstCity ?firstCity)
  ?tem <- (gotoa (id 97) (content $?con))
  (city (id ?id&~?firstCity&:(not (member$ ?id $?con))) (name ?name) (attractions $?attractions&:(neq 0 (length$ $?attractions))))
  =>
  (printout t ?id " " ?name crlf)
  (modify ?tem (content (insert$ ?con 1 ?id)))
)

; 选择城市
(defrule print-read-city-5
  (declare (salience 7))
  (gotoa (id 97) (content $?con))
  ?more <- (moreCity 1)
  (firstCity ?firstCity)
  (city (id ?firstCity) (name ?name))
  (firstTrans ?firstTrans)
  =>
  (printout t "Input city's id to see more attractions. Input q to stop adding" crlf)
  (bind ?choice (read))
  (while (not (member$ ?choice ?con))
    (if (eq ?choice q)
      then (break))
    (printout t "Invalid input" crlf)
    (bind ?choice (read))
  )

  (if (eq ?choice q)
    then (retract ?more) (assert (print-answer 1))
         (printout t crlf)
         (printout t "You have got the final route!" crlf)
         (printout t "You'll take " ?firstTrans " to " ?name " to start your trip" crlf )
         (printout t "The serial attractions are as follows" crlf)
    else (retract ?more) (assert (moreCityAtt ?choice)) (assert (gotoa (id 96) (content )))   ; 更多城市的景点
        (assert (returnCityList 0))
  )
)
; 打印选定城市的景点
(defrule print-read-city-6
  (declare (salience 7))
  (moreCityAtt ?choice)
  (city (id ?choice) (name ?cityName))
  (attraction (id ?id) (name $?name) (location $?location&:(member$ ?cityName $?location)))
  ?tem <- (gotoa (id 96) (content $?con&:(not (member$ ?id $?con)))) ; 当前城市所有的景点
  =>
  (printout t ?id " " ?name crlf)
  (modify ?tem (content (insert$ ?con 1 ?id)))
)
; 添加更多城市的景点
(defrule print-read-city-7
  (declare (salience 6))
  ?temm <- (gotoa (id 96) (content $?con))   ; 当前城市所有的景点
  ?temm1 <- (gotoa (id 98) (content $?con1))  ; 行程单
  ?temm2 <- (returnCityList 0)
  ?temm3 <- (moreCityAtt ?)
  =>
  (printout t "Please input the attractions' id if you want to go " crlf)
  (printout t "You can input only one attraction once. Input q to return city list" crlf)

  (bind ?choice (read))
  (while (not (member$ ?choice ?con))
    (if (eq ?choice q)
      then (break))
    (printout t "Invalid input" crlf)
    (bind ?choice (read))
  )

  (if (eq ?choice q)
    then (assert (moreCity 1)) (retract ?temm)
         (retract ?temm2) (assert (returnCityListTem 1)) (retract ?temm3)
         (printout t crlf)
    else (modify ?temm1 (content (insert$ ?con1 1 ?choice)))     ; 行程景点
  )
)
; 在返回城市菜单时打印更多城市
(defrule print-read-city-9
  (declare (salience 8))
  (moreCity 1)
  (firstCity ?firstCity)
  (returnCityListTem 1)
  ?tem <- (gotoa (id 97) (content $?con))
  (city (id ?id&~?firstCity&:(member$ ?id $?con)) (name ?name))
  =>
  (printout t ?id " " ?name crlf)
)
; 取出行程单的最后一个数据
(defrule print-answer-10
  (print-answer 1)
  (gotoa (id 98) (content $?con))
  =>
  (bind ?len (length$ ?con))
  (loop-for-count (?cnt 1 ?len) do
    (assert (finalAtt (nth$ ?cnt ?con))))
)
; 打印最后的结果
(defrule print-answer-11
  (declare (salience 10))
  (finalAtt ?id)
  (attraction (id ?id) (name $?name))
  =>
  (printout t ?name crlf)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;第四部分;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 初始化
(defrule initialize-4
  (Go-part 4)
  =>
  (printout t "In this part, I'll recommend to you some attractions which are" crlf)
  (printout t "similar to your input. The id associated with the attractions is" crlf)
  (printout t "as follows: " crlf)
  (printout t  crlf)
  (assert (current-case 4))
)
; 打印景点
(defrule print-id
  (declare (salience 10))
  (current-case 4)
  (attraction (name $?name) (id ?id))
  =>
  (if (neq 0 ?id)
    then (printout t ?id" " ?name crlf))
)
; 读取输入的景点
(defrule read-id
  (declare (salience 9))
  (current-case 4)
  =>
  (printout t crlf)
  (printout t "Please input the id of the attraction" crlf)
  (bind ?readID (read))
  (while (or (> ?readID 60) (< ?readID 0))
    (printout t "Invaid input" crlf)
    (bind ?readID (read))
  )
  (assert (recommended (id ?readID)))
  (printout t "The recommended attractions are as follows:" crlf)
  (printout t crlf)
)
; 推荐等级1
(defrule recommend-level-1
  (declare (salience 10))
  (recommended (id ?readID))
  (attraction (id ?readID) (name $?name)(label $?label))
  (attraction (id ?readID1&~?readID) (name $?name1)(label $?label1))
  =>
  (if (and (member$ earthquake ?label) (member$ earthquake ?label1))
    then (printout t "Level 1: " ?name1 "--on the basis of earthquake site" crlf))
  (if (and (member$ ancient-Shu ?label) (member$ ancient-Shu ?label1))
    then (printout t "Level 1: " ?name1 "--on the basis of ancient-Shu site" crlf))
  (if (and (member$ panda ?label) (member$ panda ?label1))
    then (printout t "Level 1: " ?name1 "--on the basis of panda" crlf))
  (if (and (member$ Buddhism ?label) (member$ Buddhism ?label1))
    then (printout t "Level 1: " ?name1 "--on the basis of Buddhism" crlf))
  (if (and (member$ snow-mountain ?label) (member$ snow-mountain ?label1))
    then (printout t "Level 1: " ?name1 "--on the basis of snow-mountain" crlf))
  (if (and (member$ Three-Kingdoms ?label) (member$ Three-Kingdoms ?label1))
    then (printout t "Level 1: " ?name1 "--on the basis of Three-Kingdoms" crlf))
  (if (and (member$ Science-and-Technology ?label) (member$ Science-and-Technology ?label1))
    then (printout t "Level 1: " ?name1 "--on the basis of Science-and-Technology" crlf))
  (if (and (member$ special ?label) (member$ special ?label1))
    then (printout t "Level 1: " ?name1 "--on the basis of special attractions" crlf))
)

(defrule recommend-level-2
  (declare (salience 9))
  (recommended (id ?readID))
  (attraction (id ?readID) (name $?name)(label $?label))
  (attraction (id ?readID1&~?readID) (name $?name1)(label $?label1))
  =>
  (if (and (member$ forest ?label) (member$ forest ?label1))
    then (printout t "Level 2: " ?name1 "--on the basis of forest" crlf))
  (if (and (member$ celebrity ?label) (member$ celebrity ?label1))
    then (printout t "Level 2: " ?name1 "--on the basis of commemorating celebrity" crlf))
  (if (and (member$ ancient-town ?label) (member$ ancient-town ?label1))
    then (printout t "Level 2: " ?name1 "--on the basis of ancient-town" crlf))
  (if (and (member$ food ?label) (member$ food ?label1))
    then (printout t "Level 2: " ?name1 "--on the basis of delicious food" crlf))
  (if (and (member$ World-Heritage ?label) (member$ World-Heritage ?label1))
    then (printout t "Level 2: " ?name1 "--on the basis of World-Heritage" crlf))
)

(defrule recommend-level-3
  (declare (salience 8))
  (recommended (id ?readID))
  (attraction (id ?readID) (name $?name)(label $?label))
  (attraction (id ?readID1&~?readID) (name $?name1)(label $?label1))
  =>
  (if (and (member$ five-A ?label) (member$ five-A ?label1))
    then (printout t "Level 3: " ?name1 "--on the basis of five-A attractions" crlf))
  (if (and (member$ folk ?label) (member$ folk ?label1))
    then (printout t "Level 3: " ?name1 "--on the basis of respective special folk" crlf))
  (if (and (member$ ancient ?label) (member$ ancient ?label1))
    then (printout t "Level 3: " ?name1 "--on the basis of ancient attractions" crlf))
  (if (and (member$ museum ?label) (member$ museum ?label1))
    then (printout t "Level 3: " ?name1 "--on the basis of museum" crlf))
)

(defrule recommend-level-4
  (declare (salience 7))
  (recommended (id ?readID))
  (attraction (id ?readID) (name $?name) (location $?location) (label $?label))
  (attraction (id ?readID1&~?readID) (name $?name1) (location $?location1) (label $?label1))
  =>
  (if (and (member$ low ?label) (member$ low ?label1))
    then (printout t "Level 4: " ?name1 "--on the basis of low expenditure" crlf))
  (if (and (member$ average ?label) (member$ average ?label1))
    then (printout t "Level 4: " ?name1 "--on the basis of average expenditure" crlf))
  (if (and (member$ high ?label) (member$ high ?label1))
    then (printout t "Level 4: " ?name1 "--on the basis of high expenditure" crlf))
)

(defrule recommend-level-5
  (declare (salience 6))
  (recommended (id ?readID))
  (attraction (id ?readID) (name $?name) (location $?location) (label $?label))
  (attraction (id ?readID1&~?readID) (name $?name1) (location $?location1) (label $?label1))
  =>
  (if (eq ?location ?location1)
    then (printout t "Level 5: " ?name1 "--on the basis of the same city" crlf))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;第五部分;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 初始化
(defrule initialize-5
  (Go-part 5)
  =>
  (printout t "In this part, I'll introduce all the cities in Sichuan, including" crlf)
  (printout t "their location, transportation, discription and attractions. If " crlf)
  (printout t "my database has the attraction associated with the city, I can also" crlf)
  (printout t "introduce more details of the attractions. The city's id is as follows: " crlf)
  (printout t  crlf)
  (assert (current-case 5))
)
; 打印城市
(defrule print-city-id
  (declare (salience 10))
  (current-case 5)
  (city (name ?name) (id ?id))
  =>
  (if (neq 0 ?id)
    then (printout t ?id" " ?name crlf))
)
; 读取输入
(defrule read-city-id
  (declare (salience 9))
  (current-case 5)
  =>
  (printout t crlf)
  (printout t "Please input the id of the city. Input q for exit" crlf)
  (bind ?readID (read))
  (if (eq ?readID q)
    then
    else (while (or (> ?readID 21) (< ?readID 0))
            (printout t "Invaid input" crlf)
            (bind ?readID (read))
          )
          (assert (inputCity ?readID))
          (printout t "The recommended attractions are as follows: " crlf)
          (printout t crlf))
)
; 打印详细城市信息
(defrule print-city-info
  (declare (salience 9))
  (current-case 5)
  (inputCity ?readID)
  (city (id ?readID) (name ?name) (location ?location)(transportation $?transportation) (discription ?discription) (attractions $?attractions))
  =>
  (printout t ?name " is located in the " ?location " of Sichuan." crlf)
  (printout t "The city can be shortly introduced by: " ?discription "." crlf)
  (printout t "You can take " ?transportation " to the city." crlf)
  (if (neq (length$ ?attractions) 0)
    then (printout t "The attractions of the city which in our database are as follows:" crlf)
         (printout t crlf))
)
; 打印景点id
(defrule print-city-info-2
  (declare (salience 8))
  (current-case 5)
  (inputCity ?readID)
  (city (id ?readID) (name ?name) (location ?location)(transportation $?transportation) (discription ?discription) (attractions $?attractions))
  (attraction (id ?id1) (name $?name1) (location $?location1) (label $?label1) (time $?time1))
  =>
  (if (member$ ?id1 ?attractions)
    then (printout t ?id1 " " ?name1  crlf ))
)
; 读取景点
(defrule read-city-attraction
  (declare (salience 7))
  (current-case 5)
  (inputCity ?readID)
  (city (id ?readID) (name ?name) (location ?location)(transportation $?transportation) (discription ?discription) (attractions $?attractions))
  =>
  (printout t "If you want to see more details of above attractions," crlf)
  (printout t "Please input the attraction's id. Input q for exit" crlf)
  (bind ?readID1 (read))
  (while (not (member$ ?readID1 ?attractions))
    (if (eq ?readID1 q)
      then (break))
    (printout t "Invaid input" crlf)
    (bind ?readID1 (read))
  )
  (if (neq ?readID1 q)
    then (assert (printAttId ?readID1)))

)
; 打印景点详细信息
(defrule print-city-info-3
  (declare (salience 6))
  (current-case 5)
  (inputCity ?readID)
  (printAttId ?readID1)
  (city (id ?readID) (name ?name) (location ?location)(transportation $?transportation) (discription ?discription) (attractions $?attractions))
  (attraction (id ?readID1) (name $?name1) (location $?location1) (label $?label1) (time $?time1))
  =>
  (if (member$ ?readID1 ?attractions)
    then (printout t ?name1 " is fit for " ?time1  crlf )
         (printout t "    and the labels we tied to it are " ?label1  crlf)
         (printout t crlf))
)
