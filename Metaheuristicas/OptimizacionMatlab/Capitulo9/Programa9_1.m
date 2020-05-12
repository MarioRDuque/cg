%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo del algoritmo Evolución Diferencial
% Erik Cuevas, Valentín Osuna, Diego Oliva y Margarita Díaz 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Programa9_1()
%Se define la función a optimizar establecida en la ecuación 9.5
%Función Eggholder
func='((-1)*(y+47)*(sin(sqrt(abs(y+(x/2)+47)))))-(x*sin(sqrt(abs(x-(y+47)))))';    
f=vectorize(inline(func));
range=[-512 512 -512 512]; 
%Parámetros iniciales
d=2; %Dimensiones
Np=100; %Tamaño Población
fuente_comida=round(Np/2); %Fuentes de Comida
gmax=150; %Generaciones Máximas
limit=15; %Criterio de Abandono
Rango=range(2)-range(1);
%Población inicial aleatoria
Poblacion = (rand(fuente_comida,d) * Rango) + range(1);
 
%Se dibuja la función como referencia
Ndiv=100;
dx=Rango/Ndiv;
dy=dx;
[x,y]=meshgrid(range(1):dx:range(2),range(3):dy:range(4));
z=f(x,y);
figure, surfc(x,y,z);
figure, contour(x,y,z,15); 
%Calcula fitness de la funcion objetivo para la población inicial
for ii=1:fuente_comida
    ValFit(ii)=f(Poblacion(ii,1),Poblacion(ii,2));
%Calcula fitness relativo
    Fitness(ii)=calculateFitness(ValFit(ii));      
end
    
%Se visualiza la población inicial
figure, contour(x,y,z,15); hold on;
plot(Poblacion(:,1),Poblacion(:,2),'b.','markersize',15);
drawnow;
hold on;
    
%Inicializar contadores de prueba
prueba=zeros(1,fuente_comida);
%Se actualiza la posicion donde se encontró la mejor fuente de comida    MejorInd=find(ValFit==min(ValFit));
MejorInd=MejorInd(end);
GlobalMin=ValFit(MejorInd);
GlobalParams=Poblacion(MejorInd,:);
g=0; %Contador de generaciones
while ((g < gmax))
%%%%%%%%%%%%Fase abeja obrera%%%%%%%%%%%%%
  for i=1:(fuente_comida)
     %Parámetro a modificar determinado aleatoriamente
      Param2Change=fix(rand*d)+1;
     %Se utiliza una solución aleatoria para producir una nueva
     %solución mutante, ambas deben ser diferentes
      vecino=fix(rand*(fuente_comida))+1;
      while(vecino==i)
         vecino=fix(rand*(fuente_comida))+1;
      end
      soluciones=Poblacion(i,:);      
    %Es aplicado: v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij})
    soluciones(Param2Change)=Poblacion(i,Param2Change)+(Poblacion(i,Param2Change)-Poblacion(vecino,Param2Change))*(rand-0.5)*2;
        
    %Si el valor del parámetro generado está fuera de los límites,
    %es llevado al límite más próximo
    ind=find(soluciones<range(1));
    soluciones(ind)=range(1);
    ind=find(soluciones>range(2));
    soluciones(ind)=range(2);    
    %Se evalúa la nueva solución candidato
    ValFitSol=f(soluciones(1),soluciones(2));           
    FitnessSol=calculateFitness(ValFitSol);      
    %Se aplica un criterio de selección Greedy entre la solución
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
    %El parámetro a modificar se selecciona aleatoriamente
    Param2Change=fix(rand*d)+1;
    %Es utilizada una solución aleatoria para producir una nueva solución  
    %candidato, deberán ser diferentres entre sí
    vecino=fix(rand*(fuente_comida))+1;
    while(vecino==i)
      vecino=fix(rand*(fuente_comida))+1;
    end
    soluciones=Poblacion(i,:);
    %Se aplica: v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij})
              soluciones(Param2Change)=Poblacion(i,Param2Change)+(Poblacion(i,Param2Change)-Poblacion(vecino,Param2Change))*(rand-0.5)*2;
    %Si el parámetro generado está fuera de los límites, es llevado al límite 
    %más próximo
    ind=find(soluciones<range(1));
    soluciones(ind)=range(1);
    ind=find(soluciones>range(2));
    soluciones(ind)=range(2);
    %Se evalúa la nueva solución candidato
    ValFitSol=f(soluciones(1),soluciones(2));              
    FitnessSol=calculateFitness(ValFitSol);
    %Se aplica un criterio de selección Greedy entre la solución actual y la
    %solución candidato
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
  %Se determinan las fuentes de comida cuyo valor de "límite" es alcanzado
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
  g=g+1; %Se incrementa la iteración
  clc
  %Se despliegan la posición y fitness del mejor individuo
  disp(GlobalMin)
  disp(GlobalParams)
 end
end
 
%Esta función permite calcular el Fitness relativo
function fFitness=calculateFitness(fObjV)
    fFitness=zeros(size(fObjV));
    ind=find(fObjV>=0);
    fFitness(ind)=1./(fObjV(ind)+1);
    ind=find(fObjV<0);
    fFitness(ind)=1+abs(fObjV(ind));
end
