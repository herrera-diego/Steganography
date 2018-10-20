%% User Inputs
audioFile = 'AudioDePrueba.wav';
audioFileOut = 'test.wav';
title = "Canon Rock";
artist = "JerryC";
album = "None";
userInputs = [title; artist; album];

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
for i = 1:length(userInputs)
    vn = v{i,1};   
    metadata = char(userInputs(i));
    metadataNum = double(metadata);

    for j = 1:length(metadataNum)

        charEncoded = typecast(metadataNum(j), 'uint8');
        charBin = dec2bin(charEncoded,8);

        for k = 1:length(charBin)  
        %% Mux
        thisBit = char(charBin(k));
        if(thisBit)
            %H1(z)
            t = 5;
            a = 0;
            h = createH();
        else
            %H0(z)
            t = 1;
            a = 1;
            h = createH();
        end

        %% Combination

        end   
    end    
end



%% Audio Export
outSig = cell2mat(v);
ys=[outSig , y(:,2)];
audiowrite(audioFileOut,ys,Fs);

%[yo,Fso] = audioread(audioFileOut);

