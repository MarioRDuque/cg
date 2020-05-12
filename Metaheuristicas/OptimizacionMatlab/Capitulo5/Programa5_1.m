%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo del algoritmo Evolución Diferencial
% Erik Cuevas, Valentín Osuna, Diego Oliva y Margarita Díaz 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Limpiar memoria
clear all
%Se define la función a optimizar formulada en 2.13
funstr='(-1)*((sin(x)*(sin((1*x^2)/pi))^(2*10))+(sin(y)*(sin((2*y^2)/pi))^(2*10)))';
f=vectorize(inline(funstr));
range=[0 pi 0 pi];
%Se dibuja la función como referencia
Ndiv=50;
dx=(range(2)-range(1))/Ndiv; dy=(range(4)-range(3))/Ndiv;
[x,y] =meshgrid(range(1):dx:range(2),range(3):dy:range(4));
z=(f(x,y));
figure(1);   surfc(x,y,z);
%Se define el número de iteraciones
g=0;
gmax=150;
%Se establece el factor de escalamiento F
F=0.8;
%Se establecen los valores de CR (para el cruce) y M (Mutación)
CR=0.8;
M=1-CR;
%Se determina el número de inviduos (Población)
NP=50;
%Se determinan las dimensiones del problema
d=2;
%Generacion del punto inicial
xrange=range(2)-range(1);
yrange=range(4)-range(3);
%Se reserva espacio para almacenar la población inicial y con su Fitness 
poblaF=zeros(NP,d); 
pobla = zeros(NP,d);
%Se genera la población inicial
        for ii=1:NP
%Inicializar población, con valores aleatorios entre los límites del espacio de %búsqueda
        pobla(ii,:) = range(1) + rand(1,d).*(range(2) - range(1));
%Se obtiene el valor del fitness en la función objetivo
        poblaF(ii,d+1)=f(pobla(ii,1),pobla(ii,2));
    end
    poblaF(:,1:d)=pobla(:,1:d);
%Se almacena el mejor individuo
    Memoria=sortrows(poblaF,d+1);
    Mejor=Memoria(1,:);
%Se Visualiza la población inicial
    figure(2)
    contour(x,y,z,15); hold on;    
  plot(poblaF(:,1),poblaF(:,2), '.','markersize',10,'markerfacecolor','g');
  drawnow;
  hold on;
%Se establece el proceso iterativo de optimización
while (g<gmax)
    for jj=1:NP
%Proceso de Mutación
    m=rand();
    if m<=M %Solo si se cumple la probabilidad de Mutación
%Se modifican los índices de la población de forma aleatoria
        al=randperm(NP);          
%Se toman los índice de selección para los individuos aleatorios
        a1=al(1);  
        a2=al(2);  
        a3=al(3);  
%Se seleccionan las posiciones para los individuos aleatorios
        r1(1,:)=poblaF(a1,1:d);             
        r2(1,:) =poblaF(a2,1:d);       
        r3(1,:)=poblaF(a3,1:d);

%Estrategia Random-to-Random
        vi=r3+F*(r1-r2);
        
%Se obtiene el Fitness del individuo mutado
        viF(1,d+1)=f(vi(1),vi(2));
        viF(1,1:d)=vi(1,:);
%Si no se cumple la probabilidad de mutación se conserva el individuo original
    else 
        viF(1,:)=poblaF(jj,:);
    end
    
%Proceso de Cruce
    cr=rand();
    if cr<=CR %Solo si se cumple la probabilidad de Cruce
        ui=viF;
%Si no se cumple con CR, se conserva el individuo previo
    else
        ui=poblaF(jj,:);   
    end      
%Proceso de Selección Greedy
    if ui(1,d+1)<poblaF(jj,d+1)
        poblaF(jj,:)=ui(1,:);
    end  
  end
%Actualizar el mejor
    Mem=sortrows(poblaF,d+1);
    Mejor=Mem(1,:);
    g=g+1; %Se incrementa la iteración
end

