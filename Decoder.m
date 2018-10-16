%% User Inputs
audioFile = 'Canon_Rock_new.wav';


%% Audio Extraction
[yin,Fs] = audioread(audioFile);
%sound(y,Fs);

%% System Parameters

% Total Samples
totalSamples = size(yin,1);
yr=yin(:,1);
% Number of segments

numSegments = round(yr(totalSamples));

userInputs = string(zeros(numSegments));

% Block Size
samplesSegment = ceil(totalSamples/numSegments);

%% Window
v = mat2cell(yr,diff([0:samplesSegment:totalSamples-1,totalSamples]));

%% Combination
for i = 1:numSegments
    vn = v{i,1};   
    metadataLength = typecast(vn(1), 'uint8'); 
    metadata = zeros(metadataLength(1));

    
    for j = 1:metadataLength(1)        
       sample = typecast(vn(j+1), 'uint8');  
       metadata(j) = sample(1);        
    end
    
    userInputs(i) = string(typecast(metadata, 'double'));
end

