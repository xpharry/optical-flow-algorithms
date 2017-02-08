function A = fix_margin(A, margsz)

tmp = A(margsz(1)+1:end-margsz(1), margsz(2)+1:end-margsz(2), :);
p = padarray(tmp, [margsz, 0], 'replicate');