function [MSE, RC] = jdes_custom(imgComprimida, imgOriginal)
    % Funci�n de descompresi�n: [MSE,RC]=jdes_custom(fComprimida)
    % o Se basa en la segunda mitad de la funci�n jcomdes (librer�a)
    % o Aplica tablas Huffman por frecuencia
    % o Lee un archivo comprimido *.hud
    % o Genera y almacena un archivo descomprimido *_des_cus.bmp
    % o Calcula y devuelve:
    % ? La relaci�n de compresi�n RC
    % ? El error cuadr�tico medio MSE
    % o Visualiza la imagen bitmap original y la descomprimida
    disptext = 0; % Flag de verbosidad

    if disptext
        disp('--------------------------------------------------');
        disp('Funcion jdes_custom:');
    end

    % Instante inicial
    tc = cputime;
    % Leemos la imagen
    % Orden m,n,mamp,namp,
    % caliQ,CodedY,CodedCb,CodedCr
    % BITS_Y_DC, HUFFVAL_Y_DC, ...
    % BITS_Y_AC, HUFFVAL_Y_AC, ...
    % BITS_C_DC, HUFFVAL_C_DC, ...
    % BITS_C_AC, HUFFVAL_C_AC
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

    % BITS_Y_DC, HUFFVAL_Y_DC, ...
    lenBITS_Y_DC = double(fread(fid, 1, 'uint8'));
    BITS_Y_DC = double(fread(fid, lenBITS_Y_DC, 'uint8'));
    lenHUFFVAL_Y_DC = double(fread(fid, 1, 'uint8'));
    HUFFVAL_Y_DC = double(fread(fid, lenHUFFVAL_Y_DC, 'uint8'));

    % BITS_Y_AC, HUFFVAL_Y_AC
    lenBITS_Y_AC = double(fread(fid, 1, 'uint8'));
    BITS_Y_AC = double(fread(fid, lenBITS_Y_AC, 'uint8'));
    lenHUFFVAL_Y_AC = double(fread(fid, 1, 'uint8'));
    HUFFVAL_Y_AC = double(fread(fid, lenHUFFVAL_Y_AC, 'uint8'));

    % BITS_C_DC, HUFFVAL_C_DC
    lenBITS_C_DC = double(fread(fid, 1, 'uint8'));
    BITS_C_DC = double(fread(fid, lenBITS_C_DC, 'uint8'));
    lenHUFFVAL_C_DC = double(fread(fid, 1, 'uint8'));
    HUFFVAL_C_DC = double(fread(fid, lenHUFFVAL_C_DC, 'uint8'));

    % BITS_C_AC, HUFFVAL_C_AC
    lenBITS_C_AC = double(fread(fid, 1, 'uint8'));
    BITS_C_AC = double(fread(fid, lenBITS_C_AC, 'uint8'));
    lenHUFFVAL_C_AC = double(fread(fid, 1, 'uint8'));
    HUFFVAL_C_AC = double(fread(fid, lenHUFFVAL_C_AC, 'uint8'));

    fclose(fid);

    % Pasamos de y x 8 a 1 x k
    % Convierte sbytesY a string binario codificado
    CodedY = bytes2bits(sbytesY, ultlY);
    % Convierte sbytesCb a string binario codificado
    CodedCb = bytes2bits(sbytesCb, ultlCb);
    % Convierte sbytesCb a string binario codificado
    CodedCr = bytes2bits(sbytesCr, ultlCr);

    % Decodifica los tres Scans a partir de strings binarios
    XScanrec = DecodeScans_custom(CodedY, CodedCb, CodedCr, ...
        [mamp, namp], ...
        BITS_Y_DC, HUFFVAL_Y_DC, ...
        BITS_Y_AC, HUFFVAL_Y_AC, ...
        BITS_C_DC, HUFFVAL_C_DC, ...
        BITS_C_AC, HUFFVAL_C_AC);
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

    % Repone el tama�o original
    Xrec = Xrec(1:m, 1:n, 1:3);
    % Genera nombre archivo descomprimido <nombre>_des.txt
    [~, name, ~] = fileparts(imgComprimida);
    nombreDescomp = strcat(name, '_des_cus', '.bmp');
    % Guarda archivo descomprimido
    imwrite(Xrec, nombreDescomp, 'bmp')

    % Tiempo de ejecucion
    e = cputime - tc;

    % Calculamos RC y MSE
    FileInfo = dir(imgComprimida);
    TC = FileInfo.bytes;
    [Xoriginal, ~, ~, m, n, ~, ~, TO] = imlee(imgOriginal);
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
        fprintf('Terminado jdes_custom\n ----------------\n');
        fprintf('%s %s\n', 'Imagen recuperada', nombreDescomp);
        fprintf('%s %d %s %d\n', 'Tamaño original =', TO, 'Tamaño comprimido =', TC);
        fprintf('%s %2.2f %s\n', 'RC archivo =', RC, '%.');
        fprintf('MSE : %f\n', MSE)
        fprintf('Descompresión terminadas');
        fprintf('%s %1.6f\n', 'Tiempo total de CPU:', e);
        fprintf('\n--------------------------------------------------');
    end

end
