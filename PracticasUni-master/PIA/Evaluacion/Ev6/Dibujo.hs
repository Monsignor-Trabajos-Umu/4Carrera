module Dibujo(Dibujo(..),construyeDibujo,apilarHCon,apilarVCon,altura) where

type Altura = Int
type Anchura = Int
data Dibujo = DB Altura Anchura [String]


instance Show Dibujo where
    show (DB h y xs ) =  "Altura = " ++ show h ++  " Anchura = " ++ show y ++ "\n" ++ unlines xs



-- C

altura :: Dibujo -> Int
altura (DB a _ _) = a 

anchura :: Dibujo -> Int
anchura (DB _ a _) = a 


prueba :: [Dibujo]
prueba = [(DB 4 1 ["a","b","c","d"]),(DB 4 1 ["a","b","c","d"]),(DB 4 1 ["a","b","c","d"]),(DB 4 1 ["a","b","c","d"])]

-- Uno sobre otro

sobre ::  Dibujo -> Dibujo -> Dibujo
sobre (DB al an xs) (DB al' an' xs') |
    an == an' = DB (al + al') (an) (xs ++ xs')
    | otherwise =  error "Anchuras diferentes"


juntoA  ::  Dibujo -> Dibujo -> Dibujo
juntoA  (DB al an xs) (DB al' an' xs') |
    al == al' = DB (al) (an + an') (zipWith (++) xs xs')
    | otherwise =  error "Alturas diferentes"

apilarV :: [Dibujo] -> Dibujo
apilarV d = foldr1 (sobre) d

apilarH :: [Dibujo] -> Dibujo
apilarH d = foldr1 (juntoA) d 



-- fila ::  String -> Dibujo
fila ::  String -> Dibujo
fila [] = error "La cadena es vacia"
fila xs = DB (1) (length xs) [xs]


-- Creacion
crearDibujo:: Altura -> Anchura -> Dibujo
crearDibujo al an = (DB al an db) where 
    db = replicate al cadena
    cadena = concat (replicate an " ")

crearBlanco:: Altura-> Anchura -> [Dibujo] -> [Dibujo]
crearBlanco h a [] = []
crearBlanco h a (x:xs) =x: (crearDibujo h a ):(crearBlanco h a xs)


-- Vertical
apilarVCon ::  Altura -> [Dibujo] -> Dibujo
apilarVCon h djs =  apilarV d where
    d = init(crearBlanco h an djs)
    an = anchura (head djs)

-- Horizontal 
apilarHCon ::  Anchura -> [Dibujo] -> Dibujo
apilarHCon an djs =  apilarH d where
    d = init(crearBlanco h an djs)
    h = altura (head djs)


-- Extra 
construyeDibujo :: [String] -> Dibujo
construyeDibujo xs = DB (length xs) (length (xs !! 0)) xs 