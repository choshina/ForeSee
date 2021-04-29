function eq = equals_to(phi1, phi2)
    if ~strcmp(phi1.type, phi2.type)
        eq = false;
    else
        switch (phi1.type)
            case {'predicate'}
                %eq = isequal(STL_ExtractSignals(phi1), STL_ExtractSignals(phi2)) && isequal(struct2array(get_params(phi1)), struct2array(get_params(phi2)));
                eq = strcmp(get_id(phi1), get_id(phi2));
            case {'not', 'always', 'eventually'}
                eq = equals_to(phi1.phi, phi2.phi);
            case {'and', 'or'}
                eq = equals_to(phi1.phi1, phi2.phi1) && equals_to(phi1.phi2, phi2.phi2);
        end
    end
    
        
end