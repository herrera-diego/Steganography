% funcion de autocorrelacion 
function Rcc = AutoCorrelation(v)
  fourierV = fft(v);
  logaritmoF = log(fourierV);
  logCuadrado = (logaritmoF) .* (logaritmoF);
  iFourierLogCuadrado = ifft(logCuadrado);
  Rcc = abs(iFourierLogCuadrado);
end