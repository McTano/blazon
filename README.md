# blazon
An experiment in heraldry.

## Background of blazon
The term "blazon" has two important meanings, generally clearly distinguished by context:

    1. A codified written description of a coat of arms.
    2. The language in which such a description is written.

In the first sense, a blazon is the canonical representation of a coat of arms, or other heraldic component. We will focus on the coat of arms (the shield). In the second sense, blazon is a Domain Specific Language for describing Heraldry.

In theory, given a particular blazon, a heraldic artist can recreate the associated coat of arms based on no additional information. Although different artists may produce visually different results, the result should be judged as correct to the extent which it agrees with the blazon. Anything not conveyed by the blazon is not officially part of the arms.

This aspect of Heraldry has been referred to (e.g. by Arthur Fox-Davies) as "The Science of Heraldry", to emphasize its exactness, while the graphical depiction of coats of arms has been similarly called "The Art of Heraldry".

A natural question is whether the language is in fact precise enough that it could be interpreted by a computer program and compiled to an image. We will call such a program an *artificial herald*.

## Key terms
*charge*: a heraldic image, either representational or abstract.
*ordinary*: a basic geometric heraldic image, whose size and shape is determined by the size and shape of the shield (or sub-shield) on which it appears.
*tincture*: A colour or pattern used in heraldry. Traditionally, these are divided into *metals* (gold and silver), *colours* (other colours), and *furs* (patterns). The distinction between metals and colours is not important for our purposes, and we will ignore furs at this stage.

## Prior Work
[Drawshield](https://drawshield.net/) is the most effective artificial herald of which we are aware. It supports basic imagery very well, and allows nesting of shields, for example, by quartering.
We have also found a 1998 honor's thesis dealing with this topic, [Heraldry and Programming Languages: the
Complexity of Natural Languages Examined
through the Parsing of the Heraldic Blazon](https://digitalcommons.csbsju.edu/cgi/viewcontent.cgi?article=1661&context=honors_theses) 

## Our Approach

The key idea motivating our approach is that constructing a coat of arms (from an empty shield) can be expressed as repeated composition of the following atoms and transformations:

Atoms:
1. A Basic Shield, or Field, representing an area of a certain tincture.
2. A charge, or group of charges.

Transformations:
1. Place one or more charges on top of a shield.
2. Divide a shield into two or more sub-shields.

A blazon can therefore be represented by an abstract syntax tree where each non-leaf node represents one of these transformations, and each leaf node is either a field or a charge.

Racket, and particularly the plai variant we have been using in class, is well suited to representing this abstract syntax.

In addition, it is possible that some ambiguities in traditional blazon can be resolved by adding punctuation (such as parentheses or commas) to our blazon language. The resulting concrete syntax may end up looking very much like a lisp, which would perhaps be unattractive or frustrating to someone trying to use the artificial herald on a real blazon.

Ideally, we could come up with a syntax for blazon in which parentheses are optional, except where not using them leads to ambiguities. This would mean that we had some clearer idea of what constitutes an ambiguity in the concrete syntax.

If so, this would be an improvement on the current situation, which is less clear. As the creator of Drawshield puts it,
   *"After careful study of many blazons I have been able to determine that all punctuation can be safely ignored, except for when it can't! By this I mean that it is used so inconsistently between blazons that it is almost useless to treat  punctuation characters in any consistent and meaningful way."*
