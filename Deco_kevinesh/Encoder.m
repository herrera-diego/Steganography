clear all;
%% User Inputs
audioFile = 'Rosa de vientos.wav';
audioFileOut = 'test.wav';
title = "Rosa de vientos";
artist = "Mago de oz";
album = "Gaia";
%end of input
eoi = '\+/';
%end of data, indicates to stop decoding.
eod = '\*/';

userInputs = [title,eoi,artist,eoi,album,eoi,eod];

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
index = 1;
data = 0;
%L = length(v{1,1});
quotient = zeros(samplesSegment,1);

for i = 1:length(userInputs)
    
    metadata = char(userInputs(i));
    
    for j = 1:length(metadata)
        
        character = metadata(j);
        charEncoded= double(character);
        charbin = dec2bin(charEncoded,8);   
        for k = 1:numel(charbin)
            %% Verify window out of bounds
            if(index >= length(v))
                break;
            end 
            %% Mux
            vn = v{index,1};
            
            %% skip windows fo 0's
            %if(all(vn ~= 0))
                thisBit = char(charbin(k));
                if(thisBit == '1')
                    %H1(z)
                    t = 65;
                    a = 0.6;   
                    data = 1;
                else
                    %H0(z)
                    t = 50;
                    a = 0.7; 
                    data = 0;
                end
                tdelays(index) = data;
                %% Combination

                h = EncoderTransferFunction(a,t);
                yk = conv(vn,h);             
                vo{index,1} = yk(1:samplesSegment) + quotient;
                Lx = samplesSegment - length(yk(samplesSegment+1:end)) ;
                quotient = [yk(samplesSegment+1:end);zeros(Lx,1)];
            %end
            
            
            index = index + 1;
        end      
    end    
end


%% Audio Export
outSig = cell2mat(vo);
audiowrite(audioFileOut,outSig,Fs);
[yTest,FsTest] = audioread(audioFileOut);
%sound(yTest,FsTest);
