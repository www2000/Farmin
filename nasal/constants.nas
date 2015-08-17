#port of simgear/constants.h


PI 						= math.pi;
2PI 					= math.pi * 2.0;
E						= 2.7182818284590452354;

PI_2					= 1.57079632679489661923;
PI_4					= 0.78539816339744830961;
DEGREES_TO_RADIANS		= PI / 180.0;
RADIANS_TO_DEGREES		= 180.0 / PI;
ONE_SECOND				= 4.848136811E-6;
EARTH_RAD				= 6378.155;
MAX_ELEVATION_M			= 9000.0;
EQUATORIAL_RADIUS_FT	= 20925650.0;
EQUATORIAL_RADIUS_M		= 6378138.12;
EQ_RAD_SQUARE_FT		= 437882827922500.0;
EQ_RAD_SQUARE_M			= 40680645877797.1344;

# Physical Constants, SI

# mean gravity on earth
g0_m_p_s2				= 9.80665; # m/s2

# standard pressure at SL
p0_Pa					= 101325.0; # Pa

# standard density at SL
rho0_kg_p_m3 			= 1.225; # kg/m3

# standard temperature at SL
T0_K 					= 288.15;   # K (=15degC)

# specific gas constant of air
R_m2_p_s2_p_K			= 287.05;   # m2/s2/K

# specific heat constant at constant pressure
cp_m2_p_s2_p_K			= 1004.68;      # m2/s2/K

# ratio of specific heats of air
gamma					= 1.4;         # =cp/cv (cp = 1004.68 m2/s2 K , cv = 717.63 m2/s2 K)

# constant beta used to calculate dynamic viscosity
beta_kg_p_sm_sqrK		= 1.458e-06;   # kg/s/m/SQRT(K)

#  Sutherland constant
S_K						= 110.4;      # K


# Conversions

# Arc seconds to radians.  (arcsec*pi)/(3600*180) = rad
ARCSEC_TO_RAD			= 4.84813681109535993589e-06;

# Radians to arc seconds.  (rad*3600*180)/pi = arcsec
RAD_TO_ARCSEC			= 206264.806247096355156;

# Feet to Meters
FEET_TO_METER			= 0.3048;

# Meters to Feet
METER_TO_FEET			= 3.28083989501312335958;

# Meters to Nautical Miles.  1 nm = 6076.11549 feet
METER_TO_NM				= 0.0005399568034557235;

# Nautical Miles to Meters
NM_TO_METER				= 1852.0000;

# Meters to Statute Miles.
METER_TO_SM				= 0.0006213699494949496;

# Statute Miles to Meters.
SM_TO_METER				= 1609.3412196;

# Radians to Nautical Miles.  1 nm = 1/60 of a degree
NM_TO_RAD				= 0.00029088820866572159;

# Nautical Miles to Radians
RAD_TO_NM				= 3437.7467707849392526;

# meters per second to Knots
MPS_TO_KT				= 1.9438444924406046432;

# Knots to meters per second
KT_TO_MPS				= 0.5144444444444444444;

# Feet per second to Knots
FPS_TO_KT				= 0.5924838012958962841;

# Knots to Feet per second
KT_TO_FPS				= 1.6878098571011956874;

# meters per second to Miles per hour
MPS_TO_MPH				= 2.2369362920544020312;

# meetrs per hour to Miles per second
MPH_TO_MPS				= 0.44704;

# Meters per second to Kilometers per hour
MPS_TO_KMH				= 3.6;

# Kilometers per hour to meters per second
KMH_TO_MPS				= 0.2777777777777777778;

# Pascal to Inch Mercury
PA_TO_INHG				= 0.0002952998330101010;

# Inch Mercury to Pascal
INHG_TO_PA				= 3386.388640341;

# slug/ft3 to kg/m3
SLUGFT3_TO_KGPM3		= 515.379;
