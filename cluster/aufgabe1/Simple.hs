{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
module Simple (
    module Simple
) where

import Helper
import Common

import Data.Graph.Inductive
import Data.List
import Data.Maybe
import Debug.Trace

import Control.Applicative
import Control.Lens
import Control.Lens.TH

data State1 = State1 {
    _state1Graph :: G,
    _state1ResEdges :: Maybe [Edge],
    _state1K :: Int
} deriving (Show)
makeFields ''State1

instance CE State1 where
    find_p3 = find_p3_simple
    select_branch = select_branch_simple
    branch_pos = branch_pos_simple
    start_state = start_state_simple
    
  
find_p3_simple :: (CE st) => st -> Maybe P3
find_p3_simple state =  
    headSafe' $ [(u,v,w) | u <- n, v <- n, w <- n, u /= w, v /= w, u /= v, isP3 (u,v,w)]
    where
        g = view graph state
        n = nodes g
        isP3 ((u,v,w)) = t && t2 && t3
            where
                t = neighbore g u v
                t2 = neighbore g v w
                t3 = not $ neighbore g u w
                    
select_branch_simple :: (CE st) => P3 -> st -> Maybe st
select_branch_simple p3 state = 
    find (isJust . (view resEdges)) 
    $ map branch
    $ map kstep
    $ branch_pos p3 state
    
branch_pos_simple :: (CE st) => P3 -> st -> [st]
branch_pos_simple (u,v,w) state =  [b1,b2,b3]
    where
        b1 = over resEdges (((:)(u,v)) <$>) $ over graph (uDelEdge (u,v)) state
        b2 = over resEdges (((:)(v,w)) <$>) $ over graph (uDelEdge (v,w)) state
        b3 = over resEdges (((:)(u,w)) <$>) $ over graph (uInsEdge (u,w)) state
     
start_state_simple :: G -> Int -> State1
start_state_simple g k = State1 g (Just []) k


    
