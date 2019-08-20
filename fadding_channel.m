close all

clear all
clc

tau = [0 2 3 5]*1e-6;
pdb = [-20 -10 -10 0];
info = randint(1, 100,2);
info_mod = pskmod(info,2);
canal = rayleighchan(1/1000000, 120, tau, pdb);
canal.StoreHistory = 1;
sinal_rec = filter(canal, info_mod);
plot(canal)