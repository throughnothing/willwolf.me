---
title: Java 8 Coding Guide
date: 2017-11-08
tags: programming, java
---

I’m getting into Java services at work, and I put together a guide with some principles / best practices to follow for Java 8.  A lot of these things become much more possible with Java 8 than they would have been in earlier versions of Java, but they can also be applied to other programming languages and technologies.

I wrote this guide based on a desire to have code that is easy to reason about and understand, which means it will be easy for new folks to jump into the codebase over time, and also with a desire to quickly produce high quality code.  Performance is not the major concern of this guide.

Many of the principles and ideas come from my foray into functional programming with both [Haskell](https://www.haskell.org) and [Purescript](http://www.purescript.org), and I just find that these concepts are the way I prefer to program now.  Following these principles gives me much more confidence in the correctness of my code, and gives me peace of mind knowing that I’m giving myself the best chance of understanding the code when I come back to it months or years later.

Without further ado, you can check out the guide [here](https://gist.github.com/throughnothing/4a14dd3e4ab5e68eb154123ad11dae79) (inlined below).


<p/>
<hr/>
<p/>

Java 8 Coding Guide
=====================

This coding guide was written for a Java 8 project, but contains principles
that are valid in many languages.  It is aimed at producing code that is easy
to reason about, easy to validate and test, easy to maintain, and easy to
avoid common bugs and pitfalls.

## Avoid explicit `null` (or, Don't use `null`)

`Null` is famously the ["billion dollar mistake"](https://www.lucidchart.com/techblog/2015/08/31/the-worst-mistake-of-computer-science/) (and that's probably an
under-estimation!). Don't use `null` as a way of representing error or failure,
and also don't use `null` as a way to avoid passing a certain argument to a
function.  Essentially you should never explicitly use a `null` value unless
you are checking that something is not `null`.  Even in those cases, it
should probably be handled better by an `Option<T>`.

### Resources
* [https://github.com/google/guava/wiki/UsingAndAvoidingNullExplained](https://github.com/google/guava/wiki/UsingAndAvoidingNullExplained)
* [http://www.oracle.com/technetwork/articles/java/java8-optional-2175753.html](http://www.oracle.com/technetwork/articles/java/java8-optional-2175753.html)
* [https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare)


## Expressions over statements

Expressions are declarative and evaluate to (and return) a value, while
statements are imperative bits of code that perform actions. Because of this,
expressions are easier to reason about, debug, and verify correctness for.

A simple example is an `if` statement, vs an `if` expression. `If` in java
does not return a value, nor does java enforce that an `if` have an `else` branch.
Additionally, if there is an `else` branch, it does not have to result in
the same type of value as the `if` branch.  This makes if statements hard to
reason about and understand.  The ternary form `predicate ? value : value` is
preferable to `if`/`then` statements.

In a language like Java, statements will be required, but we should isolate
those to their own, small, methods, and keep their surface area as small as
possible to reduce risk and complexity from these parts of the code.

### Resources
* [https://fsharpforfunandprofit.com/posts/expressions-vs-statements/](https://fsharpforfunandprofit.com/posts/expressions-vs-statements/)
* [https://www.cs.ucf.edu/~dcm/Teaching/COT4810-Fall%202012/Literature/Backus.pdf](https://www.cs.ucf.edu/~dcm/Teaching/COT4810-Fall%202012/Literature/Backus.pdf)


## Avoid explicit loops

With Java 8, we have streams, and should no longer need explicit loops.  Loops
are very repetetive, and error prone, so we should leverage abstractions that
handle looping for us to avoid bugs, verbosity, and complexity in our code.

There may be some cases where loops are more desirable
(possibly for performance), but they should be avoided until it is clear they
are actually needed.

### Resources
* [http://www.deadcoderising.com/java-8-no-more-loops/](http://www.deadcoderising.com/java-8-no-more-loops/)
* [https://martinfowler.com/articles/refactoring-pipelines.html](https://martinfowler.com/articles/refactoring-pipelines.html)


## Use immutable data structures

We should leverage `guava`'s immutable data structures as much as possible to
avoid complicated bugs related to mutating state.

Additionally, we should leverage Lombok's `@Value` objects as much as possible
to make our own data objects immutable.

### Resources
* [https://github.com/google/guava/wiki/ImmutableCollectionsExplained](https://github.com/google/guava/wiki/ImmutableCollectionsExplained)
* [https://projectlombok.org/features/Value](https://projectlombok.org/features/Value)


## Don’t throw exceptions - use values!

In general, we should never throw an exception of our own. Obviously we will
use libraries that throw exceptions.  These exceptions should be caught directly
in the function/method using the library, and turned into values (to be returned)
as much as possible.

This is because exceptions are like `goto` statements, which make the flow
of your program much more difficult to reason about.  Every function that throws
an exception can return a value in 2 ways, through the "normal" return flow,
or through an exception, and every user of that function has to think about
both cases.  It is generally easier to reason about functions that only return
values (something like vavr's [Either](http://www.baeldung.com/vavr-either) or
[Try](http://www.baeldung.com/vavr-try) types work very well for this).  This
also makes it much easier to leverage Java 8's lambda-using utilities, as they
don't like accepting `Function`s that throw exceptions.

### Resources
* [https://www.joelonsoftware.com/2003/10/13/13/](https://www.joelonsoftware.com/2003/10/13/13/)
* [http://www.baeldung.com/vavr-try](http://www.baeldung.com/vavr-try)
* [http://www.baeldung.com/vavr-either](http://www.baeldung.com/vavr-either)
* [https://fsharpforfunandprofit.com/rop/](https://fsharpforfunandprofit.com/rop/)


## Fail early, enforce invariants

It is always best to fail as early as possible, at the soonest point that you
find something is wrong.  This often means that we should validate all of our
data up front, to decouple validation from the business logic that needs to
use the values in question.

Additionally, the more we can make fail at compile time, rather than run time,
the better off we will be at finding bugs earlie.  Use Java's typesystem as much
as you can to enforce invariants statically!

For our own data objects, we should have strong validation of each object, so
that once we've constructed one, we know it will have good data in the rest of
our program.  Failed construction (on validation errors) should also be
expressed by returning values, rather than exceptions.  Something like vavr's
[Validation]() type is useful for this purpose. Make it impossible to construct
a "bad"/invalid data object!

### Resources
* [https://www.leepoint.net/principles_and_practices/40fail-early-fail-often.html](https://www.leepoint.net/principles_and_practices/40fail-early-fail-often.html)
* [https://softwaremill.com/javaslang-data-validation/](https://softwaremill.com/javaslang-data-validation/)

## Composition over Inheritance

Inheritance can be very fragile, and make refactoring of complex code involving
inheritance hierarchies very difficult to do safely and confidently.
Composition (and in java, Interfaces) should be favored over inheritence
where possible.

Often inheritance is required by certain frameworks / libraries, but we should
limit the depth of inheritance hierarchies that we use as much as possible.

Composition, via composing interfaces or composable types, allows for
more design flexibility, and easier, more confident refactoring.

### Resources
* [https://www.thoughtworks.com/insights/blog/composition-vs-inheritance-how-choose](https://www.thoughtworks.com/insights/blog/composition-vs-inheritance-how-choose)
* [https://en.wikipedia.org/wiki/Composition_over_inheritance](https://en.wikipedia.org/wiki/Composition_over_inheritance)
* [https://variadic.me/posts/2014-03-28-composition-over-inheritance.html](https://variadic.me/posts/2014-03-28-composition-over-inheritance.html)