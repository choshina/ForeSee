function output = My_STL_Break(phi)
% MY_STL_BREAK breaks a formula into subformulas
%
%  Synopsys:  output = My_STL_Break(phi, state)
%
%  Input :
%    - phi  The formula to break.
%    - state The state of parent formula before recursion
%
%  Output :
%    output includes subformula, interval_array, state, final_state.
%    - subformula  All the subformulas of phi
%    - interval_array   A array for intervals that can stand for the whole interval
%    - state  The state of current formula
%    - state(1) == 0 means no outer layer; 1 stands for 'alw'; 2 stands for 'ev'
%    - state(2) == 0 means no connection symbol; 1 stands for 'and'; 2 stands for 'or'
%    - final_state: the final state of phi

%output = struct('subformula',[],'interval_array',[],'state',state,'final_state', []);




output = [];

switch (phi.type)
    
    case {'predicate'}
        output = [];

    case {'not'}
        output = My_STL_Break(phi.phi);
        
    case {'always'}
        output = My_STL_Break(phi.phi);
        
        
    case{'eventually'}
        
        output = My_STL_Break(phi.phi);
        
    case {'and'}
        
        output = [output phi.phi1];
        if strcmp(phi.phi2.type, 'and')
            output = [output My_STL_Break(phi.phi2)];
        else
            output = [output phi.phi2];
        end
        
    case {'or'}
        output = [output phi.phi1];
        if strcmp(phi.phi2.type, 'or')
            output = [output My_STL_Break(phi.phi2)];
        else
            output = [output phi.phi2];
        end

    case {'until'}
        output = [output phi.phi1 phi.phi2];
              
end

end





