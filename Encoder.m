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
numSegments = 10000;

% Block Size
samplesSegment = ceil(totalSamples/numSegments);

%% Window
v = mat2cell(y(:,1),diff([0:samplesSegment:totalSamples-1,totalSamples]));
vo = v;

tdelays = zeros(length(v),1);

for i = 1:length(userInputs)
    
    metadata = char(userInputs(i));
    metadataNum = double(metadata);

    for j = 1:length(metadataNum)

        charEncoded = typecast(metadataNum(j), 'uint8');
        charBin = dec2bin(charEncoded,8);

        for k = 1:length(charBin)  
            %% Mux
            vn = v{k,1};   
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
            tdelays(k) = t;
            %% Combination
             h = EncoderTransferFunction(a,t);
             yk = conv(vn,h);
             vo{k,1} = yk;
             % test = conv2olam(vn,h);
        end 
        yo = OverlapAdd(vo,length(vn));
    end    
end



%% Audio Export
outSig = cell2mat(yo);
ys=[outSig , y(:,2)];
audiowrite(audioFileOut,ys,Fs);



%[yTest,FsTest] = audioread(audioFileOut);
%sound(yTest,FsTest);
