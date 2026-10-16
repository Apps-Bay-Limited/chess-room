# Offline puzzle content

The daily bank contains the seven original Chess Room positions and 64 additional original compositions. No external puzzle dataset was copied. The added positions vary the attacking pieces, supporting pieces, defenders, blockers, active color and checking square. Rotated and reflected copies were rejected during authoring.

The bank includes queen nets, back-rank mates, rook mates, bishop mates, knight mates and twelve forcing mate-in-two combinations. Difficulty describes the intended learning step rather than a calibrated chess rating. The daily selection remains deterministic for the local calendar date and repeats only after the full 71-position bank.

Authoring validation checks that neither king starts in check, each published move is legal, the last move checkmates, and every legal defense after the first move of a mate-in-two allows a mating finish. The generated compositions use no castling or en passant. Repository tests independently replay the published lines using the app's own engine and repeat the defensive-reply checks.

The puzzle player accepts alternate legal checkmates. For a different first move in a mate-in-two, it checks every legal defensive reply before accepting the move and selects a valid reply and finish for the continued exercise. This prevents a stored solution line from rejecting an equivalent winning answer.

The library preserves its original nine puzzle IDs and progress data, incorporates the new mating content without duplicate FENs, and starts returning players with unsolved puzzles in the selected theme. Daily streak storage retains its existing format and counts a multi-move combination only after the final move.
