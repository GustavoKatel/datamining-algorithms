% natural log to avoid warning division by zero
% add 0.000001

data = csvread("data/classes.csv");

% remove header and line count
data = data(2:end, 2:end);

cols_count = columns(data);
rows_count = rows(data);

global k;
k = 4;

global clusters;
clusters = zeros(k, cols_count);

% clusters_census
% count, number of positives, number of negatives
global clusters_census;
clusters_census = zeros(k, 3);

global total_dists;
total_dists = 0;

function [dists,distsIndex] = get_dist_cluster(nclusters, row)

  dists = rowfun( @(x) ( cos_dist(x, row) ), nclusters );

  [dists,distsIndex] = sort(dists, 'ascend');

  assigned = distsIndex(1);

  global clusters_census;
  clusters_census(assigned,1) = clusters_census(assigned,1)+1;
  if (row(end)==1)
    clusters_census(assigned,2) = clusters_census(assigned,2)+1;
  else
    clusters_census(assigned,3) = clusters_census(assigned,3)+1;
  end

  global total_dists;
  total_dists = total_dists+dists(assigned);

end


train_data = data(1:(0.75*rows_count),:);
test_data = data((0.75*rows_count):end,:);

% Precision: tp / (tp + fp)
% Recall: tp / (tp + fn)


max_changes = 1;

global total_dists_min;
total_dists_min = total_dists;

global clusters_census_min;
clusters_census_min = clusters_census;

% calculate the clusters
for i = 1:max_changes

  new_clusters = rand(k, cols_count);

  total_dists = 0;
  clusters_census = zeros(k, 3);

  rowfun( @(x) ( get_dist_cluster(new_clusters, x) ), train_data );

  global total_dists_min;
  global clusters_census_min;
  global clusters;

  if (total_dists<total_dists_min)
    clusters = new_clusters;
    clusters_census_min = clusters_census;
    total_dists_min = total_dists;
    % disp('Min');
  end

  % disp([ 'Step ' i '/' max_changes '... Dist: ' total_dists ]);

end


%                   =  tp tn fp fn
global global_stats = [0  0  0  0];

% We will predict the last column, but it can be adapted to predict more
% than one column
function k = stats(data, row)

  tp = tn = fp = fn = 0;

  % get_dist_cluster adapted. Ignore last column
  global clusters;
  dists = rowfun( @(x) ( cos_dist( x(:,1:end-1), row(:,1:end-1) ) ), clusters );

  [dists,distsIndex] = sort(dists, 'ascend');

  assigned = distsIndex(1);

  global clusters_census_min;
  positives = clusters_census_min(assigned, 2);
  negatives = clusters_census_min(assigned, 3);

  c = positives>negatives;

  if (c==1) && (row(end)==1)
    % true positive
    tp = 1;
  elseif (c==1) && (row(end)==0)
    % false positive
    fp = 1;
  elseif (c==0) && (row(end)==1)
    % false negative
    fn = 1;
  elseif (c==0) && (row(end)==0)
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

precision = tp / tp+fp;
recall = tp / tp+fn;
