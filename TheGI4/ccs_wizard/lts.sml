

(*  Enter dot path here: *)

val dot = "dot";

val dot = "\"" ^ dot ^ "\"";


load "Int";
load "TextIO";
load "OS";	

type edge = exp * string * exp

datatype outputFormat = SVG | PNG | PDF
	
structure LTS :> sig
	
	val compareEdge : edge * edge -> order
	val edges : bindings -> exp -> edge Set.set 
	
	val setFormat : outputFormat -> unit
	val getFormat : unit -> outputFormat
	
	val setFileName : string -> unit
	val getFileName : unit -> string
	
	val setDotCommand : string -> unit
	val getDotCommand : unit -> string
	
	val setOverwrite : bool -> unit
	val getOverwrite : unit -> bool
	
	val draw : bindings * exp -> unit
		
	
 end
 = struct
 
	fun compareEdge ((l1, a1, r1), (l2, a2, r2)) = case cmpTuple compare ((l1,r1),(l2,r2)) of EQUAL => String.compare(a1, a2) | s => s              


	fun own e es = Set.map compareEdge (fn (l, a, r) => (e, a, r)) es

	fun edges b N Stop = Set.set compareEdge nil
	|   edges b N (Id s) = ((if Set.element s N then Set.set compareEdge nil
								else own (Id s) (edges b (Set.plus N s)(lookup b s))) handle Match => Set.empty compareEdge)
	|   edges b N (Choice (l, r)) = let val (el, er) = (edges b N l, edges b N r) in
									Set.union (own (Choice(l,r)) el) (own (Choice(l,r)) er) end
	|   edges b N (Prefix (Id a, p)) = Set.set compareEdge [(Prefix (Id a, p), a, p)]
	|   edges b N (Parallel (l, r)) =  let 
											val e = Parallel (l, r)
											val (el, er) = (edges b N l, edges b N r) 
											val parLeft  = Set.map compareEdge (fn (l', a, r') => (e, a, Parallel (r',r)))
											val parRight  = Set.map compareEdge (fn (l', a, r') => (e, a, Parallel (l,r')))
											
											fun sync (l, a, r) (l', a', r') = matches a a'																	   
											
											fun findSync e s = Set.filter (fn x =>  sync e x) s						  
																
											fun pfx s = String.substring (s, 0, String.size s  -1 )
																
											fun applySync (l, a, r) (l', a', r')= (e, "["^ pfx a ^"]", Parallel (r, r'))
																		
											val union = Set.union (parLeft el) (parRight er)							 
											
										in Set.fold (fn (e,s) => Set.union (Set.map compareEdge (applySync e) (findSync e er)) s) union el end
										
										
	|   edges b N (Restrict (e, R)) = Set.map compareEdge (fn (l, a, r) => (Restrict(e, R), a, Restrict(r, R))) (Set.filter (fn (e, a, e') => not (Set.element a R)) (edges b N e))
	|   edges _ _ _ = raise Error "Invalid expression!"

	val edges' = edges
	fun edges b e = edges' b (Set.empty String.compare) e
	
	val (count, reset) = let val c = ref 1
			in
			(fn () => #1(!c, c := !c +1),
			fn () => c := 1)
			end
			
	val toString = (String.translate (fn #"\\" => "\\\\" | c => implode [c])) o toString
			
	fun draw' print nodes b e = (!nodes e; ()) handle Empty => 

								let fun id (e:exp) = !nodes e handle Empty => (let val i = Int.toString(count()) 
															val _ = print (i ^ " [shape = box, label = \""^ toString e ^"\", style = rounded];\n") 
														in nodes := update compare (!nodes) e i; i end)
									val _ = id e
								in
									Set.fold (fn ((l, a, r), ()) => (draw' print nodes b r;print (id l ^ " -> " ^ id r ^"[label = \"" ^ a ^"\"]\n"))) () (edges b e)
								end
								

	val (name, overwrite, index, format, cmd) = (ref "graphs/graph", ref false, ref 0, ref SVG, ref dot)

	fun setFormat f = format := f
	fun getFormat () = !format
		
	fun setFileName n = name := n
	fun getFileName () = !name			
		
	fun setDotCommand c = cmd := c
	fun getDotCommand () = !cmd		
		
	fun ext SVG = "svg"
	|   ext PDF = "pdf"
	|   ext PNG = "png"
		
		
	fun setOverwrite b = overwrite := b
	fun getOverwrite () = !overwrite
		

	fun getFileNumber i = (let val name = getFileName() ^  Int.toString(i)
							in if not(!overwrite) andalso (OS.FileSys.fileSize (name ^ ".dot") > 0
							 orelse OS.FileSys.fileSize (name ^ ".svg") > 0)
						  then getFileNumber (i+1)
						  else (index := i; i) end)
						  handle SysErr _ => (index := i; i)
						  
	fun getFileNameIndexed() = getFileName() ^ Int.toString(getFileNumber(!index))
		
	fun draw (b, e) = 
	let 
		val _ = reset()
		val ext = ext (getFormat ())
		val name = getFileNameIndexed ()
		
		val out = TextIO.openOut (name ^ ".dot");
		fun print s = TextIO.output (out, s)
	in 
		print "digraph \n{\n";
		print "0 [shape = plaintext, label = \"\"]\n";
		draw' print (ref(fn _ => raise Empty)) b e;
		print "0 -> 1\n}";
		TextIO.closeOut out;
		
		OS.Process.system (getDotCommand () ^" -T" ^ ext ^ " " ^ name ^ ".dot -o " ^ name ^ "." ^ ext);
		()
	end
 
end
  
open LTS

fun convert s = ((draw o ccs) s; print "\nThe graph has been drawn!\n")
