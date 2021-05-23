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

function [mirex_list mirex_list_sec] = get_note_list(Mat, TF_Mat, onsets, f0_freqs, param, path_out)

mirex_list = [];
mirex_list_sec = [];
size_y = size(Mat,1);
nrg_env = {};

for id = 1:size_y - 1
    
    rho_vect = Mat(id,:);
    events = find(rho_vect ~= 0);
    
    if ~isempty(events)
        
        TF_events = get_STFT_row_events(TF_Mat(id,:));
        k = 1;
        count = 1;
        
        while k < length(events)
            if (events(k+1) - events(k) == 1) && k ~= length(events)-1    
                count = count + 1;
                k = k + 1;
                
            elseif ~isempty(TF_Mat(id,:))

                nrg_env = duration_estim(TF_Mat(id,:), TF_events , events(k)-count+1, events(k), onsets, fix(id/12)+1);
                env_col = size(nrg_env, 2);
                count = 1;
                
                if ~isempty(nrg_env) 
                             
                  for n = 1:env_col
                        onset_sample = nrg_env{2,n}(1);
                        onset_time = onset_sample * param.dt;
                        
                        offset_sample = nrg_env{2,n}(2);
                        offset_time = offset_sample * param.dt;
                        duration_sample = offset_sample - nrg_env{2,n}(1);
                        
                        if duration_sample > param.dt_coeff

                            mirex_list = [mirex_list ; onset_sample offset_sample f0_freqs(id)];
                            mirex_list_sec = [mirex_list_sec ; onset_time offset_time f0_freqs(id)];
                            
                        end
                        
                  end

                end
                k = k + 1;
            end
        end      
    end
    
end

if ~isempty(mirex_list)
    mirex_list = adjust(mirex_list);
    mirex_list_sec = adjust(mirex_list_sec);
end

% OUTPUT MULTIPLE F0-TRACKING FILE CREATION ----------------------------------------

% str1 = [path_out param.wavname '_F0_tracking_frames.txt'];    % Time expressed in frames
% fid = fopen(str1, 'w', 'n');
% fprintf(fid, datestr(now));
% fprintf(fid, '\r\n%d\t %d\t %6.3f', mirex_list');
% fclose(fid);

%str2 = [path_out param.wavname '_F0_tracking.txt'];             % Time expressed in seconds
str2 = char(strcat(path_out, '\', param.wavname, '_F0_tracking.txt'));   % MATLAB R2017a
fid = fopen(str2, 'w', 'n');
fprintf(fid, datestr(now));
fprintf(fid, '\r\n%6.3f\t%6.3f\t%6.3f', mirex_list_sec');
fclose(fid);

% ----------------------------------------------------------------------------------

return