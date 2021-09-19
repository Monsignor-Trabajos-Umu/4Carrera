function nombrecomp = writeHudfile(fname,m,n,mamp,namp,caliQ,CodedY,CodedCb,CodedCr)
% Escribe archivo de imagen comprimido y devuelve toda la informacion 
% necesaria para su decompresion
disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion writeHudfile:');
end

[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'.hud');
fid = fopen(nombrecomp,'w');

% fname,m,n,mamp,namp,caliQ,CodedY,CodedCb,CodedCr
unm = uint32(m);
unn = uint32(n);
unmamp = uint32(mamp);
unnamp = uint32(namp);
uncaliQ = uint32(caliQ);

fwrite(fid,unm,'uint32');
fwrite(fid,unn,'uint32');
fwrite(fid,unmamp,'uint32');
fwrite(fid,unnamp,'uint32');
fwrite(fid,uncaliQ,'uint32');

% CodedY  --------------
    [sbytesY, ultlY]=bits2bytes(CodedY);
    ulensbytesY=uint32(length(sbytesY)); % Longitud de sbytes
    uultlY=uint8(ultlY); % Longitud de ultimo segmento de sbytes
    usbytesY=sbytesY; % Entrada comprimida y segmentada. Ya esta en uint8

    fwrite(fid,ulensbytesY,'uint32'); % % Longitud de sbytes.
    fwrite(fid,uultlY,'uint8'); % Longitud de ultimo segmento de sbytes
    fwrite(fid,usbytesY,'uint8'); % Mensaje comprimido y segmentado.
%-------------

% CodedCb --------------
    [sbytesCb, ultlCb]=bits2bytes(CodedCb);
    ulensbytesCb=uint32(length(sbytesCb)); % Longitud de sbytes
    uultlCb=uint8(ultlCb); % Longitud de ultimo segmento de sbytes
    usbytesCb=sbytesCb; % Entrada comprimida y segmentada. Ya esta en uint8
    fwrite(fid,ulensbytesCb,'uint32'); % % Longitud de sbytes.
    fwrite(fid,uultlCb,'uint8'); % Longitud de ultimo segmento de sbytes
    fwrite(fid,usbytesCb,'uint8'); % Mensaje comprimido y segmentado.
%-------------

% CodedCr --------------
[sbytesCr, ultlCr]=bits2bytes(CodedCr);
ulensbytesCr=uint32(length(sbytesCr)); % Longitud de sbytes
uultlCr=uint8(ultlCr); % Longitud de ultimo segmento de sbytes
usbytesCr=sbytesCr; % Entrada comprimida y segmentada. Ya esta en uint8
    fwrite(fid,ulensbytesCr,'uint32'); % % Longitud de sbytes.
    fwrite(fid,uultlCr,'uint8'); % Longitud de ultimo segmento de sbytes
    fwrite(fid,usbytesCr,'uint8'); % Mensaje comprimido y segmentado.
%-------------

fclose(fid);
end