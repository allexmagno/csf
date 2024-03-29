%%  Desvaneicimento do Canal
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
num_bits = 1e5;
fd = 30;
t = 0:1/Rs:num_bits/Rs-(1/Rs);
info = randint(1, num_bits, 2);
% BPSK
%info_mod = pskmod(info,2);
% QPSK
info_mod = pskmod(info,4);
%canal = rayleighchan(1/1000000, 120, tau, pdb);
canal = rayleighchan(1/Rs, fd);
canal.StoreHistory = 1;
sinal_rec = filter(canal, info_mod);
ganho = canal.PathGains;

%% Plot
plot(t, 20*log10(abs(ganho)))
xlabel('t [s]')
ylabel('ganho [dB]')
%plot(canal)