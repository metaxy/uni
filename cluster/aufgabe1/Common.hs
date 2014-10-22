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

class CE st where
    find_p3 :: st -> Maybe P3
    select_branch :: P3 -> st -> Maybe st
    branch_pos :: P3 -> st -> [st]
    start_state :: G -> Int -> st

data State = State {
    _stateGraph :: G,
    _stateResEdges :: Maybe [Edge],
    _stateK :: Int
} deriving (Show)

makeFields ''State

branch :: (CE st, HasResEdges st (Maybe [Edge]), HasK st Int) => st -> st
branch state
    | (view k state) < 0 = trace "::branch run out of fuel" $ set resEdges Nothing state
    | otherwise = 
        trace ("::branch" ++ " edges =" ++ show (view resEdges state) ++ " k =" ++ show (view k state)) $
        case find_p3 state of
            Just p3 -> 
                case select_branch p3 (state) of
                    Just good_branch -> trace "::::branch good_branch" $ good_branch
                    Nothing -> trace ":::: branch no good branch" $ set resEdges Nothing $ state
            Nothing -> trace "::::branch no p3" $ state
            

kstep :: (HasK a Int) => a -> a
kstep st = trace ("::kstep k " ++show (view k st)) $ over k (\x -> x - 1) st

solved :: (HasResEdges st (Maybe [Edge])) => st -> Bool
solved state =  isJust $ view resEdges state

find_min :: (CE st, HasResEdges st (Maybe [Edge]), HasK st Int, HasGraph st G) => G -> st
find_min = find_min_state' 0

find_min_state' :: (CE st, HasResEdges st (Maybe [Edge]), HasK st Int, HasGraph st G) => Int -> G -> st
find_min_state' min_k graph 
    | (solved run) = run
    | otherwise = trace "next min_state" $ find_min_state' (min_k+1) graph
        where
            run = trace ("run branch min_k = " ++ show min_k) $ branch $ start_state graph min_k
            
            
parseInput = do
     s <- getContents
     let graph' = parseFile s
     return (undir graph')
     
output res = do
     mapM_ putStr (printEdges (view graph res) (view resEdges res))

genImage name graph = do
    writeFile name $ LT.unpack $ renderDot $ toDot $ setDirectedness graphToDot nonClusteredParams graph

