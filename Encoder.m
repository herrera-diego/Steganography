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
    charEncoded = Double2Binary(totalChar(i));
    
    for j = 1:length(charEncoded)
      
       sample = Double2Binary(vn(j));
       sampleSize = 16;
       sample(1,sampleSize) = charEncoded(1,j);
       data = Binary2Double(sample);
       vn(j) = data;      
    end   
    
    v{i,1} = vn;
    ys(i:(i+size(vn)-1)) = vn;
end

%% Audio Export
outSig = y;
outSig(:,1) = ys;
audiowrite(audioFileOut,outSig,Fs);