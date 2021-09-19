import Data.List

ordenada :: Ord a => [a] ->Bool
ordenada [] = True 
ordenada [a] = True 
ordenada (x:y:xs) = x <= y && ordenada(y:xs)

borrar :: Eq a => a -> [a] -> [a]
borrar n [] = []
borrar n [x] = if x == n then [] else [x]  
borrar n (x:xs)
    | n == x = xs
    | otherwise = x : borrar n xs

insertar :: Ord a => a -> [a] -> [a]
insertar cosa [] = [cosa]
insertar cosa (x:xs)
    | cosa <= x = cosa:x:xs
    | otherwise = x:insertar cosa xs 

ordInsercion :: Ord a => [a] -> [a]
ordInsercion [] = []
ordInsercion (x:xs) = insertar x (ordInsercion xs)

minimo :: Ord a => [a] -> a
minimo = head . ordInsercion 

mezcla :: Ord a => [a] -> [a] -> [a]
mezcla [] ys = ys
mezcla xs [] = xs
mezcla xs ys = ordInsercion(xs++ys)

mitades :: [a] -> ([a], [a])
mitades [] = ([],[])
mitades (x:xs) = splitAt mitad (x:xs) where
    mitad =  length(x:xs) `div` 2
    
