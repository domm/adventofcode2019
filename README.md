# Some notes on Advent of Code 2019

https://adventofcode.com/2019

Solutions in Perl.

Most of the time I use [App::TimeTracker](http://timetracker.plix.at/) to see how long it takes me. I generally try the first part after getting up (~8:00 CET), and the second part after my morning yoga or (depending on work stress / problem complexity) later during the day.

## Day 1

A very easy start..

**Time:** 3:00 / 12:14

**Rank:** 7494 / 6679

## Day 2

We meet Intcode, and I try out some new Perl features. Read more about it [here](https://domm.plix.at/perl/2019_12_advent_of_code_intcode.html)

**Time:** 23:00 / 06:55 / plus more to clean up Intcode.pm

**Rank:** 5952 / 5091

## Day 3

Not very hard, but I used an array to map all the wires instead of an hash to only index the coordinates, which makes the program not very fast. Oh, and I had a "Lattenzaun" error in the second part (which I realized after getting the wrong answer, and I just corrected the error in my head; sorry, [Farhad](https://github.com/grauwolf))

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

Some simple Hash / Array munging again (I see a pattern here...). It took me quite a while to realize that I had to actually "render" the image for part 2, so I can read the message...

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

**Time:** 22:22 / 05:20

**Rank:** 2370 / 2617

## Day 12

The first part was rather easy and straightforward (though my code is overly verbose and can probably be compacted to a few lines of dense Perl). For the second part, I was quite sure that I need to use the least common multiple (LCM), but when I calculated it based on the whole position/vector sets, I got wrong results.

After reading reddit, I figured out (from various code fragments) that I can calculate each axis on its own, look for the repetition there, and then use the LCM of the first rep on each axis. Which was easy to implement, but I still have no clue **why** this works.

**Time:** 36:50 / 26:31 + a bit more after reading reddit

**Rank:** 3035 / 2071

