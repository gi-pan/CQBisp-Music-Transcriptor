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

function Clean_Matrix = TF_clean (TF_matrix, clean_mode, coeff)

[size_y size_x] = size(TF_matrix);

switch (clean_mode)
    
    case(0)     % temporal cleaning only
        
        for id = 1:size_y
            count = 1;
            start = 1;
            events = find(TF_matrix(id,:) ~= 0);
            if ~isempty(events)
                if length(events) == 1
                   TF_matrix(id,events) = 0;
                end
                for k = 1:length(events)-1
                    if events(k+1) - events(k) == 1
                        count = count + 1;
%                     elseif (events(k+1) - events(k)) <= coeff     % 22 -> 45     
%                         diff = events(k+1) - events(k);
%                         for num = 1:diff - 1
%                             count = count + 1;
%                             interp_nrg = num * ((TF_matrix(id,events(k+1)) - TF_matrix(id,events(k))) / diff);
%                             TF_matrix(id,events(k) + num) = TF_matrix(id,events(k)) + interp_nrg;
%                         end
                    elseif count <= coeff % && isempty(find(TF_matrix(id , events(k)+1-count : events(k)) ./ max(max(TF_matrix)) > .35))  % 18 --> 35
                        if start == 1
                            TF_matrix(id,events(1):(events(k) + 1)) = 0;
                            count = 1;
                            start = k + 1;
                        else
                            TF_matrix(id,events(start):(events(k) + 1)) = 0;
                            count = 1;
                            start = k + 1;
                        end
                    else 
                        count = 1;
                        start = k + 1;
                    end   
                end    
                if count <= coeff % && isempty(find(TF_matrix(id , events(k)+1-count : events(k)) ./ max(max(TF_matrix)) > .35))    %  18 --> 35
                    if start == 1
                        TF_matrix(id,events(1):(events(k + 1))) = 0;
                    else
                        TF_matrix(id,events(start):(events(k + 1))) = 0;
                    end
                end
            end
        end
        
        thres = mean(mean(TF_matrix))*3;
        for id = 1:size_x    
            vector = TF_matrix(:,id);
            [ind peak] = findpeaks(vector);
            [peak_max ind_max] = max(peak);
            if peak_max ~= 0 
%                soglia = peak_max * thres;
               vector(find(vector < thres)) = 0;        % si eliminano i picchi locali inferiori alla soglia di energia
            end
            TF_matrix(1:end,id) = vector;
        end
        
        Clean_Matrix = TF_matrix;
        
    
    case(1)     % rho-gram cleaning
        
        thres = .1;
        
        % amplitude cleaning -----------------------------------------

%         if poly == 1
%             peak_max = max(mean(TF_matrix));
%             TF_matrix(find(TF_matrix < peak_max * thres)) = 0;   
%         else
            for id = 1:size_x    
                vector = TF_matrix(:,id);
                [ind peak] = findpeaks(vector);
                [peak_max ind_max] = max(peak);
                if peak_max ~= 0 
                   soglia = peak_max * thres;
                   vector(find(vector < soglia)) = 0;        % pruning of local peaks undert the defined threshold
                end
                TF_matrix(1:end,id) = vector;
            end
%         end
               
        % temporal cleaning ------------------------------------------
        for id = 1:size_y
            count = 1;
            start = 1;
            events = find(TF_matrix(id,:) ~= 0);
            if ~isempty(events)
                if length(events) == 1
                   TF_matrix(id,events) = 0;
                end
                for k = 1:length(events)-1
                    if events(k+1) - events(k) == 1
                        count = count + 1;
%                     elseif (events(k+1) - events(k)) <= 10     % 22 -> 45     
%                         diff = events(k+1) - events(k);
%                         for num = 1:diff - 1
%                             count = count + 1;
%                             interp_nrg = num * ((TF_matrix(id,events(k+1)) - TF_matrix(id,events(k))) / diff);
%                             TF_matrix(id,events(k) + num) = TF_matrix(id,events(k)) + interp_nrg;
%                         end
                    elseif count <= coeff % && isempty(find(TF_matrix(id , events(k)+1-count : events(k)) ./ max(max(TF_matrix)) > .35))  % 18 --> 35
                        if start == 1
                            TF_matrix(id,events(1):(events(k) + 1)) = 0;
                            count = 1;
                            start = k + 1;
                        else
                            TF_matrix(id,events(start):(events(k) + 1)) = 0;
                            count = 1;
                            start = k + 1;
                        end
                    else 
                        count = 1;
                        start = k + 1;
                    end   
                end    
                if count <= coeff % && isempty(find(TF_matrix(id , events(k)+1-count : events(k)) ./ max(max(TF_matrix)) > .35))    %  18 --> 35
                    if start == 1
                        TF_matrix(id,events(1):(events(k + 1))) = 0;
                    else
                        TF_matrix(id,events(start):(events(k + 1))) = 0;
                    end
                end
            end
        end
        
        Clean_Matrix = TF_matrix;

        
    case(2)    % spectrogram cleaning
        
        thres = .01;
      
        % amplitude cleaning -----------------------------------------
        for id = 1:size_x    
            vector = TF_matrix(:,id);
            [ind peak] = findpeaks(vector);
            [peak_max ind_max] = max(peak);
            if peak_max ~= 0 
               soglia = peak_max * thres;
               vector(find(vector < soglia)) = 0;           % pruning of local peaks undert the defined threshold
            end
            TF_matrix(1:end,id) = vector;
        end
               
        % temporal cleaning ------------------------------------------
        for id = 1:size_y - 1
            count = 1;
            start = 1;
            events = find(TF_matrix(id,:) ~= 0);
            if ~isempty(events)
                if length(events) == 1
                   TF_matrix(id,events) = 0;
                end
                for k = 1:length(events)-1
                    if events(k+1) - events(k) == 1
                        count = count + 1;
%                     elseif (events(k+1) - events(k)) <= 10               
%                         diff = events(k+1) - events(k);
%                         for num = 1:diff - 1
%                             count = count + 1;
%                             interp_nrg = num * ((TF_matrix(id,events(k+1)) - TF_matrix(id,events(k))) / diff);
%                             TF_matrix(id,events(k) + num) = TF_matrix(id,events(k)) + interp_nrg;
%                         end
                    elseif count <= 25
                        if start == 1
                            TF_matrix(id,events(1):(events(k) + 1)) = 0;
                            count = 1;
                            start = k + 1;
                        else
                            TF_matrix(id,events(start):(events(k) + 1)) = 0;
                            count = 1;
                            start = k + 1;
                        end
                    else 
                        count = 1;
                        start = k + 1;
                    end   
                end    
                if count <= 25
                    if start == 1
                        TF_matrix(id,events(1):(events(k + 1))) = 0;
                    else
                        TF_matrix(id,events(start):(events(k + 1))) = 0;
                    end
                end
            end
        end
        
        Clean_Matrix = TF_matrix;
             
end


return