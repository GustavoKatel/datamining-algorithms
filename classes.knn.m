% distance metric? 1 - the distance - ok (line 20)
% remove class from the calculations - ok (line 53)
% more than one class at time
% iris dataset
% algorithm != application
% tweak k

data = csvread("data/classes.csv");

% remove header and line count
data = data(2:end, 2:end);

cols_count = columns(data);
rows_count = rows(data);

function nn = knn(data, new_student, k=10)

  dists = rowfun( @(x) ( cos_dist(x, new_student) ), data );

  [dists,distsIndex] = sort(dists, 'ascend');

  nn = data(distsIndex(1:k),:);

end

train_data = data(1:(0.75*rows_count),:);
test_data = data((0.75*rows_count):end,:);

% Precision: tp / (tp + fp)
% Recall: tp / (tp + fn)

%                   =  tp tn fp fn
global global_stats = [0  0  0  0];

% We will predict the last column, but it can be adapted to predict more
% than one column
function k = stats(data, student, k=11)

  tp = tn = fp = fn = 0;

  % here we remove the last column, which is the one that we're trying
  % to predict
  nn = knn(data(:,1:end-1), student(:, 1:end-1));
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
