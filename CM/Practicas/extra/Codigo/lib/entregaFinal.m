function entregaFinal()
dfactoresCalidad = [0,20,50,75,100,200,400,800,1000];
ficheros = ["ImgP00","ImgP01","ImgP02","ImgM00","ImgM01","ImgG00","ImgG01","ImgG02","ImgM02","ImgGG00"];
[MSEs_custom,RCs_custom] = practica_custom(ficheros,dfactoresCalidad);
[MSEs_dflt,RCs_dflt] = practica_dflt(ficheros,dfactoresCalidad);

fprintf("Las graficas custom vs dflt")

for imagen = 1:7
    NombreImgane = ficheros(imagen);
    f = figure('name',NombreImgane);
    hold on
    x_custom = RCs_custom(:,imagen);
    y_custom = log10(MSEs_custom(:,imagen));
   
    x_dflt = RCs_dflt(:,imagen);
    y_dflt = log10(MSEs_dflt(:,imagen)); 
    
    semilogy(x_custom, y_custom,'-*')
    semilogy(x_dflt, y_dflt,'-*')
    
    
    titulo = strcat("Graficas para -> " , NombreImgane);
    title(titulo);
    xlabel('RC(%)')
    ylabel('log10 MSE');
    legend('custom','dflt')
    
    nombre = strcat(NombreImgane,'_plot');
    saveas(f, nombre, "fig");
end;
end
