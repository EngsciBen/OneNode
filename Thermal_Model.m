%Solving the Ode:
altitude = 500E3; 
Planet_radius = 6378E3; 
P = 2*pi*sqrt((altitude + Planet_radius)^3/3.986004418E14);
tspan = 0:100:P*20; %20 periods
[t,T] = ode89(@Orbiting_Heat_Fluxes,tspan,273); %initial condition of 0K temp

%[dTdt, Qs, Qa, Qout]
dTdt = zeros(length(tspan));
Qs = zeros(length(tspan));
Qa = zeros(length(tspan));
Qout = zeros(length(tspan));

c = 0;
for i = tspan
    c = c + 1;
    [dTdt(c), Qs(c) , Qa(c), Qout(c)] = Orbiting_Heat_Fluxes(i, 69);
end

figure()
plot(tspan, Qs)
title('Solar Flux')
xlabel('Time in orbit (s)')
ylabel('Solar Flux (W)')
figure()
plot(tspan, Qa)
title('Albedo Flux')
xlabel('Time in orbit (s)')
ylabel('Albedo Flux (W)')
figure()
plot(t, T)
title('1 node CubeSat Thermal Model')
xlabel('Time in orbit (s)')
ylabel('Temperature (K)')
