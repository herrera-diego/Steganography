clear all;
%% User Inputs
userInputs = ["user inputs: ";];

audioFile = 'test.wav';
%end of input

%end of input
eoi = '\+/';

%end of data, indicates to stop decoding.
eod = '\*/';

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
  %if(all(vn ~= 0))
      %% for each window
      rcc = AutoCorrelation(vn);
      %figure();
      %stem(rcc);
      v1 = rcc(50);
      v2 = rcc(65);

      %% Decide if it its 1,0 or x
      bit = '';
      if(v1 > v2)
        bit = '0';
      else
        bit = '1';
      end

      %% concatenate each character
      charbin = strcat(charbin, bit);

      %% 8 bits
      if(mod(k,8) == 0)
        charDec = bin2dec(charbin);
        charDecoded = char(charDec);
        if(charDec == 32)
            charDecoded = {' '}; 
        end
        %% spanish english ascii characters
        if(charDec > 31 && charDec < 123)
          metadaDecoded = strcat(metadaDecoded, charDecoded);
        end
        charbin="";
        indx =  indx +1;
      end

      %% split each input
      if(contains(metadaDecoded,eoi)== true)
          metadaDecoded = erase(metadaDecoded, eoi);
          userInputs(length(userInputs)+1) = metadaDecoded;
          metadaDecoded = '';
      end

      %% end of decoding
      if(contains(metadaDecoded,eod)== true)
          metadaDecoded = erase(metadaDecoded, eod);
          break;
      end  
  %end
end

%% Print the metadata decoded
for i = 1:length(userInputs)
    disp(userInputs(i));
end
