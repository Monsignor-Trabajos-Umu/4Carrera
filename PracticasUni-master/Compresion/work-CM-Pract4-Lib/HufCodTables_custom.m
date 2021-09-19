 function [ehuf,BITS, HUFFVAL] = HufCodTables_custom(Y_DC_CP)

% Genera tablas de codificacion usando frecuencia
% Obtiene frecuencias de mensajes contenidos en x
%Hay un offset: FREQ(1) es frecuencia del entero 0
FREQ = Freq256(Y_DC_CP);
% Construye Tablas de Especificacion Huffman
[BITS, HUFFVAL] = HSpecTables(FREQ);
% Construye Tablas del Codigo Huffman
[HUFFSIZE, HUFFCODE] = HCodeTables(BITS, HUFFVAL);
% Construye Tablas de Codificacion Huffman
[EHUFCO, EHUFSI] = HCodingTables(HUFFSIZE, HUFFCODE, HUFFVAL);
ehuf=[EHUFCO EHUFSI];

 end


