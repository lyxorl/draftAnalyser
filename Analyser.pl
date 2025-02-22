
create_matrix(N, Matrix) :-
    create_matrix(N, N, Matrix).

create_matrix(0, _, []).

create_matrix(Rows, Cols, [Row | Rest]) :-
    Rows > 0,
    create_row(Cols, Row), % Row != Rows
    New_rows is Rows -1,
    create_matrix(New_rows, Cols, Rest).

create_row(0, []).

create_row(N, [0 | Rest]) :-
    N > 0,
    New_N is N-1,
    create_row(New_N, Rest).

save_matrix(Filename, Matrix) :-
    open(Filename, write, Stream),  % Ouvre le fichier en mode écriture
    write(Stream, Matrix),          % Écrit la matrice dans le fichier
    nl(Stream),                     % Nouvelle ligne pour la lisibilité
    close(Stream).

load_matrix(Filename, Matrix) :-
    open(Filename, read, Stream),   % Ouvre le fichier en mode lecture
    read(Stream, Matrix),           % Lit la matrice depuis le fichier
    close(Stream).

modify_matrix(Matrix, I, J, Value, NewMatrix) :-
    nth1(I, Matrix, Row),           % Récupère la ligne I
    replace_in_list(J, Value, Row, NewRow), % Modifie l'élément J de la ligne
    replace_in_list(I, NewRow, Matrix, NewMatrix). % Remplace la ligne I dans la matrice

increment_matrix(Matrix, I, J, NewMatrix) :-
    nth1(I, Matrix, Row),           % Récupère la ligne I
    nth1(J, Row, Value),            % Récupère la valeur à la position (I, J)
    NewValue is Value + 1,          % Incrémente la valeur de 1
    replace_in_list(J, NewValue, Row, NewRow), % Remplace la valeur dans la ligne
    replace_in_list(I, NewRow, Matrix, NewMatrix). % Remplace la ligne dans la matrice

replace_in_list(Index, Value, List, NewList) :-
    nth1(Index, List, _, Temp),     % Récupère les éléments avant l'index
    nth1(Index, NewList, Value, Temp). % Insère la nouvelle valeur à l'index

process_file(Filename) :-
    open(Filename, read, Stream),
    read_lines(Stream, Lines),
    close(Stream),
    process_lines(Lines, 1). % les indices commence a partir de 1

read_lines(Stream, []) :-
    at_end_of_stream(Stream).
read_lines(Stream, [Line | Rest]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    read_lines(Stream, Rest).

process_lines([], _).
process_lines([Line | Rest], Id) :-
    atom_string(Nom, Line),
    assertz(champion(Nom)),
    assertz(champion_id(Nom,Id)),
    NewID is Id+1,
    process_lines(Rest, NewID).

draft(Wtop,Wjgl,Wmid,Wadc,Wsup,Ltop,Ljgl,Lmid,Ladc,Lsup) :-
    champion(Wtop),
    champion(Wjgl),
    champion(Wmid),
    champion(Wadc),
    champion(Wsup),
    champion(Ltop),
    champion(Ljgl),
    champion(Lmid),
    champion(Ladc),
    champion(Lsup).

add_victory(WTop,WMid,WJgl,WAdc,WSup,LTop,LMid,LJgl,LAdc,LSup, Matrix) :-
    champion_id(WTop,WtopID),
    champion_id(LTop,LTopID),
    increment_matrix(Matrix,WtopID,LTopID, NewMatrix),
    %increment_matrix(Matrix,champion_id(WJgl,X),champion_id(LJgl,Y), Matrix),
    %increment_matrix(Matrix,champion_id(WMid,X),champion_id(LMid,Y), Matrix),
    %increment_matrix(Matrix,champion_id(WAdc,X),champion_id(LAdc,Y), Matrix),
    %increment_matrix(Matrix,champion_id(WSup,X),champion_id(LSup,Y), Matrix),
    save_matrix('matrix.txt',NewMatrix).