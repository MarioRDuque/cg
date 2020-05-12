function [temp, ind] = FUNCION(x, d, N) 

y=[];
% Funcion de Rosenbrock
% for i=1:N
%     sum=0;
%     for j = 1:d-1;
%         sum = sum+100*(x(i,j)^2-x(i,j+1))^2+(x(i,j)-1)^2;
%     end
%     y(i,1) = sum;
% end
% temp=y; ind=j;

% Six hump camel back
% for i=1:N
%     y(i,1)=4*x(i,1)^2-2.1*x(i,1)^4+(1/3)*x(i,1)^6+x(i,1)*x(i,2)-4*x(i,2)^2+4*x(i,2)^4;
% end

% % Griewank
% fr = 4000;
% for i=1:N    
%     s = 0;
%     p = 1;
%     for j = 1:d; s = s+x(i,j)^2; end
%     for j = 1:d; p = p*cos(x(i,j)/sqrt(j)); end
%     y(i,1) = s/fr-p+1;
% end
% temp=y; ind=i;   %Para poder imprimir, descomentar esta linea
% %[temp,ind]=sort(y); %Para optimizar, descomentar esta linea
% 
% Flabio1
% Obtener los valores de la funcion f(x1,x2) = x1+ x2^2
% for j=1:N    
%      y(j,1)= x(j,1)+x(j,2)^2;
% end

% Flabio2
% Obtener los valores de la funcion f(x1,x2) = x1+ x2^2
for j=1:N    
       y(j,1)= 21.5 + x(j,1)*sin(4*pi*x(j,1))+ x(j,2)*sin(20*pi*x(j,2));
     % y(j,1)= -21.5 - x(j,1)*sin(4*pi*x(j,1))-x(j,2)*sin(20*pi*x(j,2));
end

% Ackley
% for j=1:N    
%     a = 20; b = 0.2; c = 2*pi;
%     s1 = 0; s2 = 0;
%     for i=1:d;
%         s1 = s1+x(j,i)^2;
%         s2 = s2+cos(c*x(j,i));
%     end
% y(j,1) = -a*exp(-b*sqrt(1/d*s1))-exp(1/d*s2)+a+exp(1);
% end

% % Michalewikz:
% for j=1:N
%    m = 10;
%    s = 0;
%    for i = 1:d
%        s = s+sin(x(j,i))*(sin(i*x(j,i)^2/pi))^(2*m);
%    end
%    y(j,1) = -s; 
% end
%temp=y; ind=i;   %Para poder imprimir, descomentar esta linea
[temp,ind]=sort(y); %Para optimizar, descomentar esta linea