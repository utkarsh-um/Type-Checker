hastype(G,num(N),tint).
hastype(G,true,tbool).
hastype(G,false,tbool).
hastype(G,var(X),T) :- lookUp(G,X,T).
hastype(G,[],[]).
hastype(G,plus(E1,E2),tint) :- hastype(G,E1,tint),hastype(G,E2,tint). /* artithmetic op */
hastype(G,mult(E1,E2),tint) :- hastype(G,E1,tint),hastype(G,E2,tint).
hastype(G,and(E1,E2),tbool) :- hastype(G,E1,tbool),hastype(G,E2,tbool). /* tbool op */
hastype(G,not(E),tbool) :- hastype(G,E,tbool). /* tbool op */
hastype(G,comp(E1,E2),tbool) :-hastype(G,E1,tint),hastype(G,E2,tint). /* comparison */
hastype(G,equal(E1,E2),tbool)	:- hastype(G,E1,T),hastype(G,E2,T). /* equality op */
hastype(G,if_then_else(E1,E2,E3),T) :- hastype(G,E1,tbool), hastype(G,E2,T), hastype(G,E3,T). /*if then else */
hastype(G,tuple([]),cart_prod([])).
hastype(G,tuple([E|Es]),cart_prod([T|Ts])) :- hastype(G,E,T), hastype(G,tuple(Es),cart_prod(Ts)).  /* n- tuple */
hastype(G,proj(tuple([E|Es]),1),T) :- hastype(G,E,T).
hastype(G,proj(tuple([E|Es]),N),T) :- N>1, N1 is N-1, hastype(G,proj(tuple(Es),N1),T).
hastype(G,funabs(var(X),T,E),arrow(T,T2)) :-  hastype([(X,T)|G],E,T2).
hastype(G,funapp(M,N),T) :- hastype(G,M,arrow(T1,T)), hastype(G,N,T1).
hastype(G,let_in_end(D,E),T) :- typeElaborates(G,D,G1), append(G1,G,G0), hastype(G0,E,T).
hastype(G,match_with(E,C,[R1|R]),T) :- hastype(G,E,T1), sametype(G,C,T1), hastype(G,R1,T), sametype(G,R,T).
typeElaborates(G,def(var(X),E),[(X,T)]) :- hastype(G,E,T).
typeElaborates(G,seq(D1,D2),G21) :- typeElaborates(G,D1,G1), append(G1,G,G10), typeElaborates(G10,D2,G2), append(G2,G1,G21).
typeElaborates(G,par(D1,D2),G21) :- typeElaborates(G,D1,G1), typeElaborates(G,D2,G2), append(G2,G1,G21).
typeElaborates(G,local_in_end(D1,D2),G2) :- typeElaborates(G,D1,G1), append(G1,G,G10), typeElaborates(G10,D2,G2).
lookUp([(X,T)|Ys],X,T) :- !.
lookUp([(Y,M)|Ys],X,T) :- lookUp(Ys,X,T). 
sametype(G,[],T).
sametype(G,[X|Xs],T) :- hastype(G,X,T), sametype(G,Xs,T).




%% 	.

%% 	

	


