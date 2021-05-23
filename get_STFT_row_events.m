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

function TF_events = get_STFT_row_events(STFT_vect)

k = 1;
group_event_flag = 0;
start_flag = 0;
op_flag = 0;
del_grp = 0;

TF_events = {};

STFT_vect = smooth(STFT_vect,5);

min_id = find(imregionalmin(STFT_vect))';
max_id = find(imregionalmax(STFT_vect))';

if length(min_id) < 2
    stop_flag = 1;
end

for m_k = 2:length(min_id)
    if min_id(m_k) - min_id(m_k - 1) == 1
        del_grp = del_grp + 1;
    elseif del_grp ~= 0
        min_id(m_k - del_grp : m_k - 1) = 0;
        del_grp = 0;
    end
end

min_id(min_id == 0) = [];

if min_id(1) == 1
    min_id = min_id(1:end-1);
end

    shift_flag = 1;
    ptr = k+shift_flag+group_event_flag;
    
    if ptr == 1
        stop_flag = 1;
    end
    
    while (ptr < length(min_id)) && (ptr < length(max_id))
    
        id1_max = max_id(ptr);
        id2_max = max_id(ptr-1);
        id1_min = min_id(k+group_event_flag+1);
        ratio = STFT_vect(id1_max) / STFT_vect(id1_min);
        ratio2 = STFT_vect(id2_max) / STFT_vect(id1_min);
        min_begin = min_id(k+group_event_flag-op_flag)+1;
        min_end = min_id(k+1+group_event_flag);
        
        if (ratio > 1.08) && (min_end - min_begin > 5)
            
            TF_events{1,k+start_flag} = [min_begin   min_end];
            k = k + 1;
            ptr = k+shift_flag+group_event_flag;
            op_flag = 0;
            
        else
            
            group_event_flag = group_event_flag + 1;
            op_flag = op_flag + 1;
            ptr = k+shift_flag+group_event_flag;
            
        end
        
    end
        
        k = k+1+shift_flag+group_event_flag - 2;
        TF_events{1,size(TF_events,2)+1} = [min_id(k)+1   min_id(k+1)];

    if min_id(k+1) == min_id(end)
        TF_events{1,size(TF_events,2)+1} = [min_id(end)+1   length(STFT_vect)-1];
    end
    
return