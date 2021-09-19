function [CodedY, CodedCb, CodedCr, ...
    BITS_Y_DC, HUFFVAL_Y_DC, ...
    BITS_Y_AC, HUFFVAL_Y_AC, ...
    BITS_C_DC, HUFFVAL_C_DC, ...
    BITS_C_AC, HUFFVAL_C_AC] = EncodeScans_custom(XScan)

disptext = 0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion EncodeScans_custom:');
end

% Instante inicial
tc = cputime;



% Separa las matrices bidimensionales
%  para procesar separadamente
YScan = XScan(:, :, 1);
CbScan = XScan(:, :, 2);
CrScan = XScan(:, :, 3);


% Recolectar valores a codificar
[Y_DC_CP, Y_AC_ZCP]=CollectScan(YScan);
[Cb_DC_CP, Cb_AC_ZCP]=CollectScan(CbScan);
[Cr_DC_CP, Cr_AC_ZCP]=CollectScan(CrScan);


% Construir tablas Huffman para Luminancia y Crominancia
% Tablas Huffman, formato ITU T.81, Anexo C y Anexo K
% Genera Tablas Huffman usando freq
% La variable ehuf_X_X es la concatenacion [EHUFCO EHUFSI]
% Tablas de luminancia
% Tabla Y_DC
[ehuf_Y_DC, BITS_Y_DC, HUFFVAL_Y_DC] = HufCodTables_custom(Y_DC_CP);
% Tabla Y_AC
[ehuf_Y_AC, BITS_Y_AC, HUFFVAL_Y_AC] = HufCodTables_custom(Y_AC_ZCP);
% Tablas de crominancia
% Tabla C_DC_Cb
[ehuf_C_DC_Cb, BITS_C_DC_Cb, HUFFVAL_C_DC_Cb] = HufCodTables_custom(Cb_DC_CP);
% Tabla C_AC_Cb
[ehuf_C_AC_Cb, BITS_C_AC_Cb, HUFFVAL_C_AC_Cb] = HufCodTables_custom(Cb_AC_ZCP);

% Tabla C_DC_Cr
[ehuf_C_DC_Cr, BITS_C_DC_Cr, HUFFVAL_C_DC_Cr] = HufCodTables_custom(Cr_DC_CP);
% Tabla C_AC_Cb
[ehuf_C_AC_Cr, BITS_C_AC_Cr, HUFFVAL_C_AC_Cr] = HufCodTables_custom(Cr_AC_ZCP);



% Codifica en binario cada Scan
% Las tablas de crominancia, ehuf_C_DC y ehuf_C_AC, se aplican, tanto a Cb, como a Cr
CodedY=EncodeSingleScan(YScan, Y_DC_CP, Y_AC_ZCP, ehuf_Y_DC, ehuf_Y_AC);
CodedCb=EncodeSingleScan(CbScan, Cb_DC_CP, Cb_AC_ZCP, ehuf_C_DC_Cb, ehuf_C_AC_Cb);
CodedCr=EncodeSingleScan(CrScan, Cr_DC_CP, Cr_AC_ZCP, ehuf_C_DC_Cr, ehuf_C_AC_Cr);

BITS_C_DC = {BITS_C_DC_Cb, BITS_C_DC_Cr};
HUFFVAL_C_DC = {HUFFVAL_C_DC_Cb, HUFFVAL_C_DC_Cr};

BITS_C_AC = {BITS_C_AC_Cb, BITS_C_AC_Cr}; 
HUFFVAL_C_AC = {HUFFVAL_C_AC_Cb, HUFFVAL_C_AC_Cr};

% Tiempo de ejecucion
e = cputime - tc;

if disptext
    disp('Componentes codificadas en binario');
    fprintf('%s %1.6f\n', 'Tiempo de CPU:', e);
    disp('Terminado EncodeScans_custom');
end


end