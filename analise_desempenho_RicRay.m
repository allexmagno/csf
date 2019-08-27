clear all
close all
clc

Rs = 100e3;                                                                % Taxa de símbolos na entrada do canal (equivalente a tava de transmissão)
num_sym = 1e6;                                                             % Numero de símbolos a ser transmitido
fd = 300;                                                                  % Doppler
t = 0:1/Rs:num_sym/Rs-(1/Rs);      
k = 10;                                                                  % Parâmetro Riciano
M = 2;                                                                     % Numero de bits/simbolo
info = randint(num_sym,1,M);                                               % Informação e ser transmitido
info_mod = pskmod(info, M);                                                % Modulação PSK

canal_ray = rayleighchan(1/Rs, fd);                                        % Gerando o objeto que representa o canal
canal_ric = ricianchan(1/Rs, fd, k);                                       % O doppler indica que o canal está variando, mas não afeta tanto o canal
canal_ray.StoreHistory = 1;                                                % habilitando a gravação dos ganhos do canal
canal_ric.StoreHistory = 1;

sinal_rec_ray = filter(canal_ray, info_mod);                               % Transmissão do sinal modulado por um canal sem fio
sinal_rec_ric = filter(canal_ric, info_mod);

ganho_ray = canal_ray.PathGains;                                           % Salvando os ganhos para conhecer o canal
ganho_ric = canal_ric.PathGains;

for SNR = 0:30                                                             % Variação do SNR
    
   sinalRxRayAwgn = awgn(sinal_rec_ray, SNR);                              % Recebendo o sinal com o ruído gaussiano
   sinalRxRicAwgn = awgn(sinal_rec_ric, SNR);
   sinalEqRay = sinalRxRayAwgn./ganho_ray;                                 % Eliminando os efeitos de rotação de fase e amplitude do ganho do sinal
   sinalEqRic = sinalRxRicAwgn./ganho_ric;                                 % Sinal equalizado

   sinalDemRay = pskdemod(sinalEqRay, M);                                  % Demodulando o sinal equalizado
   sinalDemRic = pskdemod(sinalEqRic, M);
   
   [num_ray(SNR + 1), taxa_ray(SNR + 1)] = symerr(info, sinalDemRay);      % Compara os símbolos que chegam no receptor
   [num_ric(SNR + 1), taxa_ric(SNR + 1)] = symerr(info, sinalDemRic); 
end

semilogy(0:30,taxa_ray, 'r', 0:30, taxa_ric, 'b');