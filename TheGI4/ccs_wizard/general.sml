exception Error of string


fun cmpTuple cmp ((l1, r1), (l2, r2)) = case cmp (l1, l2) of EQUAL => cmp (r1, r2) | s => s

fun update cmp env x a y = if cmp(x,y) = EQUAL then a else env y

fun iter n s f = if n <= 0 then s else iter (n-1) (f s) f