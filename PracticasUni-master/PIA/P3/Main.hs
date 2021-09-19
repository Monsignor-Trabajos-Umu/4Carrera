module Main where
import Pictures
import Test.HUnit

-- Funciones que se van a probar
f1 :: Int -> (Int, Int)
f1 x = (1, x)
f2 :: Int -> (Int, Int)
f2 v = (v+2, v+3)
f3 :: Int -> Bool
f3 v = (v > 5)
f4 :: Int -> String -> String
f4 n s = if (f3 n) then "" else s
--Creaci´on de los Test
test1,test2,test3,test4 :: Test
test1 = TestCase (assertEqual "Fallo con (f1 3)." (1,3) (f1 3))
test2 = TestCase (assertEqual "Fallo en primer elemento de f2 3." 5 (fst(f2 3)))
test3 = TestCase (assertBool "Fallo de prueba con f3." (f3 (snd(f2 3))))
test4 = TestCase (assertString (f4 6 "Resultado incorrecto con f4."))
tests :: Test
tests = TestList [TestLabel "test1" test1, TestLabel "test2" test2, TestLabel "test3" test3,TestLabel "test4" test4]
--Ejecuci´on del test
main :: IO Counts
main = runTestTT tests



---- Ejercicio 1:

blackWhite :: Picture -> Picture -> Integer -> Picture
blackWhite w b n
    | n <= 1 = b
    | otherwise = b `beside` whiteBlack w b (n-1)

whiteBlack :: Picture -> Picture -> Integer -> Picture
whiteBlack w b n
    | n <= 1 = w  
    | otherwise = w `beside` blackWhite w b (n-1)

blackChess :: Picture -> Picture -> Integer -> Integer -> Picture
blackChess w b n m
	| n <= 1 = blackWhite  w b m
	| otherwise = blackWhite w b m `above` whiteChess w b (n-1) m

whiteChess :: Picture -> Picture -> Integer -> Integer -> Picture
whiteChess w b n m
	| n <= 1 = whiteBlack w b m
	| otherwise = whiteBlack w b m `above` blackChess w b (n-1) m

chess :: IO()
chess = printPicture (chessG white black)

chessG ::  Picture -> Picture -> Picture
chessG p p' = whiteChess p p' 8 8

besideN :: Int -> Picture -> Picture
besideN 1 p = p
besideN 2 p = beside p p
besideN n p = beside p (besideN (n-1) p) 

aboveN :: Int -> Picture -> Picture
aboveN 1 p = p
aboveN 2 p = above p p
aboveN n p = above p (aboveN (n-1) p) 

casilla :: Int -> Picture -> Picture
casilla 0 p = error "ERROR: No hay casilla."
casilla 1 p = p
casilla n p = aboveN n (besideN n p)

tablero :: Int -> Picture -> Picture -> Picture
tablero n w b = chessG (casilla n white) (casilla n black) 

pintaTab :: Int -> IO()
pintaTab n = printPicture (tablero n white black)

igualesImg :: Picture -> Picture -> Bool
igualesImg = (==)

avisoImg :: Picture -> Picture -> String
avisoImg p p' = if igualesImg p p' then "" else "Prueba de fallo tablero volteado en vertical."
