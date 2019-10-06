clc;
clear;

p1 = 2;
p2 = 256;
p3 = 4096;

qamOrder = 256;

x1 = randi([0, 1], 25 * log2(qamOrder), 1);
x2 = randi([0, 1], 25 * log2(qamOrder), 1);
x3 = randi([0, 1], 25 * log2(qamOrder), 1);

y1 = qammod(x1, qamOrder, 'InputType', 'bit', 'UnitAveragePower', 1);
y2 = qammod(x2, qamOrder, 'InputType', 'bit', 'UnitAveragePower', 1);
y3 = qammod(x3, qamOrder, 'InputType', 'bit', 'UnitAveragePower', 1);

Tx = p1 * y1 + p2 * y2 + p3 * y3;

Rx = Tx;

decodedSignal = Rx;
x_h3 = qamdemod(decodedSignal/p3, qamOrder, 'OutputType', 'bit', 'UnitAveragePower', true);

disp('Weak User Err: ');
disp(sum(bitxor(x3, x_h3)));

y_h3 = qammod(x_h3, qamOrder, 'InputType', 'bit', 'UnitAveragePower', 1);

decodedSignal = decodedSignal - p3 * y_h3;

x_h2 = qamdemod(decodedSignal/p2, qamOrder, 'OutputType', 'bit', 'UnitAveragePower', true);
disp('Medium User Err: ');
disp(sum(bitxor(x2, x_h2)));

y_h2 = qammod(x_h2, qamOrder, 'InputType', 'bit', 'UnitAveragePower', 1);

decodedSignal = decodedSignal - p2 * y_h2;

x_h1 = qamdemod(decodedSignal/p1, qamOrder, 'OutputType', 'bit', 'UnitAveragePower', true);
disp('Strong User Err: ');
disp(sum(bitxor(x1, x_h1)));

y_h1 = qammod(x_h1, qamOrder, 'InputType', 'bit', 'UnitAveragePower', 1);

decodedSignal = decodedSignal - p2 * y_h1;
