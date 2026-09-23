% function f = fogging_factor(t)
% 
% % t in days since 1-Jan-2026
% 
% day = mod(t,365);
% 
% % fogging months example: July–October
% start_day = 273;  % July 1
% end_day   = 364;  % October 31
% 
% if day >= start_day && day <= end_day
%     f=12/(end_day - start_day); %number of fogging events/duration
% %     fogging every 7 days
% %     if mod((day-start_day),7) == 0
% %         f = 1;
% %     else
% %         f = 0;
% %     end
%     
% else
%     f = 0;
% end
% 
% end


function f = fogging_factor(t)

% t in days since 1-Jan-2026

day = mod(t,365);

% ===== USER INPUT ONLY THESE =====
start_day = 151;   % example: Nov 1
end_day   = 272;    % example: Jan 31
events_per_season = 17;
% =================================

% compute duration automatically
if end_day >= start_day
    
    duration = end_day - start_day + 1;
    
    in_period = (day >= start_day && day <= end_day);
    
else
    
    duration = (365 - start_day) + (end_day + 1);
    
    in_period = (day >= start_day || day <= end_day);
    
end

% constant fogging rate during fogging period
if in_period
    
    f = 0.6*(events_per_season / duration);
    
else
    
    f = 0;
    
end

end