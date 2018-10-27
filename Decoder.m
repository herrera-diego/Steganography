%clear all;
%% User Inputs
audioFile = 'test.wav';


%% Audio Extraction
[yin,Fs] = audioread(audioFile);
%sound(y,Fs);

%% System Parameters


% Total Samples
totalSamples = size(yin,1);

% Number of segments
numSegments = 1000;

% Block Size
samplesSegment = ceil(totalSamples/numSegments);

%% Window
vin = mat2cell(yin(:,1),diff([0:samplesSegment:totalSamples-1,totalSamples]));

outDataBits = zeros(length(vin),1);
%% Combination
for i = 1:length(vin)
    vn = vin{i,1};   

    t = (0:length(vn)-1)/Fs;
    acf = xcorr(vn);
    c = rceps(acf);

    [px,locs] = findpeaks(c,'Threshold',0.2,'MinPeakDistance',0.2);
    ts = [t, 2*t(1:end-1)];
    %subplot(3,1,3)
    figure()
    plot(ts,c,ts(locs),px,'o')
    xlabel('Time (s)')


    outDataBits(i) = data;
end

diffData = outDataBits - inDataBits;
berr = length(diffData) - sum(diffData == 0);
disp(berr);