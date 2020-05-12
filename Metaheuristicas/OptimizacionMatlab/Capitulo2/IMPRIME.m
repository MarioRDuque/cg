[x,y] = meshgrid(-15:0.8:30,-15:0.8:30); %Ackley
%[x,y] = meshgrid(0:0.1:pi,0:0.1:pi); %Michalewics
z=[];
tam=size(x,1);
for ind=1:tam
   [f, ~] = FUNCION([x(:,ind),y(:,ind)], 2, tam); 
   z=[z,f]; 
end
surfc(x,y,z)