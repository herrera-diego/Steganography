% Module Name:  Codificador
% Project:      Esteganografo
% 
% Convierte un "string" llamado "hiddenMessage" a su equivalente en bits
% y por cada muestra de la señal de audio sustituye su LSB por uno de los 
% bits del mensaje secreto.
%
% Cada "char" del mensaje secreto se combierte a vectores de 16 bits, es
% decir se requieren de al menos 16 muestras de audio para esconder su
% informacion

%% Init

% Clear all variables and plots
clear all;

% Read command line arguments/configuration file
% TODO


%% Read .WAV input file
inputFilename = 'AudioDePrueba.wav';
outputFilename = 'AudioDePruebaModificado.wav';
Fs = 44100;

% Read the data back into MATLAB using audioread. 
[y,Fs] = audioread(inputFilename);

%%%%% DEBUG - A copy used for comparison 
%[y2,Fs] = audioread(inputFilename); 

%% Encode hidden data in signal

% Data to write
hiddenMessage = 'Hubert Blaine Wolfeschlegelsteinhausenbergerdorff';
% Convert to ASCII
hiddenMessage_ASCII = double(hiddenMessage);
% Find the number of chars
hiddenMessage_length = length(hiddenMessage_ASCII);

% Encoding address start
sampleNumber = 0;

% Foreach ascii char in the message get a binary vector
for i = 1:hiddenMessage_length
    
    charInBinary = Double2Binary(hiddenMessage_ASCII(i));
    
    %%%% DEBUG - Check value that was read
    %charInDouble = Binary2Double(charInBinary);
   
    % Foreach bit in the binary array, override the LSB of 1 audio sample.
    % 16 samples are required per "char"
    for j = 1:length(charInBinary)
       sampleNumber = sampleNumber+1;
       
       row = sampleNumber;
       column = 1;
       sampleInBinary = Double2Binary(y(row,column));
       
       %%%%% DEBUG - Check value that was read
       %charInDouble = Binary2Double(sampleInBinary);
       
       % Override LSB with ascii bit
       LSB = 16;
       sampleInBinary(1,LSB) = charInBinary(1,j);
       
       % Recalculate sample double value after changing LSB
       sampleInDouble = Binary2Double(sampleInBinary);
       
       % Override sample original value
       y(row,column) = sampleInDouble;      
    end   
end

%%%%% DEBUG - Compare the original vs modified audio signals
%y3 = y2 - y;


%% Write .WAV output file
audiowrite(outputFilename,y,Fs);

%%%%% DEBUG - Sample output file to see if coding can be detected 
[y4,Fs] = audioread(outputFilename);

%% Play the audio 
% Original file
sound(y,Fs); 

% Modified file
pause(1);
sound(y4,Fs); 


