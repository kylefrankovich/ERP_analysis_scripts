
ERP_data_folder = '/Users/kfranko/Box Sync/ERP_experiment_data/LOTP_4AFC_processed_data/';
subject_list = {'S01','S03','S04','S05','S06','S07','S08','S09','S12','S13','S14','S16','S17','S18','S19'};

numsubjects = length(subject_list); % number of subjects

% review subs: S06: 5; S07: 6; S09: 8; S12: 9; S16: 12; S18: 14;
% 

cur_sub = 14;
sub_folder = fullfile(ERP_data_folder, subject_list(cur_sub), '/');

fprintf('\n******\nProcessing subject %s\n******\n\n', subject_list{cur_sub});
ERP = pop_loaderp( 'filename', 'ERP_collapsed_res_EM.erp', 'filepath', char(sub_folder) );
ERP = pop_binoperator( ERP, {  'b7 = (b5-b6) Label Left - Right'}); % add difference wave
% ERP = pop_ploterps( ERP, [ 5 6],33 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 6], 'ChLabel', 'on', 'FontSizeChan',10, 'FontSizeLeg',12, 'FontSizeTicks',10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' }, 'LineWidth',1, 'Maximize', 'on', 'Position', [ 103.667 29.6364 107 32], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',0, 'xscale', [ -200.0 698.0 -200:100:600 ], 'YDir', 'normal' );
% from Jackie:
ERP = pop_ploterps( ERP,  [5 6 7], 33 , 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 1 1], 'ChLabel', 'on', 'FontSizeChan',...
  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' }, 'LineWidth',  1, 'Maximize', 'off',...
 'Position', [ 103.667 29.6667 106.833 31.9167], 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0, 'xscale', [ -200.0 698.0 -200:100:600 ],...
 'YDir', 'normal', 'yscale',  [ -6.4 6.4   -6.4:.8:6.4 ] );
