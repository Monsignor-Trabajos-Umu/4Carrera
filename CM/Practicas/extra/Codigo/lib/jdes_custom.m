function  [MSE, RC] = jdes_custom(fname)
% Función de descompresión: [MSE,RC]=jdes_custom(fname)
% o Se basa en la segunda mitad de la función jcomdes (librería)
% o Aplica tablas Huffman por frecuencia
% o Lee un archivo comprimido *.hud
% o Genera y almacena un archivo descomprimido *_des_cus.bmp
% o Calcula y devuelve:
% ? La relación de compresión RC
% ? El error cuadrático medio MSE
% o Visualiza la imagen bitmap original y la descomprimida
disptext = 0; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion jdes_custom:');
end

% Instante inicial
tc = cputime;
% Leemos la imagen
[m, n, mamp, namp, caliQ, CodedY, CodedCb, CodedCr, ...
    BITS_Y_DC, HUFFVAL_Y_DC, ...
    BITS_Y_AC, HUFFVAL_Y_AC, ...
    BITS_C_DC, HUFFVAL_C_DC, ...
    BITS_C_AC, HUFFVAL_C_AC] = readHudfileCustom(fname);


% Decodifica los tres Scans a partir de strings binarios
XScanrec = DecodeScans_custom(CodedY, CodedCb, CodedCr, [mamp, namp], ...
    BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC, HUFFVAL_Y_AC, ...
    BITS_C_DC, HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC);
% Recupera matrices de etiquetas en orden natural
%  a partir de orden zigzag
Xlabrec = invscan(XScanrec);

% Descuantizacion de etiquetas
Xtransrec = desquantmat(Xlabrec, caliQ);

% Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
% Como resultado, reconstruye una imagen YCbCr con tamaño ampliado
Xamprec = imidct(Xtransrec, m, n);

% Convierte a espacio de color RGB
% Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
Xrecrd = round(ycbcr2rgb(Xamprec/255)*255);
Xrec = uint8(Xrecrd);

% Repone el tamaño original
Xrec = Xrec(1:m, 1:n, 1:3);

% Genera nombre archivo descomprimido <nombre>_des.txt
[pathstr, name, ext] = fileparts(fname);
nombrecomp = strcat(name,"_",int2str(caliQ),'_des_custom', '.bmp');

% Guarda archivo descomprimido
imwrite(Xrec, nombrecomp, 'bmp')


% Tiempo de ejecucion
e = cputime - tc;

nombreOriginal = strcat(name, '.bmp');

FileInfo = dir(nombrecomp);
TO = FileInfo.bytes; % Longitud del fichero original.
% Esto es una buena jugada
FileInfo = dir(fname);
TC = FileInfo.bytes;

% Mostrar la(s) Relacion(es) de compresión.
RC = 100 * (TO - TC) / TO; % TASA (rate) de compresión.


% Test visual
if disptext
    % Reconstruida
    figure('Units', 'pixels', 'Position', [100, 100, n, m]);
    set(gca, 'Position', [0, 0, 1, 1]);
    image(Xrec);
    set(gcf, 'Name', 'Imagen reconstruida Xrec');

    % Original
    [Xoriginal, Xamp, tipo, m, n, mamp, namp, TO] = imlee(nombreOriginal);
    [m, n, p] = size(Xoriginal);
    figure('Units', 'pixels', 'Position', [100, 100, n, m]);
    set(gca, 'Position', [0, 0, 1, 1]);
    image(Xoriginal);
    set(gcf, 'Name', 'Imagen original X');
    fprintf('Terminado jdes_dflt\n ----------------\n');
    fprintf('%s %s\n', 'Archivo comprimido:', nombrecomp);
    fprintf('%s %d %s %d\n', 'Tamaño original =', TO, 'Tamaño comprimido =', TC);
    %fprintf('%s %d %s %d\n', 'Tamaño cabecera y codigo =', TCabecera, 'Tamaño datos=', TDatos);
    fprintf('%s %2.2f %s\n', 'RC archivo =', RC, '%.');
end
[Xoriginal, ~, ~, m, n, ~, ~, ~] = imlee(nombreOriginal);
MSE = (sum(sum(sum((double(Xrec) - double(Xoriginal)).^2)))) / (m * n * 3);
if disptext
    % Calculo de MSE
    fprintf('MSE : %f\n', MSE)
    fprintf('Descompresion terminadas');
    fprintf('%s %1.6f\n', 'Tiempo total de CPU:', e);

    fprintf('\n--------------------------------------------------');
end

end