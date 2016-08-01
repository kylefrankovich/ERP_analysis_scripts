% LOTP_4AFC_ERP2 ERP data processing script:

% script loads previously created erp files and adds occipital electrode
% site, outputs new erp file for erp measurement

% importing file parameters:

clear all
close all

subject_list = {'S01','S03','S04','S05','S06','S07','S08','S09','S12','S13','S14','S16','S17','S18', 'S19', 'S20', 'S21'};
subject_numbers = {'S1','S3','S4','S5','S6','S7','S8','S9','S12','S13','S14','S16','S17','S18', 'S19', 'S20', 'S21'};
num_subs = length(subject_list);


ERP_data_folder = '/Users/kfranko/Desktop/LOTP_ERP_data/';
ANALYSIS_DIR = ('/Users/kfranko/Desktop/ERP_analysis_scripts/');


file_name_template = '_LOTP_4AFC_ERP2_';



for i = 1:num_subs
    
    sub_data_folder = char(subject_list(i));
    sub_num = char(subject_numbers(i));
    data_directory = fullfile(ERP_data_folder, sub_data_folder);
    file_name = [sub_num file_name_template];
    
    % load current sub
    ERP = pop_loaderp( 'filename', [file_name 'ERP_contra_ipsi_diff_blocked_mixed.erp'], 'filepath', [data_directory '/'] );
    
    % add occipital electrode site:
    ERP = pop_erpchanoperator( ERP, {  'ch12 = (ch5+ch6+ch7+ch9+ch10+ch11)/6 label occipital average'} , 'ErrorMsg', 'popup', 'Warning', 'on' );
    
    
    % save new erp:
    erpname = [data_directory,'/',sub_num,file_name_template,'ERP_collapse_blocked_mixed_occip.txt'];  % name for erpset menu
    
    
    
    
    ERP = pop_binoperator( ERP, [ANALYSIS_DIR 'LOTP_4AFC_collapse_blocked_mixed.txt']);
    erpname = [data_directory,'/',sub_num,file_name_template,'ERP_collapse_blocked_mixed_occip.txt'];  % name for erpset menu
    
    
    % Now we will do bin operations using a set of equations
    % stored in the file 'fast_contra_ipsi_bin_operations.txt';
    
    ERP = pop_binoperator( ERP, [ANALYSIS_DIR 'contra_ipsi_bin_operators_blocked_mixed.txt']);
    erpname = [data_directory,'/',sub_num,file_name_template,'ERP_contra_ipsi_diff_blocked_mixed'];  % name for erpset menu
    fname_erp = [data_directory,'/',sub_num,file_name_template,'ERP_contra_ipsi_diff_blocked_mixed.erp'];
    pop_savemyerp(ERP, 'erpname', erpname, 'filename', fname_erp);
    
    fprintf('\n\n\n**** subject %s processed! ****\n\n\n', sub_num);
    
    
    
end