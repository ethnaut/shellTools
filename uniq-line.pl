# Lee linea por linea y guarda líneas únicas
perl -ne 'print unless $seen{$_}++'
