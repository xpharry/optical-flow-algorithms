function visualize_correspondence(img1,img2,Mx1,My1,Mx2,My2,figno)
if size(img1,1)==1
    img1=imread(img1);
end
if size(img2,1)==1
    img2=imread(img2);
end

K=length(Mx1);
n=length(Mx1);
Cols=jet(K);

X_length=size(img1,2);

Image=cat(2,img1,img2);


figure(figno),
clf;
hold on;
imshow(uint8(Image))
hold on;
plot(Mx1(1:min(K,n)),My1(1:min(K,n)),'*y','markersize',0.5);
PtsAll=[Mx1(1:min(K,n))' My1(1:min(K,n))'];

hold on;
plot(X_length+Mx2(1:min(K,n)),My2(1:min(K,n)),'*g','markersize',0.5);
PtsAll=[PtsAll; [X_length+Mx2(1:min(K,n))' My2(1:min(K,n))']];

fprintf('click on the points to see their correspondences');

set(gcf,'WindowButtonDownFcn',@debug_edge_subplot);


    function debug_edge_subplot(hObject, eventdata, handles)
        
        selectionType = get (gcf , 'SelectionType');
        switch selectionType    
            case 'normal'
                selectPt();
            otherwise
        end;
    end


    function selectPt(hObject, eventdata,handles)
        currentAxes = gca;
        curpos = get(currentAxes, 'CurrentPoint');
        ind = find_nearest_point(PtsAll(:,1),PtsAll(:,2), curpos(1,1), curpos(1,2));
        
        L=length(PtsAll);
        if ind<=L/2
            ind2=ind+L/2;
            
        else
            ind2=ind-L/2;
        end
        
        
        string=sprintf('%d',ind);
        
        pt=PtsAll(ind2,:);
        text(pt(1),pt(2),string,'Backgroundcolor',[1 1 1]);
        
        hold on;
        plot(pt(1), pt(2), '*b','markerSize',30);
        hold off;
        
    end

    function ind = find_nearest_point(x,y,ex,ey)
        
        d2 = dist2([x y], [ex ey]);
        [void, ind] = min(d2);
    end
end
