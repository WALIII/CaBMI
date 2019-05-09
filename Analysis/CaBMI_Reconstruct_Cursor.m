function  [cursor] = CaBMI_Reconstruct_Cursor(D_ROIhits_z);

x = size(D_ROIhits_z,1);
counter = 1; 

range = 1:30;
for i = range
try
cursor(:,counter) = smooth((D_ROIhits_z(i,:,1)+D_ROIhits_z(i,:,2))-(D_ROIhits_z(i,:,3)+D_ROIhits_z(i,:,4)),10);
counter = counter+1;
catch
disp('one hit too close to the end. Skipping...');
end
end

figure(); hold on; plot(cursor,'k'); plot(mean(cursor,2),'LineWidth',2,'Color','b');
