function [MSEs,RCs] = practica_dflt()
% Instante inicial
tc=cputime;


fprintf("Con jcom_dflt\n");
factoresCalidad = [20,50,100,200,400,800];
ficheros = ["Img01","Img02","Img03","Img04","Img05","Img06","Img07"];
MSEs = zeros(6,7);
RCs = zeros(6,7);
img = 1;
for fic = ficheros
    calidad = 1;
    for c = factoresCalidad
        base = strcat(fic,".bmp");
        comp = strcat(fic,".hud");
        fprintf("Fichero %s Calidad %d  ",comp,c);
        [RC] = jcom_dflt(base,c);
        [MSE,~]=jdes_dflt(comp);
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

