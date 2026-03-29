% --- FACTS: Books (Title, Topic, Difficulty [1-5]) ---
book(calculus_1, math, 1).
book(linear_algebra, math, 2).
book(intro_to_ai, ai, 3).
book(prolog_programming, ai, 2).
book(machine_learning_basics, ml, 4).
book(deep_learning_advanced, ml, 5).

% --- FACTS: Prerequisites (Subject A must be known for Subject B) ---
prereq(math, ai).
prereq(ai, ml).

% --- DYNAMIC DATABASE (Lab Exp 7) ---
% Allows the system to "remember" what the user has already read
:- dynamic has_read/1.

% --- RULES: Logic and Inference (CO2) ---

% A student is 'eligible' for a book if they have completed the prerequisites 
% for that topic or if the topic has no prerequisites.
can_study(Book) :-
    book(Book, Topic, _),
    \+ prereq(PreTopic, Topic). % No prerequisite exists

can_study(Book) :-
    book(Book, Topic, _),
    prereq(PreTopic, Topic),
    has_read_topic(PreTopic).

% Helper: Checks if the user has read at least one book in a specific topic
has_read_topic(Topic) :-
    has_read(B),
    book(B, Topic, _).

% --- RECURSION: Finding the "Learning Path" (Lab Exp 5) ---
% Finds all books in a topic that are at or below a certain difficulty level.
find_path(Topic, MaxDiff, [Book|Tail]) :-
    book(Book, Topic, Diff),
    Diff =< MaxDiff,
    % Use a cut to prevent redundant backtracking once found
    !, 
    NewMax is MaxDiff - 1,
    find_path(Topic, NewMax, Tail).
find_path(_, _, []).

% --- LIST OPERATIONS: Counting available resources (Lab Exp 6) ---
count_books([], 0).
count_books([_|Tail], Count) :-
    count_books(Tail, TCount),
    Count is TCount + 1.