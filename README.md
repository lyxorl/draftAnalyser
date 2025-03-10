# Draft Analyser

This project as goal to analyse League of Legends draft, and will bve use for the event First Stand 2024.
How to use it :

[There is a PDF which explain probability model here](main.pdf)

---
## Load Data
- Open prolog file :
```
consult('Analyser.pl').
```
- Load champion file :
```
process_file('LstLegend.txt').
```
- Initialise matrix (fill the file matrix.txt with 0 (total reset)).
```
initialiser(Matrix)
```
## Add victory and update data matrix
The first 5 champ are the winnig team and the five last are for the loser team :
```
add_victory('Ornn','Maokai','Tristana','Varus','Nautilus','Jayce','Vi','Aurora','Ezreal','Rell').

```

## Check win probability
The first 5 champ are 1 team and the five last the other team too :
```
load_matrix('matrix.txt',Matrix),
win_proba_draft('K\'Sante','Nocturne','Taliyah','Lucian','Nami','Gnar','Xin Zhao','Ahri','Zeri','Yuumi',Matrix,P).
```