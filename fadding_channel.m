clear all
close all
clc

tau = [0 2 3 5]*1e-6;
pdb = [0 -10 0 -20];
info = randint(1, 5000,2);
info_mod = pskmod(info,2);
canal = rayleighchanghchan(1/1000, 30, tau, pdb);
