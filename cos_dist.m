function dist = cos_dist(a, b)
  % what if mag is zero?
  d = dot(a, b);
  mag = norm(a)*norm(b);
  dist = 1 - (d/mag);

end
