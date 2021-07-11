function draw_box_around(coordinates)

x=coordinates(:,1);
y=coordinates(:,2);

x_min = min ( x );
  x_max = max ( x );
  y_min = min ( y );
  y_max = max ( y );
  delta =0* 0.05 * max ( x_max - x_min, y_max - y_min );
  
  plot ( [ x_min - delta, ...
           x_max + delta, ...
           x_max + delta, ...
           x_min - delta, ...
           x_min - delta ], ...
         [ y_min - delta, ...
           y_min - delta, ...
           y_max + delta, ...
           y_max + delta, ...
           y_min - delta ], ...
         'k' );

