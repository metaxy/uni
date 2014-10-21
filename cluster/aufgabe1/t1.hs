import Helper
import Data.Graph.Inductive
import Data.List
import Data.Maybe
import Data.GraphViz
import Data.GraphViz.Attributes
import Debug.Trace
import qualified Data.Text.Lazy.IO as LT
import Data.Text.Lazy (Text)
import Data.GraphViz
import Data.GraphViz.Printing

findP3 :: G -> Maybe P3
findP3 graph = headSafe $ map (is_p3 graph) (nodes graph)

is_p3 :: G -> Node -> Maybe P3
is_p3 graph node
    | length near < 2 = Nothing
    | otherwise = make_p3 (first,node,(second first))
        where
            near = neighbors graph node
            first = find connected near
            connected x = not $ any (neighbore graph x) (delete x near)
            
            second Nothing = Nothing
            second (Just first) = find connected (delete first near)
            
ce_branch :: G -> Integer -> Maybe [Edge]
ce_branch graph k
    | k < 0 = Nothing
    | otherwise = ce_branch' p3 graph k
        where
            p3 = findP3 graph

ce_branch' :: Maybe P3 -> G -> Integer -> Maybe [Edge]
ce_branch' Nothing _ _ = Just []
ce_branch' (Just (u,v,w)) graph k 
    | isJust b1 = fmap ((:) (u,v)) b1
    | isJust b2 = fmap ((:) (v,w)) b2
    | isJust b3 = fmap ((:) (u,w)) b3
    | otherwise = Nothing
        where
            b1 = ce_branch (uDelEdge (u,v) graph) (k-1)
            b2 = ce_branch (uDelEdge (v,w) graph) (k-1)
            b3 = ce_branch (uInsEdge (u,w, ()) graph) (k-1)

main = do
    s <- getContents
    let graph' = parseFile s
        graph = undir graph'
        k2 = ce_branch graph 1
    LT.putStr $ renderDot $ toDot $ graphToDot nonClusteredParams graph
    return ()
