function XScanrec = DecodeScans_custom(CodedY, CodedCb, CodedCr, tam, ...
        BITS_Y_DC, HUFFVAL_Y_DC, ...
        BITS_Y_AC, HUFFVAL_Y_AC, ...
        BITS_C_DC, HUFFVAL_C_DC, ...
        BITS_C_AC, HUFFVAL_C_AC)

    % Construir tablas Huffman para Luminancia y Crominancia
    % Tablas de luminancia
    % Tabla Y_DC
    [mincode_Y_DC, maxcode_Y_DC, valptr_Y_DC, huffval_Y_DC] = HufDecodTables_custom(BITS_Y_DC, HUFFVAL_Y_DC);
    % Tabla Y_AC
    [mincode_Y_AC, maxcode_Y_AC, valptr_Y_AC, huffval_Y_AC] = HufDecodTables_custom(BITS_Y_AC, HUFFVAL_Y_AC);
    % Tablas de crominancia
    % Tabla C_DC
    [mincode_C_DC, maxcode_C_DC, valptr_C_DC, huffval_C_DC] = HufDecodTables_custom(BITS_C_DC, HUFFVAL_C_DC);
    % Tabla C_AC
    [mincode_C_AC, maxcode_C_AC, valptr_C_AC, huffval_C_AC] = HufDecodTables_custom(BITS_C_AC, HUFFVAL_C_AC);
    % Decodifica en binario cada Scan
    % Las tablas de crominancia se aplican, tanto a Cb, como a Cr
    YScanrec = DecodeSingleScan(CodedY, mincode_Y_DC, maxcode_Y_DC, valptr_Y_DC, huffval_Y_DC, mincode_Y_AC, maxcode_Y_AC, valptr_Y_AC, huffval_Y_AC, tam);
    CbScanrec = DecodeSingleScan(CodedCb, mincode_C_DC, maxcode_C_DC, valptr_C_DC, huffval_C_DC, mincode_C_AC, maxcode_C_AC, valptr_C_AC, huffval_C_AC, tam);
    CrScanrec = DecodeSingleScan(CodedCr, mincode_C_DC, maxcode_C_DC, valptr_C_DC, huffval_C_DC, mincode_C_AC, maxcode_C_AC, valptr_C_AC, huffval_C_AC, tam);
    % Reconstruye matriz 3-D
    XScanrec = cat(3, YScanrec, CbScanrec, CrScanrec);

end
