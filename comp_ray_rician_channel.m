%%  Comparação entre Canal Riciano e de Rayleigh
%   Engenharia de Telecomunicações - IFSC/SJ
%   Comunicação sem Fio - 2019/2
%   Allex Magno Andrade
%%

clear all
close all
clc

%tau = [0 2 3 5]*1e-6;
%pdb = [-20 -10 -10 0];
Rs = 100e3;
num_bits = 1e6;
fd = 300;
t = 0:1/Rs:num_bits/Rs-(1/Rs);
info = randint(1, num_bits, 2);
k = 1000;                                                                  % Quando menor o K, mais semelhante a distribuição de raylen o canal fica

% BPSK
%info_mod = pskmod(info,2);
% QPSK
info_mod = pskmod(info,4);
%canal = rayleighchan(1/1000000, 120, tau, pdb);
canal_ray = rayleighchan(1/Rs, fd);
canal_ric = ricianchan(1/Rs, fd, k);                                       % O doppler indica que o canal está variando, mas não afeta tanto o canal
canal_ray.StoreHistory = 1;
canal_ric.StoreHistory = 1;
sinal_rec_ray = filter(canal_ray, info_mod);
sinal_rec_ric = filter(canal_ric, info_mod);

ganho_ray = canal_ray.PathGains;
ganho_ric = canal_ric.PathGains;


%% plots

figure(1)
plot(t, 20*log10(abs(ganho_ray)));
hold on
plot(t, 20*log10(abs(ganho_ric)))
hold off

figure(2)
hist(abs(ganho_ric), 10000)
title('Variação do ganho')
figure(3)
hist(angle(ganho_ric), 10000)                                              % Variação de -pi a pi
xlim([-pi pi])
title('Variação do angulo')

