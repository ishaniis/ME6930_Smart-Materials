function putTitletoBottom( ht)
    h = xlabel(''); pos = get(h,'Position'); delete(h);
    set(ht,'Position',pos);
    set(gca, 'XAxisLocation','top');
end

