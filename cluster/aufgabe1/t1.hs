import Helper
import Common
import Simple

main = do
    g <- parseInput 
    let res = (find_min g) :: State2
    output res
    return ()
