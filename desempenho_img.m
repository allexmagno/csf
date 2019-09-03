clear all
close all
clc

Rs = 10e3;                                                                % Taxa de símbolos na entrada do canal (equivalente a tava de transmissão)
num_sym = 1e6;                                                             % Numero de símbolos a ser transmitido
fd = 4;                                                                  % Doppler
t = 0:1/Rs:num_sym/Rs-(1/Rs);      
k = [1 1000 1000 1];                                                                  % Parâmetro Riciano
SNR = [100 100 0 10];
M = 2;                                                                     % Numero de bits/simbolo
%%info = randint(num_sym,1,M);                                               % Informação e ser transmitido

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Trabalhando com a imagem
A = imread('img.jpg');
[linha, coluna, dim] = size(A);
A_serial = reshape(A,1,(size(A,1)*size(A,2)*size(A,3)));
A_bin = de2bi(A_serial);
[linha_b, coluna_b] = size(A_bin);
A_bin(1:10,:);
A_bin_serial = reshape(A_bin,1,(size(A_bin,1)*size(A_bin,2)));
info = double(A_bin_serial);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

info_mod = pskmod(info, M);% Modulação PS


for i = 1:4
canal_ric = ricianchan(1/Rs, fd, k(i));                                       % O doppler indica que o canal está variando, mas não afeta tanto o canal
canal_ric.StoreHistory = 1;

sinal_rec_ric = filter(canal_ric, info_mod);
ganho_ric = canal_ric.PathGains;
                                                                           % Variação do SNR

sinalRxRicAwgn = awgn(sinal_rec_ric, SNR(i));
sinalEqRic = sinalRxRicAwgn./transpose(ganho_ric);                                 % Sinal equalizado
sinalDemRic = pskdemod(sinalEqRic, M);

imagem_rx_ric = uint8(sinalDemRic);
imagem_rx_ric = reshape(imagem_rx_ric, linha_b, coluna_b);
imagem_rx_ric = bi2de(imagem_rx_ric);
imagem_rx_ric = reshape(imagem_rx_ric, linha, coluna, dim);
figure(i)
image(imagem_rx_ric)
end

