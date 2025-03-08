#set heading(numbering: "1.")
#align(center, text(20pt)[*Draft Analyser*])

= Modeling
== Defining Items and Objects

Let us define a champion by an ID: each champion has a unique ID between $1$ and $170$ (since there are currently 170 champions).\
Let us define the Victory-Defeat matrix $M in M_(170)(NN)$.\
For $(i,j) in [|1; 170|]^2$, the coefficient$M_(i,j)$ represents the number of victories of champion $i$ over the champion $j$.\
In consequence we can have the number of win $w_i in NN$ and the number of loose $l_i in NN$.
$ w_i = (sum_(k=1)^(170) M_(i,k))/5\
l_i =  (sum_(k=1)^(170) M_(k,i))/5 $

$w_i$ will be the sum of the line $i$ and $l_i$ will be the sum of the column $i$ (and we will explain why over $5$ later).

== Draft
What is a draft ? A draft is the selection of 5 champions against 5 others champions which are all different : we can define that mathematicaly with an $10-"tuple"$ we can call D wiath distinct element.
$ D = (x_1,x_2,x_3,x_4,x_5,x_5,x_6,x_7,x_8,x_9,x_(10))\
forall (i,j) in [|1,10|] "we have : " x_i != x_j $
The draft is cut in two teams the "Red" team and the "Blue" team. So let us define two $5-"tuple"$: $R$ and $B$ :
$ R = (x_1,x_2,x_3,x_4,x_5)\
B = (x_5,x_5,x_6,x_7,x_8,x_9,x_(10)) $
And finnaly after a match one of the two team win and the other team loose and we need to update $M$.\
So for each victory champion we add 1 at each column of the defeat champion of the other team (we add one five times so that explain if we want to count the number of victory we need to over 5).

= Historical of draft and command in Prolog

= Result and conclusion