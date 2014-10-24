{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
module Helper (
    module Helper
    ) where
import Data.Graph.Inductive
import Data.Graph.Inductive.Example
import Prelude
import Data.List
import Data.Maybe
import Data.GraphViz
import Debug.Trace
type G = Gr String ()
type P3 = (Node,Node,Node)

parseFile :: String -> G
parseFile content =  mkGraph nodes edges
    where
        lines' = filter(\x -> not $ head x == ' ') $ 
            filter(\x -> not $ head x == '#') $ 
            lines content
        nodes' =  nub $ concat $ map (words) $ lines'
        nodes = zip [1..length nodes'] nodes'
        edges = labUEdges $ map (tuplify2   .map (hashGet nodes). words) $ lines'
        tuplify2 [x,y] = (x,y)
        hashGet table needle = fst $ fromJust $ find (\x -> snd x == needle) table 

parseInput = do
     s <- getContents
     let graph' = parseFile s
     return (undir graph')
parseGraphFile file = do
     s <- readFile file
     let graph' = parseFile s
     return (undir graph')

headSafe [] = Nothing
headSafe x = head $ x

headSafe' :: [a] -> Maybe a
headSafe' [] = Nothing
headSafe' x = Just $ head $ x

neighbore :: G -> Node -> Node -> Bool
neighbore graph x y = x `elem` (neighbors graph y) 

uDelEdge :: Edge -> G -> G
uDelEdge edge@(x,y) graph = delEdge (y,x) $ delEdge edge graph

uInsEdge :: Edge -> G -> G
uInsEdge (x,y) graph = insEdge (y,x,()) $ insEdge (x,y,()) graph


printEdges graph (Just x) = map (printEdge graph) x
printEdges _ Nothing = []

printEdge graph (u,v) = (fromMaybe "" $ lab graph u) ++ " " ++ (fromMaybe "" $ lab graph v) ++"\n"

combos n =  [(u,v,w) | u <- n, v <- n, w <- n, u /= w, w /= v, v /= u]

nodes_with_neighbors g nodes = map (\x -> (x, (neighbors g x))) $ nodes

make_p3 ((x,_),(y,_),(z,_)) = (x,y,z)

connected graph x y 
    | x `elem` (neighbors graph y) = 1
    | otherwise = 0
