#!/bin/bash
sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' -e '/parameter real   P_FREERUN_FREQUENCY/ c \  parameter real   P_FREERUN_FREQUENCY    = 195.3125,' ./gtwizard_ultrascale_0_example_init.v > DLx_phy_example_init.v
