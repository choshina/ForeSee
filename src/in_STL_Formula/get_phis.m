function phip = get_phis(phi, type)
  switch (type)
      case 0
          phip = phi.phi;
      case 1
          phip = phi.phi1;
      case 2
          phip = phi.phi2;
      otherwise
          phip = [];
  end
end