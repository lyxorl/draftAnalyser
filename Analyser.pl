
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matrix Gestion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_matrix(N, Matrix) :- %Square Matrix
    create_matrix(N, N, Matrix).

create_matrix(0, _, []).

create_matrix(Rows, Cols, [Row | Rest]) :-
    Rows > 0,
    create_row(Cols, Row), % /!\ Row != Rows  and add 0 in matrix
    New_rows is Rows -1,
    create_matrix(New_rows, Cols, Rest).

create_row(0, []).

create_row(N, [0 | Rest]) :- % Fill Matrix with 0
    N > 0,
    New_N is N-1,
    create_row(New_N, Rest).

modify_matrix(Matrix, I, J, Value, NewMatrix) :-
    nth1(I, Matrix, Row),
    replace_in_list(J, Value, Row, NewRow),
    replace_in_list(I, NewRow, Matrix, NewMatrix).

increment_matrix(Matrix, I, J, NewMatrix) :-
    nth1(I, Matrix, Row),
    nth1(J, Row, Value),
    NewValue is Value + 1,
    replace_in_list(J, NewValue, Row, NewRow),
    replace_in_list(I, NewRow, Matrix, NewMatrix).

replace_in_list(Index, Value, List, NewList) :-
    nth1(Index, List, _, Temp),
    nth1(Index, NewList, Value, Temp).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%File loading and saving gestion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save_matrix(Filename, Matrix) :-
    open(Filename, write, Stream),
    write(Stream, Matrix),
    nl(Stream),
    close(Stream).

load_matrix(Filename, Matrix) :-
    open(Filename, read, Stream),
    read_line_to_codes(Stream, Codes),
    close(Stream),
    atom_codes(Atom, Codes),
    atom_to_term(Atom, Matrix, _).

process_file(Filename) :-
    open(Filename, read, Stream),
    read_lines(Stream, Lines),
    close(Stream),
    process_lines(Lines, 1). % start at 1 for matrix

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initialiser(Matrix) :-
    process_file('LstLegend.txt'),
    create_matrix(170, 170, Matrix),
    save_matrix('matrix.txt',Matrix).

draft_check(Wtop,Wjgl,Wmid,Wadc,Wsup,Ltop,Ljgl,Lmid,Ladc,Lsup) :-
    %add checking to have different champ and valid draft
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

    add_victory_one_champ(Matrix, WChamp, LChamp, NewMatrix) :-
    champion_id(WChamp,WchampID),
    champion_id(LChamp,LChampID),
    increment_matrix(Matrix,WchampID,LChampID,NewMatrix).

add_victory_one_champ_for_five(Matrix, WChamp, LChamp1, LChamp2, LChamp3, LChamp4, LChamp5, NewMatrix) :-
    add_victory_one_champ(Matrix ,WChamp,LChamp1,Matrix1),
    add_victory_one_champ(Matrix1,WChamp,LChamp2,Matrix2),
    add_victory_one_champ(Matrix2,WChamp,LChamp3,Matrix3),
    add_victory_one_champ(Matrix3,WChamp,LChamp4,Matrix4),
    add_victory_one_champ(Matrix4,WChamp,LChamp5,NewMatrix).

add_victory(WTop,WMid,WJgl,WAdc,WSup,LTop,LMid,LJgl,LAdc,LSup) :-
    load_matrix('matrix.txt',Matrix),
    add_victory_one_champ_for_five(Matrix ,WTop,LTop,LJgl,LMid,LAdc,LSup,Matrix1),
    add_victory_one_champ_for_five(Matrix1,WJgl,LTop,LJgl,LMid,LAdc,LSup,Matrix2),
    add_victory_one_champ_for_five(Matrix2,WMid,LTop,LJgl,LMid,LAdc,LSup,Matrix3),
    add_victory_one_champ_for_five(Matrix3,WAdc,LTop,LJgl,LMid,LAdc,LSup,Matrix4),
    add_victory_one_champ_for_five(Matrix4,WSup,LTop,LJgl,LMid,LAdc,LSup,FinalMatrix),
    save_matrix('matrix.txt',FinalMatrix).