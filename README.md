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
Solution class to interact with it. The solution class only needs three methods:

1. The *initialize* method, which accepts a set of variables you want to test.

2. The *score* method, which figures out and returns a score based on the variables you gave it.

3. The *top_score* method, which returns the top score that was possible if the variables had been perfect.

### Simple Example

Let's say you want to train your GA 