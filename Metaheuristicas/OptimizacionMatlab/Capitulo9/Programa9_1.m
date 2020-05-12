%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo del algoritmo Evoluci�n Diferencial
% Erik Cuevas, Valent�n Osuna, Diego Oliva y Margarita D�az 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Programa9_1()
%Se define la funci�n a optimizar establecida en la ecuaci�n 9.5
%Funci�n Eggholder
func='((-1)*(y+47)*(sin(sqrt(abs(y+(x/2)+47)))))-(x*sin(sqrt(abs(x-(y+47)))))';    
f=vectorize(inline(func));
range=[-512 512 -512 512]; 
%Par�metros iniciales
d=2; %Dimensiones
Np=100; %Tama�o Poblaci�n
fuente_comida=round(Np/2); %Fuentes de Comida
gmax=150; %Generaciones M�ximas
limit=15; %Criterio de Abandono
Rango=range(2)-range(1);
%Poblaci�n inicial aleatoria
Poblacion = (rand(fuente_comida,d) * Rango) + range(1);
 
%Se dibuja la funci�n como referencia
Ndiv=100;
dx=Rango/Ndiv;
dy=dx;
[x,y]=meshgrid(range(1):dx:range(2),range(3):dy:range(4));
z=f(x,y);
figure, surfc(x,y,z);
figure, contour(x,y,z,15); 
%Calcula fitness de la funcion objetivo para la poblaci�n inicial
for ii=1:fuente_comida
    ValFit(ii)=f(Poblacion(ii,1),Poblacion(ii,2));
%Calcula fitness relativo
    Fitness(ii)=calculateFitness(ValFit(ii));      
end
    
%Se visualiza la poblaci�n inicial
figure, contour(x,y,z,15); hold on;
plot(Poblacion(:,1),Poblacion(:,2),'b.','markersize',15);
drawnow;
hold on;
    
%Inicializar contadores de prueba
prueba=zeros(1,fuente_comida);
%Se actualiza la posicion donde se encontr� la mejor fuente de comida    MejorInd=find(ValFit==min(ValFit));
MejorInd=MejorInd(end);
GlobalMin=ValFit(MejorInd);
GlobalParams=Poblacion(MejorInd,:);
g=0; %Contador de generaciones
while ((g < gmax))
%%%%%%%%%%%%Fase abeja obrera%%%%%%%%%%%%%
  for i=1:(fuente_comida)
     %Par�metro a modificar determinado aleatoriamente
      Param2Change=fix(rand*d)+1;
     %Se utiliza una soluci�n aleatoria para producir una nueva
     %soluci�n mutante, ambas deben ser diferentes
      vecino=fix(rand*(fuente_comida))+1;
      while(vecino==i)
         vecino=fix(rand*(fuente_comida))+1;
      end
      soluciones=Poblacion(i,:);      
    %Es aplicado: v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij})
    soluciones(Param2Change)=Poblacion(i,Param2Change)+(Poblacion(i,Param2Change)-Poblacion(vecino,Param2Change))*(rand-0.5)*2;
        
    %Si el valor del par�metro generado est� fuera de los l�mites,
    %es llevado al l�mite m�s pr�ximo
    ind=find(soluciones<range(1));
    soluciones(ind)=range(1);
    ind=find(soluciones>range(2));
    soluciones(ind)=range(2);    
    %Se eval�a la nueva soluci�n candidato
    ValFitSol=f(soluciones(1),soluciones(2));           
    FitnessSol=calculateFitness(ValFitSol);      
    %Se aplica un criterio de selecci�n Greedy entre la soluci�n
    %actual y la producida (mutante), se conserva la mejor entre ellas
    if (FitnessSol>Fitness(i)) 
       Poblacion(i,:)=soluciones;
       Fitness(i)=FitnessSol;
       ValFit(i)=ValFitSol;
        prueba(i)=0;
     else
        prueba(i)=prueba(i)+1; %Se incrementa el contador de prueba
     end
  end     
 %%%%%%%%%%%%Fin Fase Abeja Obrera%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
 %Se calculan probabilidades utilizando los valores de fitness normalizados
  probab=(0.9.*Fitness./max(Fitness))+0.1;
        
 %%%%%%%%%%%%%%%Fase Abeja Observadora%%%%%%%%%%%%%%%%
  i=1;
  t=0;
  while(t<fuente_comida)
    if(rand<probab(i))
    t=t+1;
    %El par�metro a modificar se selecciona aleatoriamente
    Param2Change=fix(rand*d)+1;
    %Es utilizada una soluci�n aleatoria para producir una nueva soluci�n  
    %candidato, deber�n ser diferentres entre s�
    vecino=fix(rand*(fuente_comida))+1;
    while(vecino==i)
      vecino=fix(rand*(fuente_comida))+1;
    end
    soluciones=Poblacion(i,:);
    %Se aplica: v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij})
              soluciones(Param2Change)=Poblacion(i,Param2Change)+(Poblacion(i,Param2Change)-Poblacion(vecino,Param2Change))*(rand-0.5)*2;
    %Si el par�metro generado est� fuera de los l�mites, es llevado al l�mite 
    %m�s pr�ximo
    ind=find(soluciones<range(1));
    soluciones(ind)=range(1);
    ind=find(soluciones>range(2));
    soluciones(ind)=range(2);
    %Se eval�a la nueva soluci�n candidato
    ValFitSol=f(soluciones(1),soluciones(2));              
    FitnessSol=calculateFitness(ValFitSol);
    %Se aplica un criterio de selecci�n Greedy entre la soluci�n actual y la
    %soluci�n candidato
    if (FitnessSol>Fitness(i)) 
        Poblacion(i,:)=soluciones;
        Fitness(i)=FitnessSol;
        ValFit(i)=ValFitSol;
        prueba(i)=0;
    else
        prueba(i)=prueba(i)+1; %Se incrementa el contador de prueba
    end
  end
  i=i+1;
  if (i==(fuente_comida)+1) 
     i=1;
  end
end
 %Se almacena la mejor fuente de comida
 ind=find(ValFit==min(ValFit));
 ind=ind(end);
 if (ValFit(ind)<GlobalMin)
    GlobalMin=ValFit(ind);
    GlobalParams=Poblacion(ind,:);
 end
%%%%%%%%%Fin de la Fase abeja observadora%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%Fase de la abeja exploradora%%%%%%%%%%%%%%%%%%
  %Se determinan las fuentes de comida cuyo valor de "l�mite" es alcanzado
  ind=find(prueba==max(prueba));
  ind=ind(end);
  if (prueba(ind)>limit)
     prueba(ind)=0;
     soluciones=(Rango).*rand(1,d)+range(1);
     ValFitSol=f(soluciones(1),soluciones(2));
     FitnessSol=calculateFitness(ValFitSol);
     Poblacion(ind,:)=soluciones;
     Fitness(ind)=FitnessSol;
     ValFit(ind)=ValFitSol;
  end
  g=g+1; %Se incrementa la iteraci�n
  clc
  %Se despliegan la posici�n y fitness del mejor individuo
  disp(GlobalMin)
  disp(GlobalParams)
 end
end
 
%Esta funci�n permite calcular el Fitness relativo
function fFitness=calculateFitness(fObjV)
    fFitness=zeros(size(fObjV));
    ind=find(fObjV>=0);
    fFitness(ind)=1./(fObjV(ind)+1);
    ind=find(fObjV<0);
    fFitness(ind)=1+abs(fObjV(ind));
end
