function progress(Info, a, b)
%%%%%%%%%% progress(Info, a, b)

	if a==1
		fprintf('%s: %05d of %05d',Info, a,b);
	else
		fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b%05d of %05d', a,b);
	end

	if a==b
		fprintf('\n');
	end

end