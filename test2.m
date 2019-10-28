

qamOrder = 4;

p1 = 1;
p2 = 2;

x1 = ones( 960, 1);
x2 = ones( 960, 1);

y1 = qammod(x1, qamOrder, 'InputType', 'bit', 'UnitAveragePower', 1);
y2 = qammod(x2, qamOrder, 'InputType', 'bit', 'UnitAveragePower', 1);

y = p1 * y1 + p2 * y2;

x_h2 = qamdemod(y, qamOrder, 'OutputType', 'bit', 'UnitAveragePower', true);

disp('Weak User Err: ');
disp(sum(bitxor(x2, x_h2)));

y_h2 = qammod(x_h2, qamOrder, 'InputType', 'bit', 'UnitAveragePower', 1);

y_h1 = y - p2 * y_h2;

x_h1 = qamdemod(y_h1, qamOrder, 'OutputType', 'bit', 'UnitAveragePower', true);
disp('Strong User Err: ');
disp(sum(bitxor(x1, x_h1)));
