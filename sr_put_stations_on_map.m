function sr_put_stations_on_map(ax)
coo = sr_get_station_coordinates();
plot(ax, coo(:, 1), coo(:, 2), 'k.')
lab = [{'st1'} {'st2'} {'st3'} {'st4'} {'st5'} {'st6'} {'st7'} {'st8'} {'st16'} {'st17'} {'st18'} {'st19'} {'st20'} {'st21'} {'st22'} {'st23'}];
for idx = 1:length(coo(1:8, :))
   sr_text(coo(idx,1), coo(idx,2), cell2mat(lab(idx)), 'bl', [0 0 0], 10);
end
for idx = 9:length(coo)
   sr_text(coo(idx,1), coo(idx,2), cell2mat(lab(idx)), 'tr', [0 0 0], 10);
end
end