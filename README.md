# [Advent of Code, 2018](https://adventofcode.com/2018)

I'm doing it.

```
Languages so far: 25
Puzzles solved: 46

      --------Part 1--------   --------Part 2--------
Day       Time   Rank  Score       Time   Rank  Score
 23       >24h   4294      0       >24h   2472      0
 22       >24h   3873      0       >24h   2862      0
 21       >24h   3363      0       >24h   3134      0
 20       >24h   3166      0       >24h   3028      0
 19       >24h   4427      0       >24h   3641      0
 18       >24h   5209      0       >24h   4866      0
 17       >24h   3659      0       >24h   3630      0
 16       >24h   5521      0       >24h   5388      0
 15       >24h   3378      0       >24h   3173      0
 14       >24h   7123      0       >24h   6708      0
 13       >24h   7009      0       >24h   6716      0
 12       >24h   8642      0       >24h   7704      0
 11       >24h   9381      0       >24h   9553      0
 10       >24h   9413      0       >24h   9381      0
  9   17:43:11   7443      0   17:57:59   6378      0
  8   17:41:57   7669      0   18:04:24   7191      0
  7       >24h  10046      0       >24h   7597      0
  6       >24h  12291      0       >24h  11687      0
  5   21:23:09  15026      0   22:23:36  14413      0
  4       >24h  14629      0       >24h  14017      0
  3       >24h  18623      0       >24h  17418      0
  2   00:56:54   2919      0   01:22:41   2672      0
  1   22:27:36  24586      0   22:58:21  20019      0
```

## My Philosophy

I'm not doing this to hone my production ready skills, or to write perfect code.  I don't 
think anyone is.  My most overarching goal is to _have fun_ - and take some joy in coding.
This takes the form of using weird language features in weird way (like `eval` in JavaScript).
I'm also trying to use as many languages as I can think of.  I will keep track of which languages
I chose here and "why".  Though the reasons may be specious, at best.

As much as possible, I'm trying to avoid package management.  My goal is to get my hands super dirty,
so I'll gladly reroll things not available in the standard library.

### [Day 1](https://adventofcode.com/2018/day/1) - JS & Python
#### Puzzle 1 - [JS](days/1/puzzles/1)
I did this one in JS, just to use `eval`.  I chuckled to myself as I did it, and I'm not
apologizing.

#### Puzzle 2 - [Python](days/1/puzzles/2)
I did this in Python, because none of my JS code was reusable and I wanted a change of pace.  Also,
I've always enjoyed Python's list comprehensions.

### [Day 2](https://adventofcode.com/2018/day/2) - [Java](days/2/puzzles/)
Java is my day job, and when I read the puzzle for this day I thought the OO would be easy.  As it
turns out, I didn't need to write any classes and OO really wasn't necessary.  Whatever.

### [Day 3](https://adventofcode.com/2018/day/3) - [Prolog](days/3/puzzles/)
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

### [Day 4](https://adventofcode.com/2018/day/4) - [AWK](days/4/puzzles/)
I was legit watching Brian Kernighan talk about language design. He mentioned AWK (for obvious
reasons), and it clicked in my head that the regexp line matching was perfect for this puzzle.
Also used bash (sort) to sort the input.

### [Day 5](https://adventofcode.com/2018/day/5) - [C](days/5/puzzles/)
I'm running out of languages I feel strong in at this point, but C has always felt like a friend.
I chose it specifically because of the conversions between `char` and `int` - meaning I could check
wether two units were destructible by checking wether `| u1 - u2 | = 32`.  I hope the unicode
consortium will forgive my reliance on ASCII.

### [Day 6](https://adventofcode.com/2018/day/6) - [Go](days/6/puzzles/)
I could not figure out a clever way to do this, so I thought if I was going to brute force
this, I would at least learn Go and use goroutines to parallelize it.

### [Day 7](https://adventofcode.com/2018/day/7) - [Scala](days/7/puzzles/)
Scala used to be my day job, and a friend was learning/trying Scala for his own AoC puzzles.  I
figured out how easy it would be to use Scala's massive standard library of collections to 
calculate the list of available steps, so I finished the whole thing in Scala.

### [Day 8](https://adventofcode.com/2018/day/8) - [Haskell](days/8/puzzles/)
I haven't written Haskell since college.  This was another brain stretcher for me!

### [Day 9](https://adventofcode.com/2018/day/9) - [Rust](days/9/puzzles/)
I used Rust because a non-trivial number of my coworkers were using it.  Wanted to see how
I liked it, and felt like Sunday was a good day to spend on learning a new language.

For the record - I hated rust.  I found its intense memory management way too restrictive for what
I was trying to do.  Granted, I was probably trying to work at too low a level for the language,
but I still hated it.

It _was_ pretty cool, though, changing my internal structure for the second part of the puzzles
(the insertion/deletion time was too much for the Vec structure).  As someone said about it at
work: "If my code compiles, it's correct".  I think you get a lot of the same guarantees from any
statically typed language, but it was nice to see it in action.

### [Day 10](https://adventofcode.com/2018/day/10) - [PHP](days/10/puzzles/)
PHP!  Running out of languages.

### [Day 11](https://adventofcode.com/2018/day/11) - Bash and Clojure
#### Puzzle 1 [Bash](days/11/puzzles/1)
I realized that the purely functional nature of this made it really easy to implement in Bash.
It's not fast though.  Not even a little.

#### Puzzle 2 [Clojure](days/11/puzzles/2)
Argh.  Part 2 was so much larger, I had to throw away all my bash.  This is not suprising
to me.  Anyway, I wanted to stick with the pure functionalism, and I'd never used clojure
before.  Even then, it was so slow I had to use an executor pool - still took 45 minutes.

### [Day 12](https://adventofcode.com/2018/day/12) - [Crystal](days/12/puzzles/)
Saw the OO solution right away - so I wanted to pick a new OO language to learn. Turns out,
there was a pretty good functional solution right underneath my OO one - so this turned
out to be a bit of a Hybrid.

### [Day 13](https://adventofcode.com/2018/day/13) - [C++](days/13/puzzles/)
Oh, I overthought this one a lot.  Sort of "Once bitten, twice shy" with all the massive scale
issues in the previous ones.  I chose C++ because... I... felt like it?  Not a great reason.
It was a lot of code.

### [Day 14](https://adventofcode.com/2018/day/14) - [Perl](days/14/puzzles/)
Perl is supposed to be this whizbang language that everyone loves.  I did not love it.  It did
not make me feel like a wizard. But I did use it.

### [Day 15](https://adventofcode.com/2018/day/15) - [Ruby](days/15/puzzles/)
I find Depth first search easiest to implement in an OO context.  But Ruby
does a good job with mix and match.

### [Day 16](https://adventofcode.com/2018/day/16) - [Common Lisp](days/16/puzzles/)
I knew I wanted to do this in a purely functional language, and if the internet is to
be believed, "Lisp will make you a programmer".  I'm not better after this, but lisp was mega fun
to write in.

### [Day 17](https://adventofcode.com/2018/day/17) - [Elixir](days/17/puzzles/)
I dunno guys.  I'm running out of languages - and patience for these effing two dimensional
puzzles.  Elixir was okay, I guess.  Pretty much just another functional paradigm.  I
didn't really get into all the Communicating Sequential Process stuff.

### [Day 18](https://adventofcode.com/2018/day/18) - [Kotlin](days/18/puzzles/)
I was so tired of immutability at this point, I just needed to use a standard OO language, so
I decided to see how bad Kotlin could really be. It was fine.  Oodles of that good Scala DNA.

### [Day 19](https://adventofcode.com/2018/day/19) - [Lua](days/19/puzzles/)
Lua is a bizarre language.  1 Based arrays, 0 is truthy.  Just weird.  Interesting learn, though.
And dereferencing a string against the global scope to get the function in question?  Very helpful.

### [Day 20](https://adventofcode.com/2018/day/20) - [Erlang](days/20/puzzles/)
I was going to do this in a mutable, OO way.  But the more I thought about it, the more I realized
I could do it in an immutable, functional way.  It's like a Cordyceps fungus.  So I figured I'd give
Erlang a try.

### [Day 21](https://adventofcode.com/2018/day/21) - [Io](days/21/puzzles/)
I love to wax poetic about how cool and interesting Prototypical inheritance is, and how tragic it
is to see Javascript throwing away its interesting heritage in favor of looking like a "classical"
language.  Prototypes are sweet, and Io is sweet.  However, it _is_ virtually ungoogleable.

[Here it is, though.](https://iolanguage.org/index.html)

### [Day 22](https://adventofcode.com/2018/day/22) - [C#](days/22/puzzles/)
I'm so tired of immutability and pure functionalism.  I scraped for an OO language.  This is how
my brain works.

### [Day 23](https://adventofcode.com/2018/day/23) - [F#](days/23/puzzles/)
I had a pretty good time using C#, so I thought I'd give F# a try.  Functionalism in the Dotnet
ecosystem wasn't half bad.

### [Day 24](https://adventofcode.com/2018/day/24) - [TBD](days/24/puzzles/)
### [Day 25](https://adventofcode.com/2018/day/25) - [TBD](days/25/puzzles/)

## Languages that are on my list, but I haven't used yet
- Scheme
- Julia

# Results
## Day 1
### Puzzle 1
Run 1 of 1
```
420

real	0m0.174s
user	0m0.063s
sys	0m0.078s
```
### Puzzle 2
Run 1 of 1
```
227

real	0m0.605s
user	0m0.078s
sys	0m0.141s
```
## Day 2
### Puzzle 1
Run 1 of 1
```
6696

real	0m2.667s
user	0m1.938s
sys	0m1.188s
```
### Puzzle 2
Run 1 of 1
```
bvnfawcnyoeyudzrpgslimtkj

real	0m1.895s
user	0m1.547s
sys	0m0.906s
```
## Day 3
### Puzzle 1
Run 1 of 1
```
121259
real	0m4.706s
user	0m4.391s
sys	0m0.250s
```
### Puzzle 2
Run 1 of 1
```
239
real	0m0.335s
user	0m0.234s
sys	0m0.047s
```
## Day 4
### Puzzle 1
Run 1 of 1
```
50558

real	0m0.123s
user	0m0.016s
sys	0m0.047s
```
### Puzzle 2
Run 1 of 1
```
28198

real	0m0.089s
user	0m0.031s
sys	0m0.078s
```
## Day 5
### Puzzle 1
Run 1 of 1
```
11754

real	0m0.890s
user	0m0.016s
sys	0m0.250s
```
### Puzzle 2
Run 1 of 1
```
4098

real	0m0.565s
user	0m0.156s
sys	0m0.297s
```
## Day 6
### Puzzle 1
Run 1 of 1
```
3660

real	0m2.705s
user	0m0.547s
sys	0m1.688s
```
### Puzzle 2
Run 1 of 1
```
35928

real	0m0.855s
user	0m0.609s
sys	0m1.344s
```
## Day 7
### Puzzle 1
Run 1 of 1
```
BETUFNVADWGPLRJOHMXKZQCISY

real	0m7.231s
user	0m12.078s
sys	0m2.844s
```
### Puzzle 2
Run 1 of 1
```
848

real	0m6.944s
user	0m11.766s
sys	0m2.766s
```
## Day 8
### Puzzle 1
Run 1 of 1
```
40309

real	0m1.877s
user	0m0.203s
sys	0m0.656s
```
### Puzzle 2
Run 1 of 1
```
28779

real	0m0.473s
user	0m0.125s
sys	0m0.266s
```
## Day 9
### Puzzle 1
Run 1 of 1
```
367634

real	0m3.780s
user	0m0.984s
sys	0m1.422s
```
### Puzzle 2
Run 1 of 1
```
3020072891

real	0m4.798s
user	0m3.719s
sys	0m1.328s
```
## Day 10
### Puzzle 1
Run 1 of 1
```
######..#....#....##....#.......#.......#....#..#.......#####.
#.......#...#....#..#...#.......#.......#...#...#.......#....#
#.......#..#....#....#..#.......#.......#..#....#.......#....#
#.......#.#.....#....#..#.......#.......#.#.....#.......#....#
#####...##......#....#..#.......#.......##......#.......#####.
#.......##......######..#.......#.......##......#.......#....#
#.......#.#.....#....#..#.......#.......#.#.....#.......#....#
#.......#..#....#....#..#.......#.......#..#....#.......#....#
#.......#...#...#....#..#.......#.......#...#...#.......#....#
######..#....#..#....#..######..######..#....#..######..#####.

real	0m49.935s
user	0m30.438s
sys	0m18.719s
```
### Puzzle 2
Run 1 of 1
```
10227

real	0m49.775s
user	0m31.266s
sys	0m18.375s
```
## Day 11
### Puzzle 1
Run 1 of 1
```
243 27

real	408m40.171s
user	19m27.109s
sys	346m19.344s
```
### Puzzle 2
Run 1 of 1
```
"284,172,12"

real	34m23.196s
user	360m20.938s
sys	1m16.297s
```
## Day 12
### Puzzle 1
Run 1 of 1
```
3890

real	0m3.039s
user	0m0.797s
sys	0m1.344s
```
### Puzzle 2
Run 1 of 1
```
4800000001087

real	0m2.142s
user	0m0.828s
sys	0m1.375s
```
## Day 13
### Puzzle 1
Run 1 of 1
```
8,9

real	0m3.712s
user	0m1.625s
sys	0m1.188s
```
### Puzzle 2
Run 1 of 1
```
73,33

real	0m1.866s
user	0m0.984s
sys	0m0.734s
```
## Day 14
### Puzzle 1
Run 1 of 1
```
2688510125

real	6m40.354s
user	6m39.969s
sys	0m0.156s
```
### Puzzle 2
Run 1 of 1
```
20188250

real	4m14.605s
user	3m58.594s
sys	0m15.672s
```
## Day 15
### Puzzle 1
Run 1 of 1
```
190012

real	0m1.013s
user	0m0.672s
sys	0m0.094s
```
### Puzzle 2
Run 1 of 1
```
34364

real	0m5.274s
user	0m5.172s
sys	0m0.063s
```
## Day 16
### Puzzle 1
Run 1 of 1
```

531 

real	0m0.734s
user	0m0.125s
sys	0m0.438s
```
### Puzzle 2
Run 1 of 1
```

649 

real	0m0.420s
user	0m0.141s
sys	0m0.188s
```
## Day 17
### Puzzle 1
Run 1 of 1
```
31158

real	4m52.655s
user	4m38.859s
sys	0m33.125s
```
### Puzzle 2
Run 1 of 1
```
25419

real	4m56.560s
user	4m45.250s
sys	0m31.359s
```
## Day 18
### Puzzle 1
Run 1 of 1
```
495236

real	0m7.800s
user	0m11.609s
sys	0m3.922s
```
### Puzzle 2
Run 1 of 1
```
201348

real	0m9.157s
user	0m13.297s
sys	0m4.734s
```
## Day 19
### Puzzle 1
Run 1 of 1
```
1968

real	0m3.135s
user	0m3.047s
sys	0m0.047s
```
### Puzzle 2
Run 1 of 1
```
21211200

real	0m0.077s
user	0m0.000s
sys	0m0.031s
```
## Day 20
### Puzzle 1
Run 1 of 1
```
4050

real	0m2.652s
user	0m1.203s
sys	0m0.984s
```
### Puzzle 2
Run 1 of 1
```
8564

real	0m2.604s
user	0m1.047s
sys	0m0.875s
```
## Day 21
### Puzzle 1
Run 1 of 1
```
3115806

real	0m0.362s
user	0m0.203s
sys	0m0.078s
```
### Puzzle 2
Run 1 of 1
```

IOVM:
	Received signal. Setting interrupt flag.

  current coroutine
  ---------
  Coroutine callStack                  A4_Exception.io 244
  Coroutine backTraceString            A4_Exception.io 274
  Coroutine showStack                  System.io 62
  System userInterruptHandler          [unlabeled] 0
  Object tick                          program.io 104
  CLI doFile                           Z_CLI.io 140
  CLI run                              IoState_runCLI() 1


real	1640m7.065s
user	1631m53.656s
sys	0m2.781s
```
## Day 22
### Puzzle 1
Run 1 of 1
```
10603

real	0m7.151s
user	0m2.109s
sys	0m4.078s
```
### Puzzle 2
Run 1 of 1
```
952

real	0m57.780s
user	0m52.797s
sys	0m4.391s
```
## Day 23
### Puzzle 1
Puzzle not yet solved.
### Puzzle 2
Puzzle not yet solved.
## Day 24
### Puzzle 1
Puzzle not yet solved.
### Puzzle 2
Puzzle not yet solved.
## Day 25
### Puzzle 1
Puzzle not yet solved.
### Puzzle 2
Puzzle not yet solved.
