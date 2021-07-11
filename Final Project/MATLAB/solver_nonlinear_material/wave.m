function y=wave(x,T)
if nargin==1
    T=2*pi;                %period
end
x=rem(x,T);
y=interp1(T*[0 1/4 1/2 3/4 1],[0 1 0 -1 0],x);
end
