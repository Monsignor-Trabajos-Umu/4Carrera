function [MSE, RC] = jdes_dflt(imgComprimida, imgOriginal)
    % Función de descompresión: [MSE,RC]=jdes_dflt(imgComprimida,imgOriginal)
    % Se basa en la segunda mitad de la función jcomdes (librer�a)
    % Aplica tablas Huffman por defecto
    % Lee un archivo comprimido *.hud
    % Genera y almacena un archivo descomprimido *_des_def.bmp
    % Calcula y devuelve:
    % La relación de compresión RC
    % El error cuadrático medio MSE
    % o Visualiza la imagen bitmap original y la descomprimida
    disptext = 0; % Flag de verbosidad

    if disptext
        disp('--------------------------------------------------');
        disp('Funcion jdes_dflt:');
    end

    % Instante inicial
    tc = cputime;
    % Leemos la imagen
    % Orden m,n,mamp,namp,caliQ,CodedY,CodedCb,CodedCr
    fid = fopen(imgComprimida, 'r');
    m = double(fread(fid, 1, 'uint32'));
    n = double(fread(fid, 1, 'uint32'));

    mamp = double(fread(fid, 1, 'uint32'));
    namp = double(fread(fid, 1, 'uint32'));
    caliQ = double(fread(fid, 1, 'uint32'));

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

    % Pasamos de y x 8 a 1 x k
    % Convierte sbytesY a string binario codificado
    CodedY = bytes2bits(sbytesY, ultlY);
    % Convierte sbytesCb a string binario codificado
    CodedCb = bytes2bits(sbytesCb, ultlCb);
    % Convierte sbytesCb a string binario codificado
    CodedCr = bytes2bits(sbytesCr, ultlCr);

    % Decodifica los tres Scans a partir de strings binarios
    XScanrec = DecodeScans_dflt(CodedY, CodedCb, CodedCr, [mamp, namp]);

    % Recupera matrices de etiquetas en orden natural
    %  a partir de orden zigzag
    Xlabrec = invscan(XScanrec);

    % Descuantizacion de etiquetas
    Xtransrec = desquantmat(Xlabrec, caliQ);

    % Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
    % Como resultado, reconstruye una imagen YCbCr con tama�o ampliado
    Xamprec = imidct(Xtransrec, m, n);

    % Convierte a espacio de color RGB
    % Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
    Xrecrd = round(ycbcr2rgb(Xamprec / 255) * 255);
    Xrec = uint8(Xrecrd);

    % Repone el tamaño original
    Xrec = Xrec(1:m, 1:n, 1:3);

    % Genera nombre archivo descomprimido <nombre>_des.txt
    [pathstr, name, ext] = fileparts(imgComprimida);
    nombreDescomp = strcat(name, '_des_def', '.bmp');
    % Guarda archivo descomprimido
    imwrite(Xrec, nombreDescomp, 'bmp')

    % Tiempo de ejecucion
    e = cputime - tc;

    % Calculamos RC y MSE
    FileInfo = dir(imgComprimida);
    TC = FileInfo.bytes;
    [Xoriginal, Xamp, tipo, m, n, mamp, namp, TO] = imlee(imgOriginal);
    RC = 100 * (TO - TC) / TO; % TASA (rate) de compresión.
    MSE = (sum(sum(sum((double(Xrec) - double(Xoriginal)).^2)))) / (m * n * 3);
    % Test visual

    if disptext
        % Reconstruida
        figure('Units', 'pixels', 'Position', [100, 100, n, m]);
        set(gca, 'Position', [0, 0, 1, 1]);
        image(Xrec);
        set(gcf, 'Name', 'Imagen reconstruida Xrec');

        % Original

        [m, n, p] = size(Xoriginal);
        figure('Units', 'pixels', 'Position', [100, 100, n, m]);
        set(gca, 'Position', [0, 0, 1, 1]);
        image(Xoriginal);
        set(gcf, 'Name', 'Imagen original X');

    end

    if disptext
        fprintf('Terminado jdes_dflt\n ----------------\n');
        fprintf('%s %s\n', 'Imagen recuperada', nombreDescomp);
        fprintf('%s %d %s %d\n', 'Tamaño original =', TO, 'Tamaño comprimido =', TC);
        fprintf('%s %2.2f %s\n', 'RC archivo =', RC, '%.');
        fprintf('MSE : %f\n', MSE)
        fprintf('Descompresión terminadas');
        fprintf('%s %1.6f\n', 'Tiempo total de CPU:', e);
        fprintf('\n--------------------------------------------------');
    end

end
