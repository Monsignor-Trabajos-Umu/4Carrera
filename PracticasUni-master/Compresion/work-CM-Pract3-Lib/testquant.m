function [mse,dmaxdifer]=testquant(fname,caliQ)
% Entradas:
% fname: Un string con nombre de archivo, incluido sufijo
% Admite BMP y JPEG, indexado y truecolor
% caliQ: Factor de calidad (entero positivo >= 1)
% Salidas:
% mse: Error cuadratico medio entre la matriz original y la matriz reconstruida
% dmaxdifer: Maxima diferencia entre pixeles homologos 

[X, Xamp, tipo, m, n, mamp, namp, TO] = imlee(fname);
%Calcula DCT bidimensional en bloques de 8 x 8 pixeles
Xtrans = imdct(Xamp);
%cuantizamos
Xlab = quantmat(Xtrans,caliQ);
%Des cuantizamos
Xtransrec = desquantmat(Xlab,caliQ);
% Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
% Reconstruye una imagen YCbCr con tamaño ampliado
Xamprec = imidct(Xtransrec,m,n);
%Guardamos la imagen
%Xrec: Matriz de imagen original reconstruida en RGB en formato truecolor (uint8)
[Xrec, nombrecomp] = imescribe(Xamprec,m,n,fname);

%Tes visual
[m,n,p] = size(X);
figure('Units','pixels','Position',[100 100 n m]);
set(gca,'Position',[0 0 1 1]);
image(X);
set(gcf,'Name','Imagen original X');
figure('Units','pixels','Position',[100 100 n m]);
set(gca,'Position',[0 0 1 1]);
image(Xrec);
set(gcf,'Name','Imagen reconstruida Xrec');


% Calculo de MSE
mse=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3); 

% Test de valor de diferencias double
ddifer=abs(double(Xrec)-double(X));
dmaxdifer=max(max(max(ddifer)));

fprintf('MSE : %f\n',mse)
fprintf('Dmaxdifer : %f\n',dmaxdifer)
end