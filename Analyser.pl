
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
    open(Filename, write, Stream),
    write(Stream, Matrix),
    nl(Stream),
    close(Stream).

load_matrix(Filename, Matrix) :-
    open(Filename, read, Stream),
    read(Stream, Matrix),
    close(Stream).

modify_matrix(Matrix, I, J, Value, NewMatrix) :-
    nth1(I, Matrix, Row),
    replace_in_list(J, Value, Row, NewRow),
    replace_in_list(I, NewRow, Matrix, NewMatrix).

increment_matrix(Matrix, I, J, NewMatrix) :-
    nth1(I, Matrix, Row),
    nth1(J, Row, Value),
    NewValue is Value + 1,
    replace_in_list(J, NewValue, Row, NewRow),
    replace_in_list(I, NewRow, Matrix, NewMatrix)

replace_in_list(Index, Value, List, NewList) :-
    nth1(Index, List, _, Temp),
    nth1(Index, NewList, Value, Temp).

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
    % add verification for valid draft
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
    %add victory of the draft
    champion_id(WTop,WtopID),
    champion_id(LTop,LTopID),
    increment_matrix(Matrix,WtopID,LTopID, NewMatrix),
    save_matrix('matrix.txt',NewMatrix).