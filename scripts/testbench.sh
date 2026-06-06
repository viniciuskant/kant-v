#!/bin/bash

RTL=../rtl
TB=../tb
PDK=/pdk/synopsys/saed32/SAED32_EDK/lib/stdcell_rvt/verilog

echo "Compilando..."

vcs \
-sverilog \
-kdb \
-lca \
-debug_access+all+reverse \
-cm line+tgl+branch+cond \
$TB/top_tb.sv \
$RTL/register_bank.sv \
$RTL/register.sv \
$RTL/control.sv \
$RTL/memory.sv \
$RTL/alu.sv \
$RTL/branch_unit.sv \
$RTL/gen_imm.sv \
$RTL/cpu.sv \
$RTL/top.sv \
-v $PDK/saed32nm.v

echo "Simulando..."

./simv \
+FSDB_ON \
+fsdbfile+inter.fsdb \
-l new.log \
-cm line+cond+tgl+branch+assert

echo "Abrindo Verdi..."

verdi -cov -covdir simv.vdb/