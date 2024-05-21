%Solving the Ode:
P = 90;
tspan = 0:0.1:90*60*20; %period of 90mins
[t,T] = ode89(@Orbiting_Heat_Fluxes,tspan,273); %initial condition of 0K temp
figure()
plot(t, T)
title('1 node CubeSat Thermal Model')
xlabel('Time in orbit (s)')
ylabel('Temperature (K)')
