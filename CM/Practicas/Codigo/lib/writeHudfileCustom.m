function nombrecomp = writeHudfileCustom( ...
    fname, m, n, mamp, namp, caliQ, CodedY, CodedCb, CodedCr, ...
    BITS_Y_DC, HUFFVAL_Y_DC, ...
    BITS_Y_AC, HUFFVAL_Y_AC, ...
    BITS_C_DC, HUFFVAL_C_DC, ...
    BITS_C_AC, HUFFVAL_C_AC)
% Escribe archivo de imagen comprimido y devuelve toda la informacion
% necesaria para su decompresion
disptext = 0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion writeHudfile:');
end

[~, name, ~] = fileparts(fname);
nombrecomp = strcat(name,'.hud');
fid = fopen(nombrecomp, 'w');

% fname,m,n,mamp,namp,caliQ,CodedY,CodedCb,CodedCr
unm = uint32(m);
unn = uint32(n);
unmamp = uint32(mamp);
unnamp = uint32(namp);
uncaliQ = uint32(caliQ);

fwrite(fid, unm, 'uint32');
fwrite(fid, unn, 'uint32');
fwrite(fid, unmamp, 'uint32');
fwrite(fid, unnamp, 'uint32');
fwrite(fid, uncaliQ, 'uint32');


% Y_DC
ulenBITS_Y_DC = uint32(length(BITS_Y_DC)); % Nº de filas de BITS
uBITS_Y_DC = uint32(BITS_Y_DC); % Nº de palabras codigo de cada longitudulen
ulenHUFFVAL_Y_DC = uint32(length(HUFFVAL_Y_DC)); % Nº de filas de HUFFVAL
uHUFFVAL_Y_DC = uint32(HUFFVAL_Y_DC); % Mensajes ordenados por long. de palabraulen

fwrite(fid, uint32(ulenBITS_Y_DC), 'uint32');
fwrite(fid, uint32(uBITS_Y_DC), 'uint32');
fwrite(fid, uint32(ulenHUFFVAL_Y_DC), 'uint32');
fwrite(fid, uint32(uHUFFVAL_Y_DC), 'uint32');

% Y_AC
ulenBITS_Y_AC = uint32(length(BITS_Y_AC)); % Nº de filas de BITS
uBITS_Y_AC = uint32(BITS_Y_AC); % Nº de palabras codigo de cada longitudulen
ulenHUFFVAL_Y_AC = uint32(length(HUFFVAL_Y_AC)); % Nº de filas de HUFFVAL
uHUFFVAL_Y_AC = uint32(HUFFVAL_Y_AC); % Mensajes ordenados por long. de palabraulen

fwrite(fid, uint32(ulenBITS_Y_AC), 'uint32');
fwrite(fid, uint32(uBITS_Y_AC), 'uint32');
fwrite(fid, uint32(ulenHUFFVAL_Y_AC), 'uint32');
fwrite(fid, uint32(uHUFFVAL_Y_AC), 'uint32');




% Extraemos los bits cr y cb y sus huffvalues

BITS_C_DC_Cb = cell2mat(BITS_C_DC(1));
BITS_C_DC_Cr = cell2mat(BITS_C_DC(2));

HUFFVAL_C_DC_Cb = cell2mat(HUFFVAL_C_DC(1));
HUFFVAL_C_DC_Cr = cell2mat(HUFFVAL_C_DC(2));


BITS_C_AC_Cb = cell2mat(BITS_C_AC(1));
BITS_C_AC_Cr = cell2mat(BITS_C_AC(2));

HUFFVAL_C_AC_Cb = cell2mat(HUFFVAL_C_AC(1));
HUFFVAL_C_AC_Cr = cell2mat(HUFFVAL_C_AC(2));




% C_DC_Cb
ulenBITS_C_DC_Cb = uint32(length(BITS_C_DC_Cb)); % Nº de filas de BITS
uBITS_C_DC_Cb = uint32(BITS_C_DC_Cb); % Nº de palabras codigo de cada longitudulen
ulenHUFFVAL_C_DC_Cb = uint32(length(HUFFVAL_C_DC_Cb)); % Nº de filas de HUFFVAL
uHUFFVAL_C_DC_Cb = uint32(HUFFVAL_C_DC_Cb); % Mensajes ordenados por long. de palabraulen

fwrite(fid, uint32(ulenBITS_C_DC_Cb), 'uint32');
fwrite(fid, uint32(uBITS_C_DC_Cb), 'uint32');
fwrite(fid, uint32(ulenHUFFVAL_C_DC_Cb), 'uint32');
fwrite(fid, uint32(uHUFFVAL_C_DC_Cb), 'uint32');

% C_AC_Cb
ulenBITS_C_AC_Cb = uint32(length(BITS_C_AC_Cb)); % Nº de filas de BITS
uBITS_C_AC_Cb = uint32(BITS_C_AC_Cb); % Nº de palabras codigo de cada longitudulen
ulenHUFFVAL_C_AC_Cb = uint32(length(HUFFVAL_C_AC_Cb)); % Nº de filas de HUFFVAL
uHUFFVAL_C_AC_Cb = uint32(HUFFVAL_C_AC_Cb); % Mensajes ordenados por long. de palabraulen

fwrite(fid, uint32(ulenBITS_C_AC_Cb), 'uint32');
fwrite(fid, uint32(uBITS_C_AC_Cb), 'uint32');
fwrite(fid, uint32(ulenHUFFVAL_C_AC_Cb), 'uint32');
fwrite(fid, uint32(uHUFFVAL_C_AC_Cb), 'uint32');



% C_DC_Cr
ulenBITS_C_DC_Cr = uint32(length(BITS_C_DC_Cr)); % Nº de filas de BITS
uBITS_C_DC_Cr = uint32(BITS_C_DC_Cr); % Nº de palabras codigo de cada longitudulen
ulenHUFFVAL_C_DC_Cr = uint32(length(HUFFVAL_C_DC_Cr)); % Nº de filas de HUFFVAL
uHUFFVAL_C_DC_Cr = uint32(HUFFVAL_C_DC_Cr); % Mensajes ordenados por long. de palabraulen

fwrite(fid, uint32(ulenBITS_C_DC_Cr), 'uint32');
fwrite(fid, uint32(uBITS_C_DC_Cr), 'uint32');
fwrite(fid, uint32(ulenHUFFVAL_C_DC_Cr), 'uint32');
fwrite(fid, uint32(uHUFFVAL_C_DC_Cr), 'uint32');

% C_AC_Cr
ulenBITS_C_AC_Cr = uint32(length(BITS_C_AC_Cr)); % Nº de filas de BITS
uBITS_C_AC_Cr = uint32(BITS_C_AC_Cr); % Nº de palabras codigo de cada longitudulen
ulenHUFFVAL_C_AC_Cr = uint32(length(HUFFVAL_C_AC_Cr)); % Nº de filas de HUFFVAL
uHUFFVAL_C_AC_Cr = uint32(HUFFVAL_C_AC_Cr); % Mensajes ordenados por long. de palabraulen

fwrite(fid, uint32(ulenBITS_C_AC_Cr), 'uint32');
fwrite(fid, uint32(uBITS_C_AC_Cr), 'uint32');
fwrite(fid, uint32(ulenHUFFVAL_C_AC_Cr), 'uint32');
fwrite(fid, uint32(uHUFFVAL_C_AC_Cr), 'uint32');



% Code Y
[sbytesY, ultlY] = bits2bytes(CodedY);
ulensbytesY = uint32(length(sbytesY)); % Longitud de sbytes
uultlY = uint32(ultlY); % Longitud de ultimo segmento de sbytes
usbytesY = sbytesY; % Entrada comprimida y segmentada. Ya esta en uint8

fwrite(fid, ulensbytesY, 'uint32'); % % Longitud de sbytes.
fwrite(fid, uultlY, 'uint32'); % Longitud de ultimo segmento de sbytes
fwrite(fid, usbytesY, 'uint32'); % Mensaje comprimido y segmentado.

% CodedCb --------------
[sbytesCb, ultlCb] = bits2bytes(CodedCb);
ulensbytesCb = uint32(length(sbytesCb)); % Longitud de sbytes
uultlCb = uint32(ultlCb); % Longitud de ultimo segmento de sbytes
usbytesCb = sbytesCb; % Entrada comprimida y segmentada. Ya esta en uint8

fwrite(fid, ulensbytesCb, 'uint32'); % % Longitud de sbytes.
fwrite(fid, uultlCb, 'uint32'); % Longitud de ultimo segmento de sbytes
fwrite(fid, usbytesCb, 'uint32'); % Mensaje comprimido y segmentado.
%-------------

% CodedCr --------------
[sbytesCr, ultlCr] = bits2bytes(CodedCr);
ulensbytesCr = uint32(length(sbytesCr)); % Longitud de sbytes
uultlCr = uint32(ultlCr); % Longitud de ultimo segmento de sbytes
usbytesCr = sbytesCr; % Entrada comprimida y segmentada. Ya esta en uint8

fwrite(fid, ulensbytesCr, 'uint32'); % % Longitud de sbytes.
fwrite(fid, uultlCr, 'uint32'); % Longitud de ultimo segmento de sbytes
fwrite(fid, usbytesCr, 'uint32'); % Mensaje comprimido y segmentado.
%-------------

fclose(fid);
end