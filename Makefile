SHELL := /bin/bash

# Commenting out the below line to exclude GoFumpt from the avmmakefile
$(shell curl -H 'Cache-Control: no-cache, no-store' -sSL "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/avmmakefile" -o avmmakefile)
-include avmmakefile