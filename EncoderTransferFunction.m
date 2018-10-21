function H = EncoderTransferFunction(a, t)
  H=zeros(t, 1);
  H(1)=1;
  H(t)=a;
end