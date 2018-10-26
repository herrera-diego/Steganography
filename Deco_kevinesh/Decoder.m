clear all;
%% User Inputs
audioFile = 'test.wav';


%% Audio Extraction
[yin,Fs] = audioread(audioFile);
%sound(y,Fs);

%% System Parameters


% Total Samples
totalSamples = size(yin,1);

% Number of segments
numSegments = 10000;

% Block Size
samplesSegment = ceil(totalSamples/numSegments);

%% Window
vin = mat2cell(yin(:,1),diff([0:samplesSegment:totalSamples-1,totalSamples]));


todelays = zeros(length(vin),1);

c = zeros(8,8);
charbin="";
metadaDecoded = "";
indx = 1;

for k = 1:length(vin)
  %% for each window
  vn = vin{k,1};
  rcc = AutoCorrelation(vn);
  figure();
  stem(rcc);
  v1 = rcc(50);
  v2 = rcc(65);
  
  %Decide if it its 1,0 or x
  bit = '';
  if(v1 > v2)
    bit = '0';
  else
    bit = '1';
  end
  
  charbin = strcat(charbin, bit);
   
  if(mod(k,8) == 0)
    a = bin2dec(charbin);
    c1 = char(a);
    if(a < 120)
      metadaDecoded = strcat(metadaDecoded, c1);
    end
    charbin="";
    indx =  indx +1;
  end
  

 
end
  
disp(metadaDecoded);
  
  
%% Combination
for i = 1:length(vin)
    %vn = vin{i,1};   
    %[xhat,delay] = cceps(vn);
    %stem(xhat);
    %todelays(i) = delay;
end

%stem(todelays);