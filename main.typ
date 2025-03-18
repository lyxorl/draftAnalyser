#set heading(numbering: "1.")
#align(center, text(20pt)[*Draft Analyzer*])

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
```
initialiser(Matrix).
```

== KC - TL :

#align(center, [
#grid(
    columns: 11,
    column-gutter: 5pt,
    row-gutter: 5pt,
    align: horizon,
    fill: (x, y) =>
    if (y >= 1 and x >= 1) { if (x <= 5){
        blue
    } else { red } }
    else { if (x == 0 and y > 0){green} else {white} },
    grid.cell(
    colspan: 5,
    [#align(center, [*Victory*])]
    ),
    grid.cell(
    colspan: 5,
    [#align(center, [*Defeat*])]
    ),
    [],

    [_Game 1_\
    *TL Victory*],
    [Ornn],[Maokai],[Tristana],[Varus],[Nautilus],
    [Jayce],[Vi],[Aurora],[Ezreal],[Rell],

    [_Game 2_\
    *KC Victory*],
    [Camille],[Sejuani],[Azir],[Miss Fortune],[Leona],
    [Ambessa],[Skarner],[Aurelion Sol],[Ashe],[Pantheon],

    [_Game 3_\
    *TL Victory*],
    [K'Sante],[Nocturne],[Taliyah],[Lucian],[Nami],
    [Gnar],[Xin Zhao],[Ahri],[Zeri],[Yuumi]
    )
]
)

Add victory in matrix of the match :
```Python
add_victory('Ornn','Maokai','Tristana','Varus','Nautilus','Jayce','Vi','Aurora','Ezreal','Rell').
add_victory('Camille','Sejuani','Azir','Miss Fortune','Leona','Ambessa','Skarner','Aurelion Sol','Ashe','Pantheon').
add_victory('K\'Sante','Nocturne','Taliyah','Lucian','Nami','Gnar','Xin Zhao','Ahri','Zeri','Yuumi').
```

== TES - HLE

=== Draft :

#align(center, [
#grid(
    columns: 11,
    column-gutter: 5pt,
    row-gutter: 5pt,
    align: horizon,
    fill: (x, y) =>
    if (y >= 1 and x >= 1) { if (x <= 5){
        blue
    } else { red } }
    else { if (x == 0 and y > 0){green} else {white} },
    grid.cell(
    colspan: 5,
    [#align(center, [*Victory*])]
    ),
    grid.cell(
    colspan: 5,
    [#align(center, [*Defeat*])]
    ),
    [],

    [_Game 1_\
    *HLE Victory*],
    [Jax],[Skarner],[Azir],[Ezreal],[Alistar],
    [Kennen],[Vi],[Aurora],[Miss Fortune],[Leona],

    [_Game 2_\
    *HLE Victory*],
    [Aatrox],[Nidalee],[Akali],[Varus],[Poppy],
    [Gragas],[Nocturne],[Orianna],[Kalista],[Renata Glasc],
    )
]
)

=== Calcul of winning proba of the drafts

TES-HLE Game 1 :
```Python
load_matrix('matrix.txt',Matrix),win_proba_draft('Jax','Skarner','Azir','Ezreal','Alistar','Kennen','Vi','Aurora','Miss Fortune','Leona',Matrix,P).
-> Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
-> P = 0.47834688488309984.
```
This model give probability of 0.47 at the first five champ entered in data.\
In the final result the 5 first champ win this game
We can say the model guess wrong the issue of the match.

TES - HLE Game 2 :
```python
load_matrix('matrix.txt',Matrix),win_proba_draft('Gragas','Nocturne','Orianna','Kalista','Renata Glasc','Aatrox','Nidalee','Akali','Varus','Poppy',Matrix,P).
-> Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
-> P = 0.5.
```
This model give probability of 0.5 at the first five champ entered in data.\
In the final result the 5 first champ win this game.

=== Add Victory in Matrix

```python
add_victory('Jax','Skarner','Azir','Ezreal','Alistar','Kennen','Vi','Aurora','Miss Fortune','Leona').
add_victory('Aatrox','Nidalee','Akali','Varus','Poppy','Gragas','Nocturne','Orianna','Kalista','Renata Glasc').
```
== KC - CFO

=== Draft

#align(center, [
#grid(
    columns: 11,
    column-gutter: 5pt,
    row-gutter: 5pt,
    align: horizon,
    fill: (x, y) =>
    if (y >= 1 and x >= 1) { if (x <= 5){
        blue
    } else { red } }
    else { if (x == 0 and y > 0){green} else {white} },
    grid.cell(
    colspan: 5,
    [#align(center, [*Victory*])]
    ),
    grid.cell(
    colspan: 5,
    [#align(center, [*Defeat*])]
    ),
    [],

    [_Game 1_\
    *CFO Victory*],
    [Rumble],[Skarner],[Viktor],[Ezreal],[Leona],
    [Ambessa],[Vi],[Aurora],[Kai\'Sa],[Rakan],

    [_Game 2_\
    *CFO Victory*],
    [Sion],[Sejuani],[Taliyah],[Miss Fortune],[Rell],
    [Jayce],[Brand],[Yone],[Varus],[Nautilus],
    )
]
)

=== Calculus of the winning probability of the drafts

KC - CFO Game 1 :
```python
load_matrix('matrix.txt',Matrix),win_proba_draft('Ambessa','Vi','Aurora','Kai\'Sa','Rakan','Rumble','Skarner','Viktor','Ezreal','Leona',Matrix,P).
-> Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
-> P = 0.4419298941260467.
```
This model give probability of 0.44 at the first five champ entered in data.\
In the final result the 5 last champ win this game.
We can say the model give a good reponse because he give a proba of 56% to win at the last five champ.

KC -CFO Game 2 :
```python
load_matrix('matrix.txt',Matrix),win_proba_draft('Jayce','Brand','Yone','Varus','Nautilus','Sion','Sejuani','Taliyah','Miss Fortune','Rell',Matrix,P).
->Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
->P = 0.5133301737382324.
```
This time the model don't give a good prediction.

=== Add victory in matrix
```python
add_victory('Rumble','Skarner','Viktor','Ezreal','Leona','Ambessa','Vi','Aurora','Kai\'Sa','Rakan').
add_victory('Sion','Sejuani','Taliyah','Miss Fortune','Rell','Jayce','Brand','Yone','Varus','Nautilus').
```

== TES - TL

=== Draft

#align(center, [
#grid(
    columns: 11,
    column-gutter: 5pt,
    row-gutter: 5pt,
    align: horizon,
    fill: (x, y) =>
    if (y >= 1 and x >= 1) { if (x <= 5){
        blue
    } else { red } }
    else { if (x == 0 and y > 0){green} else {white} },
    grid.cell(
    colspan: 5,
    [#align(center, [*Victory*])]
    ),
    grid.cell(
    colspan: 5,
    [#align(center, [*Defeat*])]
    ),
    [],

    [_Game 1_\
    *TES Victory*],
    [Rumble],[Vi],[Aurora],[Ashe],[Braum],
    [Galio],[Xin Zhao],[Tristana],[Ezreal],[Rakan],

    [_Game 2_\
    *TES Victory*],
    [Aatrox],[Pantheon],[Sylas],[Varus],[Neeko],
    [K'Sante],[Maokai],[Hwei],[Kalista],[Nautilus],
    )
]
)

=== Calculus of the winning probability of the drafts

TES - TL Game 1 :
```python
load_matrix('matrix.txt',Matrix),win_proba_draft('Rumble','Vi','Aurora','Ashe','Braum','Galio','Xin Zhao','Tristana','Ezreal','Rakan',Matrix,P).
-> Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
-> P = 0.46892897678537176.\
```
The model don't give a good prediction here.

TES - TL Game 2 :
```python
load_matrix('matrix.txt',Matrix),win_proba_draft('K\'Sante','Maokai','Hwei','Kalista','Nautilus','Aatrox','Pantheon','Sylas','Varus','Neeko',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.49222284950490025.
```
Here the model give a good prediction.

=== Add victory in matrix
```python
add_victory('Rumble','Vi','Aurora','Ashe','Braum','Galio','Xin Zhao','Tristana','Ezreal','Rakan').
add_victory('Aatrox','Pantheon','Sylas','Varus','Neeko','K\'Sante','Maokai','Hwei','Kalista','Nautilus').
```

== HLE - CFO

load_matrix('matrix.txt',Matrix),win_proba_draft('Rumble','Vi','Yone','Ashe','Rakan','Karma','Wukong','Azir','Ezreal','Alistar',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.4553966612109141.

add_victory('Rumble','Vi','Yone','Ashe','Rakan','Karma','Wukong','Azir','Ezreal','Alistar').

load_matrix('matrix.txt',Matrix),win_proba_draft('Vladimir','Nidalee','Zed','Miss Fortune','Rell','Gragas','Kindred','Taliyah','Corki','Leona',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.51499550161941.

add_victory('Vladimir','Nidalee','Zed','Miss Fortune','Rell','Gragas','Kindred','Taliyah','Corki','Leona').

== TES - KC

load_matrix('matrix.txt',Matrix),win_proba_draft('Ambessa','Viego','Aurora','Kalista','Renata Glasc','Jayce','Skarner','Taliyah','Ashe','Karma',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.46588641397664204.

add_victory('Jayce','Skarner','Taliyah','Ashe','Karma','Ambessa','Viego','Aurora','Kalista','Renata Glasc').

load_matrix('matrix.txt',Matrix),win_proba_draft('Gnar','Karthus','Corki','Varus','Rell','Aatrox','Ivern','Yone','Ezreal','Leona',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5036110483266414.

add_victory('Aatrox','Ivern','Yone','Ezreal','Leona','Gnar','Karthus','Corki','Varus','Rell').

== CFO - TL

load_matrix('matrix.txt',Matrix),win_proba_draft('K\'Sante','Xin Zhao','Azir','Ezreal','Alistar','Gwen','Vi','Taliyah','Kai\'Sa','Rakan',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.4830620392311757.

add_victory('K\'Sante','Xin Zhao','Azir','Ezreal','Alistar','Gwen','Vi','Taliyah','Kai\'Sa','Rakan').

load_matrix('matrix.txt',Matrix),win_proba_draft('Jax','Sejuani','Corki','Ziggs','Poppy','Gangplank','Maokai','Yone','Tristana','Leona',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5122197884189273.

add_victory('Gangplank','Maokai','Yone','Tristana','Leona','Jax','Sejuani','Corki','Ziggs','Poppy').

== KC - HLE

load_matrix('matrix.txt',Matrix),win_proba_draft('Rumble','Xin Zhao','Taliyah','Ezreal','Leona','Aurora','Vi','Sylas','Varus','Poppy',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5647338377718968.

add_victory('Aurora','Vi','Sylas','Varus','Poppy','Rumble','Xin Zhao','Taliyah','Ezreal','Leona').

load_matrix('matrix.txt',Matrix),win_proba_draft('Ambessa','Ivern','Azir','Jhin','Alistar','Gnar','Maokai','Corki','Ashe','Renata Glasc',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5271953567276605.

add_victory('Ambessa','Ivern','Azir','Jhin','Alistar','Gnar','Maokai','Corki','Ashe','Renata Glasc').

load_matrix('matrix.txt',Matrix),win_proba_draft('Vladimir','Wukong','Jayce','Kai\'Sa','Rell','Sion','Sejuani','Ryze','Draven','Rakan',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.4628463872345206.

add_victory('Vladimir','Wukong','Jayce','Kai\'Sa','Rell','Sion','Sejuani','Ryze','Draven','Rakan').

== CFO - TES

load_matrix('matrix.txt',Matrix),win_proba_draft('Jayce','Sejuani','Taliyah','Ezreal','Alistar','K\'Sante','Nidalee','Yone','Jhin','Leona',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.4652676676122881.

add_victory('Jayce','Sejuani','Taliyah','Ezreal','Alistar','K\'Sante','Nidalee','Yone','Jhin','Leona').

load_matrix('matrix.txt',Matrix),win_proba_draft('Rumble','Xin Zhao','Sylas','Corki','Poppy','Sion','Skarner','Azir','Caitlyn','Nautilus',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5049998333399998.

add_victory('Sion','Skarner','Azir','Caitlyn','Nautilus','Rumble','Xin Zhao','Sylas','Corki','Poppy').

== HLE - TL

load_matrix('matrix.txt',Matrix),win_proba_draft('K\'Sante','Pantheon','Ziggs','Kalista','Renata Glasc','Kayle','Vi','Ryze','Draven','Pyke',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5020833212770899.

add_victory('Kayle','Vi','Ryze','Draven','Pyke','K\'Sante','Pantheon','Ziggs','Kalista','Renata Glasc').

load_matrix('matrix.txt',Matrix),win_proba_draft('Renekton','Maokai','Cassiopeia','Varus','Rakan','Quinn','Zyra','Tristana','Jhin','Rell',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.48611468225399523.

add_victory('Renekton','Maokai','Cassiopeia','Varus','Rakan','Quinn','Zyra','Tristana','Jhin','Rell').

load_matrix('matrix.txt',Matrix),win_proba_draft('Ambessa','Skarner','Kassadin','Sivir','Braum','Jax','Ivern','Viktor','Ezreal','Leona',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.4775151752081999.

add_victory('Ambessa','Skarner','Kassadin','Sivir','Braum','Jax','Ivern','Viktor','Ezreal','Leona').

= Semi Final 1 : KC - CFO

?- load_matrix('matrix.txt',Matrix),win_proba_draft('Rumble','Xin Zhao','Azir','Sivir','Alistar','Jayce','Sejuani','Yone','Varus','Leona',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5110828404852331.
wrong result

add_victory('Jayce','Sejuani','Yone','Varus','Leona','Rumble','Xin Zhao','Azir','Sivir','Alistar').

?- load_matrix('matrix.txt',Matrix),win_proba_draft('Gragas','Kindred','Galio','Ezreal','Nautilus','Aatrox','Pantheon','Taliyah','Kai\'Sa','Rell',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.45449495193935213.
good result

add_victory('Aatrox','Pantheon','Taliyah','Kai\'Sa','Rell','Gragas','Kindred','Galio','Ezreal','Nautilus').

load_matrix('matrix.txt',Matrix),win_proba_draft('Renekton','Nidalee','Tristana','Ashe','Thresh','Ambessa','Vi','Hwei','Jhin','Pyke',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5181401827610472.
good result

add_victory('Renekton','Nidalee','Tristana','Ashe','Thresh','Ambessa','Vi','Hwei','Jhin','Pyke').

load_matrix('matrix.txt',Matrix),win_proba_draft('Ornn','Nocturne','Akali','Kalista','Renata Glasc','Gnar','Wukong','Aurora','Caitlyn','Karma',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5027777492001699.
good result

add_victory('Ornn','Nocturne','Akali','Kalista','Renata Glasc','Gnar','Wukong','Aurora','Caitlyn','Karma').

load_matrix('matrix.txt',Matrix),win_proba_draft('Gangplank','Skarner','Orianna','Zeri','Yuumi','Jax','Maokai','Aurora','Corki','Senna',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5351798696276825.
wrong result

add_victory('Jax','Maokai','Aurora','Corki','Senna','Gangplank','Skarner','Orianna','Zeri','Yuumi').

= Semi Final 2 : HLE - TES

load_matrix('matrix.txt',Matrix),win_proba_draft('Rumble','Wukong','Azir','Ezreal','Alistar','Jayce','Sejuani','Yone','Miss Fortune','Rakan',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.47494164615261975.
wrong result

add_victory('Rumble','Wukong','Azir','Ezreal','Alistar','Jayce','Sejuani','Yone','Miss Fortune','Rakan').

load_matrix('matrix.txt',Matrix),win_proba_draft('Aatrox','Vi','Akali','Ashe','Rell','Renekton','Xin Zhao','Sylas','Varus','Nautilus',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5022618893321819.
good result

add_victory('Aatrox','Vi','Akali','Ashe','Rell','Renekton','Xin Zhao','Sylas','Varus','Nautilus').

load_matrix('matrix.txt',Matrix),win_proba_draft('Jax','Maokai','Vladimir','Jhin','Blitzcrank','Ambessa','Pantheon','Aurora','Corki','Bard',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5306559441632994.
good result

add_victory('Jax','Maokai','Vladimir','Jhin','Blitzcrank','Ambessa','Pantheon','Aurora','Corki','Bard').

= FINAL : HLE - KC

load_matrix('matrix.txt',Matrix),win_proba_draft('Rumble','Wukong','Azir','Kai\'Sa','Alistar','Jayce','Maokai','Taliyah','Miss Fortune','Rakan',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5864764357559431.
wrong result

add_victory('Jayce','Maokai','Taliyah','Miss Fortune','Rakan','Rumble','Wukong','Azir','Kai\'Sa','Alistar').

load_matrix('matrix.txt',Matrix),win_proba_draft('Gnar','Skarner','Aurora','Varus','Braum','Aatrox','Ivern','Hwei','Ezreal','Leona',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5045969400679873.
good result

add_victory('Gnar','Skarner','Aurora','Varus','Braum','Aatrox','Ivern','Hwei','Ezreal','Leona').

load_matrix('matrix.txt',Matrix),win_proba_draft('Jax','Xin Zhao','Sylas','Ashe','Sett','Gangplank','Sejuani','Viktor','Jhin','Rell',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.47282442588745366.
wrong result

add_victory('Jax','Xin Zhao','Sylas','Ashe','Sett','Gangplank','Sejuani','Viktor','Jhin','Rell').

load_matrix('matrix.txt',Matrix),win_proba_draft('Camille','Vi','Ahri','Xayah','Gragas','Kennen','Pantheon','Galio','Draven','Renata Glasc',Matrix,P).
Matrix = [[0, 0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0, 0|...], [0, 0, 0, 0, 0|...], [0, 0, 0, 0|...], [0, 0, 0|...], [0, 0|...], [0|...], [...|...]|...],
P = 0.5341889901715515.
good result

add_victory('Camille','Vi','Ahri','Xayah','Gragas','Kennen','Pantheon','Galio','Draven','Renata Glasc').

= Result and conclusion