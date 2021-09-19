import Func1

cuarta :: Integer -> Integer
cuarta x = Func1.cuadrado(cuadrado x)

-- Definir una funci´on maximo que devuelva el mayor de sus dos argumentos.
maximo :: Integer -> Integer  -> Integer
maximo x y  = if x >= y then x else y

--Definir una funci´on para calcular el ´area de un c´ırculo, dado su radio r (usar 22/7
-- como aproximaci´on de π).
areaCirculo :: (Float) -> Float
areaCirculo (x) = (x*x)*(pi)

-- Funcion de fibonachi

fibonachi :: (Integer) -> Integer
fibonachi (x)
    | x == 0 = 0
    | x == 1 = 0
    | x < 0  = -1
    | otherwise = fibonachi(x-1) + fibonachi(x-2)
-- Absolute   
absl :: Integer -> Integer
absl(x)
    | x < 0 = (-x)
    | x >= 0 = x 

-- nAnd :: Bool -> Bool -> Bool

nAnd :: Bool -> Bool -> Bool
nAnd x y = not(x && y )

-- MInimo 3 numeros
minimo :: Integer -> Integer -> Integer
minimo x y = if x <= y then x else y

minimoTres :: Integer -> Integer -> Integer -> Integer
minimoTres x y z = minimo x (minimo y z)

--10 maximoTres 
maximoTres :: Integer -> Integer -> Integer -> Integer
maximoTres x y z = maximo x (maximo y z)