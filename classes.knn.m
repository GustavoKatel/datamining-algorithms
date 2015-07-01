
data = csvread("data/classes.csv");

% remove header and line count
data = data(2:end, 2:end);

cols_count = columns(data);
rows_count = rows(data);

function dist = cos_dist(a, b)
  % B is closer to a, if cos_dist is closer to 1
  % what if mag is zero?
  d = dot(a, b);
  mag = norm(a)*norm(b);
  dist = d/mag;

end

function nn = knn(data, new_student, k=10)

  dists = rowfun( @(x) ( cos_dist(x, new_student) ), data );

  [dists,distsIndex] = sort(dists, 'descend');

  nn = data(distsIndex(1:k),:);

end

new_student = zeros(1,cols_count);
new_student(1) = 1;
new_student(3) = 1;
new_student(14) = 1;


train_data = data(1:(0.75*rows_count),:);
test_data = data((0.75*rows_count):end,:);

% Precision: tp / (tp + fp)
% Recall: tp / (tp + fn)

%                   =  tp tn fp fn
global global_stats = [0  0  0  0];

% We will predict the last column, but it can be adapted to predict more
% than one column
% TODO: the last column is being used in the calculations
function k = stats(data, student, k=10)

  tp = tn = fp = fn = 0;

  nn = knn(data, student);
  c = sum(nn(:,end));

  if (c>k/2) && (student(end)==1)
    % true positive
    tp = 1;
  elseif (c>k/2) && (student(end)==0)
    % false positive
    fp = 1;
  elseif (c<k/2) && (student(end)==1)
    % false negative
    fn = 1;
  elseif (c<k/2) && (student(end)==0)
    % true negative
    tn = 1;
  end

  global global_stats;
  global_stats = [global_stats; [tp tn fp fn] ];

  k = 1;

end

r = rowfun( @(x)( stats(train_data, x) ), test_data );

global_stats = sum(global_stats,1);

[tp tn fp fn] = num2cell(sum(global_stats,1)){:};

precision = tp / (tp+fp);
recall = tp / (tp+fn);
