function dist = euc_dist(a, b)

  sub = (a - b).^2;

  dist = sqrt(sum(sub));

end
