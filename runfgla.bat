D:
cd D:\FlightGear\FlightGear 2020.3

SET FG_ROOT=D:\FlightGear\FlightGear 2020.3\data
SET FG_SCENERY=D:\FlightGear\FlightGear 2020.3\data\Scenery
.\\bin\fgfs --aircraft=Aerocar --fdm=network,localhost,5003,5004,5005 --fog-nicest --enable-clouds --start-date-lat=2004:06:01:09:00:00 --disable-sound --visibility=15000 --in-air --disable-freeze --airport=KSFO --runway=10L --altitude=1000 --heading=0 --offset-distance=0 --offset-azimuth=0 --enable-rembrandt --multiplay=out,60,127.0.0.1,6001 --multiplay=in,60,127.0.0.1,6000 --callsign=Test2
