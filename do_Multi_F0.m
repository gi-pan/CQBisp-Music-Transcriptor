%{
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.
You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
%}

function [En_TF, mirex_list, mirex_list_sec, f0_frame_cell] = do_Multi_F0(path_in, wavname, path_out)

% CQBISP MUSIC TRANSCRIPTOR                VERSION 1
%(Created by: Pantaleo, G., Nesi, P., and Argenti, F. - Dep. of Systems and Informatics, University of Florence, Italy)
%
%
% [mirex_list mirex_list_sec f0_frame_cell] = do_Multi_F0(path_in, wavname, path_out);
% 
% 
% OUTPUTS --------------------
% 
% mirex_list        : Mirex format List of F0-tracking: 3-column array: mirex_list = [ONSET_samples    OFFSET_samples    F0s].
% 
% mirex_list_sec    : Mirex format List of F0-tracking: 3-column array: mirex_list = [ONSET_times    OFFSET_times    F0s].
% 
% f0_frame_cell     : Cell of 10 ms spaced frame - elements; each element contains a list of active estimated F0 at that frame.
% 
% 
% INPUTS ---------------------
% 
% path_in           : Absolute path of the folder in which the input .wav file is stored. Type the desired folder 
%                     path, ending with "\", for example 'C:\Mirex2009\Inputs\'.
% 
% wavname           : File name of the input .wav file, for example 'audio.wav' or simply 'audio'. The input audio 
%                     file is supposed to be a PCM .wav sampled at 44.1 kHz, 16 bits.
% 
% path_out          : Absolute path of the folder in which the output files will be stored. Type the desired folder 
%                     path, ending with "\", for example 'C:\Mirex2009\Outputs\'.
%                     The 'path_out' folder MUST already exist or it MUST have been created before.



% ---------- ----------- ####### ----------- -----------				

param.path_in = path_in;
param.wavname = wavname;

% CONSTANTS
param.block_length              = 220;
param.fc                        = 44100;				
param.dt                        = param.block_length/param.fc;			% Time Unit (sec.)
% param.win_analysis_length       = floor((param.block_length*(1+param.overlap_fact/100))/2)*2; % +1;
% param.win                       = hann(param.win_analysis_length);
param.win                       = hann(param.block_length);

% FILTER PARAMETERS 
param.num_ottave                = 9;    % Number of Octaves
param.guard_bins                = 1;

% 2D XCORRELATION THRESHOLD
param.xcorr_thres               = .5;

% SHORTEST TIME EVENT
param.dt_coeff                  = 10;

% ---------- ----------- ####### ----------- -----------


[STFT, En_TF, note_ax, ons] = wav2freq(param);

[mirex_list, mirex_list_sec, f0_frame_cell] = time_events(note_ax,param, STFT, En_TF, ons, path_out);

logappend('CQBisp Transcriptor','END Process');

return
