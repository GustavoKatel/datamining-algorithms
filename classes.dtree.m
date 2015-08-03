data = csvread("data/classes.csv");

% remove header and line count
data = data(2:end, 2:end);

cols_count = columns(data);
rows_count = rows(data);

train_data = data(1:(0.75*rows_count),:);
test_data = data((0.75*rows_count):end,:);

global max_level = 15;

function node = gen_node(left_node, right_node, index)

  node = struct(
    'left', left_node,
    'right', right_node
  );

end

function purity = calc_purity(cdata, index)

  pred_index = columns(cdata);

  ldata = cdata( cdata(:,index)==0 , : );
  rdata = cdata( cdata(:,index)==1 , : );

  lpos = ldata( ldata(:,pred_index)==1 , : );
  ltotal = rows(ldata);
  lpos_total = rows(lpos);

  rpos = rdata( rdata(:,pred_index)==1 , : );
  rtotal = rows(rdata);
  rpos_total = rows(rpos);

  purity = ( (lpos_total/ltotal)^2 + (rpos_total/rtotal)^2 );

end

function ldata = get_left_leaf(cdata, index)
  ldata = cdata( cdata(:,index)==0 , : );
end

function rdata = get_right_leaf(cdata, index)
  rdata = cdata( cdata(:,index)==1 , : );
end

function tree = gen_tree(cdata, level)

  % disp(level);

  global max_level;

  ccols = columns(cdata);
  crows = rows(cdata);

  if (ccols==1 || crows==1 || level(1,1)>=max_level || level(1,2)>max_level)
    tree = 0;
    return;
  end

  purities = rowfun( @(x) ( calc_purity(cdata, x) ) , [1:ccols]' );

  purities = purities(1:end-1,:);

  [plist,pindexes] = sort(purities, 'descend');

  pure_node = pindexes(1);

  left_cdata = get_left_leaf(cdata, pure_node);
  left_cdata(:,pure_node) = [];
  level(1) = level(1)+1;
  left_node = gen_tree(left_cdata, level);

  right_cdata = get_right_leaf(cdata, pure_node);
  right_cdata(:,pure_node) = [];
  level(2) = level(2)+1;
  right_node = gen_tree(right_cdata, level);

  tree = gen_node(left_node, right_node, pure_node);

end

root = gen_tree(train_data, [1 1]);

% root;
