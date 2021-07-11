function elements=reorder_elements(elements,coordinates)
    %reorder elements from from the left to the right and from the bottom to the top
    
    %sort elements so that the first node 
    %is most the left and to the bottom
    
    for i=1:size(elements,1)
        [~,index]=sortrows(coordinates(elements(i,:)',:),[2,1]);   
        elements(i,:)=circshift(elements(i,:),[0,1-index(1)]);   %only rotates nodes and keep the orientation
    end
    
    [~,index]=sortrows(coordinates(elements(:,1),:),[2,1]);   
    elements=elements(index,:);

end

