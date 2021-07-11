function enlarge_axis(alpha1,alpha2)
    ax=axis;
    ax_new=ax*[[1+alpha2 -alpha2; -alpha2 1+alpha2], zeros(2); zeros(2), [1+alpha1 -alpha1; -alpha1 1+alpha1]];
    axis(ax_new);
end

