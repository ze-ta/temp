close all
clear all
clc

len  = 18432; % page_size
read_ref = -50:2:50;
% fid  = fopen('./rr1/ch0_ce0_die0_plane0_block3.bin', 'rb');
% Data = fread(fid, len * 8 * 3, 'uint8');
% LP_data = Data(0*len+1:1*len);
% MP_data = Data(1*len+1:2*len);
% UP_data = Data(2*len+1:3*len);
rr_num = length(read_ref);
cell_num = zeros(rr_num-1, 1);
cnt_pattern = zeros(rr_num, 8);
data = zeros(3*8*len, rr_num);
LP_data = zeros(len, rr_num);
MP_data = zeros(len, rr_num);
UP_data = zeros(len, rr_num);

for j = 1:rr_num
    file_name = strcat('../llr_data/rr', num2str(j), '/ch0_ce0_die0_plane0_block3.bin');
    fid = fopen(file_name, 'rb');
    data(:, j) = fread(fid, 3*8*len, 'uint8');
    LP_data(:, j) = data(0*len+1:1*len, j);
    MP_data(:, j) = data(1*len+1:2*len, j);
    UP_data(:, j) = data(2*len+1:3*len, j);
end

gray_code = [111, 110, 100, 000, 010, 011, 001, 101];
cnt_cell  = zeros(rr_num, 8);

pattern = zeros(rr_num, 3);
pattern_val = zeros(rr_num, 1);
for j = 2:rr_num
    for i = 1:len
        tmp_data = [UP_data(i, j) MP_data(i, j) LP_data(i, j)];
        data_mat = de2bi(tmp_data, 'left-msb');
        for k = 1:size(data_mat, 2)
            pattern(j, 1) = data_mat(1, k);
            pattern(j, 2) = data_mat(2, k);
            pattern(j, 3) = data_mat(3, k);
            pattern_val(j) = bi2de(pattern(j, :), 'left-msb');
            if(pattern_val(j-1) == 7)     % 111
                if(pattern_val(j) == 6)
                    cnt_cell(j-1, 1) = cnt_cell(j-1, 1) + 0;
                    cnt_cell(j, 2)   = cnt_cell(j, 2) + 1;
                else
                    cnt_cell(j-1, 1) = cnt_cell(j-1, 1) + 1;
                end
            elseif(pattern_val(j-1) == 6) % 110
                if(pattern_val(j) == 4)
                    cnt_cell(j-1, 2) = cnt_cell(j-1, 2) + 0;
                    cnt_cell(j, 3)   = cnt_cell(j, 3) + 1;
                else
                    cnt_cell(j-1, 2) = cnt_cell(j-1, 2) + 1;
                end
            elseif(pattern_val(j-1) == 4) % 100
                if(pattern_val(j) == 0)
                    cnt_cell(j-1, 3) = cnt_cell(j-1, 3) + 0;
                    cnt_cell(j, 4) = cnt_cell(j, 4) + 1;
                else
                    cnt_cell(j-1, 3) = cnt_cell(j-1, 3) + 1;
                end
            elseif(pattern_val(j-1) == 0) % 000
                if(pattern_val(j) == 2)
                    cnt_cell(j-1, 4) = cnt_cell(j-1, 4) + 0;
                    cnt_cell(j, 5) = cnt_cell(j, 5) + 1;
                else
                    cnt_cell(j-1, 4) = cnt_cell(j-1, 4) + 1;
                end
            elseif(pattern_val(j-1) == 2) % 010
                if(pattern_val(j) == 3)
                    cnt_cell(j-1, 5) = cnt_cell(j-1, 5) + 0;
                    cnt_cell(j, 6) = cnt_cell(j, 6) + 1;
                else
                    cnt_cell(j-1, 5) = cnt_cell(j-1, 5) + 1;
                end
            elseif(pattern_val(j-1) == 3) % 011
                if(pattern_val(j) == 1)
                    cnt_cell(j-1, 6) = cnt_cell(j-1, 6) + 0;
                    cnt_cell(j, 7) = cnt_cell(j, 7) + 1;
                else
                    cnt_cell(j-1, 6) = cnt_cell(j-1, 6) + 1;
                end
            elseif(pattern_val(j-1) == 1) % 001
                if(pattern_val(j) == 5)
                    cnt_cell(j-1, 7) = cnt_cell(j-1, 7) + 0;
                    cnt_cell(j, 8) = cnt_cell(j, 8) + 1;
                else
                    cnt_cell(j-1, 7) = cnt_cell(j-1, 7) + 1;
                end
            elseif(pattern_val(j-1) == 5) % 101
                cnt_cell(j, 8) = cnt_cell(j, 8) + 1;
            else
                fprintf('>> Error Pattern!\n');
            end
        end
    end
end

data_diff = zeros(rr_num - 1, 8);
for j = 1:rr_num-1
    data_diff(j, :) = abs(cnt_cell(j + 1, :) - cnt_cell(j, :));
end
plot(read_ref(2:end), data_diff(:, 1), 'r-*');
hold on;
plot(read_ref(2:end), data_diff(:, 2), 'b-*');
grid on;
xlabel('read ref voltage');
ylabel('number of cells');
title('Vth');
