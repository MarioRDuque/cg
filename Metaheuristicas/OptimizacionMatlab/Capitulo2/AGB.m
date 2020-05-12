%% ALGORITMO GENÉTICO BINARIO %%
function AGB
    clear all
    d=2;                % Número de dimensiones del problema
    u=pi; l=0;         % Límites del espacio de búsqueda - Rosenbrock
    maxk=1000;          % Número máximo de iteraciones
    %% Parametros:
    Np=100;              % Tamano de poblacion
    Nb=44;              % Numero de bits por dimension
    mutacion=0.2;       % Proporcion de mutacion
    cruza=0.9;
    k=0;                % Iteración actual
    %% Inicializar y evaluar población: 
    B = 2 .* rand(Np,Nb*d) - 1;   
    B = hardlim(B);               % Poblacion inicial, binaria
    R=[];                         % Poblacion inicial, real
    for ind = 1 : Np
        R=[R;DECOD(B(ind,1:Nb),l,u,Nb),DECOD(B(ind,Nb+1:Nb*2),l,u,Nb)];
    end
    [f, ind] = FUNCION(R, d, Np); % Rosenbrock
    minf(k+1)=f(1);
    B=B(ind,:); R=R(ind,:);
    %% Iteraciones:
    while k<maxk
        k=k+1;                  % Incrementa generacion 
        %% Seleccion de padres para cruza (Metodo de la ruleta):
        E=sum(-f);  %Ec 2.4
        E=-f./E;    %Ec 2.5
        q=[];
        for c=1:Np  %Ec 2.6
            q=[q;sum(E(1:c,1))];
        end
        E=q;    
        for c=1:Np
           padre1(c)=RULETA(E);
           padre2(c)=RULETA(E);
        end                
        %% Cruza de un punto:
        H=[];                               % Hijos
        for c=1:Np
            hijo1=[]; hijo2=[];
            if rand()<=cruza 
               ptCruce=floor(rand()*Nb*d);  % Obtener el punto de cruce
               hijo1=[B(padre1(c),1:ptCruce),B(padre2(c),ptCruce+1:end)];
               hijo2=[B(padre2(c),1:ptCruce),B(padre1(c),ptCruce+1:end)];
            end
            H=[H;hijo1;hijo2];
        end
        Hb=H;
        %% Mutacion:
        sizeH=size(H,1); Hm=rand(sizeH,Nb*d)<mutacion;
        for c=1:sizeH
            ind=find(Hm(c,:));
            H(c,ind)=~H(c,ind);
        end
        Hm=H;                   % Hijos mutados
        Hr=[];                  % Hijos en valor real
        for ind = 1 : sizeH
            Hr=[Hr;...
               DECOD(Hm(ind,1:Nb),l,u,Nb),DECOD(Hm(ind,Nb+1:Nb*2),l,u,Nb)];
        end
        H=[Hr;R];  Hb=[Hb;B];
        [Hf, ind] = FUNCION(H, d, Np+sizeH);
        minf(k)=f(1);
        %% Reselección:
        f=Hf(1:Np,1);           % Restaura fitness
        R=H(ind(1:Np),:);       % Restaura individuos en real
        B=Hb(ind(1:Np),:);      % Restaura individuos en binario
        disp(sprintf('generacion = %d, mejor fenotipo = %.8f' , k, f(1)));
    end
    plot(minf)                  % Convergencia
end