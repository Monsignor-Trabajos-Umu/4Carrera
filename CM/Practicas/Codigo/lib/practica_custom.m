function [MSEs,RCs] = practica_custom(ficheros,dfactoresCalidad)
% Entradas:
%  ficheros: Un array con los nombres de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
%  dfactoresCalidad: Array con los factores de calidad (entero positivo >= 1)
%               100: calidad estandar
%              >100: menor calidad
%              <100: mayor calidad
% Salidas:
% RC. TASA (rate) de compresión.
% MSE. El error cuadrático medio MSE
% Instante inicial
tc=cputime;


fprintf("Con jcom_custom\n");
factoresCalidad = dfactoresCalidad;
%ficheros = ["Img01","Img02","Img03","Img04","Img05","Img06","Img07"];
MSEs = zeros(6,7);
RCs = zeros(6,7);
img = 1;
for fic = ficheros
    calidad = 1;
    for c = factoresCalidad
        base = strcat(fic,".bmp");
        comp = strcat(fic,".hud");
        fprintf("Fichero %s Calidad %d  ",comp,c);
        [RC] = jcom_custom(base,c);
        [MSE,~]=jdes_custom(comp);
        fprintf("MSE = %u RC = %u\n",MSE,RC);
        MSEs(calidad,img) = MSE;
        RCs(calidad,img) = RC;
        calidad = calidad + 1;
    end
    img = img + 1;
end

% Tiempo de ejecucion
e=cputime-tc;

fprintf('%s %1.6f\n', 'Tiempo total de CPU:', e);

