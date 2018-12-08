# [Advent of Code, 2018](https://adventofcode.com/2018)

I'm doing it.

Languages so far: 8
Puzzles solved: 14

      --------Part 1--------   --------Part 2--------
Day       Time   Rank  Score       Time   Rank  Score
  7       >24h  10046      0       >24h   7597      0
  6       >24h  12291      0       >24h  11687      0
  5   21:23:09  15026      0   22:23:36  14413      0
  4       >24h  14629      0       >24h  14017      0
  3       >24h  18623      0       >24h  17418      0
  2   00:56:54   2919      0   01:22:41   2672      0
  1   22:27:36  24586      0   22:58:21  20019      0

## My Philosophy

I'm not doing this to hone my production ready skills, or to write perfect code.  I don't 
think anyone is.  My most overarching goal is to _have fun_ - and take some joy in coding.
This takes the form of using weird language features in weird way (like `eval` in JavaScript).
I'm also trying to use as many languages as I can think of.  I will keep track of which languages
I chose here and "why".  Though the reasons may be specious, at best.

As much as possible, I'm trying to avoid package management.  My goal is to get my hands super dirty,
so I'll gladly reroll things not available in the standard library.

### [Day 1](https://adventofcode.com/2018/day/1) - JS & Python
#### Puzzle 1
I did this one in JS, just to use `eval`.  I chuckled to myself as I did it, and I'm not
apologizing.

#### Puzzle 2
I did this in Python, because none of my JS code was reusable and I wanted a change of pace.  Also,
I've always enjoyed Python's list comprehensions.

### [Day 2](https://adventofcode.com/2018/day/2) - Java
Java is my day job, and when I read the puzzle for this day I thought the OO would be easy.  As it
turns out, I didn't need to write any classes and OO really wasn't necessary.  Whatever.

### [Day 3](https://adventofcode.com/2018/day/3) - Prolog
Prolog!  Oh, man - prolog is such a weird language.  I find it really mind expanding to crash
around in it and try to figure out how to write things.  I thought of it when trying to figure out
how to generate the list of dual claimed coordinates.  I'm glad I did because part 2 was _cake_
in prolog.  Mostly just deleting.

I used `sed` to turn the input file into a file of facts for Prolog.

Also, I'm extremely proud of having learned that if you have 2 rectangles A(x1, y1, x2, y2) and
B(x1, y1, x2, y2), you can find their overlap by calculating `xs = sort({A.x1, A.x2, B.x1, B.x2})`
and `ys = sort({A.y1, A.y2, B.y1, B.y2`, and returning a new square `C(xs[1], ys[1], xs[2], ys[2])`
(index from zero, of course.  We're not animals.)  I'm sure it's a common trick to all the
rectangle overlapping enthusiasts out there, but it was new to me.

### [Day 4](https://adventofcode.com/2018/day/4) - AWK
I was legit watching Brian Kernighan talk about language design. He mentioned AWK (for obvious
reasons), and it clicked in my head that the regexp line matching was perfect for this puzzle.
Also used bash (sort) to sort the input.

### [Day 5](https://adventofcode.com/2018/day/5) - C
I'm running out of languages I feel strong in at this point, but C has always felt like a friend.
I chose it specifically because of the conversions between `char` and `int` - meaning I could check
wether two units were destructible by checking wether `| u1 - u2 | = 32`.  I hope the unicode
consortium will forgive my reliance on ASCII.

### [Day 6](https://adventofcode.com/2018/day/6) - Go
I could not figure out a clever way to do this, so I thought if I was going to brute force
this, I would at least learn Go and use goroutines to parallelize it.

### [Day 7](https://adventofcode.com/2018/day/7) - Scala
Scala used to be my day job, and a friend was learning/trying Scala for his own AoC puzzles.  I
figured out how easy it would be to use Scala's massive standard library of collections to 
calculate the list of available steps, so I finished the whole thing in Scala.

### [Day 8](https://adventofcode.com/2018/day/8)
### [Day 9](https://adventofcode.com/2018/day/9)
### [Day 10](https://adventofcode.com/2018/day/10)
### [Day 11](https://adventofcode.com/2018/day/11)
### [Day 12](https://adventofcode.com/2018/day/12)
### [Day 13](https://adventofcode.com/2018/day/13)
### [Day 14](https://adventofcode.com/2018/day/14)
### [Day 15](https://adventofcode.com/2018/day/15)
### [Day 16](https://adventofcode.com/2018/day/16)
### [Day 17](https://adventofcode.com/2018/day/17)
### [Day 18](https://adventofcode.com/2018/day/18)
### [Day 19](https://adventofcode.com/2018/day/19)
### [Day 20](https://adventofcode.com/2018/day/20)
### [Day 21](https://adventofcode.com/2018/day/21)
### [Day 22](https://adventofcode.com/2018/day/22)
### [Day 23](https://adventofcode.com/2018/day/23)
### [Day 24](https://adventofcode.com/2018/day/24)
### [Day 25](https://adventofcode.com/2018/day/25)
