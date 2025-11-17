function box_plotting(Vlist, P_world, P_box)

    num_zigs = 5;
    w = .1;
    num_springs = length(P_world(1, :));
    
    figure
    hold on
    axis equal; axis square;
    axis([-3 3 -3 3])   % adjust to your scene

    % initialize square plot
    square_plot = plot(NaN, NaN, 'k-', 'LineWidth', 2);
    springs = repmat(struct('zig_zag',[], 'line_plot',plot(0,0), 'point_plot',plot(0,0)), 1, num_springs);   % 1xN struct array with fields a and b

    for i = 1:num_springs
        springs(i) = initialize_spring_plot(num_zigs,w);
    end

    for step=1:length(Vlist)
        P_box_world = compute_rbt(Vlist(step,1), Vlist(step,2), Vlist(step,3), P_box);
        % plot box
        P_plot = [P_box_world, P_box_world(:,1)];
        set(square_plot,'XData',P_plot(1,:),'YData',P_plot(2,:));
        % plot springs
        for spring=1:num_springs
            P1 = P_world(:, spring);
            P2 = P_box_world(:, spring);
            update_spring_plot(springs(spring),P1,P2)
        end
        drawnow;
    end
end

%updates spring plotting object so that spring is plotted
%with ends located at points P1 and P2
function update_spring_plot(spring_plot_struct,P1,P2)
    dP = P2-P1;
    R = [dP(1),-dP(2)/norm(dP);dP(2),dP(1)/norm(dP)];
    plot_pts = R*spring_plot_struct.zig_zag;

    set(spring_plot_struct.line_plot,...
        'xdata',plot_pts(1,:)+P1(1),...
        'ydata',plot_pts(2,:)+P1(2));

    set(spring_plot_struct.point_plot,...
        'xdata',[P1(1),P2(1)],...
        'ydata',[P1(2),P2(2)]);
end

%create a struct containing plotting info for a single spring
%INPUTS:
%num_zigs: number of zig zags in spring drawing
%w: width of the spring drawing
function spring_plot_struct = initialize_spring_plot(num_zigs,w)
    spring_plot_struct = struct();

    zig_ending = [.25,.75,1; ...
                  -1,1,0];

    zig_zag = zeros(2,3+3*num_zigs);
    zig_zag(:,1) = [-.5;0];
    zig_zag(:,end) = [num_zigs+.5;0];

    for n = 0:(num_zigs-1)
        zig_zag(:,(3+3*n):2+3*(n+1)) = zig_ending + [n,n,n;0,0,0];
    end

    zig_zag(1,:)=(zig_zag(1,:)-zig_zag(1,1))/(zig_zag(1,end)-zig_zag(1,1));
    zig_zag(2,:)=zig_zag(2,:)*w;

    spring_plot_struct.zig_zag = zig_zag;
    spring_plot_struct.line_plot = plot(0,0,'k','linewidth',2);
    spring_plot_struct.point_plot = plot(0,0,'ro','markerfacecolor','r','markersize',7);
end