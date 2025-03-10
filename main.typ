#set heading(numbering: "1.")
#align(center, text(20pt)[*Draft Analyser*])

= Modeling
== Defining Items and Objects

Let us define a champion by an ID: each champion has a unique ID between $1$ and $170$ (since there are currently 170 champions).\
Let us define the Victory-Defeat matrix $M in M_(170)(NN)$.\
For $(i,j) in [|1; 170|]^2$, the coefficient$M_(i,j)$ represents the number of victories of champion $i$ over the champion $j$.\
Consequently we can have the number of win $w_i in NN$ and the number of loose $l_i in NN$.
$ w_i = (sum_(k=1)^(170) M_(i,k))/5\
l_i =  (sum_(k=1)^(170) M_(k,i))/5 $

$w_i$ will be the sum of the line $i$ and $l_i$ will be the sum of the column $i$ . We will explain later why these sums are divided by 5.

== Draft
What is a draft ? A draft is the selection of 5 champions against 5 others champions, all of which are distinct. Mathematically, we can define a draft as a $10$-tuple, denoted by D :
$ D = (x_1,x_2,x_3,x_4,x_5,x_5,x_6,x_7,x_8,x_9,x_(10))\
forall (i,j) in [|1,10|] "we have : " x_i != x_j $
The draft is divided into two teams: the "Red" team and the "Blue" team. We can define these teams as two $5-$tuple: $R$ and $B$:
$ R = (x_1,x_2,x_3,x_4,x_5)\
B = (x_5,x_6,x_7,x_8,x_9,x_(10)) $
And finnaly after a match one of the two team win and the other team loose and we need to update $M$.\
After a match, one team wins and the other loses, and we update the matrix $M$ accordingly. For each victorious champion, we add 1 to each column corresponding to the defeated champions of the opposing team. Since there are 5 champions on each team, this explains why we divide by 5 when calculating the number of wins and losses.

== Probability

Now let's create your model to calculate probability of win of the "Red" or "Blue" with the history of the last match.\
First define define the "Strength of a champion" called $S_i$ :
$ S_i = sum_(k=1)^(5) ((w_(x_k)/(w_(x_k)+l_(x_k)))1/3 + (M_(i,k)/(M_(i,k) + M_(k,i)))2/3) $

Lets add details about $S_i$ :
- $i$ is the indice of the champion in draft.
- $x_i$ is the indice of the chmapion in the oppenent team for $i in [|1,5|]$.
- $1/3$ and $2/3$ are weights for the general win probability and for the direct matchup.

Now we can define the "Strength of team" for the "Red" and for the "Blue" : $S_R$ and $S_B$

$ S_t = sum_(k=1)^(5) S_k $

with $t in {R,B}$

Now lets use the logistic function to have the probabilty of winnig of one side :

$ PP_R = 1/(1+e^(-(S_R-S_B))) $


= Historical of draft and command in Prolog

initialiser(Matrix).
add_victory('Ornn','Maokai','Tristana','Varus','Nautilus','Jayce','Vi','Aurora','Ezreal','Rell').
add_victory('Camille','Sejuani','Azir','Miss Fortune','Leona','Ambessa','Skarner','Aurelion Sol','Ashe','Pantheon').
add_victory('K\'Sante','Nocturne','Taliyah','Lucian','Nami','Gnar','Xin Zhao','Ahri','Zeri','Yuumi').\

first test :\
load_matrix('matrix.txt',Matrix),win_proba_draft('Jax','Skarner','Azir','Ezreal','Alistar','Kennen','Vi','Aurora','Miss Fortune','Leona',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.47834688488309984.

= Result and conclusion