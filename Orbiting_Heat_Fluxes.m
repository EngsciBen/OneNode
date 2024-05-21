%page for function
function dTdt = Orbiting_Heat_Fluxes(t, T)
    %%% Function for the ode
    %%%%%%%% PARAMETERS
    Atot = 0.06; %m^2
    Mass = 1.33;%kg
    heat_cap = 961; %J/Kg/K
    beta_angle = 0; %Let it be deployed at the closest point to the sun
    altitude = 500E3; %km
    a = 0.52; %Solar absorptivity
    Af = 0.35; %Albedo factor
    g = 5.67 * 10^-8; %Stefan-Boltz Constant
    Planet_radius = 6378E3; %Radius of the parent body
    h = (Planet_radius+altitude)/Planet_radius; %Relative Height
    F = 0.5*(1-sqrt(1-(1/(h^2)))); %Veiw Factor
    S = 1361; %W/m^2
    Earth_IR = 230; %W/m^2 Assumed constant; albeit inconstant in reality
    emissivity = 0.9;
    S_earth = 200; %ranges from 110-300W

    %Checking if in eclipse first:
    Eclipse_start = pi - acos(sqrt(h^2-1)/(h*cos(beta_angle)));
    Eclipse_end = pi + acos(sqrt(h^2-1)/(h*cos(beta_angle)));
    
    %Orbital_period = 90*60; %90 minute period
    Orbital_period = 2*pi*sqrt((altitude + Planet_radius)^3/3.986004418E14);
    Chi = mod(((2*pi*t)/Orbital_period), (2*pi)); %mod((2*pi*t)/Orbital_period, 2*pi)
    %Chi = ((2*pi*t)/Orbital_period) - (2*pi).*floor(((2*pi*t)/Orbital_period)./(2*pi))
    
    if (Eclipse_start < Chi) && (Chi< Eclipse_end)
        Eclipse = 0; %0= in eclipse
    else
        Eclipse = 1; %1= not in an eclipse
    end

    if (-1*Eclipse_start < Chi) && (Chi < Eclipse_start)
        Fe = 0;
    else
        Fe = 1;
    end

    Qs = a * Atot * S * Eclipse; % SOLAR FLUX    
    QIR = emissivity * Atot * S_earth * F; % EARTH IR
    Qgen = 0; % Internal Heat Generation
    Orbital_Albedo_funct = (1+cos(Chi)/2)^2 * (1-(Chi/Eclipse_start)^2) * cos(beta_angle);
    Qa = a * Atot * S * Af * Orbital_Albedo_funct * F * Fe; % EARTH ALBEDO
    Qout = emissivity * Atot * g * F * (T^4); % Lost Heat

    dTdt = (Qs + Qa + QIR + Qgen - Qout) / (Mass*heat_cap);
    %dTdt = (Qs*Eclipse + Eclipse*a * Atot * S * Af * (1+cos((2*pi*t)/Orbital_period)/2)^2 * (1-(((2*pi*t)/Orbital_period)/Eclipse_start)^2) * cos(beta_angle) * F + QIR + Qgen - emissivity * A * g * F * (T^4 - 2.33^4)) / (Mass*heat_cap);
