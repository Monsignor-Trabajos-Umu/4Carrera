function [m, n, mamp, namp, caliQ, CodedY, CodedCb, CodedCr, ...
    BITS_Y_DC, HUFFVAL_Y_DC, ...
    BITS_Y_AC, HUFFVAL_Y_AC, ...
    BITS_C_DC, HUFFVAL_C_DC, ...
    BITS_C_AC, HUFFVAL_C_AC] = readHudfileCustom(fname)
% Lee archivo de imagen comprimido y devuelve toda la informacion
% necesaria para su decompresion
disptext = 0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion readHudfileCustom:');
end


fid = fopen(fname, 'r');
m = double(fread(fid, 1, 'uint32'));
n = double(fread(fid, 1, 'uint32'));

mamp = double(fread(fid, 1, 'uint32'));
namp = double(fread(fid, 1, 'uint32'));
caliQ = double(fread(fid, 1, 'uint32'));

% Y_DC
lenBITS_Y_DC = double(fread(fid, 1, 'uint32'));
BITS_Y_DC = double(fread(fid, lenBITS_Y_DC, 'uint32'));
lenHUFFVAL_Y_DC = double(fread(fid, 1, 'uint32'));
HUFFVAL_Y_DC = double(fread(fid, lenHUFFVAL_Y_DC, 'uint32'));

% Y_AC
lenBITS_Y_AC = double(fread(fid, 1, 'uint32'));
BITS_Y_AC = double(fread(fid, lenBITS_Y_AC, 'uint32'));
lenHUFFVAL_Y_AC = double(fread(fid, 1, 'uint32'));
HUFFVAL_Y_AC = double(fread(fid, lenHUFFVAL_Y_AC, 'uint32'));

% C_DC_Cb
lenBITS_C_DC_Cb = double(fread(fid, 1, 'uint32'));
BITS_C_DC_Cb = double(fread(fid, lenBITS_C_DC_Cb, 'uint32'));
lenHUFFVAL_C_DC_Cb = double(fread(fid, 1, 'uint32'));
HUFFVAL_C_DC_Cb = double(fread(fid, lenHUFFVAL_C_DC_Cb, 'uint32'));

% C_AC_Cb
lenBITS_C_AC_Cb = double(fread(fid, 1, 'uint32'));
BITS_C_AC_Cb = double(fread(fid, lenBITS_C_AC_Cb, 'uint32'));
lenHUFFVAL_C_AC_Cb = double(fread(fid, 1, 'uint32'));
HUFFVAL_C_AC_Cb = double(fread(fid, lenHUFFVAL_C_AC_Cb, 'uint32'));


% C_DC_Cr
lenBITS_C_DC_Cr = double(fread(fid, 1, 'uint32'));
BITS_C_DC_Cr = double(fread(fid, lenBITS_C_DC_Cr, 'uint32'));
lenHUFFVAL_C_DC_Cr = double(fread(fid, 1, 'uint32'));
HUFFVAL_C_DC_Cr = double(fread(fid, lenHUFFVAL_C_DC_Cr, 'uint32'));

% C_AC_Cr
lenBITS_C_AC_Cr = double(fread(fid, 1, 'uint32'));
BITS_C_AC_Cr = double(fread(fid, lenBITS_C_AC_Cr, 'uint32'));
lenHUFFVAL_C_AC_Cr = double(fread(fid, 1, 'uint32'));
HUFFVAL_C_AC_Cr = double(fread(fid, lenHUFFVAL_C_AC_Cr, 'uint32'));

% Juntamos los Cb y Cr
BITS_C_DC = {BITS_C_DC_Cb, BITS_C_DC_Cr};
HUFFVAL_C_DC = {HUFFVAL_C_DC_Cb, HUFFVAL_C_DC_Cr};

BITS_C_AC = {BITS_C_AC_Cb, BITS_C_AC_Cr}; 
HUFFVAL_C_AC = {HUFFVAL_C_AC_Cb, HUFFVAL_C_AC_Cr};


% Leemos CodedY
lensbytesY = double(fread(fid, 1, 'uint32'));
ultlY = double(fread(fid, 1, 'uint32'));
sbytesY = double(fread(fid, lensbytesY, 'uint32'));

% Leemos CodedCb
lensbytesCb = double(fread(fid, 1, 'uint32'));
ultlCb = double(fread(fid, 1, 'uint32'));
sbytesCb = double(fread(fid, lensbytesCb, 'uint32'));

% Leemos CodedCr
lensbytesCr = double(fread(fid, 1, 'uint32'));
ultlCr = double(fread(fid, 1, 'uint32'));
sbytesCr = double(fread(fid, lensbytesCr, 'uint32'));

fclose(fid);


% Convierte sbytesY a string binario codificado
CodedY = bytes2bits(sbytesY, ultlY);
% Convierte sbytesCb a string binario codificado
CodedCb = bytes2bits(sbytesCb, ultlCb);
% Convierte sbytesCb a string binario codificado
CodedCr = bytes2bits(sbytesCr, ultlCr);
if disptext
    disp('Terminado readHudfileCustom');
    disp('--------------------------------------------------');
end