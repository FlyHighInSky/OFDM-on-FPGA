%..........................................................
recvd_signal_paralleled = reshape(recvd_signal,rows_Append_prefix, cols_Append_prefix);
%........................................................
%........................................................
% Remove cyclic Prefix
%.......................................................
%......................................................
recvd_signal_paralleled(1:cp_len,:)=[];
R1=recvd_signal_paralleled(:,1);
R2=recvd_signal_paralleled(:,2);
R3=recvd_signal_paralleled(:,3);
R4=recvd_signal_paralleled(:,4);
figure(8),plot((imag(R1)),'r'),subplot(4,1,1),plot(real(R1),'r'),
title('Cyclic prefix removed from the four sub-carriers')
subplot(4,1,2),plot(real(R2),'c')
subplot(4,1,3),plot(real(R3),'b')
subplot(4,1,4),plot(real(R4),'g')
%...................................................
%...................................................
% FFT Of recievied signal
for i=1:number_of_subcarriers,
% FFT
fft_data(:,i) = fft(recvd_signal_paralleled(:,i),16);
end
F1=fft_data(:,1);
F2=fft_data(:,2);
F3=fft_data(:,3);
F4=fft_data(:,4);
figure(9), subplot(4,1,1),plot(real(F1),'r'),title('FFT of all the four sub-carriers')
subplot(4,1,2),plot(real(F2),'c')
subplot(4,1,3),plot(real(F3),'b')
subplot(4,1,4),plot(real(F4),'g')
%................................
%..............................
% Signal Reconstructed
%..................................
%..................................
% Conversion to serial and demodulationa
recvd_serial_data = reshape(fft_data, 1,(16*4));
qpsk_demodulated_data = pskdemod(recvd_serial_data,4);
figure(10)
stem(data)
hold on
stem(qpsk_demodulated_data,'rx');
grid on;xlabel('Data Points');ylabel('Amplitude');
title('Recieved Signal with error')