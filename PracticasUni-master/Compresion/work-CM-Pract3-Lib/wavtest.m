function wavtest(fname)
% Lea un archivo WAV, cuyo nombre ‘<file>.wav’ se da como argumento fname
[y,Fs] = audioread(fname); 
%Lo reproduzca tres veces: a velocidad normal, más lenta y más rápida 
% Normal
% sound(y,Fs) 
% lenta
% sound(y,Fs/2) 
% rapida
% sound(y,Fs*2) 


% Numero de canales
[lon canales]=size(y); 
n=(0:lon-1)'; t=n/Fs;
figure;plot(t,y(:,1));
xlabel('t (s)'); ylabel('y (V)');
set(gca,'XGrid','on', 'YGrid','on','GridLineStyle',':');
title('Senal Audio hceste.wav x(t) canal 1'); 

figure;plot(t,y(:,1));
xlabel('t (s)'); ylabel('y (V)');
set(gca,'XGrid','on', 'YGrid','on','GridLineStyle',':');
title('Senal Audio hceste.wav x(t) canal 2'); 


% Lo convierta a formato monoaural, promediando los distintos canales
Mono = (y(:,1)+y(:,2))/2;
sound(Mono,Fs) 
% Almacene los 5 primeros segundos de señal del sonido mono en otro archivo llamado ‘<file>short.wav’ 
end