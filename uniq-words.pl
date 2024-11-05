# Lee  línea por línea, divide cada línea en palabras y luego imprime solo las palabras únicas (no repetidas en el archivo).
perl -nle 'print for grep { !$seen{$_}++ } split /\s+/'
