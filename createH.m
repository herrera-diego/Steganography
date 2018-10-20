function H = createH(a, t)
  %H = [1,[zeros(t-1, 1); 1]*a];
  %H = cat(1,1,[zeros(t-1, 1); 1]*a);
  H=zeros(t, 1);
  H(1)=1;
  H(t)=a;
  %H = [zeros(t-1, 1); 1]*a;
 
end