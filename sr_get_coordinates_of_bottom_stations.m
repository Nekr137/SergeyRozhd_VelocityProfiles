function [ABS1_adcp300, ABS2_DVS, ABS2_RCM] = sr_get_coordinates_of_bottom_stations() 

ABS1_adcp300 = [45.2075	36.43902];
ABS2_DVS = [45.27137 36.42768];
ABS2_RCM = [45.21078 36.54955];

ABS1_adcp300 = flip(ABS1_adcp300);
ABS2_DVS = flip(ABS2_DVS);
ABS2_RCM = flip(ABS2_RCM);

end