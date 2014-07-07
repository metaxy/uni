load "Int";

structure Stepper :> sig

	val reset : bindings * exp -> unit
	val current : unit -> bindings * exp
	val show  : unit -> unit (* shows the current expression*)
	val bindings : unit -> unit
	val post  : unit -> unit (* shows the currently possible transitions (action and successor) in a numbered list*)
	val succ  : int -> unit (* Switches to the n-th successor in the post list*)
	val back  : unit -> unit (* Goes back to the last expression before the current one*)
	
end = struct

	val b = ref (Set.empty compareBinding) (*Bindings*)
	val c = ref Stop (* Current expression. *)
	val e = ref (Set.empty compareEdge)

	val allBindings = ref (fn () => Set.empty compareBinding)

	val path = ref nil (* First item is the expression that has last been visited before the current expression.*)

	
	fun set x = (c := x; e := LTS.edges (!b) x)
	
	(* Try to make this label' a more concise implementation of the labels function below! *)
	
	fun get s x = (x, lookup s x)
	
	fun contains s b = Set.exists (fn (x, e) => x = b) s
	
	fun bindings' s (Restrict (e, _)) = bindings' s e
	|   bindings' s (Parallel (e, e')) = Set.union (bindings' s e) (bindings' s e')
	|   bindings' s (Choice (e, e')) = Set.union (bindings' s e) (bindings' s e')
	|   bindings' s (Prefix (_, e)) =  bindings' s e
	|   bindings' s Stop = s
	|   bindings' s (Id id) = if contains s id then s else bindings' (Set.plus s (get (!b) id)) (lookup (!b) id)
			
	fun collectBindings () = bindings' (Set.empty compareBinding) (!c)
			
	fun printBindings b = (print "\n";Set.fold (fn ((x, e), _) => print ("                    \t" ^ x ^ " := " ^ (toString e) ^ "\n"))  () b; print "\n")

	fun bindings() = printBindings((!allBindings)())

	fun current () = (!b, !c)
	
	fun show () = (print "\nCurrent expression: \t"; 
				   print (toString (!c));
				   
				   let val b = collectBindings() in
				   
				   if Set.size b > 0 then 
				   (
						print "\n\nwhere";
						printBindings b						
				   )
				   else print "\n\n"
				   end)
	
	val d = ref 1
	val l = ref 1
	
	val (count', reset') = let val c = ref 1
			in
			(fn () => #1(!c, c := !c +1),
			fn () => c := 1)
			end	
	fun digits n = if n < 10 then 1 else 1 + digits (n div 10)
	fun reset () = (reset'();
					d := digits (Set.size (!e));
					l := Set.fold (fn ((_, a, _),l)
									=> let val l' = String.size a in if l' > l then l' else l end)
						1 (!e)
					)	
	
	fun spaces n = iter n "" (fn s => s ^ " ")
	
	fun count () = let val c = Int.toString(count'()) in (spaces (!d - String.size c)) ^ "(" ^ c ^ ")" end
	
	fun padC s = 
	let val p = spaces ((!l - String.size s) div 2) 
		val r = p ^ s ^ p 
	in
		if String.size r < (!l) then r ^" " else r
	end
	
	
	fun edgeToString (_, a, r) = let val arrow = "  --" ^ (iter (!l) "" (fn s => s ^ "-")) ^ "->  "
								 in 
									spaces (!d+6) ^ (padC a) ^ "\n"   ^ count() ^ arrow ^ (CCS.toString r) ^ "\n\n"
								 end
	
	
	fun post () = (reset (); print"\n\n";Set.fold (fn (e, _) => print (edgeToString e)) () (!e); print "\n\n")
	
	exception Return of exp
	
	fun succ i = (Set.fold (fn ((_, _, p), i) => if i <= 1 then raise Return p else i-1) i (!e); print "\nIndex out of range!\n") 
				handle Return x => (path := !c :: (!path);set x)
	
	fun back () = (case !path of
				  nil => ()
				| (x::xs) => (set x; path := xs))
	
	fun reset (b', c') = (b := b'; 
						  set c';
						  allBindings := (fn () => bindings' (Set.empty compareBinding) (!c));
						  path := nil)
	
end

open Stepper