 
f = 100;   
T = 1;
Ks = 0:0.2:200;  
Vs = 0:0.001:1;  

 
num_Ks = numel(Ks);
num_Vs = numel(Vs);
u_values = zeros(num_Ks, num_Vs);

 
for i = 1:num_Ks
    for j = 1:num_Vs
        u = getBlackCall(f, T, Ks(i), Vs(j));
        u_values(i, j) = u;
    end
end

 
figure;
surf(Ks, Vs, u_values', 'FaceColor', 'interp', 'FaceAlpha', 0.001);
xlabel('Ks');
ylabel('Vs');
zlabel('u');
title('Option Price (u) as a Function of Ks and Vs');
colorbar;  

colormap(jet); 


