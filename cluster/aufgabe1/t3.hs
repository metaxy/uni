{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
import Helper
import Common
import Simple

import Data.Graph.Inductive
import Data.Graph.Inductive.Example
import Data.List
import Data.Maybe
import Debug.Trace

import Control.Applicative
import Control.Lens
import Control.Lens.TH
import Control.Monad
data State3 = State3 {
    _state3Graph :: G,
    _state3ResEdges :: Maybe [Edge],
    _state3K :: Int,
    _state3EditedEdges :: [Edge],
    _state3P3s :: [Node],
    _state3Nodes :: [(Node,[Nodes])]
} deriving (Show)
makeFields ''State3

instance CE State3 where
    find_p3 = find_p3_t3
    select_branch = select_branch_simple
    branch_pos = branch_pos_t3
    start_state = start_state_t3

getNode :: State3 -> Node -> (Node,[Nodes])
getNode state x = head $ filter((==) x . view _1) $ state ^. nodes

find_p3_t3 :: State3 -> Maybe P3
find_p3_t3 state = liftM make_p3 $ headSafe' $ concat $ map (filter isP3 . pos_p3) all_n
    where
        all_n = state ^. p3s
        g = state ^. graph
        
        pos_p3 node = [(u,n',w) | u <- n, w <- n, u /= w]
            where
             n' = getNode state node
             n = nodes_with_neighbors g $ neighbors g node
             
find_all_p3_nodes g = map (view _1) $ map (view _2) $ filter isP3 $ combos n
    where
        n = nodes_with_neighbors g $ nodes g

isP3 ((u,us),(v,vs),(w,ws)) = 
    u /= v && w /= u && w /= v &&
    v `elem` us && v `elem` ws && not (w `elem` us)
{--
isP3Node :: G -> Node -> [P3]
isP3Node g node = --trace ("is new p3" ++ show res) $ 
    res
    where
        res = nub $ map make_p3 $ filter isP3 $ [(u,(node, neighbors g node),w) | u <- n, w <- n, u /= w]
        n = nodes_with_neighbors g $ neighbors g node

add_p3, delete_p3:: Node -> State3 -> State3

delete_p3 node state = -- trace ("delete folowwing nodes = " ++show (find (\x -> (view _2 x) == node) $ -view p3s state)) $
    over p3s (filter (\x -> (view _2 x) == node)) state

add_p3 node state = over p3s ((++) (isP3Node (state ^. graph) node)) state
--}
branch_pos_t3 :: P3 -> State3 -> [State3]
branch_pos_t3 (u,v,w) state = catMaybes [b1,b2,b3]
    where
        b1 = editEdge (u,v) $ over graph (uDelEdge (u,v)) state
        b2 = editEdge (v,w) $ over graph (uDelEdge (v,w)) state
        b3 = editEdge (u,w) $ over graph (uInsEdge (u,w)) state
        
        editEdge edge state
            | (isEdited state edge) = Nothing
            | otherwise = 
                Just $

                over editedEdges ((:) edge) $
                over resEdges (((:)edge) <$>) state
                
        isEdited state edge = edge `elem` (state ^. editedEdges)

                 
start_state_t3 :: G -> Int -> State3
start_state_t3 g k = trace ("all edes" ++ show (find_all_p3_nodes g)) $ 
    State3 
        g 
        (Just []) 
        k 
        [] 
        (find_all_p3_nodes g)
        (nodes_with_neighbors g $ nodes g)


main = do
    g <- parseGraphFile "/home/paul/Cloud/studium/Cluster/programs/material/ce-data/test067.graph"
    genImage "images/before.dot" (g)
    let res = (find_min g) :: State3
    genImage "images/after.dot" (view graph res)
    output res
    return ()
{--
main = do
    g <- parseInput 
    let res = (find_min g) :: State3
    output res
    return ()
    --}