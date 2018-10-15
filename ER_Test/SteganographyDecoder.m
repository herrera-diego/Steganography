% Module Name:  Decodificador
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
inputFilename = 'AudioDePruebaModificado.wav';
Fs = 44100;

% Read the data back into MATLAB using audioread. 
[y,Fs] = audioread(inputFilename);

%% Decode hidden data in signal

% Length of encoded string
hiddenMessageStringLength = 49;     % Could be input data
% Starting sample
sampleNumber = 0;                   % Could be input data
% Character coding length
charCodingLength = 16;              % Dado por la funcion "Double2Binary.m"

% Coder uses X bits per char
hiddenMessageBitLength = hiddenMessageStringLength * charCodingLength;
% Create empty array to store full message
fullHiddenMessage = zeros(1,hiddenMessageBitLength);

% Read the LSB of the signal samples
for i = 1:hiddenMessageBitLength
    % Sample  number where encoded data begins
    sampleNumber = sampleNumber+1;
       
    row = sampleNumber;
    column = 1;
    
    % Read and store LSB from sample
    sampleInBinary = Double2Binary(y(row,column));
    LSB = 16;
    fullHiddenMessage(1,i) = sampleInBinary(1,LSB);
end

% Decode the data, every "charCodingLength" (16) there is a letter
n = 0;
for i = 1:hiddenMessageStringLength
    hiddenMessageChar = fullHiddenMessage(1+n:charCodingLength+n);
    hiddenMessageDouble(i) = Binary2Double(hiddenMessageChar);
    
    % Read next letter
    n = n + charCodingLength;
end

hiddenMessageString = char(hiddenMessageDouble)







