reg overflow;
reg less;
reg equal;
reg greater;
always @(posedge clk)
	if (reset) overflow <= 0;
	else if (button) overflow <= 1;		#traffic signal button
	else if (add2) overflow <= addof;
	else if (sub2) overflow <= subof;
	else if (ide) overflow <= (rA|rX)? ideout[30] : ideout[12];
