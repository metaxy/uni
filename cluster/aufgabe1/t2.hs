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
    _state2EditedEdges :: [Edge]
} deriving (Show)
makeFields ''State2

instance CE State2 where
    find_p3 = find_p3_simple
    select_branch = select_branch_simple
    branch_pos = branch_pos_t2
    start_state = start_state_t2
    

branch_pos_t2 :: P3 -> State2 -> [State2]
branch_pos_t2 (u,v,w) state = catMaybes [b1,b2,b3]
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

                 
start_state_t2 :: G -> Int -> State2
start_state_t2 g k = State2 g (Just []) k [] 

{--
main = do
    g <- parseGraphFile "/home/paul/Cloud/studium/Cluster/programs/material/ce-data/test067.graph"
    genImage "images/before.dot" g
    let res = (find_min g) :: State2
    genImage "images/after.dot" $ view graph res
    output res
    return ()
    --}
main = do
    g <- parseInput 
    let res = (find_min g) :: State2
    output res
    return ()
