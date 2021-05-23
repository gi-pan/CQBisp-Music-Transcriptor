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

function nrg_envelope = duration_estim (STFT_vect, TF_events, start_id, end_id, onsets, oct_flag)

dim = length(TF_events);
nrg_envelope = {};
count = 0;
ons_TF = zeros(1,dim);
off_TF = zeros(1,dim);

for i = 1:dim
    ons_TF(i) = TF_events{1,i}(1);  
    off_TF(i) = TF_events{1,i}(2);  
end

diff_on  = find(ons_TF - start_id < 0);
diff_off = find(off_TF - end_id > 0);
    
if isempty(diff_on)
    start_event_no = 1;
else
    start_event_no = diff_on(end);
end
if isempty(diff_off)
    end_event_no = size(TF_events,2);
else
    end_event_no = diff_off(1);
end

    for o = start_event_no:end_event_no
      
        count = count + 1;
        STFT_env = STFT_vect(TF_events{1,o}(1):TF_events{1,o}(2));
        
        switch (oct_flag)
            case(1)
                thres = .6;
%             case(2)
%                 thres = .4;
            case(3)
                thres = .3;
            case(4)
                thres = .15;
            case(5) 
                thres = .4;
            otherwise
                thres = 0;
        end
        [val_att init_att] = max(STFT_env);
        int_ids = find(STFT_env ./ val_att > thres);
        init_id = int_ids(1);
        decay_id = int_ids(end);

            if (oct_flag == 1) || (oct_flag == 2)
                init_id=  max(init_id,init_att);
            end

            nrg_envelope{2,count} = [TF_events{1,o}(1) + init_id-1 TF_events{1,o}(1) + decay_id-1];
            nrg_envelope{1,count} = STFT_vect(nrg_envelope{2,count}(1):nrg_envelope{2,count}(2));

        scaled_start = TF_events{1,o}(1) + init_id-1;
        scaled_end = TF_events{1,o}(1) + decay_id-1;
        T_diff = onsets - scaled_start;
        
        if ~isempty(T_diff)
            
            [v_m real_on_id] = min(abs(T_diff));            % ONSET ALIGNMENT
            scaled_start2 = onsets(real_on_id);
            if scaled_start2 < scaled_end
                scaled_start = scaled_start2;
            end

            nrg_envelope{1,count} = STFT_vect(scaled_start : scaled_end);
            nrg_envelope{2,count} = [scaled_start scaled_end];
            
        end

    end

return