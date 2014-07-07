load "TextIO";

val load' = load;

 	datatype token = NULL | PLUS | DOT | PAR | BACKSLASH | ID of string | LPAR | RPAR | LCPAR | RCPAR | COMMA | SEMICOLON | DEFINE
	datatype exp = Stop | Id of string | Choice of exp * exp | Prefix of exp * exp |  Parallel of exp * exp | Restrict of exp * string Set.set
	exception Parse of string
	
	type action = string
	
	type binding = string * exp
	
	type bindings = binding Set.set
	
 structure CCS :> sig
 
	val lex : string -> token list
	val parse : token list -> bindings * exp
	
	val ccs : string -> bindings * exp
	
	val toString: exp -> string
	val compare : exp * exp -> order
	val matches : action -> action -> bool
	val internal : action -> bool
	
	val lookup : bindings -> string -> exp
	val compareBinding : binding * binding -> order
	
	val load : string -> bindings * exp
	
 end
 = struct
 

	fun kc (#"0")  = true
	|   kc (#"+")  = true
	|   kc (#".")  = true
	|   kc (#"|")  = true
	|   kc (#"\\") = true
	|   kc (#"(") = true
	|   kc (#")") = true
	|   kc (#"{") = true
	|   kc (#"}") = true
	|   kc (#",") = true
	|   kc (#";") = true
	|   kc    _    = false



	fun lex' nil ((#"0") :: cr) = (NULL, cr)
	|   lex' nil ((#"+") :: cr) = (PLUS, cr)
	|   lex' nil ((#".") :: cr) = (DOT, cr)
	|   lex' nil ((#"|") :: cr) = (PAR, cr)
	|   lex' nil ((#"\\") :: cr) = (BACKSLASH, cr)
	|   lex' nil ((#"(") :: cr) = (LPAR, cr)
	|   lex' nil ((#")") :: cr) = (RPAR, cr)
	|   lex' nil ((#"{") :: cr) = (LCPAR, cr)
	|   lex' nil ((#"}") :: cr) = (RCPAR, cr)
	|   lex' nil ((#",") :: cr) = (COMMA, cr)
	|   lex' nil ((#";") :: cr) = (SEMICOLON, cr)
	|   lex' nil ((#":") :: (#"=")::cr) = (DEFINE, cr)
	|   lex' nil (c::cr) = if Char.isSpace c then lex' nil cr else lex' [c] cr
	|   lex' id    nil   = (ID ((implode o rev) id), nil)
	|   lex' id ((#":") :: (#"=")::cr) = (ID ((implode o rev) id), (#":") :: (#"=")::cr)
	|   lex' id  (c::cr) = if kc c orelse Char.isSpace c then (ID ((implode o rev) id), c::cr)
						else lex' (c::id) cr
	fun eatWS nil = nil
	|   eatWS (c::cr) = if Char.isSpace c then eatWS cr else (c::cr) 

	fun lex'' nil = nil
	|   lex'' cs = let val (t, cr) = lex' nil cs in t :: lex'' (eatWS cr) end


	val lex = lex'' o explode
	
	fun match (a,ts) t = if null ts orelse hd ts <> t then raise Error "match" else (a, tl ts)

	fun extend (a,ts) p f = let val (a',tr) = p ts in (f(a,a'),tr) end

	fun last s = String.sub (s, String.size s - 1)
	
	fun pfx s = String.substring (s, 0, String.size s  -1 )

	fun internal a = last a = #"]" andalso String.isPrefix "[" a	

	
	fun fork a = let val l = last a in
					if l = #"?" orelse l = #"!" then [a] else if internal a then raise Error "A restriction set must not contain internal actions!" else [a, a ^"?", a^"!"] end
					
					
	fun matches a a' = (case (last a, last a') of
							(#"?", #"!") => pfx a = pfx a'
							| (#"!", #"?") => pfx a = pfx a'
							| _ => false)
								
	fun needsMatch a = let val l = last a in l = #"!" orelse l = #"?" end
					
	fun assertProper' R =  if Set.isEmpty R then ()
						else let val a = Set.any R
								val R' = Set.filter (fn a' => a <> a' andalso not(matches a a')) R
							in
									if Set.size(R') = Set.size (R) - 2 orelse not (needsMatch a) then assertProper' R'
									else raise Error ("Invalid restriction set: " ^ a ^ " violates the restriction set invariant!")
								end		 
	fun assertProper R = (assertProper' R; R)				 
	
	
	fun compareBinding ((id1, e1),(id2, e2)) = String.compare (id1, id2)
	
	fun parse ts = (case exp ts of
				(e, SEMICOLON::tr) => (bindings (Set.empty compareBinding) tr, e)
				|  (e, nil) => ((Set.empty compareBinding),e)
				|  (e, _)  => raise Parse "Could not parse input completely! Are you missing a semicolon?")
	and bindings b nil = b
	|   bindings b (SEMICOLON::tr) = bindings b tr
	|   bindings b (COMMA::tr) = bindings b tr
	|   bindings b ((ID id)::DEFINE::tr) = let val (e, tr) = (exp tr) in bindings (Set.plus b (id, e)) tr end
	|   bindings b  _                    = raise Parse "Could not parse bindings!"
	and exp ts = (case parallel ts of 
				(l, BACKSLASH::tr) => extend (l, tr) set Restrict
				|  s => s)
	and set  (LCPAR:: (ID id)::tr) = (case restrictList (Set.set String.compare (fork id)) tr of (R, RCPAR::tr) => (assertProper R, tr)
																		|  _ => raise Parse "Expected '}'!")
	|   set _ = raise Parse "Expected a set!"
	and restrictList R (COMMA:: (ID id)::tr) = restrictList (Set.union R (Set.set String.compare (fork id))) tr
	|   restrictList R tr                    = (R, tr)

	and parallel ts = parallel'(choice ts)
	and parallel' (l, PAR::tr) = parallel' (extend (l, tr) choice Parallel)
	|   parallel' s       = s
	and choice ts = choice'(prefix ts)
	and choice' (l, PLUS::tr) = choice' (extend (l, tr) prefix Choice)
	|   choice' s        = s
	and prefix    ts = (case primitive ts of (p, DOT::tr) => extend (p, tr) prefix Prefix | s => s)
	and primitive (NULL   :: tr) = (Stop, tr)
	|   primitive ((ID s) :: tr) = (Id s, tr)
	|   primitive (LPAR :: tr) = match (exp tr) RPAR
	|   primitive _ = raise Parse "Expected '0', identifier or parenthesised expression!"
	
	
	fun toString (Restrict (e, e')) = (parallelToStr e) ^ " \\ " ^ (actionsToString e')
	|   toString e = parallelToStr e
	and parallelToStr (Parallel (e, e')) = (parallelToStr e) ^ " | " ^ (choiceToStr e')
	|   parallelToStr e = choiceToStr e
	and choiceToStr (Choice (e, e')) = (choiceToStr e) ^ " + " ^ (prefixToStr e')
	|   choiceToStr e = prefixToStr e
	and prefixToStr (Prefix (e, e')) = (primitiveToStr e) ^ "." ^ (prefixToStr e')
	|   prefixToStr e = primitiveToStr e
	and primitiveToStr Stop = "0"
	|   primitiveToStr (Id s) = s
	|   primitiveToStr  e =  "(" ^ toString e ^ ")"
	and actionsToString s = Set.toString (fn s => s) (Set.map String.compare (fn a => if needsMatch a then pfx a else a) s)

						
	fun compare (Stop, Stop) = EQUAL
	|   compare (Stop, _) = LESS
	|   compare (_, Stop) = GREATER
	|   compare (Id s, Id s') = String.compare (s, s')
	|   compare (Id _, _) = LESS
	|   compare (_, Id _) = GREATER
	|   compare (Choice t, Choice t') = cmpTuple compare (t, t') 
	|   compare (Choice _, _) = LESS
	|   compare (_, Choice _) = GREATER
	|   compare (Prefix t, Prefix t') = cmpTuple compare (t, t') 
	|   compare (Prefix _, _) = LESS
	|   compare (_, Prefix _) = GREATER
	|   compare (Parallel t, Parallel t') = cmpTuple compare (t, t') 
	|   compare (Parallel _, _) = LESS
	|   compare (_, Parallel _) = GREATER
	|   compare (Restrict (e1, r1), Restrict (e2, r2)) = (case compare (e1, e2) of EQUAL => Set.compare (r1, r2) | s => s )

	val ccs = parse o lex
		
	fun load f = let val file =  TextIO.openIn f
					val e = ccs (TextIO.inputAll file)
				in	 
					TextIO.closeIn file;
					e
				end

	exception Found of exp
	
	fun lookup b x = #2(Set.any (Set.filter (fn (x', e) => x = x') b))
 
end
 
 open CCS
 
 val load = load'