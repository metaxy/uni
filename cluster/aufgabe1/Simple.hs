{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
module Simple (
    State2,
) where

import Helper
import Common

import Data.Graph.Inductive
import Data.List
import Data.Maybe
import Data.GraphViz
import Debug.Trace
import qualified Data.Text.Lazy as LT
import Data.Text.Lazy (Text)
import Data.GraphViz
import Data.GraphViz.Printing
import Control.Applicative
import Control.Lens
import Control.Lens.TH
data State2 = State2 {
    _state2Graph :: G,
    _state2ResEdges :: Maybe [Edge],
    _state2K :: Int
} deriving (Show)
makeFields ''State2

instance CE State2 where
    find_p3 = find_p3_simple
    select_branch = select_branch_simple
    branch_pos = branch_pos_simple
    start_state = start_state_simple
    
  
find_p3_simple :: (HasGraph st G) => st -> Maybe P3
find_p3_simple state = headSafe $ filter isJust $ map isP3 $ [(u,v,w) | u <- n, v <- n, w <- n, u /= w]
    where
        g = view graph state
        n = nodes g
        isP3 ((u,v,w)) 
            | t && t2 && t3 = Just (u,v,w)
            | otherwise = Nothing
                where
                    t = neighbore g u v
                    t2 = neighbore g v w
                    t3 = not $ neighbore g u w
                    
select_branch_simple :: (CE st, HasResEdges st (Maybe[Edge]), HasK st Int) => P3 -> st -> Maybe st
select_branch_simple p3 state = 
    find (isJust . (view resEdges)) 
    $ map branch
    $ map kstep
    $ branch_pos p3 state
    
branch_pos_simple :: (HasGraph st G,HasResEdges st (Maybe [Edge])) => P3 -> st -> [st]
branch_pos_simple (u,v,w) state = [b1,b2,b3]
    where
        b1 = over resEdges (((:)(u,v)) <$>) $ over graph (uDelEdge (u,v)) state
        b2 = over resEdges (((:)(v,w)) <$>) $ over graph (uDelEdge (v,w)) state
        b3 = over resEdges (((:)(u,w)) <$>) $ over graph (uInsEdge (u,w, ())) state
     
start_state_simple :: G -> Int -> State2
start_state_simple g k = State2 g (Just []) k

    
