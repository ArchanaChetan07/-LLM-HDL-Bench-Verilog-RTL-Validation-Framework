# Prompt: sign_magnitude_adder4
Write a synthesizable Verilog module named `sign_magnitude_adder4` implementing a 4-bit sign-magnitude adder (1 sign bit + 3 magnitude bits per operand, magnitude range 0-7).

Module interface:
```
module sign_magnitude_adder4(
    input  sign_a,
    input  [2:0] mag_a,
    input  sign_b,
    input  [2:0] mag_b,
    output reg sign_result,
    output reg [2:0] mag_result,
    output reg overflow
);
```
If signs match, add magnitudes; if the sum exceeds 7 (3-bit magnitude range), set `overflow`=1 and `mag_result` = sum truncated to 3 bits, `sign_result` = the common sign. If signs differ, subtract the smaller magnitude from the larger; `sign_result` takes the sign of the operand with the larger magnitude (if magnitudes are equal, result is +0: sign_result=0, mag_result=0); `overflow` is always 0 in this case (subtraction of same-range magnitudes cannot overflow).
