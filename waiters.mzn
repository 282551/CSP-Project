% Simple nurse rostering
include "regular.mzn";
int: N_WAITER; %number of waiter
int: D;        %number of days
int: firts_d;  %first day of the month


enum SHIFT = { o, f, r };
int: S = card(SHIFT);

int: Q = 12; int: q0 = 2; set of int: STATE = 1..Q;

set of int: jours = 1..7;
set of int: chef = 1..4;
set of int: tour = 1..2;
set of int: WAITER = 1..N_WAITER;
set of int: DAY = 1..D;

array[tour,jours] of int: min_req =
     [| 5, 5, 5, 5, 6, 6, 6
      | 4, 4, 4, 4, 5, 5, 5|];

array[STATE,SHIFT] of int: t =
     [| 0, 0, 2    % state 1
      | 3, 8, 2    % state 2
      | 4, 9, 2    % state 3
      | 5, 10, 2   % state 4
      | 6, 11, 2   % state 5
      | 7, 12, 2   % state 6
      | 0, 0, 1    % state 7
      | 0, 9, 2    % state 8
      | 0, 10, 2   % state 9
      | 0, 11, 2   % state 10
      | 0, 12, 2   % state 11
      | 0, 0, 1|]; % state 12 

array[WAITER,DAY] of var SHIFT: roster;

constraint forall(j in DAY)(
             sum(i in WAITER)(roster[i,j] == o) == min_req[1,((j+firts_d-2) mod 7)+1] /\
             sum(i in WAITER)(roster[i,j] == f) == min_req[2,((j+firts_d-2) mod 7)+1] /\
             sum(i in chef) (roster[i,j] == o) >= 1 /\
             sum(i in chef) (roster[i,j] == f) >= 1
           );
constraint forall(i in WAITER)(
             regular([roster[i,j] | j in DAY], Q, S, t, q0, STATE) /\
             sum(j in DAY)(roster[i,j] == r) <= 6 /\
             sum(j in DAY)(roster[i,j] == r) >= 4
           );

solve satisfy;

output [ show(roster[i,j]) ++ if j==card(DAY) then "\n" else " " endif
       | i in WAITER, j in DAY ]; 
