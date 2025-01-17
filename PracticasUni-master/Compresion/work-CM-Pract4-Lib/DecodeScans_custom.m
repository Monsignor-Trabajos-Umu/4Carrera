function XScanrec = DecodeScans_custom(CodedY, CodedCb, CodedCr, tam, ...
    BITS_Y_DC, HUFFVAL_Y_DC, ...
    BITS_Y_AC, HUFFVAL_Y_AC, ...
    BITS_C_DC, HUFFVAL_C_DC, ...
    BITS_C_AC, HUFFVAL_C_AC)

% DecodeScans_dflt: Decodifica los tres scans binarios usando Huffman por
% frecuencia
% Basado en ITU T.81, Anexos K, C y F
% Basado en SF2,  Nick Kingsbury, University of Cambridge
% Adaptado por Roque Marin

% Entradas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado
%   tam: Tama�o del scan a devolver [mamp namp]
% Salidas:
%  XScanrec: Scans reconstruidos de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3

disptext = 0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion DecodeScans_custom');
end

% Instante inicial
tc = cputime;

% Construir tablas Huffman para Luminancia y Crominancia
% Tablas Huffman, formato ITU T.81, Anexo C y Anexo K
% Genera Tablas Huffman por freq, que se archivaran
% Tablas de luminancia
% Tabla Y_DC
[mincode_Y_DC, maxcode_Y_DC, valptr_Y_DC, huffval_Y_DC] = HufDecodTables_custom(BITS_Y_DC,HUFFVAL_Y_DC);
% Tabla Y_AC
[mincode_Y_AC, maxcode_Y_AC, valptr_Y_AC, huffval_Y_AC] = HufDecodTables_custom(BITS_Y_AC,HUFFVAL_Y_AC);
% Tablas de crominancia
% Extraemos los bits cr y cb y sus huffvalues

BITS_C_DC_Cb = cell2mat(BITS_C_DC(1));
BITS_C_DC_Cr = cell2mat(BITS_C_DC(2));

HUFFVAL_C_DC_Cb = cell2mat(HUFFVAL_C_DC(1));
HUFFVAL_C_DC_Cr = cell2mat(HUFFVAL_C_DC(2));


BITS_C_AC_Cb = cell2mat(BITS_C_AC(1));
BITS_C_AC_Cr = cell2mat(BITS_C_AC(2));

HUFFVAL_C_AC_Cb = cell2mat(HUFFVAL_C_AC(1));
HUFFVAL_C_AC_Cr = cell2mat(HUFFVAL_C_AC(2));

% Tabla C_DC_Cb
[mincode_C_DC_Cb, maxcode_C_DC_Cb, valptr_C_DC_Cb, huffval_C_DC_Cb] = HufDecodTables_custom(BITS_C_DC_Cb,HUFFVAL_C_DC_Cb);
% Tabla C_AC_Cb
[mincode_C_AC_Cb, maxcode_C_AC_Cb, valptr_C_AC_Cb, huffval_C_AC_Cb] = HufDecodTables_custom(BITS_C_AC_Cb,HUFFVAL_C_AC_Cb);

% Tabla C_DC_Cr
[mincode_C_DC_Cr, maxcode_C_DC_Cr, valptr_C_DC_Cr, huffval_C_DC_Cr] = HufDecodTables_custom(BITS_C_DC_Cr,HUFFVAL_C_DC_Cr);
% Tabla C_AC_Cr
[mincode_C_AC_Cr, maxcode_C_AC_Cr, valptr_C_AC_Cr, huffval_C_AC_Cr] = HufDecodTables_custom(BITS_C_AC_Cr,HUFFVAL_C_AC_Cr);



% Decodifica en binario cada Scan
% Las tablas de crominancia se aplican, tanto a Cb, como a Cr
YScanrec = DecodeSingleScan(CodedY, mincode_Y_DC, maxcode_Y_DC, valptr_Y_DC, huffval_Y_DC, mincode_Y_AC, maxcode_Y_AC, valptr_Y_AC, huffval_Y_AC, tam);
CbScanrec = DecodeSingleScan(CodedCb, mincode_C_DC_Cb, maxcode_C_DC_Cb, valptr_C_DC_Cb, huffval_C_DC_Cb, mincode_C_AC_Cb, maxcode_C_AC_Cb, valptr_C_AC_Cb, huffval_C_AC_Cb, tam);
CrScanrec = DecodeSingleScan(CodedCr, mincode_C_DC_Cr, maxcode_C_DC_Cr, valptr_C_DC_Cr, huffval_C_DC_Cr, mincode_C_AC_Cr, maxcode_C_AC_Cr, valptr_C_AC_Cr, huffval_C_AC_Cr, tam);

% Reconstruye matriz 3-D
XScanrec = cat(3, YScanrec, CbScanrec, CrScanrec);

% Tiempo de ejecucion
e = cputime - tc;

if disptext
    disp('Scans decodificados');
    fprintf('%s %1.6f\n', 'Tiempo de CPU:', e);
    disp('Terminado DecodeScans_dflt');
end;
end