%Solving the Ode:
altitude = 500E3; 
Planet_radius = 6378E3; 
P = 2*pi*sqrt((altitude + Planet_radius)^3/3.986004418E14);
tspan = 0:40:P*15; %20 periods
[t,T] = ode89(@Orbiting_Heat_Fluxes,tspan,303.15); %initial condition of 0K temp

%[dTdt, Qs, Qa, Qout]
dTdt = zeros(length(tspan));
Qs = zeros(length(tspan));
Qa = zeros(length(tspan));
Qout = zeros(length(tspan));
QIR = zeros(length(tspan));

c = 0;
H = 303.15;
for i = tspan
    c = c + 1;
    [dTdt(c), Qs(c) , Qa(c), Qout(c), QIR(c)] = Orbiting_Heat_Fluxes(i, H);
    H = H + dTdt(c);
end

%figure()
%plot(tspan, Qs)
%title('Solar Flux')
%xlabel('Time in orbit (s)')
%ylabel('Solar Flux (W)')
%figure()
%plot(tspan, Qa)
%title('Albedo Flux')
%xlabel('Time in orbit (s)')
%ylabel('Albedo Flux (W)')
%figure()
%plot(tspan, Qout)
%title('Out Flux')
%xlabel('Time in orbit (s)')
%ylabel('Out Flux (W)')
%figure()
%plot(tspan, QIR)
%title('IR Flux')
%xlabel('Time in orbit (s)')
%ylabel('IR Flux (W)')
%figure()
%plot(tspan, QIR)
%title('Qgen')
%xlabel('Time in orbit (s)')
%ylabel('Qgen Flux (W)')
figure()
plot(t, T)
title('1 node CubeSat Thermal Model')
xlabel('Time in orbit (s)')
ylabel('Temperature (K)')
