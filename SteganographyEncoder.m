% Module Name:  Codificador
% Project:      Esteganografo
% 
% La esteganografía procura ocultar mensajes dentro de otros objetos y de 
% esta forma establecer un canal encubierto de comunicación, de modo que el
% propio acto de la comunicación pase inadvertido para observadores que 
% tienen acceso a ese canal.

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
   
    % Foreach bit in the binary array, override the LSB of the original
    % signal samples
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
       sampleInDouble = Binary2Double(sampleInBinary);
       
       % Override sampled input signal
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

% Modificatied file
pause(1);
sound(y4,Fs); 


