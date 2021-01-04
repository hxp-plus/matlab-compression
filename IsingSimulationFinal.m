%% 2D Ising simulation

%% 清理所有变量等无关信息
clear all
close all
clc

%% 初始参数设定
temperature=0.1; % 0-5 will be fine
expect_turn=200; % 预期会全部反转次数，越多相当于演化时间越长，40基本可以看见完全的相变
n=50; % 粒子的排列是一个n×n矩阵
%calculate_time=1e6;
calculate_time=n*n*expect_turn;



%% set矩阵为-1/1随机矩阵
conditions_of_spins=floor((rand(n,n)-0.5).*2);
%conditions_of_spins=zeros(n,n)+1;
for i=1:n
   for j=1:n 
       if (conditions_of_spins(i,j)==0)
           conditions_of_spins(i,j)=1;
       end
   end
end

%% 开始演化
for time=1:calculate_time
    i=randi(n);
    j=randi(n);
    
    total_energy_before_flip=0;
    total_energy_after_flip=0;
    x=[i,mod(n+i-2,n)+1,i,mod(n+i,n)+1,i]; % surrounding_position_x
    y=[j,j,mod(n+j-2,n)+1,j,mod(n+j,n)+1];
    for k=1:5
        mean_condition=conditions_of_spins(mod(n+x(k)-2,n)+1,y(k)) ...
            +conditions_of_spins(x(k),mod(n+y(k)-2,n)+1)...
            +conditions_of_spins(mod(n+x(k),n)+1,y(k))...
            +conditions_of_spins(x(k),mod(n+y(k),n)+1);
        total_energy_before_flip=total_energy_before_flip...
            +(-1)*(conditions_of_spins(x(k),y(k)))*(mean_condition);
    end
    total_energy_before_flip=total_energy_before_flip/2;
    
    test_flip=(-1)*conditions_of_spins(i,j);
    conditions_of_spins(i,j)=test_flip;
    for k=1:5
        mean_condition=conditions_of_spins(mod(n+x(k)-2,n)+1,y(k)) ...
            +conditions_of_spins(x(k),mod(n+y(k)-2,n)+1)...
            +conditions_of_spins(mod(n+x(k),n)+1,y(k))...
            +conditions_of_spins(x(k),mod(n+y(k),n)+1);
        total_energy_after_flip=total_energy_after_flip...
            +(-1)*(conditions_of_spins(x(k),y(k)))*(mean_condition);
    end
    total_energy_after_flip=total_energy_after_flip/2;
    
    delta_energy=-total_energy_after_flip+total_energy_before_flip;
    possibility_of_slip=exp(delta_energy/temperature);
    possibility_random=rand(1,1);
%    if (delta_energy>0&&(possibility_random>possibility_of_slip))
    if (possibility_of_slip<possibility_random)
        conditions_of_spins(i,j)=(-1)*test_flip;
    end
    % image(conditions_of_spins),colormap(gray) % 画视频的时候放上去
end
image((conditions_of_spins+1)*255),colormap(gray)
axis square
