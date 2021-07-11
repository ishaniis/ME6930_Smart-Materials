function [edge2nodes, edge2elements, element2edges]=getEdges_triangles(elements)
%function: [element2edges, edge2nodes]=edge_numbering(elements)
%requires: deleterepeatedrows
%generates edges of (triangular) triangulation defined in elements
%elements is matrix, whose rows contain numbers of its element nodes 
%element2edges returns edges numbers of each triangular element
%edge2nodes returns two node numbers of each edge
%example in 2D: [element2edges, edge2nodes]=getEdges([1 2 3; 2 4 3])
%example in 3D: [element2edges, edge2nodes]=getEdges([1 2 3 4; 1 2 3 5; 1 2 4 6])

%2D case
if (size(elements,2)==3)
    %extracts sets of edges 
    edges1=elements(:,[2 3]);
    edges2=elements(:,[3 1]);
    edges3=elements(:,[1 2]);

    %as sets of their nodes (vertices)
    vertices=zeros(size(elements,1)*3,2);
    vertices(1:3:end,:)=edges1;
    vertices(2:3:end,:)=edges2;
    vertices(3:3:end,:)=edges3;

    %repeated sets of nodes (joint edges) are eliminated 
    [edge2nodes,element2edges]=deleterepeatedrows(vertices);
    element2edges=reshape(element2edges,3,size(elements,1))';
end

%3D case
if (size(elements,2)==4)
    %extracts sets of edges 
    edges1=elements(:,[1 2]);
    edges2=elements(:,[1 3]);
    edges3=elements(:,[1 4]);
    edges4=elements(:,[2 3]);
    edges5=elements(:,[2 4]);
    edges6=elements(:,[3 4]);
    
    %as sets of their nodes (vertices)
    vertices=zeros(size(elements,1)*6,2);
    vertices(1:6:end,:)=edges1;
    vertices(2:6:end,:)=edges2;
    vertices(3:6:end,:)=edges3;
    vertices(4:6:end,:)=edges4;
    vertices(5:6:end,:)=edges5;
    vertices(6:6:end,:)=edges6;
    
    %repeated sets of nodes (joint edges) are eliminated 
    [edge2nodes,element2edges]=deleterepeatedrows(vertices);
    element2edges=reshape(element2edges,6,size(elements,1))';
end

edge2elements=entryInWhichRows(element2edges); 
if (size(edge2elements,2)==1)
    edge2elements=[edge2elements 0*edge2elements];    %all edges are boundary edges!!!
end 



function [matrix,I]=deleterepeatedrows(matrix)
%function: [element2edges, edge2nodes]=edge_numbering(elements)
%generates edges of (triangular) triangulation defined in elements
%elements is matrix, whose rows contain numbers of its element nodes 
%element2edges returns edges numbers of each triangular element
%edge2nodes returns two node numbers of each edge
%example: [element2edges, edge2nodes]=edge_numbering([1 2 3; 2 4 3])

%fast and short way suggested by John D'Ericco working in both 2D and 3D
matrixs=sort(matrix,2);
[dummy,J,I] = unique(matrixs,'rows');
%I=reshape(I,size(matrixs,2),size(I,1)/size(matrixs,2));
matrix=matrix(J,:);

function entryrows=entryInWhichRows(A)
%function: entryrows=entryInWhichRows(A)
%requires: none
%for every entry of integer matrix A,  
%its rows indices are stored in output matrix,
%zeros entries indicate no more occurence
%example: entryrows=entryInWhichRows([1 2; 1 3; 2 2]) returns
%         entryrows=[1   2   0; 
%                    1   3   3; 
%                    2   0   0]   
%meaning: entry 1 appears in rows 1 and 2
%         entry 2 appears in rows 1 and 3 (twice)
%         entry 3 appears in row  2 only

%size computation; 
r=max(max(A));
repetition=accumarray(A(:),ones(numel(A),1));
c=max(repetition);

%filling rows occurences
%this part should be somehow vectorized!
entryrows=zeros(r,c);
repetition=zeros(r,1);
for i=1:size(A,1)
    for j=1:size(A,2)
       index=A(i,j); 
       repetition(index)=repetition(index)+1; 
       entryrows(index,repetition(index))=i;
    end
end


