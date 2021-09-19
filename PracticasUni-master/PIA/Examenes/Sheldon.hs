
import Data.List

listaprimos :: Int -> [Int]
listaprimos x = 2 : [x' | x' <- [3..x], isprime x']

isprime:: Int -> Bool
isprime x = all (\factor -> x `mod` factor>0) (factorsToTry x) where
    factorsToTry x = takeWhile (\primo -> primo * primo <= x) (listaprimos x)

primo :: [Int]
primo = 2: [x' | x'<- [3..],isprime x']


digitos :: Int -> [Int]
digitos 0 = []
digitos x = digitos(x `div` 10 ) ++ [x `mod` 10]

productoDigitos :: Int -> Int
productoDigitos x = foldr (*) 1 (digitos x)

joinDigits :: [Int] -> Int
joinDigits x = sum [x' * 10^posic | (x',posic) <- zip x [0..] ]

inverso :: Int -> Int
inverso = joinDigits . digitos

esPrimoSheldon :: Int -> Bool
esPrimoSheldon x = producto && primoCosa where
    producto = x == (productoDigitos x)
    primoCosa