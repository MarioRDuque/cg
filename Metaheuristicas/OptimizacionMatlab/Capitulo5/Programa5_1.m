%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo del algoritmo Evoluci�n Diferencial
% Erik Cuevas, Valent�n Osuna, Diego Oliva y Margarita D�az 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Limpiar memoria
clear all
%Se define la funci�n a optimizar formulada en 2.13
funstr='(-1)*((sin(x)*(sin((1*x^2)/pi))^(2*10))+(sin(y)*(sin((2*y^2)/pi))^(2*10)))';
f=vectorize(inline(funstr));
range=[0 pi 0 pi];
%Se dibuja la funci�n como referencia
Ndiv=50;
dx=(range(2)-range(1))/Ndiv; dy=(range(4)-range(3))/Ndiv;
[x,y] =meshgrid(range(1):dx:range(2),range(3):dy:range(4));
z=(f(x,y));
figure(1);   surfc(x,y,z);
%Se define el n�mero de iteraciones
g=0;
gmax=150;
%Se establece el factor de escalamiento F
F=0.8;
%Se establecen los valores de CR (para el cruce) y M (Mutaci�n)
CR=0.8;
M=1-CR;
%Se determina el n�mero de inviduos (Poblaci�n)
NP=50;
%Se determinan las dimensiones del problema
d=2;
%Generacion del punto inicial
xrange=range(2)-range(1);
yrange=range(4)-range(3);
%Se reserva espacio para almacenar la poblaci�n inicial y con su Fitness 
poblaF=zeros(NP,d); 
pobla = zeros(NP,d);
%Se genera la poblaci�n inicial
        for ii=1:NP
%Inicializar poblaci�n, con valores aleatorios entre los l�mites del espacio de %b�squeda
        pobla(ii,:) = range(1) + rand(1,d).*(range(2) - range(1));
%Se obtiene el valor del fitness en la funci�n objetivo
        poblaF(ii,d+1)=f(pobla(ii,1),pobla(ii,2));
    end
    poblaF(:,1:d)=pobla(:,1:d);
%Se almacena el mejor individuo
    Memoria=sortrows(poblaF,d+1);
    Mejor=Memoria(1,:);
%Se Visualiza la poblaci�n inicial
    figure(2)
    contour(x,y,z,15); hold on;    
  plot(poblaF(:,1),poblaF(:,2), '.','markersize',10,'markerfacecolor','g');
  drawnow;
  hold on;
%Se establece el proceso iterativo de optimizaci�n
while (g<gmax)
    for jj=1:NP
%Proceso de Mutaci�n
    m=rand();
    if m<=M %Solo si se cumple la probabilidad de Mutaci�n
%Se modifican los �ndices de la poblaci�n de forma aleatoria
        al=randperm(NP);          
%Se toman los �ndice de selecci�n para los individuos aleatorios
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
%Si no se cumple la probabilidad de mutaci�n se conserva el individuo original
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
%Proceso de Selecci�n Greedy
    if ui(1,d+1)<poblaF(jj,d+1)
        poblaF(jj,:)=ui(1,:);
    end  
  end
%Actualizar el mejor
    Mem=sortrows(poblaF,d+1);
    Mejor=Mem(1,:);
    g=g+1; %Se incrementa la iteraci�n
end

