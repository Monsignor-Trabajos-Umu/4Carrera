function [m,n,mamp,namp,caliQ,CodedY,CodedCb,CodedCr]=readHudfile(fname)
% Lee archivo de imagen comprimido y devuelve toda la informacion 
% necesaria para su decompresion
disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion readHudfile:');
end


fid = fopen(fname,'r');
m = double(fread(fid,1,'uint32'));
n = double(fread(fid,1,'uint32'));

mamp = double(fread(fid,1,'uint32'));
namp = double(fread(fid,1,'uint32'));
caliQ = double(fread(fid,1,'uint32'));

% Leemos CodedY
lensbytesY = double(fread(fid, 1, 'uint32'));
ultlY = double(fread(fid, 1, 'uint8'));
sbytesY = double(fread(fid, lensbytesY, 'uint8'));

% Leemos CodedCb
lensbytesCb = double(fread(fid, 1, 'uint32'));
ultlCb = double(fread(fid, 1, 'uint8'));
sbytesCb = double(fread(fid, lensbytesCb, 'uint8'));

% Leemos CodedCr
lensbytesCr = double(fread(fid, 1, 'uint32'));
ultlCr = double(fread(fid, 1, 'uint8'));
sbytesCr = double(fread(fid, lensbytesCr, 'uint8'));

fclose(fid);


% Convierte sbytesY a string binario codificado
CodedY=bytes2bits(sbytesY, ultlY);
% Convierte sbytesCb a string binario codificado
CodedCb=bytes2bits(sbytesCb, ultlCb);
% Convierte sbytesCb a string binario codificado
CodedCr=bytes2bits(sbytesCr, ultlCr);
if disptext
    disp('Terminado readHudfile');    
    disp('--------------------------------------------------');
end