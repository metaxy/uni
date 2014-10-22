{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
import Helper
import Common
import Simple

import Data.Graph.Inductive
import Data.List
import Data.Maybe
import Debug.Trace

import Control.Applicative
import Control.Lens
import Control.Lens.TH
import Control.Monad
data State2 = State2 {
    _state2Graph :: G,
    _state2ResEdges :: Maybe [Edge],
    _state2K :: Int,
    _state2EditedEdges :: [Edge],
    _state2P3s :: [P3]
} deriving (Show)
makeFields ''State2

instance CE State2 where
    find_p3 = find_p3_t2
    select_branch = select_branch_simple
    branch_pos = branch_pos_t2
    start_state = start_state_t2
    


find_p3_t2 state = headSafe' $ state ^. p3s

find_all_p3s g = filter (isP3 g) $ [(u,v,w) | u <- n, v <- n, w <- n, u /= w, u /= v, w/= v]
    where
        n = {--map (\x -> (x, (neighbors g x))) $--} nodes g

--isP3 ((u,us),(v,vs),(w,ws)) = u /= v && w /= u && w /= v && (us `intersect` ws) == vs 
isP3 g (u,v,w) = t && t2 && t3
    where
        t = neighbore g u v
        t2 = neighbore g v w
        t3 = not $ neighbore g u w  

p3 ((x,_),(y,_),(z,_)) = (x,y,z)

branch_pos_t2 :: P3 -> State2 -> [State2]
branch_pos_t2 (u,v,w) state = catMaybes [b1,b2,b3]
    where
        b1 = editEdge (u,v) $ over graph (uDelEdge (u,v)) state
        b2 = editEdge (v,w) $ over graph (uDelEdge (v,w)) state
        b3 = liftM (cleanUp . addP3 (u,w)) $ editEdge (u,w) $ over graph (uInsEdge (u,w)) state
        
        editEdge edge state
            | (isEdited state edge) = Nothing
            | otherwise = 
                Just $
                over p3s (delete (u,v,w)) $
                over editedEdges ((:) edge) $
                over resEdges (((:)edge) <$>) state
                
        isEdited state edge = edge `elem` (state ^. editedEdges)
        cleanUp = over p3s nub
        addP3 :: (Node,Node) -> State2 -> State2
        addP3 (u,w) state = over p3s ((++) new_nodes) state
            where
                g = (state ^. graph)
                new_nodes = filter (isP3 g) $ [(u,v,w) | u <- n, v <- n, w <- n, u /= w, u /= v, w/= v]
                n = ((neighbors g u) ++ (neighbors g w))
                 
start_state_t2 :: G -> Int -> State2
start_state_t2 g k = trace ("all edes" ++ show (find_all_p3s g)) $ State2 g (Just []) k [] (find_all_p3s g)


main = do
    g <- parseGraphFile "/home/paul/Cloud/studium/Cluster/programs/material/ce-data/test067.graph"
    genImage "before.dot" (g)
    let res = (find_min g) :: State2
    genImage "after.dot" (view graph res)
    output res
    return ()
