module Helper ( parseFile,headSafe, make_p3, neighbore, G , uDelEdge, uInsEdge, P3) where
import Data.Graph.Inductive
import Data.Graph.Inductive.Example
import Prelude
import Data.List
import Data.Maybe
import Data.GraphViz
type G = Gr String ()
type P3 = (Node,Node,Node)

parseFile :: String -> G
parseFile content = mkGraph nodes edges
    where
        nodes' = nub $ concat $ map (words) $ lines content
        nodes =  zip [0..length nodes' - 1] nodes'
        edges = labUEdges $ map (tuplify2   .map (hashGet nodes). words) $ lines content
        tuplify2 [x,y] = (x,y)
        hashGet table needle = fst $ fromMaybe (0,"") $ find (\x -> snd x == needle) table 

headSafe [] = Nothing
headSafe x = head $ x


make_p3 (Nothing,_,_) = Nothing
make_p3 (_,_,Nothing) = Nothing
make_p3 (Just x,m,Just y) = Just $ (x,m,y)


neighbore graph x y = x `elem` (neighbors graph y) 

uDelEdge :: Edge -> G -> G
uDelEdge edge@(x,y) graph = delEdge (y,x) $ delEdge edge graph

uInsEdge :: LEdge b -> G -> G
uInsEdge (x,y,_) graph = insEdge (y,x,()) $ insEdge (x,y,()) graph

defaultVis :: G -> DotGraph Node
defaultVis = setDirectedness graphToDot nonClusteredParams
