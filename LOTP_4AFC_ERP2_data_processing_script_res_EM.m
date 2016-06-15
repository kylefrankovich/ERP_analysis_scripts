% LOTP_4AFC_ERP2 ERP data processing script (for detecting residual eye
% movements):

clear all
close all

ERP_data_folder = '/Users/kfranko/Box Sync/ERP_experiment_data/LOTP_4AFC_processed_data/';
ANALYSIS_DIR = ('/Users/kfranko/Desktop/ERP_analysis_scripts/');

subject_list = {'S01','S03','S04','S05','S06','S07','S08','S09','S12','S13','S14','S16','S17','S18','S19'};
subject_file_list = {'S1','S3','S4','S5','S6','S7','S8','S9','S12','S13','S14','S16','S17','S18','S19'};


numsubjects = length(subject_list); % number of subjects

file_name_template = '_LOTP_4AFC_ERP2_ERP.erp';

for i = 1:numsubjects
    
    fprintf('\n******\nProcessing subject %s\n******\n\n', subject_list{i});
    
    sub_folder = fullfile(ERP_data_folder, subject_list(i), '/');
    sub_data_file_name = [subject_file_list{i} file_name_template];
    
    % load averaged, artifact rejected ERP:
    
    % ERP = pop_loaderp( 'filename', 'S19_LOTP_4AFC_ERP2_ERP.erp', 'filepath', '/Users/kfranko/Box Sync/ERP_experiment_data/LOTP_4AFC_processed_data/S19/' ); 
    
    ERP = pop_loaderp( 'filename', sub_data_file_name, 'filepath', char(sub_folder) ); 
    
    % bin operations for collapsing to all left and right trials:
    ERP = pop_binoperator( ERP, [ANALYSIS_DIR 'LOTP_4AFC_collapse_residual_EM.txt']);
    erpname = strcat(sub_folder,'ERP_collapsed_res_EM.erp'); % name for erpset menu
    
    % save collapsed ERP to later review residual EMs:
    
    fname_erp = strcat(sub_folder,'ERP_collapsed_res_EM.erp');
    pop_savemyerp(ERP, 'erpname', char(erpname), 'filename', char(fname_erp));
    
    
end




