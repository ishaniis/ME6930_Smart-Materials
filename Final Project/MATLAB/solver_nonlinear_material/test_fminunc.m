
x0 = [-1,2];
fun = @rosenbrockwithgrad;


options = optimoptions('fminunc','Display','final','Algorithm','quasi-newton');

tic
x = fminunc(fun,x0,options);
toc

options = optimoptions('fminunc','Display','final','Algorithm','trust-region','DerivativeCheck','on','GradObj','on');
tic
x = fminunc(fun,x0,options);
toc

%optimtool















if 0
    [x,y] = meshgrid(-3:0.1:3);

    x=x(:);
    y=y(:);

    f = @(x)3*x(:,1).^2 + 2*x(:,1).*x(:,2) + x(:,2).^2 - 4*x(:,1) + 5*x(:,2);

    figure
    plot3(x,y,f([x,y]),'.')
end
