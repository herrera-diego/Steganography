clear all;
%% User Inputs
audioFile = 'AudioDePrueba.wav';
audioFileOut = 'test.wav';
title = "CanonRock";
%artist = "JerryC";
%album = "None";
userInputs = title;
%userInputs = [title; artist; album];

%% Audio Extraction
[y,Fs] = audioread(audioFile);
%sound(y,Fs);

%% System Parameters

% Total Samples
totalSamples = size(y,1);

% Number of segments
numSegments = 1000;

% Block Size
samplesSegment = ceil(totalSamples/numSegments);

%% Window
v = mat2cell(y(:,1),diff([0:samplesSegment:totalSamples-1,totalSamples]));
vo = v;

tdelays = zeros(length(v),1);
index = 1;

for i = 1:length(userInputs)
    
    metadata = char(userInputs(i));

    for j = 1:length(metadata)

        charEncoded = typecast(double(metadata(j)), 'uint8');
        charBin = dec2bin(charEncoded,8);

        for k = 1:numel(charBin)  
            %% Mux
            vn = v{index,1};   
            thisBit = char(charBin(k));
            if(thisBit == '1')
                %H1(z)
                t = 2;
                a = 0.05;            
            else
                %H0(z)
                t = 5;
                a = 0.001;           
            end
            tdelays(index) = t;
            %% Combination
             h = EncoderTransferFunction(a,t);
             yk = conv(vn,h);
             vo{index,1} = yk;
             % test = conv2olam(vn,h);
             index = index + 1;
        end      
    end    
end

 yo = OverlapAdd(vo,length(v{1,1}));

%% Audio Export
outSig = cell2mat(yo);
ys=[outSig , y(:,2)];
audiowrite(audioFileOut,ys,Fs);



[yTest,FsTest] = audioread(audioFileOut);
sound(yTest,FsTest);
