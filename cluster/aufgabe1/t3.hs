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
import Data.Matrix hiding(trace)


data State3 = State3 {
    _state3Graph :: G,
    _state3ResEdges :: Maybe [Edge],
    _state3K :: Int,
    _state3EditedEdges :: [Edge],
    _state3GMatrix :: Matrix Int,
    _state3GSize :: Int
} deriving (Show)
makeFields ''State3

instance CE State3 where
    find_p3 = find_p3_t3
    select_branch = select_branch_simple
    branch_pos = branch_pos_t3
    start_state = start_state_t3

find_p3_t3 :: State3 -> Maybe P3
find_p3_t3 state = 
    headSafe' $ 
    [(u,v,w) | u <- n, v <- n, w <- n, u /= w, w /= v, v /= u, m_conn state v u, m_conn state v w, not (m_conn state u w)]
        where
            n = [1..(state ^. gSize)]

        
m_conn state x y = (getElem x y (state ^. gMatrix)) > 0

el state (x,y) = (getElem x y (state ^. gMatrix))

rmEdge :: (Int,Int) -> State3 -> State3
rmEdge (x,y) = over gMatrix (setElem (-1::Int) (x,y) . setElem (-1::Int) (y,x)) 

addEdge :: (Int,Int) -> State3 -> State3
addEdge (x,y) = over gMatrix (setElem (2::Int) (x,y) . setElem (2::Int) (y,x))

branch_pos_t3 :: P3 -> State3 -> [State3]
branch_pos_t3 (u,v,w) state = 
    --trace ("remove" ++ show(state ^. gMatrix)) $ 
    catMaybes [b1,b2,b3]
    where
        b1 = editEdge (u,v) $ rmEdge (u,v) state
        b2 = editEdge (v,w) $ rmEdge (v,w) state
        b3 = editEdge (u,w) $ addEdge (u,w) state
        
        editEdge edge state
            | (isEdited state edge) = Nothing
            | otherwise = 
                Just $
                over editedEdges ((:) edge) $
                over resEdges (((:)edge) <$>) state
                
        isEdited state edge = edge `elem` (state ^. editedEdges)


start_state_t3 :: G -> Int -> State3
start_state_t3 g k = 
    --trace ("start\n" ++ show m) $
    State3 
        g 
        (Just []) 
        k 
        [] 
        m
        gsize
    where
        gsize = length (nodes g)
        m = matrix gsize gsize (\(x,y) -> connected g x y)

main = do
    g <- parseGraphFile "/home/paul/Cloud/studium/Cluster/programs/material/ce-data/test068.graph"
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