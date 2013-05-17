% R functional-programming Lisp

Functional programming in R
===========================

This post is about functional programming, why it is at the heart of the R language and how it can hopefully help you to write cleaner, faster and more bug-free R programs.
I will discuss what functional programming is at a very abstract level as a means of the representation of some simplified model of reality on a computer.  Then I’ll talk about the elements that functional programming is comprised of and highlight the most important elements in programming in R.  I will then go through a quick example demo of a FP-style generic bootstrap algorithm to sample linear models and return bootstrap confidence intervals.  I’ll compare this with a non-FP alternative version so you will hopefully clearly  see the advantages of using an FP style.  To wrap up, I’ll make a few suggestions for places to go to if you want to learn more about functional programming in R.
So, what is functional programming?  Well, what is programming?  When you build a program you are building an  abstract representation of some tiny subset of reality on your computer, whether it is an experiment you have conducted or a model of some financial system or a collection of features of members of a population. There are obviously different ways to represent reality, and these different methods can be thought of as the metaphysics of different styles of programming.
Consider for a moment building a representation of a river on a computer, a model of a river system for example.
![alt River](/home/mdehsds4/github/blog/blog/img/river.jpg)
In non-functional languages such as C++, Java and, to some extent, Python, the river is an object that does things and has various properties associated with it such as flow rate, depth and pollution levels.  These properties may change over time but there is always this constant ‘thing’, the river, which somehow persists over time.
In FP we look at things differently.  Hereclitus said “We never step into the same river twice”, recognising that we are actually less concerned with the object of the river itself but rather the processes that it undergoes through time.  Our river at any point in time is just a collection of values (say, particles and their positions). These values then feed into a process to generate the series of values at the next time point.  So we have data flowing through processes of functions and that collection of data over time is what we call a river, which is really defined by the functions that the data flows through.  This is a very different way of looking at things and is analogous to focussing more on the verbs than the nouns, as we do in imperative, object oriented programming.
Functional programming (FP) has been around for a very long time and stems from Lisp, which was first implemented in the 1950’s, but is making somewhat of a comeback of late for a variety of reasons, but mostly because it is so good at dealing with concurrent, multicore problems potentially over many computers.  

After this somewhat abstract and philosophical start, I'll talk about the more practical elements of FP.  There are several elements that FP is generally considered to be comprised of.  Different languages highlight different elements, depending on how strictly functional they are.

Functions are first class citizens of the language
--------------------------------------------------

This means that functions can be treated just like any other data type - They can be passed around as arguments to other functions, returned by other functions and stored in lists.  This is the really big deal about functional programming and allows for higher-level functions and closures, which I'll talk about later.  This is the most fundamental functional concept and I'd argue that a language has to have this property in order to be called a functional language, even if it has some of the other elements listed below.  For example, Python has anonymous functions and supports declarative programming with list comprehensions and generators, but functions are fundamentally different from data-types such as lists so Python cannot really be described as a functional language in the same way as Scheme or R can be.

Functional purity
-----------------

This is more of an element of good functional program design.  Pure functions take arguments, return values and otherwise have no side effects - no I/O or global variable changes.  This means that if you call a pure function twice with the same arguments, you know it will return the same value.  This means programs are easily tested because you can test different elements in isolation and once you know they work, you can treat them like a black box, knowing that they will not change some other part of your code somewhere else.  Some very strictly functional languages, like Haskell, insist on functional purity to the extent that in order to output data or read or write files you are forced to wrap your 'dirty' functions in constructs called monads to preserve the purity of your code.  R does not insist on functional purity, but it is certainly good practice to split your code into pure and impure functions.  This means you can test your pure code easily and confine your I/O and random numbers etc to a small number of dirty functions.

Vectorised functions
--------------------

Vectorised functions operate equally well on all elements of a vector as they do on a single number.  They are very important in R programming to the point that much of the criticism of R as a `really` slow language can be put down to failing to properly understand vectorisation.  This also includes the declaritive style of programming, where you tell the language what you want, rather than how you want to get it.  This is common in languages like SQL and in Python generators.  I'll discuss this more later.

Anonymous functions
-------------------

Immutable values
----------------

Recursion
---------



