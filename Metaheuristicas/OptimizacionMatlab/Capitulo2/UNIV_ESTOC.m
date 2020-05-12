%% 
function indices = UNIV_ESTOC(V, Np)
   r=rand();
   s=0; 
   indices=[];
   for i=1:Np
      s=s+V(i);
      while s>r
          indices=[indices; i]; 
          r=r+1; 
      end
   end
end