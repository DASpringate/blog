% R functional-programming Lisp Closures

Functional programming in R
===========================

_This post is based on a talk I gave at the [Manchester R User Group](http://www.meetup.com/Manchester-R/) on functional programming in R on May 2nd 2013.  The original slides can be found [here](http://www.slideshare.net/DASpringate/functional-programming-in-r)_

This post is about functional programming, why it is at the heart of the R language and how it can hopefully help you to write cleaner, faster and more bug-free R programs.
I will discuss what functional programming is at a very abstract level as a means of the representation of some simplified model of reality on a computer.  Then I’ll talk about the elements that functional programming is comprised of and highlight the most important elements in programming in R.  I will then go through a quick example demo of a FP-style generic bootstrap algorithm to sample linear models and return bootstrap confidence intervals.  I’ll compare this with a non-FP alternative version so you will hopefully clearly  see the advantages of using an FP style.  To wrap up, I’ll make a few suggestions for places to go to if you want to learn more about functional programming in R.

What is Functional programming?
-------------------------------

... Well, what is programming?  When you write a program you are building an  abstract representation of some tiny subset of reality on your computer, whether it is an experiment you have conducted or a model of some financial system or a collection of features of members of a population. There are obviously different ways to represent reality, and the different different methods of doing so programmatically can be thought of as the metaphysics of different styles of programming.

Consider for a moment building a representation of a river on a computer, a model of a river system for example.


![alt River](/img/river.jpg)

In non-functional languages such as C++, Java and (to some extent) Python, the river is an object in itself, a `thing` that does `things` to other `things` and that may have various properties associated with it such as flow rate, depth and pollution levels.  These properties may change over time but there is always this constant, the river, which somehow persists over time.

In FP we look at things differently... 

![Hereclitus - We never step into the same river twice](/img/heraclitus.jpg)

The presocratic philosopher  Hereclitus said “We never step into the same river twice”, recognising that the thing we call a river is not really an object in itself, but something undergoing constant change through a variety of processes. In functional programming we are less concerned with the object of the river itself but rather the processes that it undergoes through time.  Our river at any point in time is just a collection of values (say, particles and their positions). These values then feed into a process to generate the series of values at the next time point.  So we have data flowing through processes of functions and that collection of data over time is what we call a river, which is really defined by the functions that the data flows through.  This is a very different way of looking at things to that of imperative, object oriented programming.

After this somewhat abstract and philosophical start, I'll talk about the more practical elements of functional programming (FP).  FP has been around for a very long time and originally  stems from Lisp, which was first implemented in the 1950’s. It is making something of a comeback of late for a variety of reasons, but mostly because it is so good at dealing with concurrent, multicore problems potentially over many computers.  There are several elements that FP is generally considered to be comprised of.  Different languages highlight different elements, depending on how strictly functional they are.

### Functions are first class citizens of the language

This means that functions can be treated just like any other data type - They can be passed around as arguments to other functions, returned by other functions and stored in lists.  This is the really big deal about functional programming and allows for higher-order functions (such as `lapply`) and closures, which I'll talk about later.  This is the most fundamental functional concept and I'd argue that a language has to have this property in order to be called a functional language, even if it has some of the other elements listed below.  For example, Python has anonymous functions and supports declarative programming with list comprehensions and generators, but functions are fundamentally different from data-types such as lists so Python cannot really be described as a functional language in the same way as Scheme or R can be.

### Functional purity

This is more of an element of good functional program design.  Pure functions take arguments, return values and otherwise have no side effects - no I/O or global variable changes.  This means that if you call a pure function twice with the same arguments, you know it will return the same value.  This means programs are easily tested because you can test different elements in isolation and once you know they work, you can treat them like a black box, knowing that they will not change some other part of your code somewhere else.  Some very strictly functional languages, like Haskell, insist on functional purity to the extent that in order to output data or read or write files you are forced to wrap your 'dirty' functions in constructs called monads to preserve the purity of your code.  R does not insist on functional purity, but it is often good practice to split your code into pure and impure functions.  This means you can test your pure code easily and confine your I/O and random numbers etc to a small number of dirty functions.

### Vectorised functions

Vectorised functions operate equally well on all elements of a vector as they do on a single number.  They are very important in R programming to the point that much of the criticism of R as a `really` slow language can be put down to failing to properly understand vectorisation.  This also includes the declarative style of programming, where you tell the language what you want, rather than how you want to get it.  This is common in languages like SQL and in Python generators.  I'll discuss this more later.

### Anonymous functions

In FP, naming and applying a function are two separate operations, you don't need to give your functions names in order to call them. So, calling this function:


```r
powfun <- function(x, pow) {
    x^pow
}
powfun(2, 10)
```

```
## [1] 1024
```


to the interpreter is exactly the same as applying variables to the anonymous function:


```r
(function(x, pow) {
    x^pow
})(2, 10)
```

```
## [1] 1024
```


This is particularly useful when you are building small, single use functions such as those used as arguments in higher order functions such as `lapply`.

### Immutable data structures

Immutable data structures are associated with pure functions. The idea is that once an object such as a vector or list is created, it should not be changed.  You can't affect your data structures via side effects from other functions. Going back to our river example, doing so would be like going back in time and rearranging some of the molecules and starting again.  Having immutable objects means that you can reason more easily about what is going on in your program. Some languages, like Clojure, only have immutable data structures and it is impossible to change a list in place, you would have to have a list as an argument to a function which returns another list that you then assign back to the variable name for the original list.  R does not insist on immutability, but in general, data structures are only changed in this way and not through side effects.  It is often best to follow this, for the same reasons as it is best to have pure functions.

### Recursion

Recursive functions are functions that call themselves.  Historically, these have been hugely important in FP, to the extent that some languages (for example Scheme) do not even have `for` loops and they define all of their looping constructs via recursion.  R does allow for recursive functions and they can sometimes be useful, particularly in traversal of tree-like data structures, but recursion in not very efficient R (it is not [tail-call optimised](http://en.wikipedia.org/wiki/Tail-call_optimization)) and I will not discuss it further here, though it may well be the subject of a future post.

Functional Programming in R
---------------------------

R has a reputation for being an ugly, hacked together and slow language. I think this is slightly unfair, but in this ever-so-slightly biassed account, I am going to blame the parents:

![R genealogy](/img/R_genealogy.png)

R is the offspring of the languages `S` and `Scheme`.  S is a statistical language invented in the 1970's which is itself based on non-functional, imperative languages like C and Fortran.  It is useful in this domain and much of R's statistical abilities stem from this, but it is certainly less than pretty.  Scheme is a concise, elegant, functional language in the lisp family. The designers of R tried to build something with the statistical functionality of S and the elegance of Scheme.  Unfortunately, they left in much of the inelegant stuff from S as well and this mixed parentage means that it is now perfectly possible to write ugly, hacky, slow code in the style of S, just as it is also possible to write elegant, efficient functional code in the style of scheme.  The problem is that functional programming has been far less mainstream so people tend to learn to code in the way they know first, resulting in rafts of ugly, hacky R code.  Programming R in an elegant, functional way is not more difficult, but is immediately less intuitive to people who were brought up reading and writing imperative code.  I would always recommend people learning R to learn these functional concepts from the outset because this way you are working with how the language was designed, rather than against it.

To show just how functional a language is at its core, it is first important to recognise that everything in R is a function call, even if it looks like it isn't. So, 


```r
> 1 + 2
```

```
## [1] 3
```


... is exactly the same as...


```r
> `+`(1, 2)
```

```
## [1] 3
```


The `+` operator is really just "syntactic sugar" for a `+` function with the arguments 1 and 2 applied to it. Similarly, 


```r
> 1:10
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```


... is the same as...


```r
> `:`(1, 10)
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```


here again, to give the range of numbers between 1 and 10, `:` is really just a function in disguise.  If you were to break down more complex expressions in this way, the result would be code that looks very Scheme-like indeed.

I will now look in more depth at the functional concepts that are most important in R, Vectorised functions, higher order functions and closures. 

### Vectorised functions

Probably the best known FP concept in R is the vectorised function which 'automagically' operates on a data structure like a vector in just the same way as on a single number.  Some of the most important of these are the [vector subsetting](http://rpubs.com/daspringate/subsetting) operations. In these, you take a declarative approach to programming: you tell R what you want, not how to get it.  Because of this property of operating across vectors, proper use of vectorised functions will drastically reduce the number of loops you have to hand code into your scripts.  They are still performing loops under the hood, but these loops are implemented in C, so are many times faster than a standard for loop in R.  

For example, when I was first using R for data management and analysis, I spent months writing code like this:


```r
> # Get all even numbers up to 200000
> # using S-style vector allocation:
> x <- c()
> for(i in 1:200000){
>     if(i %% 2 == 0){
>         x <- c(x, i)
>     }
> }
```


This is about the worst possible way of achieving the given task (here, getting all even numbers up to 200000).  You are running a `for` loop, which is slow in itself, and testing if `i` is even on each iteration and then growing the `x` vector every time you find that it is.  The code is ugly, slow and verbose (On my machine it took around 10 seconds).

For me, writing vectorised code was a real revelation.  To achieve the same goal as the code above in a vectorised style:


```r
> # FP style vectorised operation
> a <- 1:200000
> x <- a[a %% 2 == 0] 
```


You assign a vector with all the values from 1 t0 200000, then you say "I want all of these that are divisible by two".  This ran 3 orders of magnitude faster than the non-FP code, is half the length and clearer - you don't have to mentally run through the loop in order to work out what it does.  So you get the benefits of both concision (Number of bugs correlate well with lines of code) and clarity (The code becomes almost self-documenting).

This is a slightly unfair comparison and there are ways to speed up your loops, for example by pre-allocating a vector of the correct length before you run the loop.  However, even if you do this, the result will still be around 20 times slower and will be even more verbose.  It is good practice whenever you write a `for` loop in R to check if there is not a better way to do so using vectorised functions. The majority of R's built-in functions are vectorised and using these effectively is a prerequisite of using R effectively.

### Higher-order functions

Because functions in R are first class citizens of the language, it is trivial to write and use functions that take other functions as arguments.  The most well used of these are the functions in the apply family (`lapply`, `sapply`, `apply` etc.).  These cause a lot of headaches for new-ish R users, who have just got to grips with for loops, but they are really no more difficult to use.  When you use one of these apply functions, you are just taking a collection of data (say a list or vector) and applying the input function to every element of the collection in turn, and collecting the results in another collection.

![Apply functions](/img/apply_functions.png)

Because the mapping of each element to the function is independent of the elements around it, you can split the collections up and join them together at the end, which means that the functions can be better optimised than a `for` loop (especially in the case of `lapply`) and also easily run over multiple processor cores (see `multicore::mclapply`).

Conceptually, to use these functions you just need to think about what your input is, what the function you want to apply to each element is and what data structure you want as your output:

* `lapply` : Any collection -> FUNCTION -> list 
* `sapply` : Any collection -> FUNCTION -> matrix/vector
* `apply`  : Matrix/dataframe + margin -> FUNCTION -> matrix/vector
* `Reduce` : Any collection -> FUNCTION -> single element

so if you want your output in a list, use `lapply`. If you want a vector or matrix, use `sapply`.  If you want to calculate summaries of the rows or columns of a dataframe, use `apply`. If you want to condense your dataset down into a single summary number, use `Reduce`.  There are several other functions in the same family, which all follow a similar pattern.

### Closures

Closures are at the heart of all functional programming languages.  Essentially a closure is a function to which has been added data via its arguments.  The function 'closes over' the data at the time the function was created and it is possible to access it at a later time.  Compare this to the idea of an object in languages like C++ and Java, which are data with functions attached to them.

![closures](/img/closure.png)

You can use closures to build wrappers around functions with new default values and partially apply functions and even mimic Object-oriented style objects, but possibly most interestingly, you can build functions that return other functions.  This is great if you want to call a function many times on the same dataset but with different parameters, such as in maximum-likelihood optimisation problems when you are seeking to minimise some cost function and also for randomisation and bootstrapping algorithms.

To demonstrate the usefulness of this, I am now going to build a generic bootstrapping algorithm in a functional style that can be applied to any linear model.  It will demonstrate not only functions returning functions, but higher-order functions (in this case, `sapply`), anonymous functions (in the mapping function to `sapply`) and vectorised functions.  I will then compare this against a non-FP version of the algorithm and hopefully some of the advantages of writing in an FP style in R will become clear.  Here is the code. I am doing a bootstrap of a simple linear model on the classic `iris` dataset:


```r
boot.lm <- function(formula, data, ...){
  function(){
    lm(formula=formula, 
       data=data[sample(nrow(data), replace=TRUE),], ...)
  }
}

iris.boot <- boot.lm(Sepal.Length ~ Petal.Length, iris)
bstrap <- sapply(X=1:1000, 
                 FUN=function(x) iris.boot()$coef)
```


That is the algorithm. The boot.lm function returns a closure.  You pass it a linear model formula and a dataframe and it returns a function with no arguments that itself returns a linear model object of a bootstrapped replicate (sample with replacement) of the supplied data.  So, the iris.boot function takes the formula of Sepal.Length~Petal.Length and the iris dataset and every time you call it it gives a new bootstrap replicate of that model on that data.  You then just need to run this 1000 times and collect the coefficients, which can be done with a one-liner sapply call.  We are using sapply because we want a matrix of coefficients with one line per replicate. The `FUN` argument to `sapply` is an anonymous function that returns the coefficients of the function.  You could have equally well have written something like


```r
get.coefs <- function(x){
    iris.boot$coef
}

bstrap <- sapply(X=1:1000, 
                 FUN=get.coefs)
```


... but because the function is so short, it is no less clear to include it without a name.

Once the model has run, we can use the `apply` higher-order function to summarise the rows of `bstrap` by applying the `quantile` function to give the median and 95% confidence intervals:


```r

apply(bstrap, MARGIN=1, FUN=quantile, 
      probs=c(0.025, 0.5, 0.975))
```

```
##       (Intercept) Petal.Length
## 2.5%        4.157       0.3696
## 50%         4.310       0.4083
## 97.5%       4.464       0.4461
```


This is an elegant way to solve a common analysis problem in R.  If you are running a large model and you want to speed things up (and you have a few cores free!), it is a simple task and a couple of lines of code to replace the call to `sapply` to one to `multicore::mclapply` and run the model on as many processor cores as you can.

In contrast, here is a roughly equivalent non-FP style bootstrapping algorithm:


```r
boot_lm_nf <- function(d, form, iters, output, ...){
  for(i in 1:iters){
    x <- lm(formula=form, 
            data=d[sample(nrow(d),
                   replace = TRUE),], ...)[[output]]
    if(i == 1){
      bootstrap <- matrix(data=NA, nrow=iters, 
                    ncol=length(x), 
                    dimnames=list(NULL,names(x)))
      bootstrap[i,] <- x
    } else bootstrap[i,] <- x
  }
  bootstrap
}
```


This ugly beast is full of `for`s and `if`s and braces and brackets and double brackets.  It has a load of extra boilerplate code to define the variables and fill the matrices.  Plus, it is less generic than the FP version since you can only output the attributes of the model itself, whereas previously we could apply any function we like in place of the anonymous function in the `sapply` call.  It is more than twice as verbose and impossible to multicore without a complete rewrite.  On top of all that, getting the coefficients out in a non-FP way is a tedious task:


```r
bstrap2 <- boot_lm_nf(d=iris, 
            form=Sepal.Length ~ Petal.Length, 
            iters=1000, output="coefficients")
CIs <- c(0.025, 0.5, 0.975)
cbind( "(Intercept)"=quantile(bstrap2[,1],probs = CIs),
      "Petal.Length"=quantile(bstrap2[,2],probs = CIs))
```

```
##       (Intercept) Petal.Length
## 2.5%        4.157       0.3708
## 50%         4.306       0.4088
## 97.5%       4.453       0.4457
```


The code duplication in the `cbind` is a pain, as is having to name the coefficients directly.  Both of these reduce the generalisability of the algorithm.

Wrapping up
-----------

I hope I have demonstrated that writing more functional R code is 

* More concise (fewer lines of code)
* Often faster (Particularly with effective vectorisation)
* Clearer and less prone to bugs (because you are abstracting away a lot of the 'how to' code)
* More elegant

R is a strongly functional language to its core and if you work with this in your code, your R hacking will be more intuitive, productive and enjoyable.

Further Reading
---------------

Here are some good and accessible resources available if you want to learn more about functional programming in general and FP in R in particular:

* [Structure and interpretation of computer programs](mitpress.mit.edu/sicp) by Abelson and Sussman is the bible of FP and is written by the creators of Scheme.  This book has been used as the core of the MIT Computer Science course since the early 1990s and is still not dated.
* [Hadley Wickham's in progress ebook](github.com/hadley/devtools/wiki) on Github is a fantastic resource on FP in R amongst a host of other advanced R topics.
* [The R Inferno](www.burns-stat.com/pages/Tutor/R_inferno.pdf) by Patrick Burns is a classic free online book on R and has a great chapter on vectorisation and when it is best to apply it.
* If you are intersted in the metaphysical stuff at the start of this post, Rich Hickey, the inventor of the Clojure language give [this](http://www.infoq.com/presentations/Are-We-There-Yet-Rich-Hickey) great talk on the importance of FP and the failings of the traditional OOP model.  The talk was also summarised nicely in [this](http://www.flyingmachinestudios.com/programming/the-unofficial-guide-to-rich-hickeys-brain/) blog post.



