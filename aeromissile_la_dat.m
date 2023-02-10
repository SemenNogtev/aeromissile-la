% AEROMISSILE_DAT	Initialization file for missile model
%
% See also: aeromissile

%==================================================================
% Useful Constants
%==================================================================
d2r     = pi/180;                 % Conversion Deg to Rad
g       = 9.81;                   % Gravity [m/s/s]

%==================================================================
% Missile Configuration
%==================================================================
S_ref   = 0.040877;               % Reference area [m^2]
d_ref   = 0.2286;                 % Reference length [m]
l_ref   = 0.04;                   % Reference wingspan [m]

len_missile = 3;                  % Rocket Missile
x_ref   = 0.54*len_missile;       % Reference point from nose
x_cg_0  = 0.575*len_missile;      % Initial Centre of Gravity
x_cg    = 0.555*len_missile;      % Centre of Gravity

massf = 30;                       % Mass of Fuel [Kg]
q = 2;                           % Consumption of Fuel [Kg/s]
mass_0 = 234.02;                  % Initial Mass [Kg]

Ixx     = 1/2*mass_0*(S_ref/pi); 
Iyy     = 247.44;
Izz     = Iyy;
inertia_0 = diag([Ixx Iyy Izz]);  % Initial inertia matrix [Kg*m^2]
inertia = inertia_0/2;            % Finite inertia matrix [Kg*m^2]

Thrust  = 10e3;                   % Thrust [N]

%==================================================================
% Missile Aerodynamics
%==================================================================
Mach_vec  = [2:0.5:4];            % Reference Mach Numbers
alpha_vec = [-20:1:20]'*d2r;      % Reference Incidence Values [rad]
beta_vec = [-20:1:20]'*d2r;       % Reference Sliding Values [rad]
[al,be,M]=meshgrid(alpha_vec/d2r,beta_vec/d2r,Mach_vec);

% Force coefficients
cx = 0.3*ones(length(alpha_vec),length(beta_vec),length(Mach_vec));

afy    =	-0.000103;            % [Deg^-3]
bfy    =	 0.009450; 		      % [Deg^-2]
cfy    =     0.169600;		      % [Deg^-1]
cy = afy*al.^3 + bfy*al.*abs(al) + cfy*(2-M/3).*al;
cy_el = 0.034000/d2r;

afz    =	 0.000103;            % [Deg^-3]
bfz    =	-0.009450; 		      % [Deg^-2]
cfz    =    -0.169600;		      % [Deg^-1]
cz = afz*be.^3 + bfz*be.*abs(be) + cfz*(2-M/3).*be;
cz_el = -0.034000/d2r;

% Moment coefficients
mx = zeros(length(alpha_vec),length(beta_vec),length(Mach_vec));
mx_el = -0.206000/d2r;
mx_wx = -0.5;
mxa = 1*ones(length(alpha_vec),length(beta_vec),length(Mach_vec));
mxad = 1*ones(length(alpha_vec),length(beta_vec),length(Mach_vec));

amy       = 0.000215;             % [Deg^-3]
bmy       =-0.019500;             % [Deg^-2]
cmy       = 0.051000;             % [Deg^-1]
my = amy*be.^3 + bmy*be.*abs(be) - cmy*(7-8*M/3).*be;
my_el    = -0.206000/d2r;
my_wy     = -1.719;

amz       = 0.000215;             % [Deg^-3]
bmz       =-0.019500;             % [Deg^-2]
cmz       = 0.051000;             % [Deg^-1]
mz = amz*al.^3 + bmz*al.*abs(al) - cmz*(7-8*M/3).*al;
mz_el    = -0.206000/d2r;
mz_wz     = -1.719;

%==================================================================
% Define Initial Conditions
%==================================================================
xmg_0      = [0;1000;0];	% Initial position in inertial axes [Xg,Yg,Zg] [m]
Vm_0       = [300;0;0];   % Initial velocity in body axes [Vxc,Vyc,Vzc] [m/s]
eul_0      = [0;0;0];   % Initial Euler orientation [roll, pitch, yaw] [rad]
wm_0       = [0;0;0];   % Initial body rotation rates [wx,wy,wz] [rad/s]

%==================================================================
% Missile Actuators
%==================================================================
wn_fin      = 150.0;            % Actuator Bandwidth [rad/sec]
z_fin 	    = 0.7;              % Actuator Damping
fin_act_0   = 0.0;              % Initial Fin Angle [rad]
fin_max     =  30.0*d2r;        % Max Fin Deflection [rad] 
fin_min	    = -30.0*d2r;        % Min Fin Deflection [rad]
fin_maxrate = 500*d2r;          % Max Fin Rate [rad/sec]

%==================================================================
% Sensors
%==================================================================
l_acc       = 0.5;     % Position of accelerometer ahead of c.g [m]

%==================================================================
% Autopilot coefficients
%==================================================================
M_sch = [2.0000 2.2500 2.5000 2.7500 3.0000 3.2500 3.5000 3.7500 4.0000];
alpha_sch = [0 0.0698 0.1396 0.2094 0.2793 0.3491];

Ka = [0.9412    0.9389    0.9352    0.9321    0.9273    0.9217;
      0.9364    0.9336    0.9300    0.9266    0.9203    0.9142;
      0.9316    0.9290    0.9250    0.9204    0.9137    0.9071;
      0.9269    0.9239    0.9201    0.9146    0.9075    0.9005;
      0.9220    0.9191    0.9148    0.9092    0.9016    0.8943;
      0.9173    0.9140    0.9099    0.9042    0.8962    0.8885;
      0.9131    0.9092    0.9047    0.8995    0.8911    0.8831;
      0.9084    0.9047    0.8998    0.8947    0.8864    0.8781;
      0.9040    0.9005    0.8952    0.8903    0.8820    0.8735];
  
K = [0.0259    0.0249    0.0237    0.0229    0.0218    0.0207;
     0.0212    0.0204    0.0195    0.0188    0.0176    0.0168;
     0.0178    0.0172    0.0164    0.0156    0.0147    0.0139;
     0.0151    0.0146    0.0140    0.0132    0.0124    0.0118;
     0.0130    0.0126    0.0120    0.0114    0.0107    0.0102;
     0.0113    0.0109    0.0105    0.0100    0.0094    0.0089;
     0.0100    0.0096    0.0092    0.0088    0.0083    0.0079;
     0.0089    0.0085    0.0082    0.0079    0.0074    0.0071;
     0.0079    0.0077    0.0073    0.0071    0.0067    0.0064];
 
Ki = [22.5220   22.7092   22.9250   23.0923   23.2089   23.2709;
      26.1087   26.3788   26.6897   26.9316   27.0991   27.1852;
      30.1257   30.5069   30.9480   31.2933   31.5308   31.6508;
      34.5616   35.0914   35.7077   36.1912   36.5201   36.6881;
      39.3999   40.1205   40.9646   41.6291   42.0832   42.3099;
      44.6135   45.5767   46.7100   47.6092   48.2235   48.5294;
      50.5274   51.4311   52.9278   54.1228   54.9412   55.3466;
      56.4127   57.6462   59.5894   61.1489   62.2223   62.7535;
      62.5431   64.1724   66.6498   68.6538   70.0408   70.7266];
  
Kg = [0.8503    0.8430    0.8350    0.8290    0.8252    0.8234;
      0.6688    0.6616    0.6535    0.6475    0.6437    0.6419;
      0.5397    0.5324    0.5244    0.5184    0.5145    0.5127;
      0.4448    0.4375    0.4294    0.4234    0.4196    0.4178;
      0.3731    0.3658    0.3578    0.3518    0.3479    0.3461;
      0.3179    0.3106    0.3025    0.2965    0.2926    0.2908;
      0.2739    0.2672    0.2591    0.2531    0.2492    0.2474;
      0.2394    0.2327    0.2246    0.2186    0.2147    0.2128;
      0.2116    0.2049    0.1968    0.1907    0.1868    0.1850];
  