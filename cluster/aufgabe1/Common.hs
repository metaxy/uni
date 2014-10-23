{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
module Common (
    module Common,
) where

import Helper
import Data.Graph.Inductive
import Data.List
import Data.Maybe
import Debug.Trace
import qualified Data.Text.Lazy as LT
import Data.Text.Lazy (Text)
import Data.GraphViz
import Data.GraphViz.Printing
import Control.Applicative
import Control.Lens
import Control.Lens.TH

data State = State {
    _stateGraph :: G,
    _stateResEdges :: Maybe [Edge],
    _stateK :: Int
} deriving (Show)

makeFields ''State

class (HasK st Int, HasResEdges st (Maybe [Edge]), HasGraph st G) => CE st where
    find_p3 :: st -> Maybe P3
    select_branch :: P3 -> st -> Maybe st
    branch_pos :: P3 -> st -> [st]
    start_state :: G -> Int -> st
    
branch :: CE st => st -> st
branch state
    | (view k state) < 0 = set resEdges Nothing state
    | otherwise = 
        case find_p3 state of
            Just p3 -> 
                case select_branch p3 state of
                    Just good_branch ->  good_branch
                    Nothing -> set resEdges Nothing $ state
            Nothing -> state
            

kstep :: (CE st) => st -> st
kstep st =  over k (\x -> x - 1) st

solved :: (CE st) => st -> Bool
solved state =  isJust $ view resEdges state

find_min :: (CE st) => G -> st
find_min graph = find_min_state' (start_state graph 0) 0 graph 

find_min_state' :: (CE st) => st -> Int -> G -> st
find_min_state' start min_k graph 
    | (solved run) = run
    | otherwise =  find_min_state' start (min_k+1) graph
        where
            run = branch $ set k min_k start

     
output res = do
     mapM_ putStr (printEdges (view graph res) (view resEdges res))

genImage name graph = do
    writeFile name $ LT.unpack $ renderDot $ toDot $ setDirectedness graphToDot nonClusteredParams graph

