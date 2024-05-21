%Solving the Ode:
altitude = 500E3; %km
Planet_radius = 6378E3; %
P = 2*pi*sqrt((altitude + Planet_radius)^3/3.986004418E14);
tspan = 0:0.1:P*20; %period of P*60 mins
[t,T] = ode89(@Orbiting_Heat_Fluxes,tspan,273); %initial condition of 0K temp
figure()
plot(t, T)
title('1 node CubeSat Thermal Model')
xlabel('Time in orbit (s)')
ylabel('Temperature (K)')
