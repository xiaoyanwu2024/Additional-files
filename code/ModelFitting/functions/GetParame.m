%--------------------------------------------------------------------------
% Function Name: GetParame
% Author: Xiaoyan Wu (xiaoyan.psych@gmail.com)
% Date: May 20, 2024
% Usage: This script is used for generating parameter structure for all models
% Note: Path separators differ across operating systems.
%       Windows uses a backslash (\) as the path separator.
%       macOS/Linux use a forward slash (/) as the path separator.
%       Ensure you use the correct path separator for your operating system.
%--------------------------------------------------------------------------
function param = GetParame()
% M1: Baseline Model
param(1).param(1).name = 'b'; % cooperation rate
param(1).param(1).lb = 0;
param(1).param(1).ub = 1;

% M2: tit for tat
param(2).param(1).name = 'eps';
param(2).param(1).lb = 0;
param(2).param(1).ub = 1;

% M3: reward learning
param(3).param(1).name = 'learning rate';
param(3).param(1).lb = 0;
param(3).param(1).ub = 1;

param(3).param(2).name = 'decision temperature';
param(3).param(2).lb = 0;
param(3).param(2).ub = 10;

% M4:  inequality aversion with no learning
param(4).param(1).name = 'envy';
param(4).param(1).lb = 0;
param(4).param(1).ub = 10;

param(4).param(2).name = 'guilt';
param(4).param(2).lb = 0;
param(4).param(2).ub = 10;

param(4).param(3).name = 'decision temperature';
param(4).param(3).lb = 0;
param(4).param(3).ub = 10;

% M5: social reward model with no learning
param(5).param(1).name = 'social reward';
param(5).param(1).lb = 0;
param(5).param(1).ub = 10;

param(5).param(2).name = 'decision temperature';
param(5).param(2).lb = 0;
param(5).param(2).ub = 10;

% M6: social reward model with RL learning
param(6).param(1).name = 'learning rate';
param(6).param(1).lb = 0;
param(6).param(1).ub = 1;

param(6).param(2).name = 'social reward';
param(6).param(2).lb = 0;
param(6).param(2).ub = 10;

param(6).param(3).name = 'decision temperature';
param(6).param(3).lb = 0;
param(6).param(3).ub = 10;

% M7: social reward with influence model
param(7).param(1).name = 'learning rate';
param(7).param(1).lb = 0;
param(7).param(1).ub = 1;

param(7).param(2).name = 'kapa';
param(7).param(2).lb = 0;
param(7).param(2).ub = 1;

param(7).param(3).name = 'social reward';
param(7).param(3).lb = 0;
param(7).param(3).ub = 10;

param(7).param(4).name = 'decision temperature';
param(7).param(4).lb = 0;
param(7).param(4).ub = 10;

% M8: social reward with positive and negative alphas
param(8).param(1).name = 'positive learning rate';
param(8).param(1).lb = 0;
param(8).param(1).ub = 1;

param(8).param(2).name = 'negative learning rate';
param(8).param(2).lb = 0;
param(8).param(2).ub = 1;

param(8).param(3).name = 'social reward';
param(8).param(3).lb = 0;
param(8).param(3).ub = 50;

param(8).param(4).name = 'decision temperature';
param(8).param(4).lb = 0;
param(8).param(4).ub = 10;