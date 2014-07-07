structure Set :> sig
   
   type 'a set
   
   val empty : ('a * 'a -> order) -> 'a set
   val set : ('a * 'a -> order) -> 'a list -> 'a set
   val union : 'a set ->  'a set -> 'a set
   val map : ('b * 'b -> order) -> ('a  -> 'b) -> 'a set -> 'b set 
   val filter : ('a -> bool) -> 'a set -> 'a set 
   val element : 'a  ->  'a set -> bool
   val plus :  'a set -> 'a  -> 'a set
   val toList : 'a set -> 'a  list  
   val equal : 'a set -> 'a set -> bool
   val fold : ('a*'b -> 'b) -> 'b -> 'a set -> 'b
   val any : 'a set -> 'a
   val intersection : 'a set ->  'a set -> 'a set
   val exists : ('a -> bool) -> 'a set -> bool
   val compare : ('a set * 'a set) -> order
   val size : 'a set -> int
   val isEmpty : 'a set -> bool
   val toString : ('a -> string) -> 'a set -> string
   
 end
= struct
 
   type 'a set = ('a * 'a -> order) * 'a list
    
    
   fun empty cmp = (cmp, nil) 
     
   fun union' cmp nil s = s
   |   union' cmp s nil = s
   |   union' cmp (x::xs) (y::ys) = case cmp(x, y) of
 			      LESS => x :: union' cmp xs (y::ys)
 			     | EQUAL => x ::union' cmp xs ys
 			     | GREATER => y :: union' cmp (x::xs) ys
     
   fun public h (cmp, xs) (_, ys) = (cmp, h cmp xs ys)
   
   val union = public union'
  
   fun split xs = foldl (fn (x, (l, r)) => (x ::r, l))(nil, nil) xs
   
   fun sort cmp nil = nil
   |   sort cmp [x] = [x]
   |   sort cmp xs = let val (l, r) = split xs in union' cmp (sort cmp l) (sort cmp r) end
   
   
   fun set cmp l = (cmp, sort cmp l)
 			      
   fun map cmp' f (cmp, xs) = set cmp' (List.map f xs)
   
   fun filter p (cmp, xs)= (cmp, List.filter p xs)
   
   fun element' cmp y nil = false
   |   element' cmp y (x::xr) = case cmp(x, y) of
 			  LESS => element' cmp y xr
 			 | EQUAL => true
 			 | GREATER => false
 			
   fun element y (cmp, xs) = element' cmp y xs		
 			
   fun plus' cmp nil y     = [y]
   |   plus' cmp (x::xr) y = case cmp(x, y) of
 			  LESS => x::plus' cmp xr y
 			 | EQUAL => x::xr
 			 | GREATER => y::x::xr
 			
   fun plus (cmp, xs) y = (cmp, plus' cmp xs y)
 			
   fun toList (_, s) = s
   
   fun equal' cmp nil nil = true
   |   equal' cmp nil l = false
   |   equal' cmp l nil = false
   |   equal' cmp (x::xs) (y::ys) = case cmp(x, y) of
 			  LESS => false
 			 | EQUAL => equal' cmp xs ys
 			 | GREATER => false
 			 
   fun equal (cmp, xs) (_, ys) = equal' cmp xs ys
   
   fun fold f a (_, s) = foldl f a s 
   
   fun any (_, nil) = raise Match
   |   any (_, x::xs) = x
   
   fun intersection' cmp nil _ = nil
   |   intersection' cmp _ nil = nil
   |   intersection' cmp (x::xs) (y::ys) = case cmp(x, y) of 
 					  LESS => intersection' cmp xs (y::ys)
 					| GREATER => intersection' cmp (x::xs) ys
 					| EQUAL => x :: (intersection' cmp xs ys)
 					  
   fun intersection (cmp, a) (_, b) = (cmp, intersection' cmp a b)
   
   fun exists p (cmp, nil) = false
   |   exists p (cmp, x::xs) = p x orelse exists p (cmp, xs) 
   
   fun compare' cmp nil nil = EQUAL
   |   compare' cmp  _  nil = GREATER
   |   compare' cmp nil  _  = LESS
   |   compare' cmp (x::xs) (y::ys) = case cmp(x, y) of EQUAL => compare' cmp xs ys | s => s
   
   fun compare ((cmp, xs), (cmp', ys)) = compare' cmp xs ys
   
   fun size (cmp, xs) = List.length xs
   
   fun isEmpty (cmp, nil) = true
   |   isEmpty _ = false
   
   fun toString p s = "{" ^ #1(fold (fn (s, (a, prefix)) => (a^prefix^ (p s) , ", ")) ("", "") s) ^ "}"
   
 end 
