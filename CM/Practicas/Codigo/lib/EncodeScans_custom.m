function [CodedY, CodedCb, CodedCr, BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC, HUFFVAL_Y_AC, BITS_C_DC, HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC] = EncodeScans_custom(XScan)

    % Separa las matrices bidimensionales
    %  para procesar separadamente
    YScan = XScan(:, :, 1);
    CbScan = XScan(:, :, 2);
    CrScan = XScan(:, :, 3);

    % Recolectar valores a codificar
    % Solo quiero la categoria no la posicion en la misma tendre que hacer Y_DC_CP(:,1)
    [Y_DC_CP, Y_AC_ZCP] = CollectScan(YScan);
    [Cb_DC_CP, Cb_AC_ZCP] = CollectScan(CbScan);
    [Cr_DC_CP, Cr_AC_ZCP] = CollectScan(CrScan);

    % Construir tablas Huffman para Luminancia y Crominancia
    % Tablas Huffman, formato ITU T.81, Anexo C y Anexo K
    % Genera Tablas Huffman usando freq
    % La variable ehuf_X_X es la concatenacion [EHUFCO EHUFSI]

    % Tablas de luminancia
    % Tabla Y_DC
    [ehuf_Y_DC, BITS_Y_DC, HUFFVAL_Y_DC] = HufCodTables_custom(Y_DC_CP(:, 1));
    % Tabla Y_AC
    [ehuf_Y_AC, BITS_Y_AC, HUFFVAL_Y_AC] = HufCodTables_custom(Y_AC_ZCP(:, 1));

    % Tablas de crominancia
    % Tabla C_DC condadeno las dos categorias
    nn_DC_CP = [Cb_DC_CP(:, 1); Cr_DC_CP(:, 1)];
    [ehuf_C_DC, BITS_C_DC, HUFFVAL_C_DC] = HufCodTables_custom(nn_DC_CP);
    % Tabla C_AC
    nn_AC_ZCP = [Cb_AC_ZCP(:, 1); Cr_AC_ZCP(:, 1)];
    [ehuf_C_AC, BITS_C_AC, HUFFVAL_C_AC] = HufCodTables_custom(nn_AC_ZCP);

    % Codifica en binario cada Scan
    CodedY = EncodeSingleScan(YScan, Y_DC_CP, Y_AC_ZCP, ehuf_Y_DC, ehuf_Y_AC);
    CodedCb = EncodeSingleScan(CbScan, Cb_DC_CP, Cb_AC_ZCP, ehuf_C_DC, ehuf_C_AC);
    CodedCr = EncodeSingleScan(CrScan, Cr_DC_CP, Cr_AC_ZCP, ehuf_C_DC, ehuf_C_AC);
end
