%% DECODIFICA CADENAS DE BITS %%
% Tamano de paso: ((u - l) / t3)
function r = DECOD(B,l,u,Nb)
    % r:    valor real
    % B:    cadena binaria de Nb bits
    % Nb:   numero de bits de la cadena binaria
    % l:    limite inferior del espacio de busqueda
    % u:    limite superior del espacio de busqueda
    B = fliplr(B);
    t1=(Nb-1):-1:0;
    t2=ones(1,Nb);          % Numero binario maximo a obtener
    t3=sum((t2.*2.^t1)')+1; % Numero de posibles valores reales
    t2=sum((B.*2.^t1)');    % Numero real del individuo
    r =  l + t2 .* ((u - l) / t3);  % Aplicar limites del espacio de busque
end