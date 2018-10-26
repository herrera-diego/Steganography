clear all;
%% User Inputs
audioFile = 'Canon_Rock.mp3';
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
numSegments = 1000;

% Block Size
samplesSegment = ceil(totalSamples/numSegments);

%% Window
v = mat2cell(y(:,1),diff([0:samplesSegment:totalSamples-1,totalSamples]));
vo = v;

inDataBits = zeros(length(v),1);
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
                timelag = 0.01;
                delta = round(Fs*timelag);
                alpha = 0.5;
                data = 1;
            else
                %H0(z)
                timelag = 0.2;
                delta = round(Fs*timelag);
                alpha = 0.4;
                data = 0;
            end
            inDataBits(index) = data;
            %% Combination
            
            orig = [vn;zeros(delta,1)];
            echo = [zeros(delta,1);vn]*alpha;

            mtEcho = orig + echo;           
            outEcho = mtEcho(1:samplesSegment) + quotient;
            vo{index,1} = outEcho;
            partialData = mtEcho(samplesSegment+1:end);
            remaingZeros = zeros(samplesSegment-length(partialData),1);
            quotient = [partialData ; remaingZeros];
            
            tl = (0:length(mtEcho)-1)/Fs;
            t = (0:length(outEcho)-1)/Fs;

            subplot(3,1,1)
            plot(tl,[orig echo])
            legend('Original','Echo')

            subplot(3,1,2)
            plot(t,[outEcho quotient])
            legend('Total', 'Quotient')
            xlabel('Time (s)')
            
            acf = xcorr(outEcho);
            
            c = rceps(acf);

            [px,locs] = findpeaks(c,'Threshold',0.2,'MinPeakDistance',0.2);
            ts = [t, 2*t(1:end-1)];
            subplot(3,1,3)
            plot(ts,c,ts(locs),px,'o')
            xlabel('Time (s)')

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
