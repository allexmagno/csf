
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

canal_ray1.StoreHistory = 1;                                                % habilitando a gravação dos ganhos do canal
canal_ray2.StoreHistory = 1;


sinal_rec_ray1 = filter(canal_ray1, info_mod);                               % Transmissão do sinal modulado por um canal sem fio
sinal_rec_ray2 = filter(canal_ray2, info_mod);
sinal_rec2 = sinal_rec_ray1 + sinal_rec_ray2;

ganho_ray1 = canal_ray1.PathGains;                                           % Salvando os ganhos para conhecer o canal
ganho_ray2 = canal_ray2.PathGains;

for SNR = 0:25                                                             % Variação do SNR
    
   sinalRxRay1Awgn = awgn(sinal_rec_ray1, SNR);                              % Recebendo o sinal com o ruído gaussiano
   sinalRxRay2Awgn = awgn(sinal_rec_ray2, SNR);
   %sinalRxRay3Awgn = awgn(sinal_rec2, SNR);
   
   sinalEqRay1 = sinalRxRay1Awgn./ganho_ray1;                                 % Eliminando os efeitos de rotação de fase e amplitude do ganho do sinal
   sinalEqRay2 = sinalRxRay2Awgn./ganho_ray2;                                 % Eliminando os efeitos de rotação de fase e amplitude do ganho do sinal
   %sinalEqRay3 = sinalRxRay3Awgn./(ganho_ray1 + ganho_ray2);                                 % Sinal equalizado

   for t = 1:length(info_mod)
       if abs(ganho_ray1) >= abs(ganho_ray2) 
            sinalDemRay = pskdemod(sinalEqRay1(t), M);                                  % Demodulando o sinal equalizado
       else
            sinalDemRay = pskdemod(sinalEqRay2(t), M);
       end
   end
   %sinalDemRay3 = pskdemod(sinalEqRay3, M);
   
   [num(SNR+1), taxa(SNR+1)] = biterr(info, sinalDemRay);
   %[num_ray1(SNR + 1), taxa_ray1(SNR + 1)] = symerr(info, sinalDemRay1);      % Compara os símbolos que chegam no receptor
   %[num_ray2(SNR + 1), taxa_ray2(SNR + 1)] = symerr(info, sinalDemRay2); 
end

figure(1)
title('Desempenho')
semilogy(0:25,taxa, 'r', 0:25, taxa_txrx, 'b');
xlabel('SNR [dB]')
ylabel('BER')
legend('1 receptor', '2 receptores')

figure(2)
plot(20*log10(abs(ganho_ray1)));
hold on
plot(20*log10(abs(ganho_ray2)));

ganho_eq = max(ganho_ray1, ganho_ray2);

plot(20*log10(abs(ganho_eq)), '.');
hold off


   