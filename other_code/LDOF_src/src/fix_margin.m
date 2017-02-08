function B = fix_margin(A, margsz)

if nargin<2
    margsz = [1 1];
end
%tmp=zeros(size(A));
for i=1:size(A,3)
tmp = A(margsz(1)+1:end-margsz(1), margsz(2)+1:end-margsz(2), i);
B{i} = padarray(tmp, [margsz, 0], 'replicate');
end
B=cat(3,B);