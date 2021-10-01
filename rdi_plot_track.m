ADCP=RDRADCP('Bl20120925100315_000r.000');
lon=ADCP.nav_longitude;
lat=ADCP.nav_latitude;
plot(lon(1:end-1),lat(1:end-1),'-b');
