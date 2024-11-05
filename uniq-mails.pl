# imprime direcciones emails unicas provenientes de la entrada
perl -nle 'print for grep { !$seen{$_}++ } /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g' 
