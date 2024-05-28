%page for function
function [dTdt, Qs, Qa, Qout, QIR, Qgen] = Orbiting_Heat_Fluxes(t, T) % [dTdt, Qs, Qa, Qout]
    %%% Function for the ode
    %%%%%%%% PARAMETERS
    Atot = 0.06; %m^2
    Mass = 1.33;%kg
    heat_cap = 961; %J/Kg/K
    beta_angle = 0; %Let it be deployed at the closest point to the sun
    altitude = 500E3; %km
    a = 0.52; %Solar absorptivity
    Af = 0.35; %Albedo factor
    Stefan_Boltz= 5.67 * 10^-8; %Stefan-Boltz Constant
    Planet_radius = 6378E3; %Radius of the parent body
    h = (Planet_radius+altitude)/Planet_radius; %Relative Height
    F = 0.5*(1-sqrt(1-(1/(h^2)))); %Veiw Factor
    S = 1361; %W/m^2
    Earth_IR = 230; %W/m^2 Assumed constant; albeit inconstant in reality
    emissivity = 0.9;
    Earth_Temp = 250; %ranges from 110-300W

    %Checking if in eclipse first:
    Eclipse_start = pi - acos(sqrt(h^2-1)/(h*cos(beta_angle)));
    Eclipse_end = pi + acos(sqrt(h^2-1)/(h*cos(beta_angle)));
    
    %Orbital_period = 90*60; %90 minute period
    Orbital_period = 2*pi*sqrt((altitude + Planet_radius)^3/3.986004418E14);
    Phi = mod(((2.*pi.*t)/Orbital_period), (2.*pi)); %mod((2*pi*t)/Orbital_period, 2*pi)
    Phi_a = wrapToPi(Phi);
    %Phi = ((2*pi*t)/Orbital_period) - (2*pi).*floor(((2*pi*t)/Orbital_period)./(2*pi))
    
    if (Eclipse_start < Phi) && (Phi< Eclipse_end)
        Eclipse = 0; %0= in eclipse
    else
        Eclipse = 1; %1= not in an eclipse
    end

    if (-1*Eclipse_start < Phi_a) && (Phi_a < Eclipse_start)
        Fe = 1;
    else
        Fe = 0;
    end

    Qs = a .* Atot/6 .* S .* Eclipse; % SOLAR FLUX    
    QIR = emissivity .* Atot .* Earth_Temp^4 .* F .* Stefan_Boltz; % IR flux
    Qgen = 6.9864; % Internal Heat Generation

    Qout = emissivity .* Atot .* Stefan_Boltz .* (T.^4); % Lost Heat
    
    if T < 273.15+8
        Qgen = Qgen+0.37;
    elseif T < 273.15 + 4
        Qgen = Qgen+(0.37+0.555);
    elseif T < 273.15 + 1
        Qgen = Qgen + (0.37 + 0.555 + 0.74);
    end

    Orbital_Albedo_funct = ((1 + cos(Phi_a)) / 2) ^ 2 * (1 - (Phi_a / Eclipse_start) ^ 2) * cos(beta_angle) * Fe;
    Qa = a * Atot * S * Af * F * Orbital_Albedo_funct;

    dTdt = (Qs + Qa + QIR + Qgen - Qout) / (Mass.*heat_cap);
