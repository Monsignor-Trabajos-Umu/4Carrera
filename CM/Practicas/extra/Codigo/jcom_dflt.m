function [RC,NF] = jcom_dflt(fname, caliQ)

    % Entradas:
    %  fname: Un string con nombre de archivo, incluido sufijo
    %         Admite BMP y JPEG, indexado y truecolor
    %  caliQ: Factor de calidad (entero positivo >= 1)
    %         100: calidad estandar
    %         >100: menor calidad
    %         <100: mayor calidad
    % Salidas:
    %  RC. TASA (rate) de compresión.

    disptext = 0; % Flag de verbosidad

    if disptext
        disp('--------------------------------------------------');
        disp('Funcion jcom_dflt:');
    end

    % Instante inicial
    tc = cputime;

    % Lee archivo de imagen
    % Convierte a espacio de color YCbCr
    % Amplia dimensiones a multiplos de 8
    %  X: Matriz original de la imagen en espacio RGB
    %  Xamp: Matriz ampliada de la imagen en espacio YCbCr
    [X, Xamp, tipo, m, n, mamp, namp, TO] = imlee(fname);

    % Calcula DCT bidimensional en bloques de 8 x 8 pixeles
    Xtrans = imdct(Xamp);

    % Cuantizacion de coeficientes usando el factor de calidad caliQ
    Xlab = quantmat(Xtrans, caliQ);

    % Genera un scan por cada componente de color
    %  Cada scan es una matriz mamp x namp
    %  Cada bloque se reordena en zigzag 8x8
    XScan = scan(Xlab);

    % Codifica los tres scans, usando Huffman por defecto
    [CodedY, CodedCb, CodedCr] = EncodeScans_dflt(XScan);

    % Generamos el nombre para el archivo comprimido
    [pathstr, name, ext] = fileparts(fname);
    nombrecomp = strcat(name, '_', string(caliQ), '.hud');

    % Preparamos los datos
    % Orden m,n,mamp,namp,caliQ,CodedY,CodedCb,CodedCr

    % Numeros como uint32
    unm = uint32(m);
    unn = uint32(n);
    unmamp = uint32(mamp);
    unnamp = uint32(namp);
    uncaliQ = uint32(caliQ);

    % Para mayor compresion convertimos nuestros scans generados (1xk)
    % En una matriz yx8 sbytes* y ultl* son los ultimos datos
    % Es una especie de conversor de bit a bytes.
    [sbytesY, ultlY] = bits2bytes(CodedY);
    [sbytesCb, ultlCb] = bits2bytes(CodedCb);
    [sbytesCr, ultlCr] = bits2bytes(CodedCr);

    % CodedY
    ulensbytesY = uint32(length(sbytesY)); % Longitud de la matriz
    uultlY = uint8(ultlY); % Longitud de ultimo segmento de CodedY
    usbytesY = sbytesY; % Entrada comprimida y segmentada. (Ya en uint8)
    % CodedCb
    ulensbytesCb = uint32(length(sbytesCb)); % Longitud de matriz
    uultlCb = uint8(ultlCb); % Longitud de ultimo segmento de CodedCb
    usbytesCb = sbytesCb; % Entrada comprimida y segmentada. (Ya en uint8)
    %CodedCr
    ulensbytesCr = uint32(length(sbytesCr)); % Longitud de matriz
    uultlCr = uint8(ultlCr); % Longitud de ultimo segmento de CodedCr
    usbytesCr = sbytesCr; % Entrada comprimida y segmentada. (Ya en uint8)

    fid = fopen(nombrecomp, 'w');

    fwrite(fid, unm, 'uint32');
    fwrite(fid, unn, 'uint32');
    fwrite(fid, unmamp, 'uint32');
    fwrite(fid, unnamp, 'uint32');
    fwrite(fid, uncaliQ, 'uint32');

    fwrite(fid, ulensbytesY, 'uint32'); % Longitud de sbytesY.
    fwrite(fid, uultlY, 'uint8'); % Longitud de ultimo segmento de CodedY
    fwrite(fid, usbytesY, 'uint8'); % sbytesY ~= CodedY

    fwrite(fid, ulensbytesCb, 'uint32'); % Longitud de sbytesCb.
    fwrite(fid, uultlCb, 'uint8'); % Longitud de ultimo segmento de CodedCb
    fwrite(fid, usbytesCb, 'uint8'); % sbytesCb ~= CodedCb.

    fwrite(fid, ulensbytesCr, 'uint32'); % Longitud de sbytesCr.
    fwrite(fid, uultlCr, 'uint8'); % Longitud de ultimo segmento de CodedCr
    fwrite(fid, usbytesCr, 'uint8'); % sbytesCr ~= CodedCr

    fclose(fid);

    % Tiempo de ejecucion
    e = cputime - tc;

    FileInfo = dir(fname);
    TO = FileInfo.bytes; % Longitud del fichero original.
    % Esto es una buena jugada
    FileInfo = dir(nombrecomp);
    TC = FileInfo.bytes;

    % Mostrar la(s) Relacion(es) de compresi�n.
    RC = 100 * (TO - TC) / TO; % TASA (rate) de compresi�n.

    % NF es el nombre del fichero salida
    NF = nombrecomp;
    if disptext
        disp('-----------------');
        fprintf('%s %s\n', 'Archivo comprimido:', nombrecomp);
        fprintf('%s %d %s %d\n', 'Tamaño original =', TO, 'Tamaño comprimido =', TC);
        fprintf('%s %2.2f %s\n', 'RC archivo =', RC, '%.');
        disp('Compresion terminada');
        fprintf('%s %1.6f\n', 'Tiempo total de CPU:', e);
        disp('Terminado jcom_dflt');
        disp('--------------------------------------------------');
    end
