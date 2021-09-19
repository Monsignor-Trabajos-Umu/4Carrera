import Dibujo
import Data.List
import Data.List.Split
import Data.Char

type Dia = Int
type Mes = Int
type Year = Int
type NombreDia = Int
type Fecha = (Dia,Mes,Year)

bisiesto ::  Year -> Bool
bisiesto year = (year `mod` 100 == 0 && year `mod` 400 == 0) || (year `mod` 100 /= 0 && year `mod` 4 == 0 )


unoDeEnero ::  Year -> NombreDia
unoDeEnero y = (365*yearActual + diasExtraVisiestos + 1) `mod` 7 where
    diasExtraVisiestos = length(filter bisiesto [1..yearActual])
    yearActual = y-1



totalesMes ::  Year -> [Int]
totalesMes year = [31,febrero,31,30,31,30,31,31,30,31,30,31] where
    febrero = if bisiesto year then 29 else 28
--e 
primerDia ::  (Mes, Year) -> NombreDia
primerDia (m,y) = (acarreo + diasAnterioes) `mod` 7 where
    acarreo =  unoDeEnero y
    listaMesesAnteriores = take (m-1) (totalesMes y)
    diasAnterioes = foldr (+) 0 listaMesesAnteriores

-- f
cleanDia :: (String,String,String) -> Fecha
cleanDia (d,m,y) = (read d ::Int, read m::Int, read y::Int)

dia ::  Fecha -> NombreDia
dia (d,m,y) = (primerDia(m,y) + d -1) `mod` 7

-- Dibujo

nombreMes :: Mes -> String
nombreMes m = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"] !! (m-1)

generaCabecera :: Mes-> Year -> Dibujo
generaCabecera m y =(DB 1 26 cabecera)where
    cabecera =  [base ++ concat(replicate diferencia " ")]
    diferencia =  26 - length(base)
    base = nm ++" "++ny
    nm = nombreMes m
    ny = show y


generaDias :: Mes -> Year -> [String]
generaDias m y  = nombreDias++blanco ++ dias ++ filling where
    nombreDias = ["Lu","Ma","Mi","Ju","Vi","Sa","Do"]
    blanco =  replicate ((primerDia (m,y) + 6) `mod` 7) "  "
    filling = replicate (7- (dia (diasMes,m,y)) `mod` 7) "  "
    diasMes = (totalesMes y)!! (m-1)
    dias = map combierteString [1..diasMes]

combierteString:: Dia -> String
combierteString d 
    | d >= 10 = show d
    | otherwise = " " ++ show d

generaSemanas::Mes -> Year -> [Dibujo]
generaSemanas m y  =  map construyeDibujo semanasString where
    semanasString = transpose (chunksOf 7 (dias))  
    dias = generaDias m y

alturaMinimaMes::Int
alturaMinimaMes = 8

extra :: Dibujo
extra = DB 1 26 [concat(replicate 26 " ")]

generaMes:: Mes -> Year -> Dibujo
generaMes m y = if (altura preMes < 8) then apilarVCon 0 [preMes,extra] else preMes where
    preMes = apilarVCon 0 [cebecera,core] 
    cebecera = generaCabecera m y 
    core = apilarHCon 2 dibujosDias
    dibujosDias = generaSemanas m y 


generarCalendario :: Year -> Dibujo
generarCalendario y = vertical where 
    vertical = apilarVCon 2 horizontal
    horizontal = [apilarHCon 5 dibujo|dibujo <-dibujos]
    dibujos = chunksOf 3 [generaMes x y | x <- [1..12]]



main :: IO()
main = bucle


menu :: IO String
menu = do
    putStrLn "Que quieres hacer moreno"
    putStrLn "M <- Imprimir mes"
    putStrLn "Y <- Imprimer calendario"
    putStrLn "Q <- Salir"
    valor <- getLine
    let (truValor:_) = map toUpper valor
    if ( elem (truValor) ['M','Y','Q']) then return [truValor] else menu


bucle :: IO()
bucle = do 
    valor <- menu
    case valor of 
        "M" -> imprimirMes
        "Y" -> imprimirMes
        "Q" -> imprimirMes


imprimirMes :: IO()
imprimirMes = do 
    putStrLn "Que mes quieres imprimir"
    mes <- getLine
    bucle