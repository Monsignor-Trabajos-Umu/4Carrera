module ListaPar(ListaP2,comprimida,expandida) where
-- 1
data ListaP a = LP [(Int,a)]

-- 2
-- 12->’B’
instance (Show a) => Show (ListaP a) where
    show (LP []) =""
    show (LP ((x,y):xs) ) = show x ++ show " -> " ++ show y ++ show "\n"  ++ show(LP xs)

-- Renombramiento

type ListaP2 a = [(Int,a)]

prueba :: ListaP2 Int
prueba = [(2,1),(3,7),(2,5),(4,7)]

-- Comprime
-- comprimida [1,1,7,7,7,5,5,7,7,7,7]
-- [(2,1),(3,7),(2,5),(4,7)]
comprimida ::Eq a => [a] -> ListaP2 a
comprimida [] = []
comprimida (x:xs) = 
    (1 + length (takeWhile (==x) xs),x) : comprimida (dropWhile (==x) xs)

expandida ::  ListaP2 a -> [a]
expandida [] = []
expandida ((x,y):xs) = [y | x' <-[1..x]] ++ expandida xs

expandida2 ::  ListaP2 a -> [a]
expandida2 ((x,y):xs) = replicate x y ++ expandida xs 