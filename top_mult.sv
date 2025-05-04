`timescale 1ns / 1ps

module top_mult(
  input logic clk_i,
  input logic srst_i,
  input logic [17:0] data_a_i_i,
  input logic [17:0] data_a_q_i,
  input logic [17:0] data_b_i_i,
  input logic [17:0] data_b_q_i,
  output logic [36:0] data_i_o, // 37 бит (36 + 1 переполнение)
  output logic [36:0] data_q_o 
    );
  
  /* умножение комплексных чисел: (a + bi)(c + di) =
  = ac + a*di + bi*c + bi*di = ac + i(ad + bc) + i^2 * bd = |i^2 = -1| =
  = (ac - bd) + i(ad + bc)
  real = a_real*b_real - a_imag*b_imag = real_1 - real_2
  imag = a_real*b_imag + a_imag*b_real = imag_1 + imag_2
  */

  logic signed [35:0] real_1, real_2, imag_1, imag_2;

  assign real_1 = $signed(data_a_i_i) * $signed(data_b_i_i);
  assign real_2 = $signed(data_a_q_i) * $signed(data_b_q_i);
  assign imag_1 = $signed(data_a_i_i) * $signed(data_b_q_i);
  assign imag_2 = $signed(data_a_q_i) * $signed(data_b_i_i);

  always_ff @(posedge clk_i) begin 
    if (srst_i) begin
      data_i_o <= 37'b0;
      data_q_o <= 37'b0;
    end else begin
      // real
      data_i_o <= real_1 - real_2;

      //imag
      data_q_o <= imag_1 + imag_2;
    end
  end

endmodule