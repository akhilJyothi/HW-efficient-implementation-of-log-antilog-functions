% Inputs
N = 40;
% Lower half: 32 segments in [0, 0.5)
edges_low = linspace(0, 0.5, 33);
% Upper half: 8 segments in [0.5, 1)
edges_high = linspace(0.5, 1, 9);
% Combine (avoid duplicate 0.5)
edges = [edges_low, edges_high(2:end)];

% Dense sampling
m = linspace(0, 1, 200000);
y = log2(1 + m);

% Output arrays
a = zeros(1, N);
b = zeros(1, N);

% Compute a_i, b_i for each segment
for i = 1:N
    idx = (m >= edges(i)) & (m < edges(i+1));
    x_seg = m(idx);
    y_seg = y(idx);
    x_local = x_seg - edges(i);
    p = polyfit(x_local, y_seg, 1);
    a(i) = p(1);
    b(i) = p(2);
end

FRAC = 14;
scale = 2^FRAC;
a_q = round(a * scale);
b_q = round(b * scale);
edges_q14_to_q10 = round((edges + 1) * 2^10);

% --- Write edges.mem ---
fid = fopen('edges.mem', 'w');
for i = 1:length(edges_q14_to_q10)
    fprintf(fid, '%03X\n', edges_q14_to_q10(i));
end
fclose(fid);

% --- Write a_lut.mem ---
fid = fopen('a_lut.mem', 'w');
for i = 1:N
    fprintf(fid, '%04X\n', typecast(int16(a_q(i)), 'uint16'));
end
fclose(fid);

% --- Write b_lut.mem ---
fid = fopen('b_lut.mem', 'w');
for i = 1:N
    fprintf(fid, '%04X\n', typecast(int16(b_q(i)), 'uint16'));
end
fclose(fid);

disp('Done! edges.mem, a_lut.mem and b_lut.mem generated.');