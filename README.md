# The Simple Genetic Algorithm Library

This library provides a GeneticAlgorithm class that will hopefully make it easy
for anyone to get into genetic algorithms using Ruby. It's not meant to be comprehensive - 
on the contrary, it's intentionally simple to encourage you to play around with it. That's
why it's a library, and not a gem.

## What are Genetic Algorithms?

Genetic algorithms are probably the simplest form of machine learning. They're based on the 
concepts of micro-evolution and natural selection. If you have a problem with many 
(ie, millions) of possible combinations of solutions, a GA can help you narrow down
the field.

If you want to solve a problem using a GA, there are just a few simple steps:

1. Create several potential solutions at random. This will be your first "generation".

2. Test each solution, and give it a score.

3. Make a new generation of solutions by combining the best solutions from the previous generation.

4. Repeat this process until you get a solution that meets your needs.

Technically, you don't even need a computer to use this approach. Maybe you're a fan of the 
Risk board game, where you start by choosing a handful of several countries, hoping to take
over the world. For the first 10 games you play, you could pick countries at random. After that, 
you could start choosing countries based on combinations of what worked before. 

## How to Use This Library

There are two parts to this process: using the GeneticAlgorithm class provided, and writing your own
Solution class to interact with it. When the GA wants to try a possible solution to the problem at
hand, it creates a new instance of your solution class, with a list of parameters that represent its 
latest guess.

Your solution class only needs three methods:

1. A **class method** called *top_score* to tell the GA what the best possible score is.

2. The *initialize* method, which accepts a list of parameters (guesses) from the GA.

3. A *score* method, which returns the fitness score for the given parameters.

4. A *to_s* method, which displays the solution in a screen-friendly way.

Then you create a new GA instance, using your solution class:

```
GeneticAlgorithm.new directory, solution_class, ranges, options={}
```

Parameters:

* directory: the GA will store data files here.
* solution_class: the solution class the GA will use to test its solution attempts.
* ranges: one array-ish object for every parameter your solution class requires.
* options: hash of options to override defaults.

Available options and their defaults:

* population_size: 50; how many solutions the GA will try each generation.
* generations: 1000; how many generations the GA will run before giving up.
* mutation_rate: 0.05; how often part of a solution will be mutated.
* holdover_rate: 0.1; how many of the best solutions will live on to the next generation, unaltered.
* top_score: nil; the score at which your GA will be satisfied, and stop running.
* display: 1; how many generations to run between outputting the status.
* verbose: false; if true, you will get an absurd amount of debugging info.

### Simple Example

Let's say you want to train your GA to guess the password "secret4u". Your solution class only needs four parts:


Your solution class might look like this:

```ruby
class Password
  LETTER_POOL = 'abcdefghijlkmnopqrstuvwxyz0123456789'
  TARGET = "secret4u"
  
  class << self
    def top_score
      TARGET.size
    end
  end
  
  def initialize *guess_letters
    @guess_letters = guess_letters
    @target_letters = TARGET.split('')
  end
  
  def score
    total = 0
    
    @target_letters.each_with_index do |target_letter, i|
      total += 1 if target_letter == @guess_letters[i]
    end
    
    total
  end
    
  def to_s
    @guess_letters.join('')
  end
end
```

We have a couple constants here: `LETTER_POOL`, which is all the possible characters 
the password could be, and `TARGET`, which is the password we want our GA to figure out.

We also have our *top_score* class method. The most letters you can get right is all eight
of them, so the top possible score is equal to the total number of letters in the password.

Next, our *initialize* method is going to accept and store all the guess letters that the GA is trying.

Our *score* method awards each potential solution one point for every letter it gets correct, 
for a total possible score of 8 points.

Finally, our *to_s* method squishes all the guess letters together into one word for easy screen display.

Let's try it out by using the GA class:

```ruby
possible_letters = Password::LETTER_POOL
ga = GeneticAlgorithm.new 'ga/password', Password, [POSSIBLE_LETTERS]*8

```

Here's the abbreviated output, with columns for generation number, time, worst score, best score, and best solution. 
Scores are based on percentage of total possible score:

```
0    00:00:00    0.0    0.25    shyp5tiv
1    00:00:00    0.0    0.5    oeyhetau
2    00:00:00    0.0    0.5    oeyhetau
3    00:00:00    0.125    0.625    se4hetfu
4    00:00:00    0.125    0.625    se4hetfu
5    00:00:00    0.25    0.75    seopet4u
6    00:00:00    0.25    0.75    seopet4u
7    00:00:00    0.375    0.75    seopet4u
8    00:00:00    0.375    0.75    seopet4u
9    00:00:00    0.375    0.75    seopet4u
10    00:00:00    0.5    0.75    seopet4u
11    00:00:00    0.375    0.875    secbet4u
12    00:00:00    0.5    0.875    secbet4u
13    00:00:00    0.375    0.875    secbet4u
14    00:00:00    0.5    0.875    secbet4u
15    00:00:00    0.5    0.875    secbet4u
16    00:00:00    0.625    0.875    secbet4u
17    00:00:00    0.5    0.875    secbet4u
18    00:00:00    0.5    0.875    secbet4u
19    00:00:00    0.625    0.875    secbet4u
20    00:00:00    0.625    0.875    secbet4u
21    00:00:00    0.625    0.875    secbet4u
22    00:00:00    0.625    0.875    secbet4u
23    00:00:00    0.5    1.0    secret4u
```

More to come soon, but this should get you started! This password class is one of several examples in the *lib* directory.