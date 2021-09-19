import PicturesSVG

main :: IO()
main = return ()

cuatroImg :: Picture -> Picture
cuatroImg x = y where
    y = ariba `Above` abajo
    ariba = (x `beside` (flipH (invertColour x)))
    abajo = (invertColour x `beside` (flipH (x)))
