# Author: Andrew Gaylord
# File Name: dllist_step1.s
#
# Architecture : RISC-V Assembly
# interpreter  : https://www.cs.cornell.edu/courses/cs3410/2019sp/riscv/interpreter
#
# Part 1 - Test to make sure you calloc and free the dllist struct
#
#####################################################################
# Modifications from dllist_step0.S:
#
# Step 1 - x18 points to address 0x7ffff648
# Step 2 - Call the function calloc for the dllist struct
# Step 3 - Allocate the memory for the dllist struct
# Step 4 - Free the dllist struct main call
# Step 5 - Free the dllist Procedure
#####################################################################
#
# This is the equivalent of:
#
# #include <stdlib.h>
# 
# typedef struct dll_node{
#     int the_int;
#     struct dll_node* prev_node;
#     struct dll_node* next_node;
# }dll_node;
# 
# typedef struct dllist{
#     struct dll_node* head_ptr;
#     struct dll_node* tail_ptr;
# }dllist;
# 
# int main(){
#     dllist the_list = ( dllist* )calloc( 1, sizeof(dllist) );
# 
#     free(the_list);
#     return 0;
# }
# 
# 

MAIN:

# Step 1 - x18 points to address 0x051a6110
lui x5, 0x7ffff
addi x18, x5, 0x620
add x5, x0, x0

# Step 2 - Call the function calloc for the dllist struct
# use register x12 to pass a copy of the pointer to the function
add x12, x18, x0
jal x1, CALLOC_DLLIST   # dllist the_list = ( dllist* )calloc( 1, sizeof(dllist) );
add x1, x0, x0     # Empty x1 since we returned from the function call
add x12, x0, x0    # Empty x12 since it is out of scope


# Step 4 - Free the dllist struct main call
add x12, x18, x0    # Pointer to the_list is copied to x12
jal x1, FREE_DLLIST # free(the_list);
add x1, x0, x0     # Empthy x1 since we returned from the function call
add x12, x0, x0    # Empty x12


# Step 0 - Return 0
add x18, x0, x0     # x18 is no longer pointing to the memory
beq x0, x0, END


# Step 3 - Allocate the memory for the dllist struct
##########################################
# Procedure Name: CALLOC_DLLIST
# Pre-conditions: x12 contains the base address of an dll_node
# Post-conditions: x1 contains the return address of the calling procedure
#
# This procedure clears 128 bits (16 bytes) of memory 
# to be allocated to a dll_node
##########################################
CALLOC_DLLIST:

# 3-1 - calloc overwrites the memory at that location with 0
# Note - Problem says every 128 bits must be cleared, which is 16 bytes
sw x0, 0(x12)   # Clears bytes 0-3
sw x0, 4(x12)   # Clears bytes 4-7
sw x0, 8(x12)   # Clears bytes 8-11
sw x0, 12(x12)  # Clears bytes 12-15

# 3-2 Jump and link back to main
jalr x0, x1, 0



# Step 5 - Free the dllist Procedure
##########################################
# Procedure Name: FREE_DLLIST
# Pre-conditions: x12 contains the base address of an dll_node
# Post-conditions: x1 contains the return address of the calling procedure
#
# This procedure clears 128 bits (16 bytes) of memory 
# previously allocated to a dll_node
##########################################
FREE_DLLIST:

# 5-1 Must clear the memory pointed to by x12
sw x0, 0(x12)   # Clears bytes 0-3
sw x0, 4(x12)   # Clears bytes 4-7
sw x0, 8(x12)   # Clears bytes 8-11
sw x0, 12(x12)  # Clears bytes 12-15

# 5-2 Jump and link back to main
jalr x0, x1, 0

END:
quit