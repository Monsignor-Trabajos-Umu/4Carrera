type Simbolo = Char
type Estado = Int
type Alfabeto = [Simbolo]
type Cinta = [Simbolo]

data Accion = Izq | Drcha | Impr Simbolo | Ninguna
    deriving (Eq,Show)


-- 2
type Cuadruplas = [(Estado,Simbolo,Accion,Estado)]

ejemplo :: Cuadruplas
ejemplo = [(1,'a',Izq,0),(0,'n',Drcha,1)]

delta::Cuadruplas->(Estado,Simbolo)->(Accion,Estado)
delta [] _ = (Ninguna,0)
delta ((es,sim,ac,es'):xs) (esta,simb) = if (es == esta && sim == simb) then (ac,es')
    else delta xs (esta,simb)

-- Una MT estar�a compuesta por ([Estado], Estado, Alfabeto, Cuadruplas).
-- [Estado] son los que hay en las cuadruplas. Los consideramos no predefinidos.
-- Estado se refiere al estado inicial. Lo consideramos por defecto  el q1 (represendo por el 1). 
-- Alfabeto es una lista ordenada que no puede tener s�mbolos repetidos.
type MT = (Alfabeto,Cuadruplas)

ejemploTR:: MT
ejemploTR = (['a'..'z'],ejemplo)


-- 3 Configuracion
-- Compuesto por Un estado su simbolo, la parte izquierda de la cinta y la parte derecha
newtype Configuracion = Conf (Estado,Cinta,Simbolo,Cinta)

instance Show Configuracion where
    show (Conf (es,iz,sim,der)) = iz ++ [sim]++ der ++ "\n" ++ espacios ++ "^" ++ "\n" ++ espacios ++ show (es) ++ "\n" where
        espacios =  replicate (length iz) ' '
-- 4 Actualiza
actualizaCinta::Accion->(Cinta,Simbolo,Cinta)->(Cinta,Simbolo,Cinta)
actualizaCinta Izq (l,s,r) 
        | l==[] = ([],' ',s:r)
        | otherwise = (tail l, head l, s:r) 
actualizaCinta Drcha (l,s,r)
        | r==[] = (s:l,' ',[])
        | otherwise = (s:l, head r, tail r) 
actualizaCinta (Impr s') (l,s,r)  = (l, s', r) 
actualizaCinta Ninguna (l,s,r) = error "Termina calculo sin esperarlo\n"


-- pasos
-- Dada una m�quina de Turing, devuelve el conjunto de configuraciones, desde una dada hasta la final (si existe).
-- Devuelve las posibles configuraciones de la lista para cada una de las acciones desde la configuracion actual hasta el final
pasosCalculo::MT -> Configuracion -> [Configuracion]
pasosCalculo (alf,cuadru) (Conf (est,cintIz,simb,cintDer))
    | (ac',esta') ==  (Ninguna,0) = [Conf (est,cintIz,simb,cintDer)]
    | otherwise = Conf (est,cintIz,simb,cintDer) : (pasosCalculo (alf,cuadru) (Conf (esta',cintIz',simb',cintDer'))) 
    where 
        (ac',esta') = delta cuadru (est,simb)
        (cintIz',simb',cintDer') = actualizaCinta ac' (cintIz,simb,cintDer')
--6
--Devuelve el c�lculo completo a partir de una MT y una entrada.
calculo :: MT -> String -> [Configuracion]
calculo (alf,d) palabra = pasosCalculo (alf,d) (Conf (1,"",' ', palabra))


-- 7
calcula :: MT -> String -> Cinta
calcula (alf,d) palabra = 