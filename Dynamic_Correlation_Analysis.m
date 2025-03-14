clear; clc; close all;

%% Parameter Settings
% Define multiple window widths (modify as needed)
window_widths = [7, 14, 21, 28];  

% Select correlation test method: 'Pearson' or 'Spearman'
correlation_method = 'Pearson';
fprintf('Selected correlation method: %s\n', correlation_method);

%% Step 1: Read Data from Excel
filename = 'sample_data.xlsx';  % Change filename as needed

% Read time data (range A4:A15)
time = readmatrix(filename, 'Range', 'A4:A15');

% Read header names from cells C3 and H3
header_C3 = readcell(filename, 'Range', 'C3');
header_H3 = readcell(filename, 'Range', 'H3');

% If the header is a cell array, extract the first element
if iscell(header_C3)
    header_C3 = header_C3{1};
end
if iscell(header_H3)
    header_H3 = header_H3{1};
end

% Check for missing or empty headers and assign default names if necessary
if isempty(header_C3) || isequal(header_C3, missing)
    header_C3 = "C3_data";
end
if isempty(header_H3) || isequal(header_H3, missing)
    header_H3 = "H3_data";
end

% Convert headers to string type
header_C3 = string(header_C3);
header_H3 = string(header_H3);

% Read raw data for the variable corresponding to header_C3 (range C4:E15, 3 measurements per time point)
raw_data_C3 = readmatrix(filename, 'Range', 'C4:E15');
% Read raw data for the variable corresponding to header_H3 (range H4:J15, 3 measurements per time point)
raw_data_H3 = readmatrix(filename, 'Range', 'H4:J15');

% Compute the mean of the three measurements for each time point
data_C3 = mean(raw_data_C3, 2);
data_H3 = mean(raw_data_H3, 2);

% Combine data into a table with dynamic variable names and display
data = table(time, data_C3, data_H3, 'VariableNames', {'Time', char(header_C3), char(header_H3)});
disp('Data read from Excel:');
disp(data);

%% Step 2: Interpolate and Smooth Data
% Generate a continuous integer time sequence from the minimum to maximum time
t_min = min(time);
t_max = max(time);
new_time = (t_min:1:t_max)';

% Perform linear interpolation for both variables
C3_interp = interp1(time, data_C3, new_time, 'linear');
H3_interp = interp1(time, data_H3, new_time, 'linear');
time_interp = new_time;

% Smooth the interpolated data using a moving average (window size = 1)
C3_smooth = smoothdata(C3_interp, 'movmean', 1);
H3_smooth = smoothdata(H3_interp, 'movmean', 1);

%% Plot Interpolated and Smoothed Data (dashed lines for raw interpolated data)
figure;
hold on;
color_C3 = [0 0.4470 0.7410];    % MATLAB default blue
color_H3 = [0.8500 0.3250 0.0980]; % MATLAB default reddish-orange

plot(time_interp, C3_interp, '--', 'Color', color_C3, 'DisplayName', header_C3 + " Raw Data");
plot(time_interp, C3_smooth, '-o', 'Color', color_C3, 'DisplayName', header_C3 + " Smoothed Data");
plot(time_interp, H3_interp, '--', 'Color', color_H3, 'DisplayName', header_H3 + " Raw Data");
plot(time_interp, H3_smooth, '-s', 'Color', color_H3, 'DisplayName', header_H3 + " Smoothed Data");

xlabel('Time');
ylabel('Value');
title('Interpolated and Smoothed Data (Raw Data in Dashed Lines)');
legend('show');
grid on;

%% Step 3: Correlation Test with Fixed C3 Window and Sliding H3 Window
N = length(time_interp);
all_results = [];  % Structure array to store results

for w = 1:length(window_widths)
    current_window_width = window_widths(w);
    if current_window_width > N
        continue;
    end
    % Fixed window for C3: take the first "current_window_width" points
    C3_fixed = C3_smooth(1:current_window_width);
    
    % Maximum possible lag ensuring H3 window is complete
    max_possible_lag = N - current_window_width;
    
    % Loop over each possible window lag from 1 to max_possible_lag
    for current_window_lag = 1:max_possible_lag
        H3_start = 1 + current_window_lag;
        H3_end = current_window_width + current_window_lag;
        if H3_end > N
            continue;
        end
        H3_window = H3_smooth(H3_start:H3_end);
        
        % Compute correlation
        if strcmpi(correlation_method, 'Pearson')
            [r, p] = corr(C3_fixed, H3_window, 'Type', 'Pearson');
        elseif strcmpi(correlation_method, 'Spearman')
            [r, p] = corr(C3_fixed, H3_window, 'Type', 'Spearman');
        else
            error('Unrecognized correlation method. Please choose "Pearson" or "Spearman".');
        end
        
        % Store results: record current window width, lag, and correlation values
        res_entry.window_width = current_window_width;
        res_entry.window_lag = current_window_lag;
        res_entry.r = r;
        res_entry.p = p;
        all_results = [all_results; res_entry];
        
        fprintf('Fixed window %s [1, %d] vs %s window [%d, %d], window_width = %d, window_lag = %d: r = %.3f, p = %.3f\n',...
            char(header_C3), current_window_width, char(header_H3), time_interp(H3_start), time_interp(H3_end), current_window_width, current_window_lag, r, p);
    end
end

%% Step 4: Visualize Results
% Plot correlation coefficient r versus window_lag for different window_widths
figure;
hold on;
colors = lines(length(window_widths));
for w = 1:length(window_widths)
    current_window_width = window_widths(w);
    indices = find([all_results.window_width] == current_window_width);
    if ~isempty(indices)
        lag_vals = [all_results(indices).window_lag];
        r_vals = [all_results(indices).r];
        plot(lag_vals, r_vals, '-o', 'LineWidth', 1.5, 'Color', colors(w,:), ...
            'DisplayName', sprintf('window\\_width = %d', current_window_width));
    end
end
xlabel('window\_lag');
ylabel('Correlation Coefficient r');
title([correlation_method, ' Correlation Coefficient vs. window\_lag']);
legend('show');
grid on;

% Plot p-values versus window_lag for different window_widths
figure;
hold on;
for w = 1:length(window_widths)
    current_window_width = window_widths(w);
    indices = find([all_results.window_width] == current_window_width);
    if ~isempty(indices)
        lag_vals = [all_results(indices).window_lag];
        p_vals = [all_results(indices).p];
        plot(lag_vals, p_vals, '-s', 'LineWidth', 1.5, 'Color', colors(w,:), ...
            'DisplayName', sprintf('window\\_width = %d', current_window_width));
    end
end
xlabel('window\_lag');
ylabel('p-value');
title('p-value vs. window\_lag');
yline(0.05, '--r', '0.05');  % Significance level reference line
legend('show');
grid on;

%% Step 5: Interpret the Results
alpha = 0.05;
fprintf('\n====== Interpretation of Correlation Test Results ======\n');
for k = 1:length(all_results)
    entry = all_results(k);
    if entry.p < alpha
        fprintf('window_width = %d, window_lag = %d: p = %.3f (< %.2f) —— Significant, r = %.3f, indicating a significant correlation between fixed %s window and %s window.\n', ...
            entry.window_width, entry.window_lag, entry.p, alpha, entry.r, char(header_C3), char(header_H3));
    else
        fprintf('window_width = %d, window_lag = %d: p = %.3f (>= %.2f) —— Not significant, r = %.3f.\n', ...
            entry.window_width, entry.window_lag, entry.p, alpha, entry.r);
    end
end
