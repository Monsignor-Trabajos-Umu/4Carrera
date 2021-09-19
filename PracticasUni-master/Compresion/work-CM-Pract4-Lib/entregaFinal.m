function entregaFinal()
[MSEs_custom,RCs_custom] = practica_custom();
[MSEs_dflt,RCs_dflt] = practica_dflt();

fprintf("Las graficas custom vs dflt")

%                                       dfactoresCalidad = [20,50,100,200,400,800];
ficheros = ["Img01","Img02","Img03","Img04","Img05","Img06","Img07"];

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
