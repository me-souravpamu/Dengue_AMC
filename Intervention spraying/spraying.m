% %%Once spraying
% %-------------------------------------------------------------
% %-------------------------------------------------------------
% 
% function f = spraying(t)
% 
% % t in days since 1-Jan-2026
% 
% day = mod(t,365);
% 
% % ===== USER INPUT ONLY THESE =====
% start_day = 212;     % example: Jan 2 (use 0 for Jan 1)
% end_day   = 30;   % example: June 30
% % =================================
% 
% f0 = 0.25;
% 
% %% determine duration correctly
% 
% if start_day <= end_day
%     
%     duration = end_day - start_day + 1;
%     
%     in_cycle = (day >= start_day && day <= end_day);
%     
%     tau = day - start_day;
%     
% else
%     
%     duration = (365 - start_day) + (end_day + 1);
%     
%     in_cycle = (day >= start_day || day <= end_day);
%     
%     tau = mod(day - start_day,365);
%     
% end
% 
% %% apply quadratic decay only during spraying period
% 
% if in_cycle
%     
%     f = f0 * (1 - (tau/duration)^2);
%     
% else
%     
%     f = 0;
%     
% end

% end
%%Twice spraying
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
% function f = spraying(t)
% 
% % t in days since 1-Jan-2026
% 
% day = mod(t,365);
% 
% % ===== USER INPUT ONLY THESE =====
% start_day = 01;   % example: July 1
% end_day   = 180;   % example: Dec 31
% % =================================
% 
% f0 = 0.25;
% 
% %% determine duration of first cycle correctly
% 
% if start_day <= end_day
%     
%     duration1 = end_day - start_day + 1;
%     
%     in_cycle1 = (day >= start_day && day <= end_day);
%     
%     tau1 = day - start_day;
%     
% else
%     
%     duration1 = (365 - start_day) + (end_day + 1);
%     
%     in_cycle1 = (day >= start_day || day <= end_day);
%     
%     tau1 = mod(day - start_day,365);
%     
% end
% 
% %% second cycle fills remaining year
% 
% duration2 = 365 - duration1;
% 
% if in_cycle1
%     
%     tau = tau1;
%     duration = duration1;
%     
% else
%     
%     tau = mod(day - end_day - 1,365);
%     duration = duration2;
%     
% end
% 
% %% quadratic decay
% 
% f = f0 * (1 - (tau/duration)^2);
% 
% end

function f = spraying(t)

% t in days since 1-Jan-2026

start_day = 151;   % Aug 1
end_day   = 333;    % Jan 31

f0 = 0.25;

day = mod(t,365);

%% prevent spraying before first start_day in simulation
if t < start_day
    f = 0;
    return
end

%% determine duration

if start_day <= end_day
    
    duration = end_day - start_day + 1;
    
    in_cycle = (day >= start_day && day <= end_day);
    
    tau = day - start_day;
    
else
    
    duration = (365 - start_day) + (end_day + 1);
    
    in_cycle = (day >= start_day || day <= end_day);
    
    tau = mod(day - start_day,365);
    
end

%% quadratic decay

if in_cycle
    f = f0 * (1 - (tau/duration)^2);
else
    f = 0;
end

end