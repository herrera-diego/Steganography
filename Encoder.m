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
numSegments = length(userInputs);

% Block Size
samplesSegment = ceil(totalSamples/numSegments);

%% Window
yr=y(:,1);
ys = yr;
v = mat2cell(yr,diff([0:samplesSegment:totalSamples-1,totalSamples]));

%% Combination
for i = 1:numSegments
    vn = v{i,1};   
    metadata = char(userInputs(i));
    metadataNum = double(metadata);
    metadataLength = typecast(vn(1), 'uint8'); 
    metadataLength(1)= length(metadataNum);
    vn(1) =  typecast(metadataLength, 'double'); 
    
    for j = 1:length(metadataNum)
   
        charEncoded = typecast(metadataNum(j), 'uint8');
        
        for k = 1:length(charEncoded)      
           sample = typecast(vn(k+1), 'uint8');  
           sample(1) = charEncoded(k);
           vn(k+1) =  typecast(sample, 'double'); 
        end   
    end
    v{i,1} = vn;
    ys(i:(i+size(vn)-1)) = vn;
end

%% Audio Export
ys(totalSamples) =  numSegments/100; 
outSig = y;
outSig(:,1) = ys;
audiowrite(audioFileOut,outSig,Fs);

[yo,Fso] = audioread(audioFileOut);

