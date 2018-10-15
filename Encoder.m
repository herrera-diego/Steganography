%% User Inputs
audioFile = 'Canon_Rock.mp3';
audioFileOut = 'Canon_Rock_new.wav';
title = 'Canon Rock';
artist = 'JerryC';
album = 'None';

%% Audio Extraction
[y,Fs] = audioread(audioFile);
%sound(y,Fs);

%% System Parameters

 q = quantizer([4,3]);

% Total Samples
totalSamples = size(y,1);

% Number of segments
totalChar = strcat(title,artist,album);
totalCharNum = double(totalChar);
numSegments = length(totalCharNum);

% Block Size
samplesSegment = ceil(totalSamples/numSegments);

%% Window
yr=y(:,1);
ys = yr;
v = mat2cell(yr,diff([0:samplesSegment:totalSamples-1,totalSamples]));

%% Combination
for i = 1:numSegments
    vn = v{i,1};   
    charEncoded = typecast(totalCharNum(i), 'uint8');
    
    for j = 1:length(charEncoded)      
       sample = typecast(vn(j), 'uint8');  
       sample(1) = charEncoded(j);
       vn(j) =  typecast(sample, 'double'); 
    end   
    
    v{i,1} = vn;
    ys(i:(i+size(vn)-1)) = vn;
end

%% Audio Export
outSig = y;
outSig(:,1) = ys;
audiowrite(audioFileOut,outSig,Fs);