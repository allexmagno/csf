
clear all
close all
clc

Rs = 10e3;                                                                % Taxa de símbolos na entrada do canal (equivalente a tava de transmissão)
num_sym = 1e4;                                                             % Numero de símbolos a ser transmitido
fd = 10;                                                                  % Doppler
t = 0:1/Rs:num_sym/Rs-(1/Rs);      
k = 10;                                                                  % Parâmetro ray2iano
M = 2;                                                                     % Numero de bits/simbolo
info = randint(num_sym,1,M);                                               % Informação e ser transmitido
info_mod = pskmod(info, M);                                                % Modulação PSK

canal_ray1 = rayleighchan(1/Rs, fd);                                        % Gerando o objeto que representa o canal
canal_ray2 = rayleighchan(1/Rs, fd);                                       % O doppler indica que o canal está variando, mas não afeta tanto o canal
canal_ray3 = rayleighchan(1/Rs, fd);
canal_ray1.StoreHistory = 1;                                                % habilitando a gravação dos ganhos do canal
canal_ray2.StoreHistory = 1;
canal_ray3.StoreHistory = 1;

sinal_rec_ray1 = filter(canal_ray1, info_mod);                               % Transmissão do sinal modulado por um canal sem fio
sinal_rec_ray2 = filter(canal_ray2, info_mod);
sinal_rec_ray3 = filter(canal_ray3, info_mod);

ganho_ray1 = canal_ray1.PathGains;                                           % Salvando os ganhos para conhecer o canal
ganho_ray2 = canal_ray2.PathGains;
ganho_ray3 = canal_ray3.PathGains;


figure(1)
plot(20*log10(abs(ganho_ray1)));
hold on
plot(20*log10(abs(ganho_ray2)));
plot(20*log10(abs(ganho_ray3)));
ganho_eq = max(ganho_ray1, ganho_ray2);
ganho_eq = max(ganho_eq, ganho_ray3);
plot(20*log10(abs(ganho_eq)), '.');
hold off


   