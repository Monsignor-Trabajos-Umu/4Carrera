function [mse,dmaxdifer]=testdct(filename)
% Entradas:
% fname: Un string con nombre de archivo, incluido sufijo
% Salidas:
% mse: Error cuadratico medio entre matrices original y reconstruida
% dmaxdifer: Maxima diferencia entre pixeles homologos 
[X, Xamp, tipo, m, n, mamp, namp, TO] = imlee(filename);
Xtrans = imdct(Xamp);
Xamprec = imidct(Xtrans,m,n);
[Xrec, nombrecomp] = imescribe(Xamprec,m,n,filename);
% Calculo de MSE
mse=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3); 
% Test de valor de diferencias double
ddifer=abs(double(Xrec)-double(X));
dmaxdifer=max(max(max(ddifer)));
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

fprintf('MSE : %f\n',mse)
fprintf('Dmaxdifer : %f\n',dmaxdifer)
end