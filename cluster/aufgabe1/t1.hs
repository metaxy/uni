import Helper
import Common
import Simple
import Control.Lens

main = do
    g <- parseInput 
    genImage "before.dot" (g)
    let res = (find_min g) :: State2
    genImage "after.dot" (view graph res)
    output res
    return ()
