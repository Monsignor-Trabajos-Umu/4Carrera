function RC=jcom_dflt(fname,caliQ)

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
%  caliQ: Factor de calidad (entero positivo >= 1)
%         100: calidad estandar
%         >100: menor calidad
%         <100: mayor calidad
% Salidas:
%  RC. TASA (rate) de compresión.

disptext=0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion jcom_dflt:');
end

% Instante inicial
tc=cputime;


% Lee archivo de imagen
% Convierte a espacio de color YCbCr
% Amplia dimensiones a multiplos de 8
%  X: Matriz original de la imagen en espacio RGB
%  Xamp: Matriz ampliada de la imagen en espacio YCbCr
[X, Xamp, tipo, m, n, mamp, namp, TO]=imlee(fname);

% Calcula DCT bidimensional en bloques de 8 x 8 pixeles
Xtrans = imdct(Xamp);

% Cuantizacion de coeficientes
Xlab=quantmat(Xtrans, caliQ);

% Genera un scan por cada componente de color
%  Cada scan es una matriz mamp x namp
%  Cada bloque se reordena en zigzag
XScan=scan(Xlab);

% Codifica los tres scans, usando Huffman por defecto
[CodedY,CodedCb,CodedCr]=EncodeScans_dflt(XScan); 


nombrecomp = writeHudfile(fname,m,n,mamp,namp,caliQ,CodedY,CodedCb,CodedCr);

% Tiempo de ejecucion
e=cputime-tc;


FileInfo = dir(fname);
TO=FileInfo.bytes; % Longitud del fichero original.
% Esto es una buena jugada
FileInfo = dir(nombrecomp);
TC= FileInfo.bytes;

 % Mostrar la(s) Relacion(es) de compresión.
RC= 100*(TO-TC)/TO; % TASA (rate) de compresión.
if disptext
    disp('-----------------');
    fprintf('%s %s\n', 'Archivo comprimido:', nombrecomp);
    fprintf('%s %d %s %d\n', 'Tamaño original =', TO, 'Tamaño comprimido =', TC);
    %fprintf('%s %d %s %d\n', 'Tamaño cabecera y codigo =', TCabecera, 'Tamaño datos=', TDatos);
    fprintf('%s %2.2f %s\n', 'RC archivo =', RC, '%.');
    disp('Compresion terminada');
    fprintf('%s %1.6f\n', 'Tiempo total de CPU:', e);
    disp('Terminado jcom_dflt');
    disp('--------------------------------------------------');
end