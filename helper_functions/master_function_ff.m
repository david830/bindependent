%% Master File for Running Feed-Forward Predictions
% Demarcus Briers, May 2015

%HOW TO USe THIS FILE
%1. Make sure this file and prediction code is in YOUR Matlab PATH. 
% Change the name of this folder to where this file is located
addpath('E:\BU\Belta Rotation\Weiss Lab\test_dir\complex_prediction')


%2. Run this file with the command below. Warning, matlab objects,figs, and PNG images will be created:
% matlab -nosplash -nodesktop -r "master_function;exit" -logfile master_log.txt


%% MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%% 

%1
%Function: Load the devices aka "library of parts" and normalize Input to a single curve instead of
%          multiple curves seperated by Plasmid Copy Number bin.
%Input:
%  (1) ../controls/expression_calibration_2/ExpressionCalibration 
%  (2)  ../devices/LmrA/LmrA-Fine.mat
%  (3) ../devices/TAL14/TAL14-Fine.mat
%  (4) ../devices/TAL21/TAL21-Fine.mat
%
%Output:
%  (1) device_data_set.mat
run('load_device_data.m');


%% 2
%input:
%  (1) device_data_set [from load_device_data.m]
%
%output:
%  (1) circuits.mat
run('load_circuit_data.m');


%% 3
%input
%  (1) circuits [load_circuit_data.m]
%output
%  (1) circuit_predictions.mat
run('predict_circuits.m');

%% 4
% Function:
%
%Input:
% (1) device_data_set
% (2) circuits
% (3) circuit_predictions
%
%Output:
%   Many matlab figures
run('plot_circuit_predictions.m');

