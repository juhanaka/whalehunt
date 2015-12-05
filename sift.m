run('vlfeat-0.9.20/toolbox/vl_setup.m');

QUERY_IMG_PATH = 'data/heads/w_8_b5.png';
DB_IMG_PATHS = {'data/heads/w_835_b2.png', 'data/heads/w_15_b81.png'};

query_img = rgb2gray(im2single(imread(QUERY_IMG_PATH)));
db_imgs = {};

for path_idx=1:length(DB_IMG_PATHS)
    db_imgs = [db_imgs, rgb2gray(im2single(imread(DB_IMG_PATHS{path_idx})))];
end

[f_q,d_q] = vl_sift(query_img);


for img_idx=1:length(db_imgs)
    db_img = db_imgs{img_idx};
    [f_db,d_db] = vl_sift(db_img);
    [matches, scores] = vl_ubcmatch(d_q,d_db);
    [uniqueRow2, IA, IC] = unique(matches(2,:));
    uniqueRow1 = matches(1,IA);
    matches = [uniqueRow1; uniqueRow2];
    numMatches = size(matches,2) ;
    
    X_q = f_q(1:2,matches(1,:)) ; X_q(3,:) = 1 ;
    X_db = f_db(1:2,matches(2,:)) ; X_db(3,:) = 1 ;
    
    clear H score ok ;
    radius = 6;
    for t = 1:100
      % estimate homography
      subset = vl_colsubset(1:numMatches, 4) ;
      A = [] ;
      for i = subset
        A = cat(1, A, kron(X_q(:,i)', vl_hat(X_db(:,i)))) ;
      end
      [U,S,V] = svd(A) ;
      H{t} = reshape(V(:,9),3,3) ;

      % score homography
      X_db_ = H{t} * X_q ;
      du = X_db_(1,:)./X_db_(3,:) - X_db(1,:)./X_db(3,:) ;
      dv = X_db_(2,:)./X_db_(3,:) - X_db(2,:)./X_db(3,:) ;
      ok{t} = (du.*du + dv.*dv) < radius*radius ;
      score(t) = sum(ok{t}) ;
    end

    [score, best] = max(score) ;
    H = H{best} ;
    ok = ok{best} ;    
    good_matches = f_q(1:2,matches(1,ok));
    fprintf('Sum of matches image %d is %d\n', img_idx, sum(ok));
    
    
    % plotting
    dh1 = max(size(db_img,1)-size(query_img,1),0) ;
    dh2 = max(size(query_img,1)-size(db_img,1),0) ;

    figure(1) ; clf ;
    % subplot(2,1,1) ;
    imshow([padarray(query_img,dh1,'post') padarray(db_img,dh2,'post')]) ;

    o = size(query_img,2) ;
    figure(2) ; clf ;
    imshow([padarray(query_img,dh1,'post') padarray(db_img,dh2,'post')]) ;
    hold on;
    h1 = vl_plotframe(f_q) ;
    h2 = vl_plotframe(f_q) ;
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;

    fTemp = f_db;
    fTemp(1, :) = fTemp(1, :) + o;
    h1 = vl_plotframe(fTemp) ;
    h2 = vl_plotframe(fTemp) ;
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;

    figure(3) ; clf ;
    imshow([padarray(query_img,dh1,'post') padarray(db_img,dh2,'post')]) ;
    hold on;
    
    plot([f_q(1,matches(1,:));f_db(1,matches(2,:))+o], ...
     [f_q(2,matches(1,:));f_db(2,matches(2,:))], ['k' '-'],  'LineWidth', 2) ;
    plot([f_q(1,matches(1,:)) + 1;f_db(1,matches(2,:))+o+1], ...
         [f_q(2,matches(1,:)) + 1;f_db(2,matches(2,:))+1], ['y' '-'],  'LineWidth', 2) ;
    plot(f_q(1,matches(1,:)), f_q(2,matches(1,:)), 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k'); 
    plot(f_q(1,matches(1,:))+1, f_q(2,matches(1,:))+1, 'yo', 'MarkerSize', 5, 'MarkerFaceColor', 'y'); 
    plot(f_db(1,matches(2,:))+o, f_db(2,matches(2,:)), 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
    plot(f_db(1,matches(2,:))+o+1, f_db(2,matches(2,:))+1, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'y');

    figure(4) ; clf ;
    imshow([padarray(query_img,dh1,'post') padarray(db_img,dh2,'post')]) ;
    o = size(query_img,2) ;
    hold on;
    plot([f_q(1,matches(1,ok));f_db(1,matches(2,ok))+o], ...
         [f_q(2,matches(1,ok));f_db(2,matches(2,ok))], ['k' '-'],  'LineWidth', 2) ;
    plot([f_q(1,matches(1,ok))+1;f_db(1,matches(2,ok))+o+1], ...
         [f_q(2,matches(1,ok))+1;f_db(2,matches(2,ok))+1], ['y' '-'],  'LineWidth', 2) ;  
    plot(f_q(1,matches(1,ok)), f_q(2,matches(1,ok)), 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k'); 
    plot(f_q(1,matches(1,ok))+1, f_q(2,matches(1,ok))+1, 'yo', 'MarkerSize', 5, 'MarkerFaceColor', 'y'); 
    plot(f_db(1,matches(2,ok))+o, f_db(2,matches(2,ok)), 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'k');
    plot(f_db(1,matches(2,ok))+o+1, f_db(2,matches(2,ok))+1, 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'y');
end