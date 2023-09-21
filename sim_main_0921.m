close all
clear all
clc

len         = 18432; % page_size
read_ref    = -50:2:50;
rr_num      = length(read_ref);
cell_num    = zeros(rr_num - 1, 1);
cnt_pattern = zeros(rr_num, 8);
Data        = zeros(3*8*len, rr_num);
LP_data     = zeros(len, rr_num);
MP_data     = zeros(len, rr_num);
UP_data     = zeros(len, rr_num);
for i = 1:rr_num
    file_name     = strcat('D:\DSP_7030\LLR_7030\llr_data\rr',num2str(i), '\ch0_ce0_die0_plane0_block3.bin');
    fid           = fopen(file_name, 'rb');
    Data(:, i)    = fread(fid, 3 * 8 * len, 'uint8');
    LP_data(:, i) = Data(0*len+1:1*len, i);
    MP_data(:, i) = Data(1*len+1:2*len, i);
    UP_data(:, i) = Data(2*len+1:3*len, i);
end
save LP_Data.mat
save MP_Data.mat
save UP_Data.mat
save Data.mat
gray_code = [111, 110, 100, 000, 010, 011, 001, 101];
% cnt_cell  = zeros(rr_num, 8);
cnt_111 = zeros(51, 1);
cnt_110 = zeros(51, 1);
cnt_100 = zeros(51, 1);
cnt_000 = zeros(51, 1);
cnt_010 = zeros(51, 1);
cnt_011 = zeros(51, 1);
cnt_001 = zeros(51, 1);
cnt_101 = zeros(51, 1);
for i = 1:rr_num
    for j = 1:len
        data = [UP_data(j, i) MP_data(j, i) LP_data(j, i)];
        data_mat = de2bi(data, 'left-msb');
        pattern  = zeros(rr_num, 3);
        for k = 1:size(data_mat, 2)
            pattern(i, 1) = data_mat(1, k);
            pattern(i, 2) = data_mat(2, k);
            pattern(i, 3) = data_mat(3, k);
            pattern_val   = bi2de(pattern(i, :), 'left-msb');
            if(pattern_val == 7)     % 111
                cnt_111(i) = cnt_111(i) + 1;
            elseif(pattern_val == 6)
                cnt_110(i) = cnt_110(i) + 1;
            elseif(pattern_val == 4)
                cnt_100(i) = cnt_100(i) + 1;
            elseif(pattern_val == 0)
                cnt_000(i) = cnt_000(i) + 1;
            elseif(pattern_val == 2)
                cnt_010(i) = cnt_010(i) + 1;
            elseif(pattern_val == 3)
                cnt_011(i) = cnt_011(i) + 1;
            elseif(pattern_val == 1)
                cnt_001(i) = cnt_001(i) + 1;
            elseif(pattern_val == 5)
                cnt_101(i) = cnt_101(i) + 1;
            else
                fprintf('>> Error Pattern!\n');
            end
        end
    end
end
figure(1)
subplot(2, 2, 1)
histogram(cnt_111);
grid on;
subplot(2, 2, 2)
histogram(cnt_110);
grid on;
subplot(2, 2, 3)
histogram(cnt_100);
grid on;
subplot(2, 2, 4)
histogram(cnt_000);
grid on;

% data_diff = zeros(rr_num - 1, 8);
% for i = 1:rr_num - 1
%     data_diff(i, :) = abs(cnt_cell(i+1, :) - cnt_cell(i, :));
% end
% plot(-48:2:50, data_diff(:, 1), 'r-*');
% hold on
% plot(-48:2:50, data_diff(:, 2), 'g-*');
% plot(-48:2:50, data_diff(:, 3), 'b-*');
% plot(-48:2:50, data_diff(:, 4), 'y-*');
% plot(-48:2:50, data_diff(:, 5), 'c-*');
% plot(-48:2:50, data_diff(:, 6), 'r-.*');
% plot(-48:2:50, data_diff(:, 7), 'g-.*');
% plot(-48:2:50, data_diff(:, 8), 'y-.*');
% grid on
%     count_rr_111 = 0;
%     count_rr_110 = 0;
%     count_rr_100 = 0;
%     count_rr_000 = 0;
%     count_rr_010 = 0;
%     count_rr_011 = 0;
%     count_rr_001 = 0;
%     count_rr_101 = 0;
%     cnt_pattern(rr_num, :) = 0;
%     for i = 1:len
%         data = [LP_data(i) MP_data(i) UP_data(i)];
%         data_mat = de2bi(data, 'left-msb');
%         for j = 1:size(data_mat, 2)
%             pattern = [data_mat(1, j), data_mat(2, j), data_mat(3, j)];
%             if(data_mat(1, j) == 1     && data_mat(2, j) == 1 && data_mat(3, j) == 1)
%                 count_rr_111 = count_rr_111 + 1;
%             elseif(data_mat(1, j) == 1 && data_mat(2, j) == 1 && data_mat(3, j) == 0)
%                 count_rr_110 = count_rr_110 + 1;
%             elseif(data_mat(1, j) == 1 && data_mat(2, j) == 0 && data_mat(3, j) == 0)
%                 count_rr_100 = count_rr_100 + 1;
%             elseif(data_mat(1, j) == 0 && data_mat(2, j) == 0 && data_mat(3, j) == 0)
%                 count_rr_000 = count_rr_000 + 1;
%             elseif(data_mat(1, j) == 0 && data_mat(2, j) == 1 && data_mat(3, j) == 0)
%                 count_rr_010 = count_rr_010 + 1;
%             elseif(data_mat(1, j) == 0 && data_mat(2, j) == 1 && data_mat(3, j) == 1)
%                 count_rr_011 = count_rr_011 + 1;
%             elseif(data_mat(1, j) == 0 && data_mat(2, j) == 0 && data_mat(3, j) == 1)
%                 count_rr1_001 = count_rr1_001 + 1;
%             elseif(data_mat(1, j) == 1 && data_mat(2, j) == 0 && data_mat(3, j) == 1)
%                 count_rr_101 = count_rr_101 + 1;
%             else
%                 fprintf('>> Error pattern!\n');
%             end
%         end
%     end
% end
% res_name = 'cnt_res_1142.txt';
% fid = fopen(res_name, 'a+');
% fprintf(fid, '%d %d %d %d %d %d %d %d\n', count_rr_111, count_rr_110, count_rr_100, count_rr_000, count_rr_010, count_rr_011, count_rr1_001, count_rr_101);
% fclose(fid);