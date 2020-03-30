function m = paircombs(n)

  if n==2

    m = uint8([1 2]);

  else

        % stack n-1 copies of previous matrix, which contains

        % values from 1 to n-2

    q = paircombs(n-2);

    qrow = size(q,1);

    m = repmat(q, n-1,1);            

        % append two new columns with values n-1, n

    onz = ones(1,size(m,1),'uint8')';

    m = [m (n-1)*onz n*onz];

        % split rows of matrix into n-1 sections, and in all but one section

        % swap value n-1 with one of values 1..n-2

    for k = 1:n-2

      ind = k*qrow+1:(k+1)*qrow;

      msub = m(ind,:);

      msub(msub==(n-(k+1))) = n-1;

      msub(:,end-1) = n-(k+1);

      m(ind,:) = msub;

    end

  end
    m = n+1-fliplr(m);
end