clc;
clear;
close all;

filename = 'D:\carlo\matlab\p5';

[xs, Fs_xs]=audioread('pruebaa.mp3');
[ys, Fs_ys]=audioread('prueba.mp3');
%sound(xs, Fs_xs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Señal del mensaje
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samples_xs=0:length(xs)-1;
%t_xs=samples_xs/Fs_xs;
t_xs=samples_xs;
Fs=3*Fs_xs;


xs=xs(1:length(xs));

length_xs=length(xs);%tamaño de xs
length_xs2=2^nextpow2(length_xs);
xs_fourier=fft(xs, length_xs2);%transformada de xs
xs_fourier=xs_fourier(1:length_xs2/2);%tomar los valores positivos de la transformada (por eso es length_xs2/2)
xs_freq_axis=Fs*(0:length_xs2/2-1)/length_xs2;
xs_fourier=xs_fourier/length_xs;%se divide la transformada entre la longitud de la señal xs para obtener la magnitud correcta


figure(1);
subplot(2,1,1);
plot(t_xs, xs)
title('Señal de voz contra tiempo')
xlabel('t');
ylabel('dB');
grid on;

subplot(2,1,2);
plot(xs_freq_axis,abs(xs_fourier));
title('Espectro de frecuencias de la señal de voz')
xlabel('f');
ylabel('|Xs|');
xlim([0 5000]);
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Señal del carrier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fc=1220000;
Fs=20*fc;
Ts=1/Fs;
t_xc=0:Ts:1-Ts;

xc=5*cos(2*pi*fc*t_xc);
t_xc1=t_xc(1:length(t_xs));
xc1=xc(1:length(xs));

length_xc=length(xc1);%tamaño de xc
length_xc2=2^nextpow2(length_xc);
xc_fourier=fft(xc, length_xc2);%transformada de xc
xc_fourier=xc_fourier(1:length_xc2/2);%tomar los valores positivos de la transformada (por eso es length_xc2/2)
xc_freq_axis=Fs*(0:length_xc2/2-1)/length_xc2;
xc_fourier=xc_fourier/length_xc;%se divide la transformada entre la longitud de la señal xc para obtener la magnitud correcta


figure(2);
subplot(2,1,1);
plot(t_xc1, xc1);
xlim([0 3/fc]);
title('Señal del carrier en tiempo (1220 kHz)')
ylabel('xc(t)')
xlabel('t')
grid on;

subplot(2,1,2);
plot(xc_freq_axis, abs(xc_fourier));
title('Espectro de frecuencia del carrier ')
ylabel('|Xc(f)')
xlabel('f')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Señal modulada
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs=4*fc;
Ts=1/Fs;
%t=0:Ts:1-Ts;

xc1=xc(1:length(xs));
xm=xs.*xc1;
%xm=xs1.*xc1;

length_xm=length(xm);%tamaño de xm
length_xm2=2^nextpow2(length_xm);
xm_fourier=fft(xm, length_xm2);%transformada de xm
xm_fourier=xm_fourier(1:length_xm2/2);%tomar los valores positivos de la transformada (por eso es length_xm2/2)
xm_freq_axis=Fs*(0:length_xm2/2-1)/length_xm2;
xm_fourier=xm_fourier/length_xm;%se divide la transformada entre la longitud de la señal xm para obtener la magnitud correcta

figure(3);
subplot(2,1,1);
plot(t_xc1, xm);
title('Señal modulada con respecto al tiempo')
ylabel('xm(t)')
xlabel('t')
grid on

subplot(2,1,2)
plot(xm_freq_axis, abs(xm_fourier))
title('Espectro de frecuencia de la señal modulada')
ylabel('|Xm(f)|')
xlabel('f')
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Señal demodulada
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fs=fc*15;
Ts=1/Fs;
%t=0:Ts:1-Ts;

xd=xm.*xc1;

length_xd=length(xd);%tamaño de xd
length_xd2=2^nextpow2(length_xd);
xd_fourier=fft(xd, length_xd2);%transformada de xd
xd_fourier=xd_fourier(1:length_xd2/2);%tomar los valores positivos de la transformada (por eso es length_xd2/2)
xd_freq_axis=Fs*(0:length_xd2/2-1)/length_xd2;
xd_fourier=xd_fourier/length_xd;%se divide la transformada entre la longitud de la señal xd para obtener la magnitud correcta

figure(4)
subplot(2,1,2);
plot(xd_freq_axis, abs(xd_fourier))
title('Espectro de frecuencias de señal de demodulada')
ylabel('|Xd(f)|')
xlabel('f')
grid on

%xlim([-10000 50000])

subplot(2,1,1);
plot(t_xc1,xd);
title('Señal demodulada en tiempo')
ylabel('xd(t)')
xlabel('t')
%axis([0/fc 0.5/fc -100 100])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Señal con filtro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xf=lowpass(xd, 2000/2, Fs_xs);


length_xf=length(xf);%tamaño de xf
length_xf2=2^nextpow2(length_xf);
xf_fourier=fft(xf, length_xf2);%transformada de xf
xf_fourier=xf_fourier(1:length_xf2/2);%tomar los valores positivos de la transformada (por eso es length_xf2/2)
xf_freq_axis=Fs*(0:length_xf2/2-1)/length_xf2;
xf_fourier=xf_fourier/length_xf;%se divide la transformada entre la longitud de la señal xf para obtener la magnitud correcta


figure(5);
subplot(2,1,1);
plot(t_xs, xf)
%sound(xf, Fs_xs)
title('Señal filtrada contra tiempo')
ylabel('xf(t)')
xlabel('t')
grid on

subplot(2,1,2);
plot(xf_freq_axis, abs(xf_fourier))
title('Espectro de frecuencias de la señal filtrada')
ylabel('|Xf(f)|')
xlabel('f')
grid on

%sound(xd,Fs_xs)
correlacion_xf=corrcoef(xs, xf);
correlacion_xd=corrcoef(xs, xd);
k=5;
while k~=0
    k=input('1 para escuchar señal de mensaje, 2 para escuchar señal demodulada, \n 3 para escuchar la señal con filtro y 4 para dejar de escuchar, 0 para terminar');
    if k==1
        sound(xs,Fs_xs);
    elseif k==2
        sound(xd, Fs_xs);
    elseif k==3
        sound(xf, Fs_xs);
    elseif k==4
        clear sound;
    elseif k==5
        correlacion_xd
    elseif k==6
        correlacion_xf
    else 
        clear sound;
        k=0;
    end
end
