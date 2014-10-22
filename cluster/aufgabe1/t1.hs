import Helper
import Common
import Simple
import Control.Lens

main = do
    g <- parseInput 
    genImage "before.dot" (g)
    let res = (find_min g) :: State1
    genImage "after.dot" (view graph res)
    output res
    return ()
