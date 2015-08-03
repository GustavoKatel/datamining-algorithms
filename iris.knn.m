% Iris-setosa = 1
% Iris-versicolor = 2
% Iris-virginica = 3

% confusion matrix

data = csvread("data/iris.data");

cols_count = columns(data);
rows_count = rows(data);

function nn = knn(data, new_student, k=10)

  % switched cos_dist to euc_dist
  dists = rowfun( @(x) ( euc_dist(x, new_student) ), data );

  [dists,distsIndex] = sort(dists, 'ascend');

  nn = data(distsIndex(1:k),:);

end

rndIDX = randperm(rows_count);
train_data = data(rndIDX(1:100), :);
test_data = data(rndIDX(101:end	),:);

% Precision: tp / (tp + fp)
% Recall: tp / (tp + fn)

%                   =  tp tn fp fn
global global_stats = [0  0];

% We will predict the last column, but it can be adapted to predict more
% than one column
% k is odd to avoid draws
function k = stats(data, row, k=11)

  tp = fp = 0;

  % here we remove the last column, which is the one that we're trying
  % to predict
  % iris dataset is the same!
  nn = knn(data(:,1:end-1), row(:, 1:end-1));

  setosa = length( nn(nn(:,end)==1) );
  versicolor = length( nn(nn(:,end)==2) );
  virginica = length( nn(nn(:,end)==3) );

  vec = [setosa versicolor virginica];
  [maxValue,indexValue] = sort(vec, 'ascend');

  predicted = indexValue(1);

  % TODO: precision and recall for each variable?
  if (predicted==row(end))
    % true positive
    tp = 1;
  else
    fp = 1;
  end

  global global_stats;
  global_stats = [global_stats; [tp fp] ];

  k = 1;

end

r = rowfun( @(x)( stats(train_data, x) ), test_data );

global_stats = sum(global_stats,1);

[tp fp] = num2cell(sum(global_stats,1)){:};

% precision = tp / (tp+fp);
% recall = tp / (tp+fn);
