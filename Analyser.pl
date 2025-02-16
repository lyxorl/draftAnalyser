
process_file(Filename) :-
    open(Filename, read, Stream),
    read_lines(Stream, Lines),
    close(Stream),
    process_lines(Lines).

read_lines(Stream, []) :-
    at_end_of_stream(Stream).
read_lines(Stream, [Line | Rest]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    read_lines(Stream, Rest).

process_lines([]).
process_lines([Line | Rest]) :-
    atom_string(Nom, Line),
    assertz(champion(Nom)),
    assertz(champion_id(Nom,0)), %faire l'ajout de 1 par recurrence
    process_lines(Rest).

