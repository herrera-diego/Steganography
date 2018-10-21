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

%% Combination
for i = 1:length(vin)
    vn = vin{i,1};   
    [xhat,delay] = cceps(vn);
end

