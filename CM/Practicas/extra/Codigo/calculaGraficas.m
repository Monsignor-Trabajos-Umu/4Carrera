function [MSeesD, RCeesD, MSeesC, RCeesC] = calculaGraficas()

    ficheros = ["C0099.bmp", "C0100.bmp", ...
                "C0149.bmp", "C0152.bmp", ...
                "C0401.bmp", "C0837.bmp"];
    calidades = [0, 50, 100, 150, 200, 500];
    

    for f = ficheros
        
        MSeesD = [];
        RCeesD = [];

        MSeesC = [];
        RCeesC = [];
        fichero = strcat("imagenes/",f);
        fprintf('Fichero %s\n', fichero)
        [~, name, ~] = fileparts(fichero);
        for calidad = calidades
            % Default
            fprintf('Default %i\n', calidad)
            [~, NF_D] = jcom_dflt(fichero, calidad);

            [MSE_D, RC_D] = jdes_dflt(NF_D, fichero);
            RCeesD = [RCeesD RC_D];
            MSeesD = [MSeesD MSE_D];
            fprintf('Default MSE = %.2f RC = %.2f \n', MSE_D, RC_D);

            % CUSTOM
            [~, NF_C] = jcom_custom(fichero, calidad);
            [MSE_C, RC_C] = jdes_custom(NF_C, fichero);
            RCeesC = [RCeesC RC_C];
            MSeesC = [MSeesC MSE_C];
            fprintf('Custom MSE = %.2f RC = %.2f \n', MSE_C, RC_C);

        end

        titutlo = strcat('MSE vs RC para Img ', f);
        figure
        x1 = RCeesD;
        y1 = MSeesD;

        x2 = RCeesC;
        y2 = MSeesC;

        semilogy(x1, y1, '--', x2, y2)
        legend('Matlab Default', 'Matlab custom', 'Location', 'northwest')
        title(titutlo)
        subtitle('Factores de calidad 0 50 100 150 200 500')
        xlabel('RC(%)')
        ylabel('MSE')
        hgsave(name);
    end

end
