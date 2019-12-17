# Some notes on Advent of Code 2019

https://adventofcode.com/2019

Solutions in Perl.

Most of the time I use [App::TimeTracker](http://timetracker.plix.at/) to see how long it takes me. I generally try the first part after getting up (~8:00 CET), and the second part after my morning yoga or (depending on work stress / problem complexity) later during the day.

## Day 1

A very easy start..

**Time:** 3:00 / 12:14

**Rank:** 7494 / 6679

## Day 2

We meet Intcode, and I try out some new Perl features. Read more about it [here](https://domm.plix.at/perl/2019_12_advent_of_code_intcode.html).

**Time:** 23:00 / 06:55 / plus more to clean up Intcode.pm

**Rank:** 5952 / 5091

## Day 3

Not very hard, but I used an array to map all the wires instead of an hash to only index the coordinates, which makes the program not very fast. Oh, and I had a "Lattenzaun" error in the second part (which I realized after getting the wrong answer, and I just corrected the error in my head but not in the code; sorry, [Farhad](https://github.com/grauwolf))

**Time:** 36:42 / 14:32

**Rank:** 4363 / 3493

## Day 4

Another simple brute force attack...

**Time:** ? / 20:33

**Rank:** 6324 / 5266

## Day 5

Yay, I can reuse Intcode.pm. Oh no, the new `modes` do not work at all with my previous implementation... hence the long time it took me to solve part 1. And my solution to parse the modes is very ugly (Read about it [here](https://domm.plix.at/perl/2019_12_advent_of_code_intcode_day_5.html) where I also describe how I rewrote / cleaned up Intcode)

But adding the new opcodes from part 2 was easy and they fit quite well into Intcode.pm!

**Time:** 1:26:08 / 21:06

**Rank:** 4192 / 3524

## Day 6

Again a not-so-hard problems: graphs. Which I solved by reversing the graph into an array...

[Here](https://www.reddit.com/r/adventofcode/comments/e6tyva/2019_day_6_solutions/f9vjikv/?context=3) is a slightly golfed solution for part 2.

**Time:** 13:35 / 11:45

**Rank:** 3557 / 2981

## Day 7

Intcode again. The first example was not too hard; as I have implemented Intcode in a class, I can just have several instances of the class in one script, where each instance has its own memory.

But part 2 took me ages (about 2 hours, but I was also watching "TV"), mostly because I did not understood how the inputs / signal / phase settings have to be provided to the amplifiers. Only after reading some of the posts on reddit I understood what I was supposed to do.

And I also had to change the whole input/output handling if Intcode...

**Time:** ? / ?

**Rank:** 4194 / 6490

## Day 8

Some simple Hash / Array munging again. It took me quite a while to realize that I had to actually "render" the image for part 2, so I can read the message...

**Time:** 20:52 / 20:09

**Rank:** 6175 / 5624

## Day 9

Intcode day!

The large numbers / large memory hints did not bother my Intcode, and the one new opcode / mode was easy to implement. But I wasn't reading the instructions very carefully and did not implement `relative mode` for writes, which cost me at least 15min of debugging... But task 2 was very easy!

**Time:** 26:22 / 1:12

**Rank:** 2651 / 2597

## Day 10

That was a tough one. It took me rather long to understand that the asteroids on the map are tiny points and do not take up the whole block (but it says so very clear in the instructions..). But after grabbing some graph paper and drawing the map I realized that this is not an array problem, but has to be solved with vectors. So, **math**!

I used [Math::Vec](https://metacpan.org/pod/Math::Vec) (because it came up first on CPAN) to calculate the unit vector (or "Einheitsvektor", which sound much cooler in German..), and using this unit vector it was trivial to filter out vectors pointing in the same direction.

After that, I needed a break, and finished the second task in the evening, using a very stupid approach to calculate the angle via tangens, and the sorting the asteroids by angel to nuke them. Even though I was quite proud that I still remembered enough math from school to cobble together my code (using some online math tutorials for the math details), I have the feeling that there are way more elegant solutions than mine...

**Time:** 1:07:32 / 30:34

**Rank:**  2441 / 4853

## Day 11

Intcode again, but this time there were no changes to the "compiler" necessary, just a simple program using Intcode. For the second part I remembered to "render" the result, reusing the code from day 8 to dump the array in a format where I can read the generated code.

Oh, and I was very lazy and just used a rather big two-dimensional array for the hull, of which only a small part was actually used. But I did not want to handle negative array indices...

**Time:** 22:22 / 5:20

**Rank:** 2370 / 2617

## Day 12

The first part was rather easy and straightforward (though my code is overly verbose and can probably be compacted to a few lines of dense Perl). For the second part, I was quite sure that I need to use the least common multiple (LCM), but when I calculated it based on the whole position/vector sets, I got wrong results.

After reading reddit, I figured out (from various code fragments) that I can calculate each axis on its own, look for the repetition there, and then use the LCM of the first rep on each axis. Which was easy to implement, but I still have no clue **why** this works.

**Time:** 36:50 / 26:31 + a bit more after reading reddit

**Rank:** 3035 / 2071

## Day 13

Part one was a rather easy Intcode exercise, part two not so much.

As I did not want to play the game, I thought I could cheat by looking at the Intcode source of the game to figure out how the scores are calculated. I wasted an hour adding debugging and introspection to Intcode, but made no progress, so I stopped (and baked a cake).

Later I added a manual interface so I could actually play the game, the interface was very clunky and I always died before even coming close to cleaning the board. Reddit suggested writing some AI to steer the paddle, which I did (with a lot of hilarious mistakes on my part) and took me another hour.

But in the end I got a working solution! I added an option to render the game play (at different speeds), and later learned to use `byzanz-record` to record my term to a [gif](https://github.com/domm/adventofcode2019/blob/master/13_2.gif). To make this nicer, I used some simple unicode chars to render the game.

**Time:** 07:34 / 02:01:16 plus some time for cleanup and recording a gif

**Rank:** 2692 / 3338

## Day 14

Things start to get annoyingly complex, not sure I want too keep up with it for a lot longer...

In theory, the task looked simple (walk a chain of dependencies, and calculate some sums), but the fact that each reaction produced weird amount of chemicals, and that you have to use the leftovers made this my most-hated task (up to now..). I worked an hour during the late afternoon, and two more after coming back from a friends exhibition.

The second part was then quite easy, though I got some errors because I forgot to reset the leftovers between each run. And I was too lazy to implement a binary search, and just did a quick guesstimate from the commandline, and then run a stupid incrementing brute force attack (all of which took another 20min, but at 1:00 in the morning...)

**Time:** 02:53:16 / 00:19:12

**Rank:** 4954 / 4337

## Day 15

I hardly notice that I'm using Intcode anymore :-)

Getting to move the droid through the maze was not that hard, but I could not figure out how to implement a proper maze solver, so I went for a "random mouse" approach, which I later finetuned to not enter known dead-ends again.

I actually found the oxygen system quite fast using a pure random
approach, but spend about 30 minutes implementing the dead-end
detection (because some random runs took ages, and I didn't figure out
how to calculate the minimum distance)

Getting the minimum distance turned out to be quite easy: I just
counted the steps and stored them at each coordinate; if I later
backtracked through an already visited point, I started counting again
from the distance stored there.

[Here is a gif for part 1](https://raw.githubusercontent.com/domm/adventofcode2019/master/15_1.gif) 

For the second part I took a maybe weird approach: From a previous
run, I had a complete map lying around (when the random mouse was very
thorough), so I applied 4 regex to simulate the spread of the
oxygen:

```
$maze=~s/\.O/oO/g;               # spread left
$maze=~s/O(.{$width})\./O$1o/sg; # spread down
# etc
```

I missed a few corner cases in my first try:

* `s/.O/OO/g` would allow the next regex to pick up an oxygen that was just generated, so I changed the 4 regex to `s/.O/Oo/g` and then converted `o` to `O` after all where done.
* a bit trickier to catch was that if there were two up/downward spreads in the same row, only one would match, so I packed each regex into a while-loop

[And here is a gif for part 2](https://raw.githubusercontent.com/domm/adventofcode2019/master/15_2.gif) 

**Time:** 02:05:27 / 00:45:56

**Rank:** 3015 / 2794

## Day 16

A not too hard first part (though my solution is rather convoluted), and a second part I could have never solved without reddit and looking at various solutions.

I found [this comment]:https://www.reddit.com/r/adventofcode/comments/ebf5cy/2019_day_16_part_2_understanding_how_to_come_up/fb4a34p especially helpful. As pointed out on reddit, the sequence we are looking for is always in the second half of the signal. But the pattern for the second half will only consist of 0 and 1. So we can calculate the next row by working through the current row from behind:

```
this_phase: ... 6  9  9  8
next_phase: ... ?  ?  ?  ?
```

Work from right to left (i.e. reverse the list). For the last digit, just copy the last digit to the next row (because the last `pattern` will always be  `… 0 0 0 1`, so we need to add a lot of zeros to `1 * last digit`)

```
this_phase: ... 6  9  9  8
next_phase: ... ?  ?  ?  8
```

From then on, take the current digit and add the all the following digits, because the pattern will always be `… 0 1 1+`. But as we store the sum of this calculation into the next row, we don't have to always calc this long sum. We can just re-use the result of the last calculation, i.e. the field in the next phase we have just calculated:

```
this_phase: ... 6  9 >9< 8
next_phase: ... ?  ?  ? >8<
```

`8 + 9 = 17`, take the last digit (i.e. `modulo 10`) and store it in the next phase

```
this_phase: ... 6  9  9  8
next_phase: ... ?  ? >7< 8
```

In the next phase the pre-calced sum trick should be obvious:

```
this_phase: ... 6  9  9  8
next_phase: ... ? >?< 7 8
```

We could do `9 + 9 + 8 = 16`. But we have just calculated `9 + 8 = 17 => mod 10 => 7` and stored this in the next row. And thanks to math, `9 + 7 = 16 => mod 10 => 6` yields the same result as `9 + 9 + 8 = 16 => mod 10 => 6`. yay!

so, this will be much quicker: 9 + 7 = 16 => 6; 6 + 6 = 12 => 2, ...

**Time:** 36:38 / at least 2 hours

**Rank:** 2612 / 2374 - wow, good rank at 12:52:09 :-)

## Day 17

writeup coming soon

**Time:** 28:24 / 56:41 (45min to get IO etc working, then 10 minutes to solve the maze by hand)

**Rank:** 2072 / 1062 (damn it, just missed 3 digits, but best rank ever)

