%%  DIVERSIDADE - Alamouti
%   Engenharia de Telecomunicações - IFSC/SJ
%   Comunicação sem Fio - 2019/2
%   Allex Magno Andrade
%
%% Sistema

clear all
close all
clc

M = 2;
SNR = 10;
Rs = 10e3;
fd = 10;
info = randi([0 1], 4, 1);
info_mod = pskmod(info, M);

info_mod_i = (info_mod(1:2:end));
info_mod_p = (info_mod(2:2:end));

info_tx_1 = zeros(1,length(info));
info_tx_2 = zeros(1,length(info));

info_tx_1(1:2:end) = info_mod_i;
info_tx_1(2:2:end) = -conj(info_mod_p);

info_tx_2(1:2:end) = info_mod_p;
info_tx_2(1:2:end) = conj(info_mod_i);

canal_ray1 = rayleighchan(1/Rs, fd);                                       % Gerando o objeto que representa o canal
canal_ray2 = rayleighchan(1/Rs, fd);                                       % O doppler indica que o canal está variando, mas não afeta tanto o canal

canal_ray1.StoreHistory = 1;                                               % habilitando a gravação dos ganhos do canal
canal_ray2.StoreHistory = 1;


sinal_rec_ray1 = filter(canal_ray1, info_mod);                             % Transmissão do sinal modulado por um canal sem fio
sinal_rec_ray2 = filter(canal_ray2, info_mod);                             % Recepção na antena após passar pelo canal

ganho_ray1 = canal_ray1.PathGains;                                         % Salvando os ganhos para conhecer o canal
ganho_ray2 = canal_ray2.PathGains;

sinalRxRay1Awgn = awgn(sinal_rec_ray1, SNR);                               % Recebendo o sinal com o ruído gaussiano
sinalRxRay2Awgn = awgn(sinal_rec_ray2, SNR);


r0 = ganho_ray1(1:2:end)'.*info_tx_1(1:2:end) + ganho_ray2(2:2:end)'.*info_tx_2(2:2:end);
r1 = -ganho_ray1(1:2:end)'.*conj(info_tx_2(2:2:end)) + ganho_ray2(2:2:end)'.*conj(info_tx_1(1:2:end));

sinal_rx_i = r0(1:2:end).*conj(ganho_ray1(1:2:end)') + conj(r1(2:2:end)).*ganho_ray2(2:2:end)';
sinal_rx_p = r0(1:2:end).*conj(ganho_ray2(2:2:end)') - conj(r1(2:2:end)).*ganho_ray1(1:2:end)';

sinal_rx = zeros(1,length(info));

sinal_rx(1:2:end) = sinal_rx_i(1:2:end);
sinal_rx(2:2:end) = sinal_rx_p(2:2:end);
info_demod = pskdemod(sinal_rx, M)
info_mod
