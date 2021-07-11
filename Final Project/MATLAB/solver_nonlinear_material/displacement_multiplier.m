function all_a = displacement_multiplier(all_t,cycles)
if nargin==1
    cycles=1;
end
if numel(all_t)==1
   all_a=0;
else
    all_a=wave(all_t,max(all_t)/cycles);
end
end

