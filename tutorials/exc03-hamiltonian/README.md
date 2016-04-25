The Haydock inversion algorithm has been implemented also for the full coupling
case (so for non-Hermitian matrices) but has to be tested.

tamm-dancoff, fulldiago:    10135.40 s @ 64 cores
tamm-dancoff, haydock:        131.30 s @ 64 cores
coupling, fulldiago:        never finishes
coupling, haydock:            910.71 s @ 64 cores
coupling, diag_no:            775.62 s @ 64 cores
coupling, diag_para:        52723.99 s, 90+ GB @ 128 cores
coupling, diag_para:        42918.71 s, 70+ GB @ 192 cores
