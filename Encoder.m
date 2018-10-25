clear all;
%% User Inputs
audioFile = 'AudioDePrueba.wav';
audioFileOut = 'test.wav';
title = "Canon";
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
numSegments = 600;

% Block Size
samplesSegment = ceil(totalSamples/numSegments);

%% Window
v = mat2cell(y(:,1),diff([0:samplesSegment:totalSamples-1,totalSamples]));
vo = v;

tdelays = zeros(length(v),1);
index = 1;
data = 0;
%L = length(v{1,1});
quotient = zeros(samplesSegment,1);

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
                t = 100;
                a = 0.1;   
                data = 1;
            else
                %H0(z)
                t = 25;
                a = 0.5; 
                data = 0;
            end
            tdelays(index) = data;
            %% Combination
            
            h = EncoderTransferFunction(a,t);
            yk = conv(vn,h);
            vo{index,1} = yk(1:samplesSegment) + quotient;
            Lx = samplesSegment - length(yk(samplesSegment+1:end)) ;
            quotient = [yk(samplesSegment+1:end);zeros(Lx,1)];
            
            index = index + 1;
        end      
    end    
end

 %yo = OverlapAdd(vo,length(v{1,1}));

%% Audio Export
outSig = cell2mat(vo);
%ys=[outSig , y(:,2)];
audiowrite(audioFileOut,outSig,Fs);



[yTest,FsTest] = audioread(audioFileOut);
sound(yTest,FsTest);
