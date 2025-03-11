# Draft Analyzer

This project aims to analyze League of Legends drafts and will be used for the event **First Stand 2024**.
Here’s how to use it:
[You can find a PDF explaining the probability model here.](main.pdf)

---
## Load Data
- Open prolog file :
```
consult('Analyser.pl').
```
- Load the champion file :
```
process_file('LstLegend.txt').
```
- Initialize matrix (this will fill the file `matrix.txt` with 0 for total reset).
```
initialiser(Matrix)
```
## Add Victory and Update Data Matrix
The first 5 champions represent the winning team, and the last 5 represent the losing team:
```
add_victory('Ornn','Maokai','Tristana','Varus','Nautilus','Jayce','Vi','Aurora','Ezreal','Rell').

```

## Check win probability
The first 5 champions represent one team, and the last 5 represent the other team. This will calculate the probability of the first team winning:
```
load_matrix('matrix.txt',Matrix),
win_proba_draft('K\'Sante','Nocturne','Taliyah','Lucian','Nami','Gnar','Xin Zhao','Ahri','Zeri','Yuumi',Matrix,P).
```