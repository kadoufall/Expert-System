# Expert-System

基于[CLIPS](http://www.clipsrules.net/)实现的简单专家系统，主题是四川旅游

 - 猜测用户描述的旅游地在哪里
	- 使用前：`（clear）(load) (reset) (run) `
    - 输入1，进入第一个模块，然后根据问题输入相应的值进入下一个问题。在所有问题结束后得到系统猜测的旅游地
    - 输入q可以退出当前环节
    - 每一次猜测完毕后若要重新进行下一次猜测，需要输入`(reset) (run) `
- 根据一些问题和判定，推荐特定的旅游地
	- 使用前：`（clear）(load) (reset) (run) `
    - 输入2，进入第二个模块，然后根据问题输入相应的值进入下一个问题。在所有问题结束后得到系统推荐的旅游地
    - 输入q直接退出整个环境
    - 每一次推荐完毕后若要重新进行下一次推荐，需要输入`(reset) (run) `
- 根据一些问题和判定，生成旅游线路
	- 使用前：`（clear）(load) (reset) (run) `
    - 输入3，进入第三个模块，然后根据问题输入相应的值进入下一个问题。在所有问题结束后得到系统生成的旅游线路
    - 输入q可以退出当前环节
    - 每一次生成完毕后若要重新进行下一次生成，需要输入`(reset) (run) `
- 根据用户提出的旅游地，推荐相似的旅游地
	- 使用前：`（clear）(load) (reset) (run)`
    - 输入4，进入第四个模块，然后根据问题输入相应的值进入下一个问题，最后根据推荐程度列出了从1到5五个不同等级的相似旅游地
    - 输入q可以退出当前环节
    - 每一次推荐完毕后若要重新进行下一次推荐，需要输入`(reset) (run) `
- 城市介绍和相应景点介绍
	- 使用前：`（clear）(load) (reset) (run)`
    - 输入5，进入第五个模块，然后根据问题输入相应的值进入下一个问题，最后可以列出四川省各个城市的介绍，和有的景点介绍
    - 输入q可以退出当前环节
    - 每一次介绍完毕后若要重新进行下一次介绍，需要输入`(reset) (run) `

---

## Logical Problems
全部采用CLIPS实现, 分别`(load "**.clp"),(reset),(run)`即可

### Crossing River
Eight people come to the edge of a river, including a policeman, a criminal and a family of six people, which consists of a father, a mother, two sons and two daughters. They need to cross the river. There is a boat at the river's edge, which can carry two people at a time. Only the policeman, the father and the mother can row. 
When crossing the river, the following situations must be avoided. The situations can happen on either edge of the river or on the boat.
- If the policeman is not with the criminal, the criminal will harm the family of six people.
- If the father is not with the mother, the mother will scold the sons.
- If the mother is not with the father, the father will scold the daughters.

Write code to figure out how to make all eight people arrive safely on the other side of the river. You should find the optimal way, i.e. the way with the minimum crossing times.

- 思路
    - 首先定义状态模版，该模版记录了两岸有哪些人，分别由多少个人，以及船的位置，所以初始状态为所有人和船在左边，目标状态是所有人和船在右边
    - 其次定义规则，对于每一种状态，根据船的位置判断下一次move结束后新的状态并assert。而因为只有三个人会划船，并且在船上的两个人不能出现限制中的情况，所以分为了`policeman带criminal、father、mother、daughter、son`；`father带mother、son`；`mother带daughter`以及`policeman、father、mother单独上船`等11种情况。对于每种情况assert新的状态
    - 接着对于两岸Move后的状态，需要满足限制条件，删除不满足的状态事实。并且删除状态重复的事实
    - 最后根据最后的目标状态根据parent这个slot的值反推出每一步的状态事实。最后打印出来。
    - 程序得到的只有两个答案，实际因为daughter和son有两个，所以可以有八种选择

- 答案
Solution-1:
```
Move policeman and criminal to shore-2.
Move policeman to shore-1.
Move policeman and son to shore-2.		// 这一步policeman可以选择一个son带过去
Move policeman and criminal to shore-1.
Move father and son to shore-2.
Move father to shore-1.
Move father and mother to shore-2.
Move mother to shore-1.
Move policeman and criminal to shore-2.
Move father to shore-1.
Move father and mother to shore-2.
Move mother to shore-1.
Move mother and daughter to shore-2.		// 这一步mother可以选择一个daughter带过去
Move policeman and criminal to shore-1.
Move policeman and daughter to shore-2.
Move policeman to shore-1.
Move policeman and criminal to shore-2.
```

Solution-2:policeman先带daughter过去，思路和上面一样
```
Move policeman and criminal to shore-2.
Move policeman to shore-1.
Move policeman and daughter to shore-2.
Move policeman and criminal to shore-1.
Move mother and daughter to shore-2.
Move mother to shore-1.
Move father and mother to shore-2.
Move father to shore-1.
Move policeman and criminal to shore-2.
Move mother to shore-1.
Move father and mother to shore-2.
Move father to shore-1.
Move father and son to shore-2.
Move policeman and criminal to shore-1.
Move policeman and son to shore-2.
Move policeman to shore-1.
Move policeman and criminal to shore-2.
```

---

### Einstein's Puzzle
Variations of this riddle appear on the net from time to time. It is sometimes attributed to Albert Einstein and it is claimed that 98% of the people are incapable of solving it. Some commentators suggest that Einstein created such puzzles not to test out intelligence but to get rid of all the students who wanted him as an advisor. It is not likely that there is any truth to these stories. Wherever this comes from, it is a nice riddle.
With Prolog, this riddle can easily be solved.
1. There are five houses of different colors next to each other on the same road. In each house lives a man of a different nationality. Every man has his favorite drink, his favorite brand of cigarettes, and keeps pets of a particular kind.
2. The English lives in the red house.
3. The Swedish keeps dogs.
4. The Danish drinks tea.
5. The green house is just to the left of the white one.
6. The owner of the green house drinks coffee.
7. The Pall Mall smoker keeps birds.
8. The owner of the yellow house smokes Dunhill.
9. The man in the center house drinks milk.
10. The Norwegian lives in the first house.
11. The Blend smoker has a neighbor who keeps cats.
12. The man who keeps horses lives next to the Dunhill smoker.
13. The man who smokes Blue Master drinks beer.
14. The German smokes Prince.
15. The Norwegian lives next to the blue house.
16. The Blend smoker has a neighbor who drinks water. 

The question to be answered is: Who keeps fish?

- 思路
    - 给定Nationality Color Pet Drink Smokes分别由五种，最后每个对应到1 2 3 4 5五个位置，穷举出所有可能出现的情况
    - 定义statement模版，槽值分别代表location Nationality Color Pet Drink Smokes

    将现有的描述划分为两类，
    - 一类为直接对应一个statement，即如“The English lives in the red house”
    - 第二类为对应两个statement，即如“The green house is just to the left of the white one”
    - 对于第一类描述，定义规则删除不满足的事实。所有这一类事实检测完可以大规模减少存在的事实
    - 对于第二种描述，在最后匹配找答案的规则RHS中，逐个检测LHS左侧匹配到的五个事实是否满足第二类的描述

- Solution: The German keeps fish

The total information: 
| Index | Nationality | Color  | Drink  | Pet    | Smokes |
|:---:|:---:|:---:|:---:|:---:|:---:|
|  1   | Norwegian   | yellow | water  | cats   | Dunhill|
|  2   | Danish      | blue   | tea    | horses | Blend   |  
|  3   | English     | red    | milk   | birds  | The-Pall-Mall|
|  4   | German      | green  | coffee | fish   | Prince    |
|  5   | Swedish     | white  | beer   | dogs   | Blue-Master|

---

### Which Car Do Each Man Own?
Read the following information.
- George is a mechanic. His co-workers, Jimmy and Tito, and their friend Doc often hang out together and talk about their cars. In no particular order, one of the men owns a Ford, one owns a Chevrolet, one owns a Dodge, and one owns a Toyota. They also talk about their gas mileage, and which of their cars is most fuel-efficient. One of the cars does really well and gets 30 miles per gallon of gasoline. Another of the cars gets 25 miles to the gallon. Another car gets 20 miles per gallon. And the last car gets only 15 miles per gallon.
- When they talk about their cars, all four of the friends are truthful when they speak about who owns which car. However, the two men whose cars have the lowest gas mileage (20 and 15 mpg) are a little embarrassed and will always lie when they talk about gas mileage, whether they are talking about their own car or their friends' cars. The two men who get the highest gas mileage (25 and 30 mpg) have nothing to hide and will always tell the truth about who gets what mileage, no matter which friend they're talking about.
- One night in a bar, the following conversation was heard.
- Tito said: Doc gets 20 miles per gallon of gas. George's gas mileage is better than Jimmy's.
- Jimmy said: Doc doesn't drive a Toyota. Tito's gas mileage is higher than the guy who drives the Dodge.
- George said: The guy who owns the Ford is getting 30 miles per gallon. The guy who gets 20 miles per gallon doesn't own a Chevrolet.
- Doc said: My gas mileage is 20 miles per gallon.

Question: What kind of car does each man drive and what gas mileage (mpg) does each car get? Your answer should be in the following order: George, Doc, Tito, Jimmy. 

- 思路
    - 给定name car Gas-Mileage分别由五种，最后每个对应到1 2 3 4 5五个位置
    - 穷举出所有可能出现的情况，每一种情况采用（对象，值，归属位置）三元组表示。于是问题的答案就应该为12个事实
    - 定义规则，使其LHS根据描述对事实进行限制，在描述的限制下匹配的12个事实就可以在RHS中进行输出
    - 对于说谎的情况，说谎下规则的LHS就会变化。
    - 所以首先对说谎的情况进行分析，显然肯定有两个说谎，并且Tito和Doc有句话是一样的。所以这两个要么同时说谎，要么同时不说谎
    - 所以分为两种情况下的规则，Doc和Tito说谎，George和Jimmy说谎。
    - 由于这个问题下的描述中并没有出现Gas-Mileage为15和26的内容，并且出现了“the guy who drives the Dodge”这种与归属位置无关的信息，
        - 所有LHS匹配的事实中就可能出现多于4种Gas-Mileage的情况
        - 所以在RHS中就得先判断LHS匹配的事实中所有对象为Gas-Mileage的事实必须只有4种，以避免重复

- 答案

|Index | Name        | Car          | Gas-Mileage  
|:---:|:---:|:---:|:---:|
|  1   | George      | Chevrolet    | 25   |       
|  2   | Doc         | Dodge        | 15    |       
|  3   | Tito        | Toyota       | 20     |      
|  4   | Jimmy       | Ford         | 30      |    

